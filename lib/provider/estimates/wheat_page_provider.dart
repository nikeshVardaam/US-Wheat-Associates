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
  bool alreadyHasInWatchlist = false;
  String? selectedDate;
  WheatData? current;
  SharedPreferences? sp;
  String? selectedClass;
  List<ModelLocalWatchlistData> localWatchList = [];
  WheatData? yearAverage;
  WheatData? fiveYearAverage;
  bool isLoading = false;

  void clearData() {
    current = null;
    yearAverage = null;
    fiveYearAverage = null;
  }

  void updatedDate({required String date, required BuildContext context}) {
    selectedDate = date;
    getQualityReport(context: context);
    checkLocalWatchlist();
    notifyListeners();
  }

  initFromWatchlist({required BuildContext context}) {
    getQualityReport(context: context).then((value) {
      updateLocalWatchlist(context: context);
    });
    checkLocalWatchlist();
  }

  Future<void> getDefaultDate({required BuildContext context}) async {
    await PostServices().post(endpoint: ApiEndpoint.lastDate, context: context, loader: true, requestData: {"class": selectedClass}, isBottomSheet: false).then(
      (value) {
        if (value != null) {
          var response = jsonDecode(value.body);
          var data = response["data"];
          selectedDate = data["last_available_date"].toString();
          selectedClass = data["class"];
        }
      },
    );

    await getQualityReport(context: context).then(
      (value) {
        checkLocalWatchlist();
        notifyListeners();
      },
    );
  }

  void checkLocalWatchlist() async {
    alreadyHasInWatchlist = false;

    List<ModelLocalWatchlistData> localList = [];

    notifyListeners();

    sp = await SharedPreferences.getInstance();
    var data = sp?.getString(PrefKeys.watchList);
    if (data != null) {
      List<dynamic> list = jsonDecode(data ?? "");

      for (var i = 0; i < list.length; ++i) {
        ModelLocalWatchlistData modelLocalWatchlistData = ModelLocalWatchlistData.fromJson(list[i]);
        localList.add(modelLocalWatchlistData);
      }
    }

    for (var i = 0; i < localList.length; ++i) {
      if (localList[i].type == "quality" && localList[i].date == selectedDate && localList[i].cls == selectedClass) {
        alreadyHasInWatchlist = true;
        break;
      }
    }
    notifyListeners();
  }

  Future<void> updateLocalWatchlist({required BuildContext context}) async {
    bool hasData = false;
    if (localWatchList.isNotEmpty) {
      for (var i = 0; i < localWatchList.length; ++i) {
        if (localWatchList[i].type == "quality" && localWatchList[i].date == selectedDate && localWatchList[i].cls == selectedClass) {
          hasData = true;
          break;
        }
      }
      if (hasData) {
        for (var i = 0; i < localWatchList.length; ++i) {
          if (localWatchList[i].type == "quality" && localWatchList[i].cls == selectedClass && localWatchList[i].date == selectedDate) {
            ModelLocalWatchlistData modelLocalWatchlist = ModelLocalWatchlistData(
              type: "quality",
              date: selectedDate,
              cls: selectedClass,
              yearAverage: yearAverage,
              finalAverage: fiveYearAverage,
              currentAverage: current,
              region: null,
              graphData: [],
              gRPHCode: '',
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
          cls: selectedClass,
          yearAverage: yearAverage,
          finalAverage: fiveYearAverage,
          currentAverage: current,
          region: null,
          graphData: [],
          gRPHCode: '',
        );
        localWatchList.add(modelLocalWatchlist);
      }
    } else {
      ModelLocalWatchlistData modelLocalWatchlist = ModelLocalWatchlistData(
        type: "quality",
        date: selectedDate,
        cls: selectedClass,
        yearAverage: yearAverage,
        finalAverage: fiveYearAverage,
        currentAverage: current,
        region: null,
        graphData: [],
        gRPHCode: '',
      );
      localWatchList.add(modelLocalWatchlist);
    }
    sp?.setString(PrefKeys.watchList, jsonEncode(localWatchList));
  }

  Future<void> getQualityReport({required BuildContext context}) async {
    var data = {
      "class": selectedClass,
      "date": selectedDate,
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

          current = data['current'] != null ? WheatData.fromJson(data['current']) : null;
          yearAverage = data['year_average'] != null ? WheatData.fromJson(data['year_average']) : null;
          fiveYearAverage = data['five_year_average'] != null ? WheatData.fromJson(data['five_year_average']) : null;

          notifyListeners();
        }
      }
    });
  }

  getPrefData({required String cls, required String date}) async {
    selectedClass = cls;
    selectedDate = date;
    localWatchList.clear();

    notifyListeners();

    sp = await SharedPreferences.getInstance();
    var data = sp?.getString(PrefKeys.watchList);
    if (data != null) {
      List<dynamic> list = jsonDecode(data ?? "");

      for (var i = 0; i < list.length; ++i) {
        ModelLocalWatchlistData modelLocalWatchlistData = ModelLocalWatchlistData.fromJson(list[i]);
        localWatchList.add(modelLocalWatchlistData);
      }
    }
  }

  void addWatchList({required BuildContext context, required String wheatClass, required String color}) {
    if (selectedDate == null || selectedDate!.isEmpty) {
      AppWidgets.appSnackBar(
        context: context,
        color: AppColors.cd63a3a,
        text: AppStrings.pleaseSelectDateBeforeAddingToWatchlist,
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
            region: null,
            graphData: [],
            gRPHCode: '',
          );

          localWatchList.add(modelLocalWatchlist);

          sp?.setString(PrefKeys.watchList, jsonEncode(localWatchList));
        } else {
          bool ifModalHasInList = false;

          for (var i = 0; i < localWatchList.length; ++i) {
            if (localWatchList[i].type == "quality" && localWatchList[i].cls == wheatClass && localWatchList[i].date == selectedDate) {
              ifModalHasInList = true;
              break;
            }
          }

          if (ifModalHasInList) {
            for (var i = 0; i < localWatchList.length; ++i) {
              if (localWatchList[i].type == "quality" && localWatchList[i].cls == wheatClass && localWatchList[i].date == selectedDate) {
                ModelLocalWatchlistData modelLocalWatchlist = ModelLocalWatchlistData(
                  type: "quality",
                  date: selectedDate,
                  cls: wheatClass,
                  yearAverage: yearAverage,
                  finalAverage: fiveYearAverage,
                  currentAverage: current,
                  region: null,
                  graphData: [],
                  gRPHCode: '',
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
              region: null,
              graphData: [],
              gRPHCode: '',
            );
            localWatchList.add(modelLocalWatchlist);
          }

          sp?.setString(PrefKeys.watchList, jsonEncode(localWatchList));
        }

        AppWidgets.appSnackBar(context: context, text: AppStrings.added, color: AppColors.c2a8741);
      }
    });
  }
}
