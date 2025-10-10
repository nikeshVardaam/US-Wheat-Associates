import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:uswheat/service/post_services.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_strings.dart';
import '../../modal/watch_list_state.dart';
import '../../modal/watchlist_modal.dart';
import '../../service/get_api_services.dart';
import '../../utils/app_widgets.dart';

class WheatPageProvider extends ChangeNotifier {
  List<int>? uniqueYears = [];

  String? selectedDate;
  WheatData? current;

  WheatData? yearAverage;
  WheatData? fiveYearAverage;

  bool isLoading = false;

  void clearData() {
    current = null;
    yearAverage = null;
    fiveYearAverage = null;
  }

  Future<void> getYearList(
      {required BuildContext context, required bool loader}) async {
    uniqueYears?.clear();
    await GetApiServices()
        .get(
      endpoint: ApiEndpoint.getYears,
      context: context,
      loader: loader,
    )
        .then((value) {
      if (value != null) {
        var data = jsonDecode(value.body);

        for (var i = 0; i < data.length; ++i) {
          uniqueYears?.add(data[i]);
        }
        uniqueYears?.sort((a, b) => b.compareTo(a));

        notifyListeners();
      }
    });
  }

  void updatedDate({required String date}) {
    selectedDate = date;
    notifyListeners();
  }

  void getQualityReport(
      {required BuildContext context,
      required String wheatClass,
      required String date}) async {
    var data = {
      "class": wheatClass,
      "date": date ?? "",
    };
    await PostServices()
        .post(
      endpoint: ApiEndpoint.qualityReport,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: true,
    )
        .then((value) {
      if (value != null) {
        final decoded = json.decode(value.body);

        if (decoded['data'] != null) {
          final data = decoded['data'];

          current = data['current'] != null
              ? WheatData.fromJson(data['current'])
              : null;
          yearAverage = data['year_average'] != null
              ? WheatData.fromJson(data['year_average'])
              : null;
          fiveYearAverage = data['five_year_average'] != null
              ? WheatData.fromJson(data['five_year_average'])
              : null;

          notifyListeners();
        }
      }
    });
  }

  void addWatchList(
      {required BuildContext context,
      required String wheatClass,
      required String color}) {
    if (selectedDate == null || selectedDate!.isEmpty) {
      AppWidgets.appSnackBar(
        context: context,
        text: AppStrings.pleaseSelectDateBeforeAddingToWatchlist,
        color: AppColors.cd63a3a,
      );
      return;
    }

    var data = {
      "type": "quality",
      "filterdata": {
        "class": wheatClass,
        "date": selectedDate,
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
        AppWidgets.appSnackBar(
          context: context,
          text: AppStrings.watchlistAddedSuccessfully,
          color: AppColors.c2a8741,
        );
        notifyListeners();
      }
    });
  }

  void updateFinalDate(
      {required String prDate,
      required BuildContext context,
      required String wClass}) {
    clearData();
    if (selectedDate != null) {
      prDate = prDate;
      getQualityReport(
          context: context, wheatClass: wClass, date: selectedDate.toString());
    } else {
      getQualityReport(
          context: context, wheatClass: wClass, date: selectedDate ?? "");
    }
    notifyListeners();
  }
}
