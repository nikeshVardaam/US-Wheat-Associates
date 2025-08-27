import 'package:flutter/material.dart';

extension PriceComparison on num? {
  Color compareToColor(num? previous) {
    if (this == null || previous == null) return Colors.grey;
    if (this! > previous) return Colors.green;
    if (this! < previous) return Colors.red;
    return Colors.grey;
  }
}

