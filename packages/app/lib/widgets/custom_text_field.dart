import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tedbook/persistance/text_style_const.dart';
import 'package:tedbook/utils/color_utils.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.hintText,
    this.errorText,
    this.errorValidate = false,
    this.enabled = true,
    this.helperText,
    this.onSaved,
    this.style,
    this.focusNode,
    this.textAlign,
    this.validator,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.keyboardType = TextInputType.multiline,
    this.controller,
    this.inputFormatters,
    this.minLine = 1,
    this.maxLine = 1,
    this.inputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.sentences,
    this.textMaxLength,
    this.counterText,
    this.onChanged,
    this.hasIcon = false,
    this.isReadOnly = false,
    this.prefixText,
    this.showCursor = true,
    this.backColor,
    this.initialValue,
    this.prefixIcon,
    this.autoFocus = false,
    this.showEditableInput = false,
    this.contentPadding,
    this.prefixIconConstraints,
    this.hintStyle,
    this.borderRadius,
    this.elevation = 0,
    this.onTap,
    this.height = 44,
  });

  final String? hintText;
  final TextStyle? hintStyle;
  final String? errorText;
  final String? prefixText;
  final String? initialValue;
  final bool errorValidate;
  final bool? enabled;
  final String? helperText;
  final Widget? prefixIcon;
  final TextStyle? style;
  final FocusNode? focusNode;
  final TextAlign? textAlign;
  final bool showCursor;
  final Color? backColor;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;
  final TextInputType keyboardType;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final int minLine;
  final int maxLine;
  final TextInputAction inputAction;
  final int? textMaxLength;
  final String? counterText;
  final onChanged;
  final bool hasIcon;
  final bool isReadOnly;
  final bool autoFocus;
  final bool showEditableInput;
  final EdgeInsets? contentPadding;
  final BorderRadius? borderRadius;
  final double elevation;
  final Function? onTap;
  final double height;

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    // var theme = ThemeProvider.controllerOf(context).theme.data;
    return Material(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(30),
      elevation: widget.elevation,
      shadowColor: AppColor.primaryAppColor.withOpacity(0.5),
      child: SizedBox(
        height: widget.height,
        child: TextFormField(
          onTap: () {
            widget.onTap?.call();
          },
          initialValue: widget.initialValue,
          showCursor: widget.showCursor,
          maxLength: widget.textMaxLength,
          readOnly: widget.isReadOnly,
          autofocus: widget.autoFocus,
          focusNode: widget.focusNode,
          textAlign: widget.textAlign ?? TextAlign.start,
          style: widget.style ??
              TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          textInputAction: widget.inputAction,
          controller: widget.controller,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatters,
          textCapitalization: widget.textCapitalization,
          onSaved: widget.onSaved,
          minLines: widget.minLine,
          maxLines: widget.maxLine,
          validator: widget.validator,
          onFieldSubmitted: widget.onFieldSubmitted,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(30.0),
              borderSide: BorderSide(
                  width: 1,
                  color: AppColor.greyColor
                      .withOpacity(widget.showEditableInput ? 1 : 0.5)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(30.0),
              borderSide: BorderSide(
                  width: 1,
                  color: AppColor.greyColor.withOpacity(
                      (widget.enabled! || widget.showEditableInput) ? 1 : 0.5)),
            ),
            prefixText: widget.prefixText ?? "",
            prefixIcon: widget.prefixIcon ??
                (widget.hasIcon ? const Icon(Icons.call) : null),
            errorText: widget.errorValidate ? widget.errorText : null,
            errorMaxLines: 2,
            contentPadding: widget.contentPadding ?? const EdgeInsets.all(20),
            counterText: widget.counterText,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
              borderRadius: widget.borderRadius ?? BorderRadius.circular(30.0),
            ),
            suffixIconConstraints: widget.suffixIconConstraints ??
                const BoxConstraints(minHeight: 24, minWidth: 38),
            prefixIconConstraints: widget.prefixIconConstraints ??
                const BoxConstraints(minHeight: 24, minWidth: 38),
            filled: true,
            fillColor: widget.backColor ?? Colors.white,
            hintStyle: widget.hintStyle ??
                TextStyleS.s12w500(color: AppColor.textGreyColor),
            prefixStyle: widget.hintStyle ??
                const TextStyle(
                  fontSize: 16,
                  letterSpacing: 0.2,
                  color: AppColor.greyColor,
                ),
            hintText: widget.hintText,
            labelStyle: TextStyleS.s15w500(),
            helperText: widget.helperText,
            suffixIcon: widget.suffixIcon,
          ),
        ),
      ),
    );
  }
}
