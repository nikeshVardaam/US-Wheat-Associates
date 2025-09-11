import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/service/post_services.dart';
import 'package:uswheat/utils/app_buttons.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/miscellaneous.dart';
import '../../modal/watch_list_state.dart';
import '../../modal/watchlist_modal.dart';
import '../../service/get_api_services.dart';
import '../../utils/app_widgets.dart';

class WheatPageProvider extends ChangeNotifier {
  String? finalDate;
  String? prdate;
  WheatData? current;
  WheatData? lastYear;
  WheatData? fiveYearsAgo;
  final List<String> fixedMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  bool isLoading = false;
  bool _isPickerOpen = false;

  Future<List<num>> getYears({required BuildContext context, required bool loader}) async {
    List<num> uniqueYears = [];
    final response = await GetApiServices().get(
      endpoint: ApiEndpoint.getYears,
      context: context,
      loader: loader,
    );

    if (response != null) {
      uniqueYears = List<num>.from(json.decode(response.body));
      uniqueYears.sort((a, b) => b.compareTo(a));
      notifyListeners();
    }

    return uniqueYears;
  }

  bool isInWatchlist(String wheatClass, String? date) {
    if (date == null) return false;
    String key = "$wheatClass|$date";
    return WatchlistState.watchlistKeys.contains(key);
  }

  Future<void> getQualityReport({required BuildContext context, required String wheatClass, required String date}) async {
    var data = {"class": wheatClass, "date": date ?? ""};

    await PostServices()
        .post(
      endpoint: ApiEndpoint.qualityReport,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: true,
    )
        .then(
      (value) {
        if (value != null) {
          final decoded = json.decode(value.body);

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
      },
    );
  }

  void addWatchList({required BuildContext context, required String wheatClass}) {
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
      }
    };

    PostServices()
        .post(
      endpoint: ApiEndpoint.storeWatchlist,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: false,
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

  Future<void> init({required String prDate, required BuildContext context, required String wClass}) async {
    finalDate = "";
    if (prDate.isNotEmpty) {
      await getQualityReport(context: context, wheatClass: wClass, date: prDate);
    }
  }

  Future<void> openPicker({required BuildContext context, required String wheatClass}) async {
    _isPickerOpen = true;

    List<num> uniqueYears = [];
    int initialYearIndex = 0;
    int daysInMonth = 0;
    int selectedMonth = DateTime.now().month;
    int selectedDay = DateTime.now().day;
    int selectedYears = DateTime.now().year;

    await getYears(context: context, loader: true).then((value) {
      if (value.isNotEmpty) {
        uniqueYears.addAll(value);
        daysInMonth = DateTime(int.parse(value.first.toString()), selectedMonth + 1, 0).day;
      }
    });

    showCupertinoModalPopup(
      context: context,
      builder: (_) => SafeArea(
        child: Container(
            color: AppColors.cFFFFFF,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(initialItem: initialYearIndex),
                          itemExtent: 40,
                          onSelectedItemChanged: (index) {
                            selectedYears = int.parse(uniqueYears[index].toString() ?? "0");
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
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(onTap: () => Navigator.pop(context), child: AppButtons().filledButton(true, AppStrings.cancel, context)),
                      GestureDetector(
                          onTap: () async {
                            DateTime selectedDate = DateTime(selectedYears, selectedMonth, selectedDay);
                            finalDate = Miscellaneous.dateConverterToYYYYMMDD(selectedDate.toString());

                            await getQualityReport(context: context, wheatClass: wheatClass, date: Miscellaneous.dateConverterToYYYYMMDD(selectedDate.toString())).then(
                              (value) {
                                Navigator.pop(context);
                              },
                            );
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
