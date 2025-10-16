import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/modal/model_local_watchList.dart';
import 'package:uswheat/service/post_services.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/pref_keys.dart';
import '../../modal/watchlist_modal.dart';
import '../../utils/app_widgets.dart';

class WheatPageProvider extends ChangeNotifier {
  List<int>? uniqueYears = [];

  String? selectedDate;
  WheatData? current;
  SharedPreferences? sp;
  String? defaultDate;
  String? defaultClass;
  List<ModelLocalWatchlistData> localWatchList = [];
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

  getPrefData() async {
    sp = await SharedPreferences.getInstance();
    var data = sp?.getString(PrefKeys.watchList);

    List<dynamic> list = jsonDecode(data ?? "");

    for (var i = 0; i < list.length; ++i) {
      ModelLocalWatchlistData modelLocalWatchlistData = ModelLocalWatchlistData.fromJson(list[i]);
      localWatchList.add(modelLocalWatchlistData);
    }
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
        if (localWatchList.isEmpty) {
          ModelLocalWatchlistData modelLocalWatchlist = ModelLocalWatchlistData(
            type: "quality",
            date: selectedDate,
            cls: wheatClass,
            yearAverage: yearAverage,
            finalAverage: fiveYearAverage,
            currentAverage: current,
          );

          localWatchList.add(modelLocalWatchlist);

          sp?.setString(PrefKeys.watchList, jsonEncode(localWatchList));
        } else {
          bool ifModalHasInList = false;

          for (var i = 0; i < localWatchList.length; ++i) {
            if (localWatchList[i].cls == wheatClass && localWatchList[i].date == selectedDate) {
              ifModalHasInList = true;
              break;
            }
          }

          if (ifModalHasInList) {
            for (var i = 0; i < localWatchList.length; ++i) {
              if (localWatchList[i].cls == wheatClass && localWatchList[i].date == selectedDate) {
                ModelLocalWatchlistData modelLocalWatchlist = ModelLocalWatchlistData(
                  type: "quality",
                  date: selectedDate,
                  cls: wheatClass,
                  yearAverage: yearAverage,
                  finalAverage: fiveYearAverage,
                  currentAverage: current,
                );
                localWatchList[i] = modelLocalWatchlist;
                notifyListeners();
                break;
              }
            }
          } else {
            ModelLocalWatchlistData modelLocalWatchlist = ModelLocalWatchlistData(
              type: "quality",
              date: selectedDate,
              cls: wheatClass,
              yearAverage: yearAverage,
              finalAverage: fiveYearAverage,
              currentAverage: current,
            );
            localWatchList.add(modelLocalWatchlist);
          }

          sp?.setString(PrefKeys.watchList, jsonEncode(localWatchList));
        }

        AppWidgets.appSnackBar(context: context, text: AppStrings.added, color: AppColors.c2a8741);
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
