import 'package:flutter/material.dart';

class AppColor {
  static const Color scaffoldBackColor = Color(0xFFECECEC);
  static const Color primaryAppColor = Color(0xFF5FDE33);
  static const Color customRedColor = Color(0xFF4C0120);
  static const Color redColor = Color(0xFFD84745);
  static const Color orangeColor = Color(0xFFFFA303);
  static const Color blackColor = Color(0xFF1E1E1E);
  static const Color lightGreyColor = Color(0xFFE0E0E0);
  static const Color greyColor = Color(0xFF979C9E);
  static const Color textColor = Color(0xFF292D32);
  static const Color textGreyColor = Color(0xFF6C6C6C);
  static const Color cardColor = Color(0xFFF2F8FF);
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  static int? getColorFromHexMayDataNull(String? hexColor) {
    if (hexColor == null) return null;
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
