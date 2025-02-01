part of 'home_bloc.dart';

@immutable
class HomeState {
  final BaseStatus status;
  final int? selectedOrderType;
  final List<OrderModel>? ordersList;
  final List<OrderModel>? returningList;
  final List<OrderModel>? deliveredList;
  final List<OrderModel>? canceledList;
  final String? sentOrderId;

  HomeState({
    required this.status,
    this.selectedOrderType,
    this.ordersList,
    this.returningList,
    this.deliveredList,
    this.canceledList,
    this.sentOrderId,
  });

  factory HomeState.initial() {
    return HomeState(status: BaseStatus.initial());
  }

  HomeState copyWith({
    BaseStatus? status,
    int? selectedOrderType,
    List<OrderModel>? ordersList,
    List<OrderModel>? returningList,
    List<OrderModel>? deliveredList,
    List<OrderModel>? canceledList,
    String? sentOrderId,
  }) {
    return HomeState(
      status: status ?? this.status,
      selectedOrderType: selectedOrderType ?? this.selectedOrderType,
      ordersList: ordersList ?? this.ordersList,
      returningList: returningList ?? this.returningList,
      deliveredList: deliveredList ?? this.deliveredList,
      canceledList: canceledList ?? this.canceledList,
      sentOrderId: sentOrderId ?? this.sentOrderId,
    );
  }
}
