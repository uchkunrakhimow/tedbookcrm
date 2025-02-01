import 'package:flutter/cupertino.dart';

extension SizeExtension on BuildContext {
  get screenWidth => MediaQuery.of(this).size.width;

  get screenHeight => MediaQuery.of(this).size.height;
}

extension SizeExtension2 on State {
  get screenWidth => MediaQuery.of(context).size.width;

  get screenHeight => MediaQuery.of(context).size.height;
}
