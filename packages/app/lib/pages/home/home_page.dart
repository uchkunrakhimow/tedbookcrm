import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tedbook/pages/home/bloc/home_bloc.dart';
import 'package:tedbook/pages/home/widgets/orders.dart';
import 'package:tedbook/pages/login/bloc/login_bloc.dart';
import 'package:tedbook/pages/login/login_page.dart';
import 'package:tedbook/persistance/base_status.dart';
import 'package:tedbook/persistance/text_style_const.dart';
import 'package:tedbook/utils/color_utils.dart';
import 'package:tedbook/utils/navigator_extension.dart';
import 'package:tedbook/utils/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late HomeBloc bloc;
  late TabController _tabController;

  @override
  void initState() {
    bloc = context.read<HomeBloc>();
    bloc.add(InitEvent());
    _tabController = TabController(length: 4, vsync: this);
    listen();
    super.initState();
  }

  @override
  void dispose() {
    bloc.socket.dispose();
    super.dispose();
  }

  listen() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mainUi,
    );
  }

  Widget get _mainUi => BlocListener<HomeBloc, HomeState>(
        listenWhen: (_, c) =>
            c.status.type == StatusType.logout ||
            c.status.type == StatusType.sent ||
            c.status.type == StatusType.updated ||
            c.status.type == StatusType.error,
        listener: (_, HomeState state) {
          if (state.status.type == StatusType.logout) {
            pushAndRemoveAllWithBloc(LoginPage(), LoginBloc());
          } else if (state.status.type == StatusType.sent) {
            bloc.commentControllers[state.sentOrderId].clear();
            bloc.commentFocuses[state.sentOrderId].unfocus();
          } else if (state.status.type == StatusType.updated) {
            pop();
          } else if (state.status.type == StatusType.error) {
            if (state.status.message?.text?.isNotEmpty == true)
              showToast(
                state.status.message?.text ?? "",
                context: context,
                animation: StyledToastAnimation.scale,
                backgroundColor: Colors.red,
                position: StyledToastPosition(align: Alignment.topCenter),
              );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                _appBar,
                SizedBox(height: 22),
                _tabBarField,
                SizedBox(height: 22),
                _tabBarViewField,
              ],
            ),
          ),
        ),
      );

  Widget get _appBar => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset("assets/icons/person.svg", height: 30),
            SizedBox(width: 12),
            InkWell(
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: () => bloc.add(LogoutEvent()),
              child: Text(
                "Выйти",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      );

  Widget get _tabBarField => BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) =>
            previous.selectedOrderType != current.selectedOrderType ||
            current.status.type == StatusType.success,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _tabBarItem(
                  title: "Заявки",
                  isSelected: state.selectedOrderType == 0,
                  onTap: () {
                    _tabController.animateTo(0);
                    bloc.add(ChangeOrderTypeEvent(selectedTypeIndex: 0));
                  },
                  count: state.ordersList?.length ?? 0,
                ),
                _tabBarItem(
                  title: "Возвращение",
                  isSelected: state.selectedOrderType == 1,
                  onTap: () {
                    _tabController.animateTo(1);
                    bloc.add(ChangeOrderTypeEvent(selectedTypeIndex: 1));
                  },
                  count: state.returningList?.length ?? 0,
                ),
                _tabBarItem(
                  title: "Возвращено",
                  isSelected: state.selectedOrderType == 2,
                  onTap: () {
                    _tabController.animateTo(2);
                    bloc.add(ChangeOrderTypeEvent(selectedTypeIndex: 2));
                  },
                  count: state.canceledList?.length ?? 0,
                ),
                _tabBarItem(
                  title: "Доставлен",
                  isSelected: state.selectedOrderType == 3,
                  onTap: () {
                    _tabController.animateTo(3);
                    bloc.add(ChangeOrderTypeEvent(selectedTypeIndex: 3));
                  },
                  count: state.deliveredList?.length ?? 0,
                ),
              ],
            ),
          );
        },
      );

  Widget get _tabBarViewField => BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (p, c) =>
            p.status.type != c.status.type ||
            c.status.type == StatusType.sent ||
            c.status.type == StatusType.paging,
        builder: (_, state) {
          if (state.status.type == StatusType.loading)
            return Center(child: CircularProgressIndicator());
          return Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                OrdersWidget(ordersList: state.ordersList),
                OrdersWidget(ordersList: state.returningList),
                OrdersWidget(ordersList: state.canceledList),
                OrdersWidget(ordersList: state.deliveredList),
              ],
            ),
          );
        },
      );
}

Widget _tabBarItem({
  required String title,
  required bool isSelected,
  required Function onTap,
  required int count,
}) =>
    InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        onTap.call();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: isSelected ? AppColor.blackColor : Colors.white,
            ),
            child: Text(
              title,
              style: TextStyleS.s12w600(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            alignment: Alignment.center,
          ),
          Positioned(
            right: 0,
            top: -13,
            child: Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.orangeColor,
              ),
              child: Text(
                count.toString(),
                style: TextStyleS.s14w700(
                  color: Colors.white,
                ),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
