import 'package:flutter/material.dart';

class StoryModel {
  final int id;
  final String title;
  final String iconPath;
  final Color? backColor;
  bool isSeen;

  StoryModel({
    required this.id,
    required this.title,
    required this.iconPath,
    this.backColor,
    required this.isSeen,
  });
}
