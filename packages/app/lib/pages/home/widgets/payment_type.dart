import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tedbook/model/response/payment_type_model.dart';
import 'package:tedbook/pages/home/bloc/home_bloc.dart';
import 'package:tedbook/persistance/base_status.dart';
import 'package:tedbook/utils/color_utils.dart';
import 'package:tedbook/widgets/custom_button.dart';
import 'package:tedbook/widgets/custom_text_field.dart';
import 'package:tedbook/widgets/message_shape_card.dart';

class PaymentTypeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (p, c) => c.status.type == StatusType.paging,
        builder: (_, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: context.read<HomeBloc>().paymentTypes.map((element) {
              return PaymentTypeItem(model: element);
            }).toList(),
          );
        },
      ),
    );
  }
}

class PaymentTypeItem extends StatelessWidget {
  final PaymentTypeModel model;

  const PaymentTypeItem({required this.model});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: () => _showInputDialog(context, model.method ?? ""),
          child: SizedBox(
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 48,
                  child: SvgPicture.asset(
                    "assets/icons/${model.method?.toLowerCase().replaceAll('-', "_")}.svg",
                    height: 48,
                    color: model.amount != null
                        ? AppColor.orangeColor
                        : AppColor.blackColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  model.name ?? "-",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    decoration:
                        model.amount != null ? TextDecoration.underline : null,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        if (model.amount != null)
          Positioned(
            top: -38,
            left: 0,
            right: 0,
            child: MessageShapeCard(
              amount: model.amount,
            ),
          ),
      ],
    );
  }

  void _showInputDialog(BuildContext context, String method) {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.all(6),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(CupertinoIcons.clear_circled_solid),
                  color: Colors.blueGrey,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              CustomTextField(
                  controller: _controller, keyboardType: TextInputType.number),
              SizedBox(height: 14),
              CustomButton(
                text: "Подтвердить",
                height: 50,
                onTap: () {
                  context.read<HomeBloc>().add(
                        InputAmountEvent(
                            method: method,
                            amount: double.parse(_controller.text)),
                      );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
