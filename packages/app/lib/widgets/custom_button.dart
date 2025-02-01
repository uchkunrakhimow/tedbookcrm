import 'package:flutter/material.dart';
import 'package:tedbook/utils/color_utils.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.fieldKey,
    this.backColor,
    this.backGradient,
    this.borderRadius,
    this.textColor,
    this.borderColor,
    this.text,
    this.onTap,
    this.height = 60,
    this.fontSize = 20,
    this.textStyle,
    this.margin,
    this.padding,
    this.isLoading = false,
    this.trailingIcon,
    this.leadingIcon,
    this.enabled = true,
    this.child,
    this.mainAxisAlignment,
  });

  final Key? fieldKey;
  final String? text;
  final Color? backColor;
  final Gradient? backGradient;
  final double? borderRadius;
  final Color? textColor;
  final double fontSize;
  final TextStyle? textStyle;
  final Color? borderColor;
  final double height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Widget? child;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final bool isLoading;
  final bool enabled;
  final GestureTapCallback? onTap;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled
                ? backColor ?? AppColor.primaryAppColor
                : Colors.grey.withOpacity(0.4),
            gradient: backGradient,
            border:
                borderColor != null ? Border.all(color: borderColor!) : null,
            borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryAppColor,
                offset: const Offset(0, 24),
                blurRadius: 48,
                spreadRadius: -18,
              ),
            ],
          ),
          child: child ??
              Padding(
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment:
                      mainAxisAlignment ?? MainAxisAlignment.spaceEvenly,
                  children: [
                    if (leadingIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: leadingIcon!,
                      ),
                    if (leadingIcon == null && isLoading)
                      const SizedBox(width: 25),
                    Flexible(
                      child: Text(
                        text ?? "",
                        style: textStyle ??
                            TextStyle(
                              fontSize: fontSize,
                              color: textColor ?? Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (trailingIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: trailingIcon!,
                      ),
                    if (isLoading)
                      SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: AppColor.primaryAppColor,
                          backgroundColor: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
