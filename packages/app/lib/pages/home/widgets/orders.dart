import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedbook/model/response/order_response.dart';
import 'package:tedbook/pages/home/bloc/home_bloc.dart';
import 'package:tedbook/pages/home/widgets/messages.dart';
import 'package:tedbook/pages/home/widgets/contacts_card.dart';
import 'package:tedbook/pages/home/widgets/order_complete_card.dart';
import 'package:tedbook/pages/home/widgets/payment_type.dart';
import 'package:tedbook/pages/home/widgets/send_message.dart';
import 'package:tedbook/persistance/text_style_const.dart';
import 'package:tedbook/utils/color_utils.dart';
import 'package:tedbook/utils/order_status.dart';
import 'package:tedbook/utils/utils.dart';

class OrdersWidget extends StatelessWidget {
  final List<OrderModel>? ordersList;

  const OrdersWidget({super.key, this.ordersList});

  @override
  Widget build(BuildContext context) {
    if (ordersList?.isNotEmpty == true) {
      return RefreshIndicator(
        onRefresh: () async {
          debugLog("RefreshIndicator");
          return context.read<HomeBloc>().add(RefreshEvent());
        },
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (_, int index) {
            OrderModel order = ordersList![index];
            return _orderItem(context, order: order, index: index + 1);
          },
          separatorBuilder: (_, __) => SizedBox(height: 8),
          itemCount: ordersList!.length,
        ),
      );
    } else {
      return Center(
        child: Text(
          "Пусто",
          style: TextStyleS.s15w600(),
        ),
      );
    }
  }

  _orderItem(
    BuildContext context, {
    required OrderModel order,
    required int index,
  }) {
    bool isPending = getStatusType(order.status) == OrderStatus.pending;
    bool isReturning = getStatusType(order.status) == OrderStatus.returning;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ExpansionTile(
              onExpansionChanged: (val) {
                context
                    .read<HomeBloc>()
                    .add(IsExpandedEvent(orderId: order.id ?? "", isExp: val));
              },
              leading: Text(
                "${index < 10 ? "0$index" : "$index"}",
                style: TextStyleS.s14w600(color: AppColor.textGreyColor),
              ),
              title: Text(
                order.fullName ?? "-",
                style: TextStyleS.s15w500(color: AppColor.textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              tilePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              childrenPadding: EdgeInsets.only(bottom: 8),
              dense: true,
              shape: Border.all(color: Colors.transparent, width: 0),
              collapsedShape: Border.all(color: Colors.transparent, width: 0),
              children: [
                SizedBox(
                  height: (isPending || isReturning) ? 108 : 60,
                  child: Stack(
                    children: [
                      if (isPending || isReturning)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: OrderCompleteCard(
                            orderId: order.id ?? "",
                            orderStatus: isPending
                                ? OrderStatus.pending
                                : OrderStatus.returning,
                          ),
                        ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: ContactsCard(
                          address: order.address ?? "-",
                          phone: order.phoneNumber ?? "-",
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                if (order.messages?.isNotEmpty == true)
                  Messages(messages: order.messages!),
                if (isPending) SendMessage(orderId: order.id ?? ""),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        if (order.isExpanded ?? false) PaymentTypeCard(),
      ],
    );
  }
}
