import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/provider/price_provider.dart';
import 'package:uswheat/utils/app_buttons.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/pref_keys.dart';

class DatePickerSheet extends StatefulWidget {
  DatePickerSheet({
    super.key,
  });

  @override
  State<DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<DatePickerSheet> {
  String? selectedYear;
  List<int> yearsList = [];
  SharedPreferences? sp;
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

  Future<void> loadYear({required BuildContext context}) async {
    sp = await SharedPreferences.getInstance();

    final stored = sp?.getStringList(PrefKeys.yearList) ?? const <String>[];

    final parsed = <int>[];
    for (final s in stored) {
      final v = int.tryParse(s);
      if (v != null) parsed.add(v);
    }

    if (parsed.isEmpty) {
      final nowYear = DateTime.now().year;
      parsed.add(nowYear);
    }

    final sortedYears = List<int>.from(parsed)..sort((a, b) => b.compareTo(a));
    final currentYear = DateTime.now().year;
    final chosenYear =
        sortedYears.contains(currentYear) ? currentYear : sortedYears.first;

    yearsList = sortedYears;

    initData();
    setState(() {});
  }

  @override
  void initState() {
    loadYear(context: context);
    super.initState();
  }

  initData() {
    for (var i = 0; i < yearsList.length; ++i) {
      if (DateTime.now().year.toString() == yearsList[i].toString()) {
        selectedYear = yearsList[i].toString();
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
  Widget build(BuildContext perentContext) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(perentContext).size.height / 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "${AppStrings.select} ${AppStrings.date}",
                      style: Theme.of(perentContext).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(perentContext);
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
                              style:
                                  Theme.of(perentContext).textTheme.bodyMedium,
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                  itemExtent: 32,
                                  scrollController: FixedExtentScrollController(
                                      initialItem: initialYearIndex),
                                  onSelectedItemChanged: (index) {
                                    setState(() => selectedYear =
                                        yearsList[index].toString());
                                  },
                                  children: List.generate(
                                    yearsList.length,
                                    (index) {
                                      var data = yearsList[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          data.toString() ?? "",
                                          style: Theme.of(perentContext)
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
                              style:
                                  Theme.of(perentContext).textTheme.bodyMedium,
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
                                          style: Theme.of(perentContext)
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
                              style:
                                  Theme.of(perentContext).textTheme.bodyMedium,
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
                                          style: Theme.of(perentContext)
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
                        perentContext,
                        createDate(int.parse(selectedYear.toString()),
                            selectedMonth ?? "", int.parse(selectedDay ?? "")));
                  },
                  child: AppButtons().filledButton(
                    true,
                    AppStrings.confirm,
                    perentContext,
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
