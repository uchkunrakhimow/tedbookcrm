import 'package:flutter/material.dart';

class TextStyleS {
  static TextStyle s16w600({color, overflow}) {
    return TextStyle(
      color: color,
      fontSize: 16,
      overflow: overflow,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle s16w400({color, overflow}) {
    return TextStyle(
      color: color,
      fontSize: 16,
      overflow: overflow,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle s15w400({color, overflow}) {
    return TextStyle(
        color: color,
        fontSize: 15,
        overflow: overflow,
        fontWeight: FontWeight.w400,
        fontFamily: "ProximaNova");
  }

  static TextStyle s15w500({color, overflow}) {
    return TextStyle(
      color: color,
      fontSize: 15,
      overflow: overflow,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle s15w600({color, overflow}) {
    return TextStyle(
      color: color,
      fontSize: 15,
      overflow: overflow,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle s15w700({color, overflow}) {
    return TextStyle(
      color: color,
      fontSize: 15,
      overflow: overflow,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle s15w800({color, overflow}) {
    return TextStyle(
      color: color,
      fontSize: 15,
      overflow: overflow,
      fontWeight: FontWeight.w800,
    );
  }

  static TextStyle s14w700({color, overflow}) {
    return TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        overflow: overflow,
        color: color);
  }

  static TextStyle s14w400l({color, overflow}) {
    return TextStyle(
      color: color,
      fontSize: 14,
      overflow: overflow,
      letterSpacing: 0.2,
    );
  }

  static TextStyle s20w600({color, overflow}) {
    return TextStyle(
      color: color,
      fontSize: 20,
      overflow: overflow,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle s14w400({color, overflow, decoration}) {
    return TextStyle(
      color: color,
      fontSize: 14,
      overflow: overflow,
      decoration: decoration,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle s14w600({color, overflow}) {
    return TextStyle(
      color: color,
      fontSize: 14,
      overflow: overflow,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle s14w500({color, overflow}) {
    return TextStyle(
      color: color,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      overflow: overflow,
    );
  }

  static TextStyle s13w700({color, overflow}) {
    return TextStyle(
        color: color,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        overflow: overflow);
  }

  static TextStyle s13w600({color, overflow}) {
    return TextStyle(
        color: color,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        overflow: overflow);
  }

  static TextStyle s13w500({color, overflow}) {
    return TextStyle(
        color: color,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        overflow: overflow);
  }

  static TextStyle s13w400({color, overflow}) {
    return TextStyle(
        color: color,
        fontSize: 13,
        overflow: overflow,
        fontWeight: FontWeight.w400);
  }

  static TextStyle s12w700({color, overflow}) {
    return TextStyle(
      overflow: overflow,
      fontSize: 12,
      color: color,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle s12w600({color, overflow}) {
    return TextStyle(
      fontSize: 12,
      overflow: overflow,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle s12w400({color, overflow}) {
    return TextStyle(
        fontSize: 12,
        overflow: overflow,
        fontWeight: FontWeight.w400,
        color: color);
  }

  static TextStyle s12w300({color, overflow}) {
    return TextStyle(
        fontSize: 12,
        overflow: overflow,
        fontWeight: FontWeight.w300,
        color: color);
  }

  static TextStyle s12w500({color, overflow}) {
    return TextStyle(
        fontSize: 12,
        overflow: overflow,
        fontWeight: FontWeight.w500,
        color: color);
  }

  static TextStyle s11w600({color, overflow}) {
    return TextStyle(
        fontSize: 11,
        overflow: overflow,
        fontWeight: FontWeight.w600,
        color: color);
  }

  static TextStyle s11w400({color, overflow}) {
    return TextStyle(
        fontSize: 11,
        overflow: overflow,
        fontWeight: FontWeight.w400,
        color: color);
  }

  static TextStyle s10w500({color, overflow}) {
    return TextStyle(
        fontSize: 10,
        overflow: overflow,
        fontWeight: FontWeight.w500,
        color: color);
  }

  static TextStyle s10w400({color, overflow}) {
    return TextStyle(
        fontSize: 10,
        overflow: overflow,
        fontWeight: FontWeight.w400,
        color: color);
  }

  static TextStyle s9w600({color, overflow}) {
    return TextStyle(
        fontSize: 9,
        overflow: overflow,
        fontWeight: FontWeight.w600,
        color: color);
  }

  static TextStyle style({color, fontSize, fontWeight}) {
    return TextStyle(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color,
    );
  }
}
