import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/utils/app_buttons.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/pref_keys.dart';

class DatePickerSheet extends StatefulWidget {
  final String? date;

  const DatePickerSheet({super.key, required this.date});

  @override
  State<DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<DatePickerSheet> {
  String? selectedYear;
  String? selectedMonth;
  String? selectedDay;

  List<int> yearsList = [];
  List<int> days = [];
  List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  int initialYearIndex = 0;
  int initialMonthIndex = 0;
  int initialDayIndex = 0;

  late FixedExtentScrollController yearController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController dayController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  Future<void> loadData() async {
    final sp = await SharedPreferences.getInstance();
    final stored = sp.getStringList(PrefKeys.yearList) ?? const <String>[];

    final parsed = <int>[];
    for (final s in stored) {
      final v = int.tryParse(s);
      if (v != null) parsed.add(v);
    }

    if (parsed.isEmpty) {
      parsed.add(DateTime.now().year);
    }

    final sortedYears = List<int>.from(parsed)..sort((a, b) => b.compareTo(a));
    yearsList = sortedYears;

    _initDate();
    yearController = FixedExtentScrollController(initialItem: initialYearIndex);
    monthController = FixedExtentScrollController(initialItem: initialMonthIndex);
    dayController = FixedExtentScrollController(initialItem: initialDayIndex);

    setState(() {
      isLoading = false;
    });
  }

  void _initDate() {
    DateTime selectedDate;
    if (widget.date != null && widget.date!.isNotEmpty) {
      try {
        selectedDate = DateTime.parse(widget.date!);
      } catch (_) {
        selectedDate = DateTime.now();
      }
    } else {
      selectedDate = DateTime.now();
    }

    for (var i = 0; i < yearsList.length; ++i) {
      if (yearsList[i] == selectedDate.year) {
        selectedYear = yearsList[i].toString();
        initialYearIndex = i;
        break;
      }
    }

    initialMonthIndex = selectedDate.month - 1;
    selectedMonth = months[initialMonthIndex];

    getDaysInMonth(month: selectedMonth!, year: selectedDate.year);

    for (var i = 0; i < days.length; ++i) {
      if (days[i] == selectedDate.day) {
        initialDayIndex = i;
        selectedDay = days[i].toString();
        break;
      }
    }
  }

  void getDaysInMonth({required String month, required int year}) {
    days.clear();
    final monthMap = {
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

    final monthNumber = monthMap[month] ?? 1;
    final daysInMonth = DateTime(year, monthNumber + 1, 0).day;

    for (var i = 1; i <= daysInMonth; i++) {
      days.add(i);
    }
  }

  DateTime createDate(int year, String month, int day) {
    final monthMap = {
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
    final monthNumber = monthMap[month]!;
    return DateTime(year, monthNumber, day);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

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
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.clear),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(AppStrings.year, style: Theme.of(context).textTheme.bodyMedium),
                            Expanded(
                              child: CupertinoPicker(
                                itemExtent: 32,
                                scrollController: yearController,
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    selectedYear = yearsList[index].toString();
                                  });
                                },
                                children: List.generate(
                                  yearsList.length,
                                  (index) => Center(
                                    child: Text(
                                      yearsList[index].toString(),
                                      style: Theme.of(context).textTheme.labelLarge,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(AppStrings.month, style: Theme.of(context).textTheme.bodyMedium),
                            Expanded(
                              child: CupertinoPicker(
                                itemExtent: 30,
                                scrollController: monthController,
                                onSelectedItemChanged: (index) {
                                  selectedMonth = months[index];
                                  getDaysInMonth(
                                    month: selectedMonth!,
                                    year: int.parse(selectedYear ?? yearsList.first.toString()),
                                  );
                                  setState(() {});
                                },
                                children: List.generate(
                                  months.length,
                                  (index) => Center(
                                    child: Text(
                                      months[index],
                                      style: Theme.of(context).textTheme.labelLarge,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(AppStrings.day, style: Theme.of(context).textTheme.bodyMedium),
                            Expanded(
                              child: CupertinoPicker(
                                itemExtent: 32,
                                scrollController: dayController,
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    selectedDay = days[index].toString();
                                  });
                                },
                                children: List.generate(
                                  days.length,
                                  (index) => Center(
                                    child: Text(
                                      days[index].toString(),
                                      style: Theme.of(context).textTheme.labelLarge,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(
                      context,
                      createDate(
                        int.parse(selectedYear ?? yearsList.first.toString()),
                        selectedMonth ?? months.first,
                        int.parse(selectedDay ?? days.first.toString()),
                      ),
                    );
                  },
                  child: AppButtons().filledButton(true, AppStrings.confirm, context),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
