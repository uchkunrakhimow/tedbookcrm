import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tedbook/persistance/text_style_const.dart';
import 'package:tedbook/utils/color_utils.dart';
import 'package:tedbook/utils/navigator_extension.dart';
import 'package:tedbook/widgets/custom_button.dart';

extension StateDialog on State {
  showCustomDialog({
    String? title,
    String? svgPath,
    String? description,
    String? buttonTitle,
    String? buttonSvgPath,
    Function? onTap,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.cardColor,
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    SvgPicture.asset(svgPath ?? "assets/images/error.svg"),
                    SizedBox(height: 18),
                    Text(
                      title ?? "Извините, что-то пошло не так.",
                      style: TextStyleS.s16w600(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      description ?? "В приложении Pharm Uz произошла ошибка.",
                      style: TextStyleS.s15w400(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          onTap: () {
                            if (onTap != null) {
                              onTap.call();
                            } else {
                              pop();
                            }
                          },
                          height: 50,
                          text: buttonTitle ?? "OK",
                          backColor: AppColor.primaryAppColor,
                          leadingIcon: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: SvgPicture.asset(
                              buttonSvgPath ?? "assets/icons/logout.svg",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
