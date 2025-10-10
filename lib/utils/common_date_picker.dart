import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uswheat/utils/app_buttons.dart';
import 'package:uswheat/utils/app_strings.dart';

class DatePickerSheet extends StatefulWidget {
  final List<int> yearsList;

  const DatePickerSheet({
    super.key,
    required this.yearsList,
  });

  @override
  State<DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<DatePickerSheet> {
  String? selectedYear;
  String? selectedMonth;
  String? selectedDay;
  int initialYearIndex = 0;
  int initialMonthIndex = 0;
  int initialDayIndex = 0;

  List<int> days = [];
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() {
    print("year list in picker :${widget.yearsList}");

    for (var i = 0; i < widget.yearsList.length; ++i) {
      if (DateTime.now().year.toString() == widget.yearsList[i].toString()) {
        selectedYear = widget.yearsList[i].toString();
        initialYearIndex = i;
        break;
      }
    }

    initialMonthIndex = DateTime.now().month - 1;
    selectedMonth = months[DateTime.now().month - 1];
    getDaysInMonth(
        month: getCurrentMonthName(), year: int.parse(selectedYear ?? ""));

    for (var i = 0; i < days.length; ++i) {
      if (DateTime.now().day == days[i]) {
        initialDayIndex = i;
        selectedDay = days[i].toString();
        break;
      }
    }
    setState(() {});
  }

  String getCurrentMonthName() {
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    int monthIndex = DateTime.now().month;
    return monthNames[monthIndex - 1];
  }

  DateTime createDate(int year, String month, int day) {
    // Map month name to month number
    final months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };

    int? monthNumber = months[month];
    if (monthNumber == null) {
      throw ArgumentError('Invalid month name: $month');
    }

    return DateTime(year, monthNumber, day);
  }

  getDaysInMonth({required String month, required int year}) {
    days.clear();
    final months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };

    int monthNumber = months[month] ?? 1;

    int daysInMonth = DateTime(year, monthNumber + 1, 0).day;

    for (var i = 0; i < daysInMonth; ++i) {
      days.add(i + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "${AppStrings.select} ${AppStrings.date}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.clear))
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              AppStrings.year,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                  itemExtent: 32,
                                  scrollController: FixedExtentScrollController(
                                      initialItem: initialYearIndex),
                                  onSelectedItemChanged: (index) {
                                    setState(() => selectedYear =
                                        widget.yearsList[index].toString());
                                  },
                                  children: List.generate(
                                    widget.yearsList.length,
                                    (index) {
                                      var data = widget.yearsList[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          data.toString() ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                      );
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              AppStrings.month,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                  itemExtent: 30,
                                  scrollController: FixedExtentScrollController(
                                      initialItem: initialMonthIndex),
                                  onSelectedItemChanged: (index) {
                                    getDaysInMonth(
                                        month: months[index],
                                        year:
                                            int.parse(selectedYear.toString()));

                                    setState(
                                        () => selectedMonth = months[index]);
                                  },
                                  children: List.generate(
                                    months.length,
                                    (index) {
                                      var data = months[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          data.toString() ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                      );
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              AppStrings.day,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                  itemExtent: 32,
                                  scrollController: FixedExtentScrollController(
                                      initialItem: initialDayIndex),
                                  onSelectedItemChanged: (index) {
                                    setState(() =>
                                        selectedDay = days[index].toString());
                                  },
                                  children: List.generate(
                                    days.length,
                                    (index) {
                                      var data = days[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          data.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                      );
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(
                        context,
                        createDate(int.parse(selectedYear.toString()),
                            selectedMonth ?? "", int.parse(selectedDay ?? "")));
                  },
                  child: AppButtons().filledButton(
                    true,
                    AppStrings.confirm,
                    context,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
