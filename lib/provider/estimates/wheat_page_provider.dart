import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/service/post_services.dart';
import 'package:uswheat/utils/app_buttons.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_strings.dart';

import '../../modal/quality_report_modal.dart';
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
  bool _isInWatchlist = false;

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
      updateFinalDate();
      notifyListeners();
    }
  }

  void getQualityReport({required BuildContext context, required String wheatClass}) async {
    if (prdate == null || prdate!.isEmpty) {
      return;
    }
    var data = {"class": wheatClass, "date": prdate ?? ""};

    final response = await PostServices().post(
      endpoint: ApiEndpoint.qualityReport,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: true,
    );

    if (response != null) {
      print("Request Data: $data");
      print("Response Body: ${response.body}");
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

  addWatchList({
    required BuildContext context,
    required String wheatClass,
  }) {
    if (prdate == null || prdate!.isEmpty) return;

    var data = {
      "type": "quality",
      "filterdata": {"class": wheatClass, "date": prdate}
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
        _isInWatchlist = true;
        AppWidgets.appSnackBar(
          context: context,
          text: "Watchlist Added Successfully",
          color: AppColors.c2a8741,
        );
      }
    });
  }

  void updateFinalDate() {
    if (selectedYears != null) {
      final year = int.parse(selectedYears!);
      int daysInMonth = DateTime(year, selectedMonth + 1, 0).day;
      if (selectedDay > daysInMonth) selectedDay = daysInMonth;
      finalDate = "$year-${selectedMonth.toString().padLeft(2, "0")}-${selectedDay.toString().padLeft(2, "0")}";
      prdate = finalDate;
    }
  }

  void showYearPicker(BuildContext context, {required String wheatClass}) {
    if (_isPickerOpen) return;
    if (uniqueYears.isEmpty) {
      getYears(context: context, loader: false).then((_) {
        _openPicker(context, wheatClass);
      });
    } else {
      _openPicker(context, wheatClass);
    }
  }

  void _openPicker(BuildContext context, String wheatClass) {
    _isPickerOpen = true;
    int initialYearIndex = uniqueYears.indexOf(int.tryParse(selectedYears ?? '') ?? uniqueYears.first);

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
          height: MediaQuery.of(context).size.height / 3,
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
                          updateFinalDate();
                          notifyListeners();
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
                          updateFinalDate();
                          notifyListeners();
                        },
                        children: fixedMonths.map((m) => Center(child: Text(m))).toList(),
                      ),
                    ),
                    Expanded(
                      child: Consumer<WheatPageProvider>(
                        builder: (_, provider, __) {
                          int year = int.tryParse(provider.selectedYears ?? '') ?? DateTime.now().year;
                          int daysInMonth = DateTime(year, provider.selectedMonth + 1, 0).day;

                          return CupertinoPicker(
                            scrollController: FixedExtentScrollController(initialItem: provider.selectedDay - 1),
                            itemExtent: 40,
                            onSelectedItemChanged: (index) {
                              provider.selectedDay = index + 1;
                              provider.updateFinalDate();
                              provider.notifyListeners();
                            },
                            children: List.generate(daysInMonth, (i) => Center(child: Text((i + 1).toString()))),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(onTap: () => Navigator.pop(context), child: AppButtons().filledButton(true, AppStrings.cancel, context)),
                  GestureDetector(
                      onTap: () {
                        updateFinalDate();
                        getQualityReport(context: context, wheatClass: wheatClass);
                        Navigator.pop(context);
                      },
                      child: AppButtons().filledButton(true, AppStrings.confirm, context)),
                ],
              ),
            ],
          )),
    ).whenComplete(() {
      _isPickerOpen = false;
    });
  }
}
