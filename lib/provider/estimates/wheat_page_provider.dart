import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/service/post_services.dart';
import 'package:uswheat/utils/app_buttons.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_strings.dart';
import '../../modal/watch_list_state.dart';
import '../../modal/watchlist_modal.dart';
import '../../service/get_api_services.dart';
import '../../utils/app_widgets.dart';

class WheatPageProvider extends ChangeNotifier {
  List<num> uniqueYears = [];
  String? selectedYears;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  String? finalDate;
  String? prdate;
  WheatData? current;
  WheatData? lastYear;
  WheatData? fiveYearsAgo;
  final List<String> fixedMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  bool isLoading = false;
  bool _isPickerOpen = false;

  void clearData() {
    current = null;
    lastYear = null;
    fiveYearsAgo = null;
  }

  Future<void> getYears({required BuildContext context, required bool loader}) async {
    final response = await GetApiServices().get(
      endpoint: ApiEndpoint.getYears,
      context: context,
      loader: loader,
    );

    if (response != null) {
      uniqueYears = List<num>.from(json.decode(response.body));
      uniqueYears.sort((a, b) => b.compareTo(a));
      selectedYears = uniqueYears.contains(DateTime.now().year) ? DateTime.now().year.toString() : uniqueYears.first.toString();
      //updateFinalDate(prDate: "", context: context, wClass: wheatClass);
      notifyListeners();
    }
  }

  bool isInWatchlist(String wheatClass, String? date) {
    if (date == null) return false;
    String key = "$wheatClass|$date";
    return WatchlistState.watchlistKeys.contains(key);
  }

  void getQualityReport({required BuildContext context, required String wheatClass, required String date}) async {
    var data = {
      "class": wheatClass,
      "date": date ?? "",
    };

    final response = await PostServices().post(
      endpoint: ApiEndpoint.qualityReport,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: true,
    );

    if (response != null) {
      final decoded = json.decode(response.body);

      if (decoded['data'] != null) {
        var currentList = decoded['data']['current'] as List<dynamic>?;
        var lastYearList = decoded['data']['last_year'] as List<dynamic>?;
        var fiveYearsList = decoded['data']['five_years_ago'] as List<dynamic>?;

        current = (currentList != null && currentList.isNotEmpty) ? WheatData.fromJson(currentList[0]) : null;

        lastYear = (lastYearList != null && lastYearList.isNotEmpty) ? WheatData.fromJson(lastYearList[0]) : null;

        fiveYearsAgo = (fiveYearsList != null && fiveYearsList.isNotEmpty) ? WheatData.fromJson(fiveYearsList[0]) : null;

        notifyListeners();
      }
    }
  }

  void addWatchList({required BuildContext context, required String wheatClass, required String color}) {
    if (prdate == null || prdate!.isEmpty) {
      AppWidgets.appSnackBar(
        context: context,
        text: AppStrings.pleaseSelectDateBeforeAddingToWatchlist,
        color: AppColors.cd63a3a,
      );
      return;
    }

    String key = "$wheatClass|$prdate";

    if (WatchlistState.watchlistKeys.contains(key)) {
      return;
    }

    var data = {
      "type": "quality",
      "filterdata": {
        "class": wheatClass,
        "date": prdate,
        "color": color,
      }
    };

    PostServices()
        .post(
      endpoint: ApiEndpoint.storeWatchlist,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: true,
    )
        .then((value) {
      if (value != null) {
        WatchlistState.watchlistKeys.add(key);
        AppWidgets.appSnackBar(
          context: context,
          text: AppStrings.watchlistAddedSuccessfully,
          color: AppColors.c2a8741,
        );
        notifyListeners();
      }
    });
  }

  void updateFinalDate({required String prDate, required BuildContext context, required String wClass}) {
    clearData();
    if (prDate.isNotEmpty) {
      finalDate = prDate;
      prDate = prDate;
      getQualityReport(context: context, wheatClass: wClass, date: prDate);
    } else {
      if (selectedYears != null) {
        final year = int.parse(selectedYears!);
        int daysInMonth = DateTime(year, selectedMonth + 1, 0).day;
        if (selectedDay > daysInMonth) selectedDay = daysInMonth;
        finalDate = "$year-${selectedMonth.toString().padLeft(2, "0")}-${selectedDay.toString().padLeft(2, "0")}";
        prdate = finalDate;

        getQualityReport(context: context, wheatClass: wClass, date: finalDate ?? "");
      } else {
        finalDate = "";
        prdate = "";
      }
      notifyListeners();
    }
  }

  void showYearPicker(BuildContext context, {required String wheatClass}) {
    if (_isPickerOpen) return;
    _isPickerOpen = true;

    if (uniqueYears.isEmpty) {
      getYears(context: context, loader: false).then((_) {
        Future.delayed(Duration(milliseconds: 100), () {
          _openPicker(context, wheatClass);
        });
      });
    } else {
      Future.delayed(Duration(milliseconds: 100), () {
        _openPicker(context, wheatClass);
      });
    }
  }

  void _openPicker(BuildContext context, String wheatClass) {
    _isPickerOpen = true;
    int initialYearIndex = uniqueYears.indexOf(int.tryParse(selectedYears ?? '') ?? uniqueYears.first);

    int year = int.tryParse(selectedYears ?? '') ?? DateTime.now().year;
    int daysInMonth = DateTime(year, selectedMonth + 1, 0).day;

    showCupertinoModalPopup(
      context: context,
      builder: (_) => SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height / 2.5,
            color: AppColors.cFFFFFF,
            child: Column(
              children: [
                // Pickers
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(initialItem: initialYearIndex),
                          itemExtent: 40,
                          onSelectedItemChanged: (index) {
                            selectedYears = uniqueYears[index].toString();
                          },
                          children: uniqueYears.map((y) => Center(child: Text(y.toString()))).toList(),
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(initialItem: selectedMonth - 1),
                          itemExtent: 40,
                          onSelectedItemChanged: (index) {
                            selectedMonth = index + 1;
                          },
                          children: fixedMonths.map((m) => Center(child: Text(m))).toList(),
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(initialItem: selectedDay - 1),
                          itemExtent: 40,
                          onSelectedItemChanged: (index) {
                            selectedDay = index + 1;
                          },
                          children: List.generate(daysInMonth, (i) => Center(child: Text((i + 1).toString()))),
                        ),
                      ),
                    ],
                  ),
                ),
                // Buttons
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(onTap: () => Navigator.pop(context), child: AppButtons().filledButton(true, AppStrings.cancel, context)),
                      GestureDetector(
                          onTap: () {
                            updateFinalDate(prDate: "", context: context, wClass: wheatClass);
                            getQualityReport(context: context, wheatClass: wheatClass, date: prdate ?? "");
                            Navigator.pop(context);
                          },
                          child: AppButtons().filledButton(true, AppStrings.confirm, context)),
                    ],
                  ),
                ),
              ],
            )),
      ),
    ).whenComplete(() {
      _isPickerOpen = false;
    });
  }
}
