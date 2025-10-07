import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommonDatePicker {
  /// Opens a 3-column Cupertino picker (year, month, day).
  /// Returns the selected DateTime or null if cancelled.
  static Future<DateTime?> open({
    required BuildContext context,
    required List<int> uniqueYears,
    required List<String> fixedMonths, // length 12 expected
    int? initialYear,
    int? initialMonth,
    int? initialDay,
    Color backgroundColor = Colors.white,
  }) async {
    // Safety defaults
    if (uniqueYears.isEmpty) uniqueYears = [DateTime.now().year];
    if (fixedMonths.length < 12) {
      fixedMonths = const [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
      ];
    }

    int selectedYear = initialYear ?? DateTime.now().year;
    // if selectedYear not present in list, fallback to closest (or first)
    if (!uniqueYears.contains(selectedYear)) {
      selectedYear = uniqueYears.contains(DateTime.now().year)
          ? DateTime.now().year
          : uniqueYears.first;
    }

    int selectedMonth = (initialMonth != null && initialMonth >= 1 && initialMonth <= 12)
        ? initialMonth
        : DateTime.now().month;

    int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    int selectedDay = (initialDay != null && initialDay >= 1 && initialDay <= daysInMonth)
        ? initialDay
        : (DateTime.now().day <= daysInMonth ? DateTime.now().day : daysInMonth);

    List<int> dayList = List.generate(daysInMonth, (i) => i + 1);

    final int yearIndex = uniqueYears.indexOf(selectedYear).clamp(0, uniqueYears.length - 1);
    final int monthIndex = (selectedMonth - 1).clamp(0, 11);
    final int dayIndex = (selectedDay - 1).clamp(0, dayList.length - 1);

    final yearController = FixedExtentScrollController(initialItem: yearIndex);
    final monthController = FixedExtentScrollController(initialItem: monthIndex);
    final dayController = FixedExtentScrollController(initialItem: dayIndex);

    DateTime? result;

    try {
      result = await showCupertinoModalPopup<DateTime?>(
        context: context,
        builder: (_) => SafeArea(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: MediaQuery.of(context).size.height / 2.5,
                color: backgroundColor,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Row(
                        children: [
                          // Year picker
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: yearController,
                              itemExtent: 40,
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedYear = uniqueYears[index];
                                  final maxDays = DateTime(selectedYear, selectedMonth + 1, 0).day;
                                  if (selectedDay > maxDays) {
                                    selectedDay = maxDays;
                                    // update dayController to the new (safe) index
                                    dayController.jumpToItem(selectedDay - 1);
                                  }
                                  dayList = List.generate(maxDays, (i) => i + 1);
                                });
                              },
                              children: uniqueYears.map((y) => Center(child: Text(y.toString()))).toList(),
                            ),
                          ),

                          // Month picker
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: monthController,
                              itemExtent: 40,
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedMonth = index + 1;
                                  final maxDays = DateTime(selectedYear, selectedMonth + 1, 0).day;
                                  if (selectedDay > maxDays) {
                                    selectedDay = maxDays;
                                    dayController.jumpToItem(selectedDay - 1);
                                  }
                                  dayList = List.generate(maxDays, (i) => i + 1);
                                });
                              },
                              children: fixedMonths.map((m) => Center(child: Text(m))).toList(),
                            ),
                          ),

                          // Day picker
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: dayController,
                              itemExtent: 40,
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  // make sure index is valid against current dayList
                                  if (index >= 0 && index < dayList.length) {
                                    selectedDay = dayList[index];
                                  }
                                });
                              },
                              children: dayList.map((d) => Center(child: Text(d.toString()))).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.pop(context, null),
                          ),
                          CupertinoButton(
                            child: const Text("Confirm"),
                            onPressed: () {
                              final picked = DateTime(selectedYear, selectedMonth, selectedDay);
                              Navigator.pop(context, picked);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } finally {
      // always dispose controllers after popup closes
      yearController.dispose();
      monthController.dispose();
      dayController.dispose();
    }

    return result;
  }
}