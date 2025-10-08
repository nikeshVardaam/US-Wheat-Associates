import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/common_date_picker.dart';

// This widget shows a button and, when tapped, opens the CommonDatePicker.
// It awaits the result and exposes it via onDatePicked, or can be awaited from outside.
class DatePickerBottomSheet extends StatefulWidget {
  // Input data for the CommonDatePicker
  final List<int> uniqueYears;
  final List<String> fixedMonths; // length 12 expected
  final int? initialYear;
  final int? initialMonth;
  final int? initialDay;

  // Optional callback to observe the result
  final ValueChanged<DateTime?>? onDatePicked;

  const DatePickerBottomSheet({
    super.key,
    required this.uniqueYears,
    required this.fixedMonths,
    this.initialYear,
    this.initialMonth,
    this.initialDay,
    this.onDatePicked,
  });

  @override
  State<DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  DateTime? _lastPicked;

  Future<void> _openPicker() async {
    // Call the given CommonDatePicker.open which already builds a bottom sheet
    // with Cancel and Confirm and returns a DateTime? when popped. [web:2][web:7]
    final picked = await CommonDatePicker.open(
      context: context,
      uniqueYears: List<int>.from(widget.uniqueYears),
      fixedMonths: List<String>.from(widget.fixedMonths),
      initialYear: widget.initialYear,
      initialMonth: widget.initialMonth,
      initialDay: widget.initialDay,
      backgroundColor: Colors.white,
    ); // [web:2][web:7]

    setState(() {
      _lastPicked = picked;
    }); // [web:2]

    widget.onDatePicked?.call(picked); // [web:2]
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoButton.filled(
          onPressed: _openPicker,
          child: const Text('Open Date Picker'),
        ), // [web:2][web:8]
        const SizedBox(height: 12), // [web:2]
        Text(
          _lastPicked != null ? _lastPicked!.toIso8601String() : 'No date selected',
        ), // [web:2]
      ],
    );
  }
}
