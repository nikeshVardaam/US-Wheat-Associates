import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/modal/model_local_watchList.dart';
import 'package:uswheat/service/post_services.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_strings.dart';
import '../../modal/watchlist_modal.dart';
import '../../utils/app_widgets.dart';

class WheatPageProvider extends ChangeNotifier {
  List<int>? uniqueYears = [];

  String? selectedDate;
  WheatData? current;
  SharedPreferences? sp;
  String? defaultDate;
  String? defaultClass;

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

  Future<void> getDefaultDate({required BuildContext context, required String wheatClass}) async {
    await PostServices().post(endpoint: ApiEndpoint.lastDate, context: context, loader: true, requestData: {"class": wheatClass}, isBottomSheet: false).then(
      (value) {
        if (value != null) {
          var response = jsonDecode(value.body);
          var data = response["data"];
          selectedDate = data["last_available_date"].toString();
          defaultClass = data["class"];
        }
      },
    );
    notifyListeners();
  }

  void getQualityReport({required BuildContext context, required String wheatClass, required String date}) async {
    print(date.runtimeType);
    var data = {
      "class": wheatClass,
      "date": date,
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
        final decoded = json.decode(value.body);

        if (decoded['data'] != null) {
          final data = decoded['data'];

          current = data['current'] != null ? WheatData.fromJson(data['current']) : null;
          yearAverage = data['year_average'] != null ? WheatData.fromJson(data['year_average']) : null;
          fiveYearAverage = data['five_year_average'] != null ? WheatData.fromJson(data['five_year_average']) : null;

          notifyListeners();
        }
      }
    });
  }

  void addWatchList({required BuildContext context, required String wheatClass, required String color}) {
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
        .then((value) async {
      if (value != null) {
        List<ModelLocalWatchlist> modelLocalWatchList = [];
        sp = await SharedPreferences.getInstance();

        ModelLocalWatchlist localWatchlist = [] as ModelLocalWatchlist;
        modelLocalWatchList.add(localWatchlist);
        sp?.setString(AppStrings.localWatchlist, modelLocalWatchList.toString());

        var strData = sp?.getString(AppStrings.localWatchlist);
        print(strData.runtimeType);
        print("tsdbnkfj");
        List<ModelLocalWatchlist> list = [];
        list = jsonDecode(strData ?? "");
        print(list.runtimeType);
        print(list[0].cls);
        print(list[0].date);
        for (var i = 0; i < list.length; ++i) {
          if (list[i].date != selectedDate && list[i].cls != wheatClass) {
            localWatchlist =
                ModelLocalWatchlist(type: "quality", date: selectedDate, cls: wheatClass, yearAverage: current, finalAverage: yearAverage, currentAverage: fiveYearAverage);
          }
        }

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
    if (selectedDate != null) {
      prDate = prDate;
      getQualityReport(context: context, wheatClass: wClass, date: selectedDate.toString());
    } else {
      getQualityReport(context: context, wheatClass: wClass, date: selectedDate ?? "");
    }
    notifyListeners();
  }
}
