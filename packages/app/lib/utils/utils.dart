import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

debugLog(dynamic s) {
  if (kDebugMode) log(s.toString());
}

String currencyFormatter(double? number, {decimalDigit = 2}) {
  final formatCurrency = NumberFormat.currency(
      locale: "en_US", symbol: "", decimalDigits: decimalDigit);
  return formatCurrency.format(number).replaceAll(",", " ");
}

const int intMaxValue = 9223372036854775807;

String timerFormat(num seconds) =>
    "${(seconds ~/ 60).toString().padLeft(2, "0")}:${(seconds % 60).toString().padLeft(2, "0")}";

String accessTokenExpDate(int sec) => DateFormat("yyyy-MM-dd hh:mm:ss")
    .format(DateTime.now().add(Duration(seconds: sec)));

extension BuildContextX on BuildContext {
  void replaceSnackbar({
    required Widget content,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(this);
    scaffoldMessenger.removeCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(content: content),
    );
  }
}

String getErrorMessage(error) {
  String errorMessage = "";
  if (error is DioException && error.response != null) {
    try {
      errorMessage = error.response!.data!["message"].toString();
    } catch (e) {
      debugLog("getErrorMessage $e");
    }
  }
  return errorMessage;
}

int osType() {
  var result = 0;
  if (Platform.isAndroid) result = 1;
  if (Platform.isIOS) result = 2;
  return result;
}
