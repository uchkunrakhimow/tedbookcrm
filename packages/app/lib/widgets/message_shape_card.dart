import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tedbook/persistance/text_style_const.dart';

class MessageShapeCard extends StatelessWidget {
  final double? amount;

  const MessageShapeCard({super.key, this.amount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
            bottom: -5,
            right: 12,
            child: SvgPicture.asset("assets/images/triangle.svg")),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(48),
            color: Color(0xFF484848),
          ),
          child: Text(
            "${amount ?? 0}",
            style: TextStyleS.s12w700(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
