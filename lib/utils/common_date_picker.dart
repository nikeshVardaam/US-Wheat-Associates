// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uswheat/utils/app_buttons.dart';
// import 'package:uswheat/utils/app_strings.dart';
// import 'package:uswheat/utils/pref_keys.dart';
//
// class DatePickerSheet extends StatefulWidget {
//   final String? date;
//
//   const DatePickerSheet({super.key, required this.date});
//
//   @override
//   State<DatePickerSheet> createState() => _DatePickerSheetState();
// }
//
// class _DatePickerSheetState extends State<DatePickerSheet> {
//   String? selectedYear;
//   String? selectedMonth;
//   String? selectedDay;
//
//   List<int> yearsList = [];
//   List<int> days = [];
//   List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
//
//   int initialYearIndex = 0;
//   int initialMonthIndex = 0;
//   int initialDayIndex = 0;
//
//   late FixedExtentScrollController yearController;
//   late FixedExtentScrollController monthController;
//   late FixedExtentScrollController dayController;
//
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       loadData();
//     });
//   }
//
//   Future<void> loadData() async {
//     final sp = await SharedPreferences.getInstance();
//     final stored = sp.getStringList(PrefKeys.yearList) ?? const <String>[];
//
//     final parsed = <int>[];
//     for (final s in stored) {
//       final v = int.tryParse(s);
//       if (v != null) parsed.add(v);
//     }
//
//     if (parsed.isEmpty) {
//       parsed.add(DateTime.now().year);
//     }
//
//     final sortedYears = List<int>.from(parsed)..sort((a, b) => b.compareTo(a));
//     yearsList = sortedYears;
//
//     _initDate();
//     yearController = FixedExtentScrollController(initialItem: initialYearIndex);
//     monthController = FixedExtentScrollController(initialItem: initialMonthIndex);
//     dayController = FixedExtentScrollController(initialItem: initialDayIndex);
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   void _initDate() {
//     DateTime selectedDate;
//     if (widget.date != null && widget.date!.isNotEmpty) {
//       try {
//         selectedDate = DateTime.parse(widget.date!);
//       } catch (_) {
//         selectedDate = DateTime.now();
//       }
//     } else {
//       selectedDate = DateTime.now();
//     }
//
//     for (var i = 0; i < yearsList.length; ++i) {
//       if (yearsList[i] == selectedDate.year) {
//         selectedYear = yearsList[i].toString();
//         initialYearIndex = i;
//         break;
//       }
//     }
//
//     initialMonthIndex = selectedDate.month - 1;
//     selectedMonth = months[initialMonthIndex];
//
//     getDaysInMonth(month: selectedMonth!, year: selectedDate.year);
//
//     for (var i = 0; i < days.length; ++i) {
//       if (days[i] == selectedDate.day) {
//         initialDayIndex = i;
//         selectedDay = days[i].toString();
//         break;
//       }
//     }
//   }
//
//   void getDaysInMonth({required String month, required int year}) {
//     days.clear();
//     final monthMap = {
//       'Jan': 1,
//       'Feb': 2,
//       'Mar': 3,
//       'Apr': 4,
//       'May': 5,
//       'Jun': 6,
//       'Jul': 7,
//       'Aug': 8,
//       'Sep': 9,
//       'Oct': 10,
//       'Nov': 11,
//       'Dec': 12,
//     };
//
//     final monthNumber = monthMap[month] ?? 1;
//     final daysInMonth = DateTime(year, monthNumber + 1, 0).day;
//
//     for (var i = 1; i <= daysInMonth; i++) {
//       days.add(i);
//     }
//   }
//
//   DateTime createDate(int year, String month, int day) {
//     final monthMap = {
//       'Jan': 1,
//       'Feb': 2,
//       'Mar': 3,
//       'Apr': 4,
//       'May': 5,
//       'Jun': 6,
//       'Jul': 7,
//       'Aug': 8,
//       'Sep': 9,
//       'Oct': 10,
//       'Nov': 11,
//       'Dec': 12,
//     };
//     final monthNumber = monthMap[month]!;
//     return DateTime(year, monthNumber, day);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CupertinoActivityIndicator());
//     }
//
//     return SafeArea(
//       bottom: false,
//       child: Scaffold(
//         body: SizedBox(
//           height: MediaQuery.of(context).size.height / 3,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       "${AppStrings.select} ${AppStrings.date}",
//                       style: Theme.of(context).textTheme.bodyLarge,
//                     ),
//                     const Spacer(),
//                     GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child: const Icon(Icons.clear),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Text(AppStrings.year, style: Theme.of(context).textTheme.bodyMedium),
//                             Expanded(
//                               child: CupertinoPicker(
//                                 itemExtent: 32,
//                                 scrollController: yearController,
//                                 onSelectedItemChanged: (index) {
//                                   setState(() {
//                                     selectedYear = yearsList[index].toString();
//                                   });
//                                 },
//                                 children: List.generate(
//                                   yearsList.length,
//                                   (index) => Center(
//                                     child: Text(
//                                       yearsList[index].toString(),
//                                       style: Theme.of(context).textTheme.labelLarge,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Text(AppStrings.month, style: Theme.of(context).textTheme.bodyMedium),
//                             Expanded(
//                               child: CupertinoPicker(
//                                 itemExtent: 30,
//                                 scrollController: monthController,
//                                 onSelectedItemChanged: (index) {
//                                   selectedMonth = months[index];
//                                   getDaysInMonth(
//                                     month: selectedMonth!,
//                                     year: int.parse(selectedYear ?? yearsList.first.toString()),
//                                   );
//                                   setState(() {});
//                                 },
//                                 children: List.generate(
//                                   months.length,
//                                   (index) => Center(
//                                     child: Text(
//                                       months[index],
//                                       style: Theme.of(context).textTheme.labelLarge,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Text(AppStrings.day, style: Theme.of(context).textTheme.bodyMedium),
//                             Expanded(
//                               child: CupertinoPicker(
//                                 itemExtent: 32,
//                                 scrollController: dayController,
//                                 onSelectedItemChanged: (index) {
//                                   setState(() {
//                                     selectedDay = days[index].toString();
//                                   });
//                                 },
//                                 children: List.generate(
//                                   days.length,
//                                   (index) => Center(
//                                     child: Text(
//                                       days[index].toString(),
//                                       style: Theme.of(context).textTheme.labelLarge,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(
//                       context,
//                       createDate(
//                         int.parse(selectedYear ?? yearsList.first.toString()),
//                         selectedMonth ?? months.first,
//                         int.parse(selectedDay ?? days.first.toString()),
//                       ),
//                     );
//                   },
//                   child: AppButtons().filledButton(true, AppStrings.confirm, context),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/utils/app_buttons.dart';
import 'app_strings.dart';
import 'pref_keys.dart';

class CustomDatePickerr extends StatefulWidget {
  final String? date;

  const CustomDatePickerr({super.key, this.date});

  @override
  State<CustomDatePickerr> createState() => _CustomDatePickerrState();
}

class _CustomDatePickerrState extends State<CustomDatePickerr> {
  List<DateTime> availableDates = [];

  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;

  late FixedExtentScrollController yearController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController dayController;

  @override
  void initState() {
    super.initState();
    _loadAvailableDates();
  }

  Future<void> _loadAvailableDates() async {
    final sp = await SharedPreferences.getInstance();
    final storedList = sp.getStringList(PrefKeys.availableDateList) ?? [];

    availableDates = storedList.map((e) => DateTime.tryParse(e)).whereType<DateTime>().toList()
      ..sort((a, b) => a.compareTo(b));

    if (availableDates.isEmpty) {
      availableDates = [DateTime.now()];
    }

    DateTime initialDate = availableDates.first;
    if (widget.date != null && widget.date!.trim().isNotEmpty) {
      try {
        final parsed = DateTime.parse(widget.date!.trim());
        if (availableDates.contains(parsed)) {
          initialDate = parsed;
        }
      } catch (_) {}

    }

    selectedYear = initialDate.year;
    selectedMonth = initialDate.month;
    selectedDay = initialDate.day;

    setState(() {
      yearController = FixedExtentScrollController(initialItem: yearsList.indexOf(selectedYear));
      monthController = FixedExtentScrollController(initialItem: monthsList(selectedYear).indexOf(selectedMonth));
      dayController =
          FixedExtentScrollController(initialItem: daysList(selectedYear, selectedMonth).indexOf(selectedDay));
    });
  }

  List<int> get yearsList {
    return availableDates.map((d) => d.year).toSet().toList()..sort();
  }

  List<int> monthsList(int year) {
    return availableDates.where((d) => d.year == year).map((d) => d.month).toSet().toList()..sort();
  }

  List<int> daysList(int year, int month) {
    return availableDates.where((d) => d.year == year && d.month == month).map((d) => d.day).toList()..sort();
  }

  String getMonthAbbr(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (availableDates.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final years = yearsList;
    final months = monthsList(selectedYear);
    final days = daysList(selectedYear, selectedMonth);

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
                          final validMonths = monthsList(selectedYear);
                          if (!validMonths.contains(selectedMonth)) {
                            selectedMonth = validMonths.first;
                          }
                          final validDays = daysList(selectedYear, selectedMonth);
                          if (!validDays.contains(selectedDay)) {
                            selectedDay = validDays.first;
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
                          final validDays = daysList(selectedYear, selectedMonth);
                          if (!validDays.contains(selectedDay)) {
                            selectedDay = validDays.first;
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
                  final selected = DateTime(selectedYear, selectedMonth, selectedDay);
                  if (availableDates.contains(selected)) {
                    Navigator.pop(context, selected);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Selected date not available")),
                    );
                  }
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
