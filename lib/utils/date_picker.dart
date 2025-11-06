import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uswheat/utils/app_buttons.dart';

import 'app_strings.dart';

class CustomDatePicker extends StatefulWidget {
  final String? date;

  const CustomDatePicker({super.key, this.date});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;
  final int startYear = 2024;

  final int currentYear = DateTime.now().year;
  final int currentMonth = DateTime.now().month;
  final int currentDay = DateTime.now().day;

  late FixedExtentScrollController yearController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController dayController;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    DateTime initialDate = now;

    if (widget.date != null && widget.date!.trim().isNotEmpty) {
      try {
        initialDate = DateTime.parse(widget.date!.trim());
      } catch (e) {
        initialDate = now;
      }
    }

    if (initialDate.isAfter(now)) {
      initialDate = now;
    }

    selectedYear = initialDate.year;
    selectedMonth = initialDate.month;
    selectedDay = initialDate.day;

    yearController = FixedExtentScrollController(initialItem: selectedYear - startYear);
    monthController = FixedExtentScrollController(initialItem: selectedMonth - 1);
    dayController = FixedExtentScrollController(initialItem: selectedDay - 1);
  }

  String getMonthAbbr(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }

  List<int> getMonths() {
    if (selectedYear == currentYear) {
      return List.generate(currentMonth, (i) => i + 1);
    } else {
      return List.generate(12, (i) => i + 1);
    }
  }

  List<int> getDays() {
    int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    if (selectedYear == currentYear && selectedMonth == currentMonth) {
      daysInMonth = currentDay;
    }
    return List.generate(daysInMonth, (i) => i + 1);
  }

  @override
  Widget build(BuildContext context) {
    final years = List.generate(currentYear - startYear + 1, (i) => startYear + i);
    final months = getMonths();
    final days = getDays();

    return Container(
      height: 350,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "${AppStrings.select} ${AppStrings.date}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.clear),
                ),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 36,
                      scrollController: yearController,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedYear = years[index];
                          if (selectedYear == currentYear && selectedMonth > currentMonth) {
                            selectedMonth = currentMonth;
                          }
                          if (selectedYear == currentYear &&
                              selectedMonth == currentMonth &&
                              selectedDay > currentDay) {
                            selectedDay = currentDay;
                          }
                        });
                      },
                      children:
                          years.map((y) => Center(child: Text('$y', style: const TextStyle(fontSize: 18)))).toList(),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 36,
                      scrollController: monthController,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedMonth = months[index];
                          if (selectedYear == currentYear &&
                              selectedMonth == currentMonth &&
                              selectedDay > currentDay) {
                            selectedDay = currentDay;
                          }
                        });
                      },
                      children: months
                          .map((m) => Center(child: Text(getMonthAbbr(m), style: const TextStyle(fontSize: 18))))
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 36,
                      scrollController: dayController,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedDay = days[index];
                        });
                      },
                      children: days
                          .map((d) =>
                              Center(child: Text(d.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 18))))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(
                    context,
                    DateTime(selectedYear, selectedMonth, selectedDay),
                  );
                },
                child: AppButtons().filledButton(true, "Confirm", context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
