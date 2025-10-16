import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/dashboard_page/price/prices.dart';
import 'package:uswheat/modal/quality_report_modal.dart';
import 'package:uswheat/modal/watchlist_modal.dart' hide YearAverage;
import 'package:uswheat/service/delete_service.dart';
import 'package:uswheat/service/get_api_services.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';
import '../dashboard_page/quality/estimates/wheat_pages.dart';
import '../modal/graph_modal.dart';
import '../modal/sales_modal.dart';
import '../service/post_services.dart';
import '../utils/app_assets.dart';
import 'dashboard_provider.dart';

class WatchlistProvider extends ChangeNotifier {
  List<QualityWatchListModel> qList = [];
  List<PriceWatchListModel> pList = [];

  String? grphcode;

  final List<String> fixedMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final Map<String, bool> _chartLoadingMap = {};

  final Map<String, List<SalesData>> _localChartCache = {};

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
  }) {
    print(dateTime);
    print(wheatClass);
    String pageName = AppStrings.quality;
    switch (wheatClass) {
      case "HRW":
        Provider.of<DashboardProvider>(context, listen: false).setChangeActivity(
          activity: WheatPages(
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
            date: dateTime,
            title: AppStrings.hardRedSpring,
            appBarColor: AppColors.cb86a29,
            imageAsset: AppAssets.hardRedSpring,
            selectedClass: 'HRS',
          ),
          pageName: pageName,
        );
        break;
      case "durum":
        Provider.of<DashboardProvider>(context, listen: false).setChangeActivity(
          activity: WheatPages(
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

  Future<QualityReport?> fetchQualityReport({
    required BuildContext context,
    required String wheatClass,
    required String date,
  }) async {
    QualityReport? qualityReport;

    final data = {"class": wheatClass, "date": date};

    await PostServices()
        .post(
      endpoint: ApiEndpoint.qualityReport,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: false,
    )
        .then(
      (value) {
        qualityReport = QualityReport.fromJson(jsonDecode(value?.body ?? ""));
      },
    );
    return qualityReport;
  }

  void setChartLoadingForItem(String itemId, bool isLoading) {
    _chartLoadingMap[itemId] = isLoading;
  }

  getWatchList({required BuildContext context}) async {
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

      for (var i = 0; i < watchlist.length; ++i) {
        if (watchlist[i].type.toLowerCase() == "quality") {
          // final value = await fetchQualityReport(
          //   context: context,
          //   wheatClass: watchlist[i].filterdata.classs.toString(),
          //   date: watchlist[i].filterdata.date.toString(),
          // );

          // if (value != null) {
          final qualityWatchListModel = QualityWatchListModel(
            current: null,
            fiveYearAverage: null,
            yearAverage: null,
            filterData: watchlist[i].filterdata,
            // current: value.data?.current,
            // yearAverage: value.data?.yearAverage,
            // fiveYearAverage: value.data?.fiveYearAverage,
            id: watchlist[i].id,
          );
          qList.add(qualityWatchListModel);
          //}
          // } else if (watchlist[i].type.toLowerCase() == "price") {
          final priceWatchListModel = PriceWatchListModel(
            id: watchlist[i].id,
            filterData: watchlist[i].filterdata,
            graphDataList: [],
          );

          pList.add(priceWatchListModel);
        }
      }
    }
    notifyListeners();
  }

  void deleteWatchList({
    required BuildContext context,
    required String id,
  }) async {
    await DeleteService()
        .deleteWithId(
      endpoint: ApiEndpoint.removeWatchlist,
      context: context,
      id: id,
    )
        .then(
      (value) {
        if (value != null) {
          getWatchList(context: context);
        }
      },
    );
    notifyListeners();
  }

  Future<void> fetchChartDataForItem(BuildContext context, WatchlistItem? item) async {
    if (item != null) {
      try {
        if (item.chartData.isNotEmpty) return;

        String region = item.filterdata.region;
        String wclass = item.filterdata.classs;
        String date = item.filterdata.date;

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

            final avgSales = monthEntries.isNotEmpty ? monthEntries.map((e) => e.cASHMT ?? 0).reduce((a, b) => a + b) / monthEntries.length : 0.0;

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
}

class QualityWatchListModel {
  final String? id;
  final FilterData? filterData;
  final YearAverage? current;
  final YearAverage? yearAverage;
  final YearAverage? fiveYearAverage;

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
  final List<GraphDataModal>? graphDataList;

  PriceWatchListModel({
    required this.id,
    required this.filterData,
    required this.graphDataList,
  });
}
