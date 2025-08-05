import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uswheat/modal/watchlist_modal.dart';
import 'package:uswheat/service/get_api_services.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_widgets.dart';
import '../modal/all_price_data_modal.dart';
import '../modal/graph_modal.dart';
import '../modal/sales_modal.dart';
import '../service/delete_service.dart';
import '../service/post_services.dart';

class WatchlistProvider extends ChangeNotifier {
  List<WatchlistItem> watchlist = [];
  FilterData? filterData;
  String? grphcode;

  String? prdate;
  String? graphDate;
  List<GraphDataModal> graphList = [];
  List<SalesData> chartData = [];
  final List<String> fixedMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  AllPriceDataModal? allPriceDataModal;
  bool isChartLoading = false;

  final Map<String, bool> _chartLoadingMap = {};

  final Map<String, List<SalesData>> _localChartCache = {};

  bool isChartLoadingForItem(String itemId) {
    return _chartLoadingMap[itemId] ?? false;
  }

  void setChartLoadingForItem(String itemId, bool isLoading) {
    _chartLoadingMap[itemId] = isLoading;
    notifyListeners();
  }

  Future<void> fetchData({required BuildContext context}) async {
    watchlist.clear();
    notifyListeners();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AppWidgets.loading(),
    );

    await getWatchList(context: context, loader: true);

    Navigator.pop(context);
    notifyListeners();
  }

  getWatchList({required BuildContext context, required bool loader}) {
    GetApiServices().get(endpoint: ApiEndpoint.getWatchlist, context: context, loader: loader).then(
      (value) {
        if (value != null) {
          final data = jsonDecode(value.body)['data'];
          watchlist = (data as List).map((e) => WatchlistItem.fromJson(e)).toList();
          notifyListeners();
        }
      },
    );
  }

  void deleteWatchList({required BuildContext context, required String id}) {
    DeleteService().delete(endpoint: ApiEndpoint.removeWatchlist, context: context, id: id).then((value) {
      getWatchList(context: context, loader: false);
    });
  }


  Future<void> fetchChartDataForItem(BuildContext context, WatchlistItem item) async {
    try {
      if (item.chartData.isNotEmpty) return;

      String region = item.filterdata.region;
      String wclass = item.filterdata.classs;
      String date = item.filterdata.date;

      if (date.length == 4) date = "$date-01-01";

      final String cacheKey = "$region|$wclass|$date";

      if (_localChartCache.containsKey(cacheKey)) {
        print("✅ Using cached chart data for $cacheKey");
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
          print("📌 Found grphcode: $grphcode for $region | $wclass");
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

        print('📊 Fetched ${tempChartData.length} points for $cacheKey');
      }
    } catch (e) {
      debugPrint('❌ Error fetching chart data for item: $e');
    }
  }
}
