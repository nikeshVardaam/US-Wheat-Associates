import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:uswheat/modal/all_price_data_modal.dart';
import 'package:uswheat/modal/model_price_watchList.dart';
import 'package:uswheat/modal/model_region.dart';

import 'package:uswheat/service/get_api_services.dart';
import 'package:uswheat/service/post_services.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_widgets.dart';
import 'package:uswheat/utils/miscellaneous.dart';
import '../modal/graph_modal.dart';
import '../modal/watchlist_modal.dart';
import '../utils/pref_keys.dart';

class PricesProvider extends ChangeNotifier {
  List<RegionAndClasses> regionsList = [];
  RegionAndClasses? selectedRegion;

  String? selectedClass;

  String? selectedYear;
  List<GraphDataModal> graphDataList = [];
  String? selectedGRPHCode;
  String? pRDate;
  ZoomPanBehavior? zoomPanBehavior;
  AllPriceDataModal? allPriceDataModal;
  SharedPreferences? sp;

  List<ModelPriceWatchList> localPriceWatchList = [];

  setSelectedRegion({required RegionAndClasses rg, required BuildContext context}) async {
    selectedRegion = rg;
    if (selectedClass != null && pRDate != null) {
      await getGraphCodesByClassAndRegion(context: context).then(
        (value) async {
          await getGraphData(context: context).then(
            (value) async {
              await getAllPriceData(context: context).then(
                (value) {},
              );
            },
          );
        },
      );
    }

    notifyListeners();
  }

  setSelectedClass({required String cls, required BuildContext context}) async {
    selectedClass = cls;
    if (selectedClass != null && pRDate != null) {
      await getGraphCodesByClassAndRegion(context: context).then(
        (value) async {
          await getGraphData(context: context).then(
            (value) async {
              await getAllPriceData(context: context).then(
                (value) {},
              );
            },
          );
        },
      );
    }
    notifyListeners();
  }

  String getLastOneYearRange(String? date) {
    if (date?.isNotEmpty ?? false) {
      DateTime endDate = DateTime.parse(date ?? "");
      DateTime startDate = DateTime(endDate.year - 1, endDate.month, endDate.day);
      return "${Miscellaneous.ymd(startDate.toString())} To ${Miscellaneous.ymd(endDate.toString())}";
    } else {
      return "";
    }
  }

  Future<void> initCallFromWatchList({required BuildContext context, required String? region, required String? cls, required String? year}) async {
    zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      enablePinching: true,
      maximumZoomLevel: 0.5,
      // must be double
      enableDoubleTapZooming: true,
      enableDirectionalZooming: true,
      enableSelectionZooming: true,
      zoomMode: ZoomMode.xy,
    );

    for (var i = 0; i < regionsList.length; ++i) {
      if (regionsList[i].region == region) {
        selectedRegion = regionsList[i];
      }
    }

    selectedClass = cls;
    pRDate = year;

    await getGraphCodesByClassAndRegion(context: context).then(
      (value) async {
        await getGraphData(context: context).then(
          (value) async {
            await getAllPriceData(context: context).then(
              (value) {},
            );
          },
        );
      },
    );

    notifyListeners();
  }

  Future<void> initCall({required BuildContext context}) async {
    zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      enablePinching: true,
      zoomMode: ZoomMode.x,
    );

    getCurrentDate();
    await loadRegionAndClasses(context: context).then(
      (value) async {
        await getGraphCodesByClassAndRegion(context: context).then(
          (value) async {
            await getGraphData(context: context).then(
              (value) async {
                await getAllPriceData(context: context).then(
                  (value) {},
                );
              },
            );
          },
        );
      },
    );
    notifyListeners();
  }

  addToWatchlist({required BuildContext context}) async {
    sp = await SharedPreferences.getInstance();
    final data = {
      "type": "price",
      "filterdata": {"region": selectedRegion?.region ?? "", "class": selectedClass ?? "", "date": pRDate, "color": "ffab865a", "grphcode": selectedGRPHCode ?? ""}
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
        .then(
      (value) {
        if (value != null) {
          if (localPriceWatchList.isEmpty) {
            ModelPriceWatchList priceWatchListModel = ModelPriceWatchList(
                type: "price",
                filterData: FilterData(
                    region: selectedRegion?.region ?? "",
                    classs: selectedClass.toString(),
                    date: pRDate.toString(),
                    color: "ffab865a",
                    year: selectedYear.toString(),
                    graphCode: selectedGRPHCode.toString()),
                graphData: graphDataList);
            localPriceWatchList.add(priceWatchListModel);
            sp?.setString(PrefKeys.watchList, jsonEncode(localPriceWatchList));
          } else {
            bool ifModalHasInList = false;

            for (var i = 0; i < localPriceWatchList.length; ++i) {
              if (localPriceWatchList[i].filterData.classs == selectedClass &&
                  localPriceWatchList[i].filterData.date == pRDate &&
                  localPriceWatchList[i].filterData.region == selectedRegion &&
                  localPriceWatchList[i].filterData.graphCode == selectedGRPHCode) {
                ifModalHasInList = true;
                break;
              }
            }
            if (ifModalHasInList) {
              for (var i = 0; i < localPriceWatchList.length; ++i) {
                if (localPriceWatchList[i].filterData.classs == selectedClass && localPriceWatchList[i].filterData.date == pRDate) {
                  ModelPriceWatchList localWatchlist = ModelPriceWatchList(
                      type: "price",
                      filterData: FilterData(
                          region: selectedRegion.toString(),
                          date: pRDate.toString(),
                          color: "ffab865a",
                          classs: selectedClass.toString(),
                          year: selectedYear.toString(),
                          graphCode: selectedGRPHCode.toString()),
                      graphData: graphDataList);
                  localPriceWatchList[i] = localWatchlist;
                  notifyListeners();
                  break;
                }
              }
            } else {
              ModelPriceWatchList modelLocalWatchlist = ModelPriceWatchList(
                  type: 'price',
                  filterData: FilterData(
                      region: selectedRegion.toString(),
                      classs: selectedClass.toString(),
                      date: pRDate.toString(),
                      color: "ffab865a",
                      graphCode: selectedGRPHCode.toString(),
                      year: selectedYear.toString()),
                  graphData: graphDataList);
              localPriceWatchList.add(modelLocalWatchlist);
            }

            print(localPriceWatchList.runtimeType);

            String data = jsonEncode(localPriceWatchList);
            print(data.toString());
            sp?.setString(PrefKeys.watchList, data);
          }
          AppWidgets.appSnackBar(
            context: context,
            text: "Watchlist Added Successfully",
            color: AppColors.c2a8741,
          );
        }
      },
    );
    notifyListeners();
  }

  Future<void> loadRegionAndClasses({required BuildContext context}) async {
    regionsList.clear();
    sp = await SharedPreferences.getInstance();

    var value = sp?.getString("region");

    final modelRegion = ModelRegion.fromJson(jsonDecode(value.toString()));
    modelRegion.regions.forEach((key, list) {
      final RegionAndClasses regionAndClasses = RegionAndClasses(region: key, classes: list);
      regionsList.add(regionAndClasses);
    });
    selectedRegion = regionsList[0];
    selectedClass = selectedRegion?.classes?[0] ?? "";
    notifyListeners();
  }

  Future<void> getRegionsAndClasses({required BuildContext context}) async {
    regionsList.clear();
    await GetApiServices()
        .get(
      endpoint: ApiEndpoint.getRegionsAndClasses,
      context: context,
      loader: true,
    )
        .then(
      (value) {
        if (value != null) {
          final modelRegion = ModelRegion.fromJson(jsonDecode(value.body));
          modelRegion.regions.forEach((key, list) {
            final RegionAndClasses regionAndClasses = RegionAndClasses(region: key, classes: list);
            regionsList.add(regionAndClasses);
          });
          selectedRegion = regionsList[0];
          selectedClass = selectedRegion?.classes?[0] ?? "";
        }
      },
    );
  }

  getCurrentDate() async {
    List<int> yearsList = [];

    sp = await SharedPreferences.getInstance();
    final stored = sp?.getStringList(PrefKeys.yearList) ?? const <String>[];

    for (var i = 0; i < stored.length; ++i) {
      yearsList.add(int.parse(stored[i]));
    }

    yearsList.sort((a, b) => b.compareTo(a));

    selectedYear = yearsList[0].toString();

    for (var i = 0; i < yearsList.length; ++i) {
      if (yearsList[i].toString() == DateTime.now().year.toString()) {
        selectedYear = yearsList[i].toString();
        break;
      } else {
        selectedYear = yearsList[0].toString();
      }
    }

    pRDate = Miscellaneous.ymd(DateTime(
      int.parse(selectedYear ?? ""),
      DateTime.now().month,
      DateTime.now().day,
    ).toString());
  }

  setSelectedPrDate({required String date, required BuildContext context}) async {
    pRDate = date;
    await getGraphCodesByClassAndRegion(context: context).then(
      (value) async {
        await getGraphData(context: context).then(
          (value) async {
            await getAllPriceData(context: context).then(
              (value) {},
            );
          },
        );
      },
    );
    notifyListeners();
  }

  Future<void> getGraphCodesByClassAndRegion({
    required BuildContext context,
  }) async {
    final data = {
      "class": selectedClass ?? "",
      "region": selectedRegion?.region ?? "",
    };

    final value = await PostServices().post(
      endpoint: ApiEndpoint.getGraphCodesByClassAndRegion,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: true,
    );

    if (value == null) {
      return;
    }

    if (value.statusCode < 200 || value.statusCode >= 300) {
      return;
    }

    try {
      final decoded = json.decode(value.body);

      if (decoded is List && decoded.isNotEmpty) {
        selectedGRPHCode = decoded.first.toString();
        return;
      }

      if (decoded is Map<String, dynamic>) {
        final codes = decoded['codes'];
        if (codes is List && codes.isNotEmpty) {
          selectedGRPHCode = codes.first.toString();
          return;
        }
      }
    } on FormatException catch (e) {
      return;
    }
  }

  Future<void> getGraphData({
    required BuildContext context,
  }) async {
    if ((selectedGRPHCode ?? "").isEmpty || (pRDate ?? "").isEmpty) return;

    final data = {
      "grphcode": selectedGRPHCode ?? "",
      "prdate": pRDate ?? "",
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
        if (value != null) {
          graphDataList.clear();
          var data = jsonDecode(value.body);

          for (var i = 0; i < data.length; ++i) {
            GraphDataModal gl = GraphDataModal(cASHMT: data[i]["CASHMT"], pRDATE: data[i]["PRDATE"]);
            graphDataList.add(gl);
          }
        }
      },
    );
  }

  Future<void> getAllPriceData({
    required BuildContext context,
  }) async {
    await PostServices()
        .post(
      endpoint: ApiEndpoint.getAllPriceData,
      requestData: {
        "grphcode": selectedGRPHCode,
        "date": pRDate,
      },
      context: context,
      isBottomSheet: false,
      loader: true,
    )
        .then(
      (value) {
        if (value != null) {
          allPriceDataModal = AllPriceDataModal.fromJson(json.decode(value.body));
          notifyListeners();
        }
      },
    );
  }
}
