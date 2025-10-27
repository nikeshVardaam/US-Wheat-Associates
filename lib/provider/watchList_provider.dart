import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/dashboard_page/price/prices.dart';
import 'package:uswheat/modal/model_local_watchList.dart';
import 'package:uswheat/modal/watchlist_modal.dart';
import 'package:uswheat/service/delete_service.dart';
import 'package:uswheat/service/get_api_services.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/pref_keys.dart';
import '../dashboard_page/quality/estimates/wheat_pages.dart';
import '../modal/graph_modal.dart';
import '../modal/sales_modal.dart';
import '../service/post_services.dart';
import '../utils/app_assets.dart';
import 'dashboard_provider.dart';

class WatchlistProvider extends ChangeNotifier {
  List<QualityWatchListModel> qList = [];
  List<PriceWatchListModel> pList = [];
  SharedPreferences? sp;
  List<ModelLocalWatchlistData> localWatchList = [];

  String? grphcode;



  final List<String> fixedMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final Map<String, bool> _chartLoadingMap = {};

  final Map<String, List<SalesData>> _localChartCache = {};

  Future<void> getPrefData() async {
    localWatchList.clear();

    sp = await SharedPreferences.getInstance();
    var data = sp?.getString(PrefKeys.watchList);
    if (data != null) {
      List<dynamic> list = jsonDecode(data);

      for (var i = 0; i < list.length; ++i) {
        ModelLocalWatchlistData modelLocalWatchlistData = ModelLocalWatchlistData.fromJson(list[i]);
        localWatchList.add(modelLocalWatchlistData);
      }
    }
    notifyListeners();
  }

  navigateToPriceReport({
    required BuildContext context,
    required String region,
    required String classs,
    required String date,
  }) {
    Provider.of<DashboardProvider>(context, listen: false).setChangeActivity(
      activity: Prices(
        cls: classs,
        region: region,
        year: date,
      ),
      pageName: AppStrings.price,
    );
  }

  navigateToQualityReport({
    required BuildContext context,
    required String dateTime,
    required String wheatClass,
  }) async {
    String pageName = AppStrings.quality;
    switch (wheatClass) {
      case "HRW":
        await updateInPref(cls: wheatClass, date: dateTime);
        Provider.of<DashboardProvider>(context, listen: false).setChangeActivity(
          activity: WheatPages(
            fromWatchList: true,
            date: dateTime,
            title: AppStrings.hardRedWinter,
            appBarColor: AppColors.c2a8741,
            imageAsset: AppAssets.hardRedWinter,
            selectedClass: 'HRW',
          ),
          pageName: pageName,
        );
        break;
      case "SRW":
        Provider.of<DashboardProvider>(context, listen: false).setChangeActivity(
          activity: WheatPages(
            fromWatchList: true,
            date: dateTime,
            title: AppStrings.softRedWinter,
            appBarColor: AppColors.c603c16,
            imageAsset: AppAssets.softRedWinter,
            selectedClass: 'SRW',
          ),
          pageName: pageName,
        );
        break;
      case "SW":
        Provider.of<DashboardProvider>(context, listen: false).setChangeActivity(
          activity: WheatPages(
            fromWatchList: true,
            date: dateTime,
            title: AppStrings.softWhite,
            appBarColor: AppColors.c007aa6,
            imageAsset: AppAssets.softWhite,
            selectedClass: 'SW',
          ),
          pageName: pageName,
        );
        break;
      case "HRS":
        Provider.of<DashboardProvider>(context, listen: false).setChangeActivity(
          activity: WheatPages(
            fromWatchList: true,
            date: dateTime,
            title: AppStrings.hardRedSpring,
            appBarColor: AppColors.cb86a29,
            imageAsset: AppAssets.hardRedSpring,
            selectedClass: 'HRS',
          ),
          pageName: pageName,
        );
        break;
      case "Durum":
        Provider.of<DashboardProvider>(context, listen: false).setChangeActivity(
          activity: WheatPages(
            fromWatchList: true,
            date: dateTime,
            title: AppStrings.northernDurum,
            appBarColor: AppColors.cb01c32,
            imageAsset: AppAssets.northernDurum,
            selectedClass: "Durum",
          ),
          pageName: pageName,
        );
        break;
    }
    notifyListeners();
  }

  void setChartLoadingForItem(String itemId, bool isLoading) {
    _chartLoadingMap[itemId] = isLoading;
  }

  Future<ModelLocalWatchlistData?> getDataFromLocalList(
      {required String date, required String cls, required String type}) async {
    List<ModelLocalWatchlistData> localList = [];
    sp = await SharedPreferences.getInstance();

    var data = sp?.getString(PrefKeys.watchList);

    List<dynamic> list = jsonDecode(data.toString()) ?? [];
    for (var i = 0; i < list.length; ++i) {
      ModelLocalWatchlistData m = ModelLocalWatchlistData.fromJson(list[i]);
      localList.add(m);
    }
    ModelLocalWatchlistData? modelLocalWatchlistData;
    for (var i = 0; i < localList.length; ++i) {
      if (localList[i].type == type && localList[i].date == date && localList[i].cls == cls) {
        modelLocalWatchlistData = localList[i];
      }
    }
    return modelLocalWatchlistData;
  }

  Future<ModelLocalWatchlistData?> getGraphDataFromLocalList(
      {required String date, required String cls, required String gRPHCode, required String region}) async {
    List<ModelLocalWatchlistData> localList = [];
    sp = await SharedPreferences.getInstance();

    var data = sp?.getString(PrefKeys.watchList);

    List<dynamic> list = jsonDecode(data.toString()) ?? [];
    for (var i = 0; i < list.length; ++i) {
      ModelLocalWatchlistData m = ModelLocalWatchlistData.fromJson(list[i]);
      localList.add(m);
    }
    ModelLocalWatchlistData? modelLocalWatchlistData;
    for (var i = 0; i < localList.length; ++i) {
      if (localList[i].type == "price" &&
          localList[i].date == date &&
          localList[i].cls == cls &&
          localList[i].gRPHCode == gRPHCode &&
          localList[i].region == region) {
        modelLocalWatchlistData = localList[i];
      }
    }
    return modelLocalWatchlistData;
  }

  deleteFromPrefData({required String date, required String cls, required String type, required String region}) async {
    bool hasData = false;

    if (localWatchList.isNotEmpty) {
      for (var i = 0; i < localWatchList.length; ++i) {
        if (localWatchList[i].type == "quality" && localWatchList[i].date == date && localWatchList[i].cls == cls) {
          hasData = true;
          break;
        } else if (localWatchList[i].type == "price" &&
            localWatchList[i].date == date &&
            localWatchList[i].cls == cls &&
            localWatchList[i].region == region) {
          hasData = true;
          break;
        }
      }
      if (hasData) {
        for (var i = 0; i < localWatchList.length; ++i) {
          if (localWatchList[i].type == "quality" && localWatchList[i].cls == cls && localWatchList[i].date == date) {
            localWatchList.removeAt(i);
            notifyListeners();
            break;
          } else if (localWatchList[i].type == "price" &&
              localWatchList[i].cls == cls &&
              localWatchList[i].date == date) {
            localWatchList.removeAt(i);
            notifyListeners();
            break;
          }
        }
      }
    }

    sp?.setString(PrefKeys.watchList, jsonEncode(localWatchList));
    getPrefData();
  }

  getWatchList({required BuildContext context}) async {
    sp = await SharedPreferences.getInstance();
    qList.clear();
    pList.clear();

    final response = await GetApiServices().get(
      endpoint: ApiEndpoint.getWatchlist,
      context: context,
      loader: true,
    );

    if (response != null) {
      final data = jsonDecode(response.body)['data'];
      List<WatchlistItem> watchlist = (data as List).map((e) => WatchlistItem.fromJson(e)).toList();

      if (watchlist.isNotEmpty) {
        for (var i = 0; i < watchlist.length; ++i) {
          if (watchlist[i].type.toLowerCase() == "quality") {
            await getDataFromLocalList(
                    date: watchlist[i].filterdata.date ?? "",
                    cls: watchlist[i].filterdata.classs ?? "",
                    type: "quality")
                .then(
              (value) {
                QualityWatchListModel q = QualityWatchListModel(
                  id: watchlist[i].id,
                  filterData: watchlist[i].filterdata,
                  current: value?.currentAverage,
                  yearAverage: value?.yearAverage,
                  fiveYearAverage: value?.finalAverage,
                );
                qList.add(q);
              },
            );
          } else {
            getGraphDataFromLocalList(
              date: watchlist[i].filterdata.date ?? "",
              cls: watchlist[i].filterdata.classs ?? "",
              gRPHCode: watchlist[i].filterdata.graphCode ?? "",
              region: watchlist[i].filterdata.region ?? "",
            ).then(
              (value) {
                PriceWatchListModel p = PriceWatchListModel(
                  id: watchlist[i].id,
                  filterData: watchlist[i].filterdata,
                  graphData: value?.graphData,
                );
                pList.add(p);
              },
            );
          }
        }
      } else {
        localWatchList.clear();
        sp?.setString(PrefKeys.watchList, jsonEncode(localWatchList));
      }
    }
    notifyListeners();
  }

  void deleteWatchList(
      {required BuildContext context,
      required String id,
      required String date,
      required String cls,
      required String type,
      required String region}) async {
    await DeleteService()
        .deleteWithId(
      endpoint: ApiEndpoint.removeWatchlist,
      context: context,
      id: id,
    )
        .then(
      (value) {
        notifyListeners();
        if (value != null) {
          getWatchList(context: context);
          deleteFromPrefData(date: date, cls: cls, type: type, region: region);

          // if (type == "quality") {
          //   deleteFromPrefData(date: date, cls: cls, type: type,region: "");
          // }
        }
      },
    );
    notifyListeners();
  }

  upDateQualityData({required BuildContext context, required String cls, required String date}) async {
    getQualityReport(context: context, date: date, cls: cls).then((value) {});
  }

  Future<void> getQualityReport({required BuildContext context, required String cls, required String date}) async {
    var data = {
      "class": cls,
      "date": date,
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

          WheatData? current = data['current'] != null ? WheatData.fromJson(data['current']) : null;
          WheatData? yearAverage = data['year_average'] != null ? WheatData.fromJson(data['year_average']) : null;
          WheatData? fiveYearAverage =
              data['five_year_average'] != null ? WheatData.fromJson(data['five_year_average']) : null;

          bool hasData = false;

          if (localWatchList.isNotEmpty) {
            for (var i = 0; i < localWatchList.length; ++i) {
              if (localWatchList[i].type == "quality" &&
                  localWatchList[i].date == date &&
                  localWatchList[i].cls == cls) {
                hasData = true;
                break;
              }
            }
            if (hasData) {
              for (var i = 0; i < localWatchList.length; ++i) {
                if (localWatchList[i].type == "quality" &&
                    localWatchList[i].cls == date &&
                    localWatchList[i].date == cls) {
                  ModelLocalWatchlistData modelLocalWatchlist = ModelLocalWatchlistData(
                    type: "quality",
                    date: date,
                    cls: cls,
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
                date: date,
                cls: cls,
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
              date: date,
              cls: cls,
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

        getWatchList(context: context);
      }
    });
  }

  upDateGraphData({required FilterData? filterData, required BuildContext context}) async {
    final data = {
      "grphcode": filterData?.graphCode ?? "",
      "prdate": filterData?.date ?? "",
    };
    await PostServices()
        .post(
      endpoint: ApiEndpoint.getGraphData,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: true,
    )
        .then(
      (value) {
        List<GraphDataModal> graphDataList = [];
        if (value != null) {
          var data = jsonDecode(value.body);

          for (var i = 0; i < data.length; ++i) {
            GraphDataModal gl = GraphDataModal(cASHMT: data[i]["CASHMT"], pRDATE: data[i]["PRDATE"]);
            graphDataList.add(gl);
          }
        }

        if (localWatchList.isEmpty) {
          ModelLocalWatchlistData modelLocalWatchlist = ModelLocalWatchlistData(
            type: "price",
            date: filterData?.date,
            cls: filterData?.classs,
            yearAverage: null,
            finalAverage: null,
            currentAverage: null,
            region: filterData?.region,
            graphData: graphDataList,
            gRPHCode: filterData?.graphCode,
          );

          localWatchList.add(modelLocalWatchlist);

          sp?.setString(PrefKeys.watchList, jsonEncode(localWatchList));
        } else {
          bool ifModalHasInList = false;

          for (var i = 0; i < localWatchList.length; ++i) {
            if (localWatchList[i].type == "price" &&
                localWatchList[i].cls == filterData?.classs &&
                localWatchList[i].date == filterData?.date &&
                localWatchList[i].gRPHCode == filterData?.graphCode) {
              ifModalHasInList = true;
              break;
            }
          }

          if (ifModalHasInList) {
            for (var i = 0; i < localWatchList.length; ++i) {
              if (localWatchList[i].type == "price" &&
                  localWatchList[i].cls == filterData?.classs &&
                  localWatchList[i].date == filterData?.date &&
                  localWatchList[i].gRPHCode == filterData?.graphCode) {
                ModelLocalWatchlistData modelLocalWatchlist = ModelLocalWatchlistData(
                  type: "price",
                  date: filterData?.date,
                  cls: filterData?.classs,
                  yearAverage: null,
                  finalAverage: null,
                  currentAverage: null,
                  region: filterData?.region,
                  graphData: graphDataList,
                  gRPHCode: filterData?.graphCode,
                );
                localWatchList[i] = modelLocalWatchlist;
                notifyListeners();
                break;
              }
            }
          } else {
            ModelLocalWatchlistData modelLocalWatchlist = ModelLocalWatchlistData(
              type: "price",
              date: filterData?.date,
              cls: filterData?.classs,
              yearAverage: null,
              finalAverage: null,
              currentAverage: null,
              region: filterData?.region,
              graphData: graphDataList,
              gRPHCode: filterData?.graphCode,
            );
            localWatchList.add(modelLocalWatchlist);
          }

          sp?.setString(PrefKeys.watchList, jsonEncode(localWatchList));
        }
        getWatchList(context: context);
      },
    );
  }

  Future<void> fetchChartDataForItem(BuildContext context, WatchlistItem? item) async {
    if (item != null) {
      try {
        if (item.chartData.isNotEmpty) return;

        String region = item.filterdata.region ?? "";
        String wclass = item.filterdata.classs ?? "";
        String date = item.filterdata.date ?? "";

        if (date.length == 4) date = "$date-01-01";

        final String cacheKey = "$region|$wclass|$date";

        if (_localChartCache.containsKey(cacheKey)) {
          item.chartData = _localChartCache[cacheKey]!;
          return;
        }

        final graphCodeRes = await PostServices().post(
          endpoint: ApiEndpoint.getGraphCodesByClassAndRegion,
          requestData: {"class": wclass, "region": region},
          context: context,
          isBottomSheet: false,
          loader: false,
        );

        if (graphCodeRes != null) {
          final body = json.decode(graphCodeRes.body);
          if (body is List && body.isNotEmpty) {
            grphcode = body.last.toString();
          }
        }

        if (grphcode == null) return;

        final graphRes = await PostServices().post(
          endpoint: ApiEndpoint.getGraphData,
          requestData: {"grphcode": grphcode, "prdate": date},
          context: context,
          isBottomSheet: false,
          loader: false,
        );

        if (graphRes != null) {
          final jsonList = json.decode(graphRes.body) as List;
          final graphList = jsonList.map((e) => GraphDataModal.fromJson(e)).toList();

          final tempChartData = fixedMonths.map((month) {
            final monthEntries = graphList.where((e) {
              try {
                final dateString = e.pRDATE;
                if (dateString == null || dateString.isEmpty) return false;
                final d = DateTime.parse(dateString);
                return DateFormat('MMM').format(d) == month;
              } catch (_) {
                return false;
              }
            }).toList();

            final avgSales = monthEntries.isNotEmpty
                ? monthEntries.map((e) => e.cASHMT ?? 0).reduce((a, b) => a + b) / monthEntries.length
                : 0.0;

            return SalesData(month: month, sales: avgSales);
          }).toList();

          item.chartData = tempChartData;

          _localChartCache[cacheKey] = tempChartData;
        }
      } catch (e) {
        debugPrint('❌ Error fetching chart data for item: $e');
      }
    }
  }

  Future<void> updateInPref({required String cls, required String date}) async {}
}

class QualityWatchListModel {
  final String? id;
  final FilterData? filterData;
  final WheatData? current;
  final WheatData? yearAverage;
  final WheatData? fiveYearAverage;

  QualityWatchListModel({
    required this.id,
    required this.filterData,
    required this.current,
    required this.yearAverage,
    required this.fiveYearAverage,
  });
}

class PriceWatchListModel {
  final String? id;
  final FilterData? filterData;
  final List<GraphDataModal>? graphData;

  PriceWatchListModel({
    required this.id,
    required this.filterData,
    required this.graphData,
  });
}
