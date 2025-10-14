import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/service/post_services.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_strings.dart';
import '../../modal/watchlist_modal.dart';
import '../../utils/app_widgets.dart';
import '../../utils/pref_keys.dart';

class WheatPageProvider extends ChangeNotifier {
  List<int>? uniqueYears = [];

  String? selectedDate;
  WheatData? current;
  SharedPreferences? sp;

  WheatData? yearAverage;
  WheatData? fiveYearAverage;

  bool isLoading = false;

  void clearData() {
    current = null;
    yearAverage = null;
    fiveYearAverage = null;
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
    print(data);

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
        print(value.body.toString());

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
    print(data);

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
