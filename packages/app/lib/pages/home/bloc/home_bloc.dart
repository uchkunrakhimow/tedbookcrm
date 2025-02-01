import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tedbook/model/request/firebasetoken_request.dart';
import 'package:tedbook/model/request/put_order_request.dart';
import 'package:tedbook/model/response/order_response.dart';
import 'package:tedbook/model/response/payment_type_model.dart';
import 'package:tedbook/persistance/base_status.dart';
import 'package:tedbook/persistance/firebase_service.dart';
import 'package:tedbook/persistance/remote/api_provider.dart';
import 'package:tedbook/persistance/service_locator.dart';
import 'package:tedbook/persistance/user_data.dart';
import 'package:tedbook/utils/order_status.dart';
import 'package:tedbook/utils/utils.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<InitEvent>((event, emit) => initEvent());
    on<RefreshEvent>((_, __) => getOrders());
    on<SendCommentEvent>(sendComment);
    on<OrderCompletionEvent>(orderCompletion);
    on<ChangeOrderTypeEvent>((event, emit) =>
        emit(state.copyWith(selectedOrderType: event.selectedTypeIndex)));
    on<InputAmountEvent>(inputAmount);
    on<IsExpandedEvent>(expandedOrder);
    on<LogoutEvent>(logout);
  }

  initEvent() {
    emit(state.copyWith(selectedOrderType: 0));
    FirebaseService().firebaseInit();
    setFirebaseToken();
    socketInit();
    getOrders();
  }

  setFirebaseToken() async {
    String token = await FirebaseService().getToken();
    String userId = await _userData.userId() ?? "";
    FirebaseTokenRequest request = FirebaseTokenRequest(
      userId: userId,
      token: token,
    );
    await _apiProvider.setFirebaseToken(request).then((value) {
      debugLog(value);
    }).onError(
      (err, _) {
        debugLog(err);
      },
    );
  }

  socketInit() async {
    // Connect to the socket server
    socket = IO.io(
      ApiProvider.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket']) // use web socket transport
          .setPath('/ws') // Ensure this matches your server configuration
          .enableAutoConnect() // Auto-connect when the service is initialized
          .build(),
    );

    // Listen for new orders
    socket.on('orderUpdated', (newOrder) {
      getOrders();
    });

    // Listen for new comments
    socket.on('newComment', (newComment) {
      Logger().w(newComment);
      MessageModel newMessage = MessageModel.fromJson(newComment);
      List<OrderModel> list = [];
      emit(state.copyWith(
        sentOrderId: newMessage.orderId,
      ));
      for (var element in _ordersList) {
        if (element.id == newMessage.orderId) {
          element.messages?.add(MessageModel.fromJson(newComment));
        }
        list.add(element);
      }
      // _ordersList.first.messages?.add(newMessage);
      debugLog("socket.on ${_ordersList.first.messages?.length}");
      emit(state.copyWith(
        status: BaseStatus.sent(),
        ordersList: _ordersList,
      ));

      // Handle new comment
      debugLog('New comment: $newComment');
    });
  }

  getOrders() async {
    emit(state.copyWith(status: BaseStatus.loading()));
    await _apiProvider.getOrders(await _userData.userId() ?? "").then(
      (value) {
        if (value.data?.ordersList?.isNotEmpty == true) {
          _ordersList.clear();
          _returningList.clear();
          _deliveredList.clear();
          _canceledList.clear();
          for (var item in value.data!.ordersList!) {
            commentControllers[item.id ?? ""] = TextEditingController();
            commentFocuses[item.id ?? ""] = FocusNode();
            if (getStatusType(item.status) == OrderStatus.pending) {
              _ordersList.add(item);
            } else if (getStatusType(item.status) == OrderStatus.returning) {
              _returningList.add(item);
            } else if (getStatusType(item.status) == OrderStatus.delivered) {
              _deliveredList.add(item);
            } else {
              _canceledList.add(item);
            }
          }
          emit(state.copyWith(
            status: BaseStatus.success(),
            ordersList: _ordersList,
            returningList: _returningList,
            deliveredList: _deliveredList,
            canceledList: _canceledList,
          ));
        }
      },
    ).onError((err, __) {
      Logger().e(err);
      emit(
        state.copyWith(
            status: BaseStatus.errorWithString(message: err.toString())),
      );
    });
  }

  orderCompletion(OrderCompletionEvent event, Emitter<HomeState> emit) async {
    var list = <PaymentTypeModel>[];
    paymentTypes.forEach((element) {
      if (element.amount != null) list.add(element);
    });
    PutOrderRequest request = PutOrderRequest(
      isArchive: true,
      statusId: event.status,
      payments: list,
    );
    await _apiProvider
        .orderCompletion(orderId: event.orderId, request: request)
        .then(
      (value) {
        emit(state.copyWith(status: BaseStatus.updated()));
        getOrders();
      },
    ).onError((err, __) {
      emit(
        state.copyWith(
            status: BaseStatus.errorWithString(message: err.toString())),
      );
    });
  }

  sendComment(SendCommentEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(status: BaseStatus.sending()));
    // Join the room
    socket.emit('join_room', event.orderId);
    socket.emit('sendMessage', {
      'orderId': event.orderId,
      'commentText': commentControllers[event.orderId]?.text,
      'commenterRole': "courier",
    });
  }

  inputAmount(InputAmountEvent event, Emitter<HomeState> emit) async {
    paymentTypes.forEach((element) {
      if (element.method == event.method) {
        element.amount = event.amount;
        return;
      }
    });
    emit(state.copyWith(status: BaseStatus.paging()));
  }

  expandedOrder(IsExpandedEvent event, Emitter<HomeState> emit) async {
    _ordersList.forEach((element) {
      if (element.id == event.orderId) element.isExpanded = event.isExp;
      return;
    });
    _deliveredList.forEach((element) {
      if (element.id == event.orderId) element.isExpanded = event.isExp;
      return;
    });
    emit(state.copyWith(status: BaseStatus.paging()));
  }

  logout(LogoutEvent event, Emitter<HomeState> emit) async {
    await _userData.clearAllData();
    socket.dispose();
    emit(state.copyWith(status: BaseStatus.logout()));
  }

  final ApiProvider _apiProvider = getInstance();
  final UserData _userData = getInstance();
  late IO.Socket socket;
  List<OrderModel> _ordersList = [];
  List<OrderModel> _returningList = [];
  List<OrderModel> _deliveredList = [];
  List<OrderModel> _canceledList = [];
  var commentControllers = {};
  var commentFocuses = {};
  List<PaymentTypeModel> paymentTypes = [
    PaymentTypeModel(name: "Платежные системы", method: "payment-systems"),
    PaymentTypeModel(name: "Карта", method: "card"),
    PaymentTypeModel(name: "Наличные", method: "cash"),
  ];
}
