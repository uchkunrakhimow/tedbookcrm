import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tedbook/pages/home/bloc/home_bloc.dart';
import 'package:tedbook/persistance/text_style_const.dart';
import 'package:tedbook/utils/color_utils.dart';
import 'package:tedbook/utils/navigator_extension.dart';
import 'package:tedbook/utils/order_status.dart';
import 'package:tedbook/widgets/custom_button.dart';

class OrderCompleteCard extends StatelessWidget {
  final String orderId;
  final OrderStatus orderStatus;

  const OrderCompleteCard({
    super.key,
    required this.orderId,
    required this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (orderStatus == OrderStatus.pending) {
          showConfirmOrderModal(context, orderId: orderId);
        } else if (orderStatus == OrderStatus.returning) {
          showConfirmOrderDialog(context, orderId: orderId);
        }
      },
      child: Container(
        margin: EdgeInsets.zero,
        height: 56,
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/icons/complete.svg", height: 20),
              SizedBox(width: 12),
              Text(
                "Завершить",
                style: TextStyleS.s14w600(color: Colors.white),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: AppColor.primaryAppColor,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
          border: Border.all(width: 1, color: Color(0xFFDDDDDD)),
        ),
      ),
    );
  }

  showConfirmOrderModal(
    BuildContext context, {
    required String orderId,
  }) =>
      showModalBottomSheet(
        context: context,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        backgroundColor: Colors.transparent,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 36, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActionButton(
                      text: "Доставлен",
                      color: AppColor.primaryAppColor,
                      onTap: () => context.read<HomeBloc>().add(
                            OrderCompletionEvent(
                                orderId: orderId, status: "Delivered"),
                          ),
                    ),
                    _buildActionButton(
                      text: "Возврат",
                      color: AppColor.redColor,
                      onTap: () => context.read<HomeBloc>().add(
                            OrderCompletionEvent(
                                orderId: orderId, status: "Returning"),
                          ),
                    ),
                  ],
                ),
                alignment: Alignment.center,
              ),
            ],
          );
        },
      );

  showConfirmOrderDialog(
    BuildContext context, {
    required String orderId,
  }) =>
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              "Вы действительно доставили?",
              style: TextStyleS.s14w600(),
            ),
            content: Row(
              children: [
                Flexible(
                  child: CustomButton(
                    text: "Нет",
                    height: 40,
                    backColor: Colors.red,
                    onTap: () => context.pop(),
                  ),
                ),
                SizedBox(width: 12),
                Flexible(
                  child: CustomButton(
                    text: "Да",
                    height: 40,
                    onTap: () => context.read<HomeBloc>().add(
                          OrderCompletionEvent(
                              orderId: orderId, status: "Returned"),
                        ),
                  ),
                ),
              ],
            ),
          );
        },
      );

  Widget _buildActionButton({
    required String text,
    required Color color,
    required Function onTap,
  }) {
    return Flexible(
      child: CustomButton(
        margin: EdgeInsets.symmetric(horizontal: 8),
        text: text,
        height: 50,
        textStyle: TextStyleS.s14w600(color: Colors.white),
        backColor: color,
        onTap: () {
          onTap.call();
        },
      ),
    );
  }
}
