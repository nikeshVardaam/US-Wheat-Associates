import 'package:flutter/material.dart';

class ScreenItem {
  final Widget screen;   // The screen/widget to navigate to
  final String title;    // Page title
  final Color color;     // Color for icon/text
  final String mapImage; // Any extra data you want to pass

  ScreenItem({
    required this.screen,
    required this.title,
    required this.color,
    required this.mapImage,
  });
}
