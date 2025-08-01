import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uswheat/modal/all_price_data_modal.dart';
import 'package:uswheat/modal/latest_prdate_modal.dart';
import 'package:uswheat/modal/nearby_modal.dart';
import 'package:uswheat/modal/week_data_modal.dart';
import 'package:uswheat/service/get_api_services.dart';
import 'package:uswheat/service/post_services.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_colors.dart';
import '../modal/forward_price_modal.dart';
import '../modal/graph_modal.dart';
import '../modal/regions_and_classes_modal.dart';
import '../modal/sales_modal.dart';
import '../utils/app_widgets.dart';

class PricesProvider extends ChangeNotifier {
  List<String> uniqueRegion = [];
  List<String> uniqueClasses = [];
  List<num> uniqueYears = [];
  String? selectedRegion;
  String? selectedClasses;
  String? grphcode;
  String? prdate;
  String? graphDate;
  String? selectedYears;
  AllPriceDataModal? allPriceDataModal;
  List<AllPriceDataModal> allPriceDataList = [];
  List<GraphDataModal> graphList = [];
  List<NearbyModal> nearbyList = [];
  List<SalesData> chartData = [];
  List<ForwardPricesModal> forwardPricesList = [];
  LatestPrdateModal? latestPrdate;
  WeekDataModal? weekData;
  RegionsAndClassesModal? regionsAndClasses;
  bool isFormTouched = false;
  bool _isInWatchlist = false;

  bool get isInWatchlist => _isInWatchlist;

  final List<String> fixedMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  Future<void> fetchData({required BuildContext context}) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AppWidgets.loading(),
    );

    await getRegionsAndClasses(context: context, loader: false);
    await getYears(context: context, loader: false);

    prdate = selectedYears;

    await getGraphCodesByClassAndRegion(context: context, loader: false);
    await graphData(context: context, loader: false);
    await getAllPriceData(context: context, loader: false);

    Navigator.pop(context);
    notifyListeners();
  }

  Future<void> upDateGraphData({required BuildContext context}) async {
    prdate = selectedYears;
    await getGraphCodesByClassAndRegion(context: context, loader: true);
    await graphData(context: context, loader: true);
    await getAllPriceData(context: context, loader: false);
  }

  void toggleWatchlistStatus() {
    _isInWatchlist = !_isInWatchlist;
    notifyListeners();
  }

  storeWatchList({required BuildContext context, required bool loader}) async {
    if (selectedRegion == null || selectedClasses == null || graphList.isEmpty) {
      AppWidgets.appSnackBar(
        context: context,
        text: "Please select all fields",
        color: AppColors.c2a8741,
      );
    }
    var fullDate = selectedYears != null && selectedYears!.length == 4 ? "${selectedYears!}-01-01" : selectedYears ?? "";
    var data = {
      "filterdata": {
        "region": selectedRegion ?? "",
        "class": selectedClasses ?? "",
        "date": fullDate ?? "",
      }
    };
    PostServices()
        .post(
      endpoint: ApiEndpoint.storeWatchlist,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: loader,
    )
        .then((value) {
      if (value != null) {
        _isInWatchlist = false;
        AppWidgets.appSnackBar(
          context: context,
          text: "Watchlist Added Successfully",
          color: AppColors.c2a8741,
        );
      }
    });
  }

  getRegionsAndClasses({required BuildContext context, required bool loader}) async {
    print("getRegionsAndClasses");

    final response = await GetApiServices().get(
      endpoint: ApiEndpoint.getRegionsAndClasses,
      context: context,
      loader: loader,
    );

    if (response != null) {
      regionsAndClasses = RegionsAndClassesModal.fromJson(json.decode(response.body));

      uniqueRegion = regionsAndClasses?.toJson().keys.toList() ?? [];
      uniqueClasses = [];

      if (uniqueRegion.isNotEmpty) {
        selectedRegion = uniqueRegion.first;

        uniqueClasses = regionsAndClasses?.toJson()[selectedRegion]?.cast<String>() ?? [];

        if (uniqueClasses.isNotEmpty) {
          selectedClasses = uniqueClasses.first;

          if (grphcode != null && grphcode!.isNotEmpty) {
            await getAllPriceData(context: context, loader: false);
          }
        }
      }
    }
  }

  Future<void> getYears({required BuildContext context, required bool loader}) async {
    print("getYeears");

    final response = await GetApiServices().get(
      endpoint: ApiEndpoint.getYears,
      context: context,
      loader: loader,
    );

    if (response != null) {
      uniqueYears = List<num>.from(json.decode(response.body));
      uniqueYears.sort((a, b) => b.compareTo(a));

      final currentYear = DateTime.now().year;

      selectedYears = uniqueYears.firstWhere((year) => year == currentYear, orElse: () => uniqueYears.first).toString();

      prdate = selectedYears;
    }
  }

  getAllPriceData({required BuildContext context, required bool loader}) {
    print("getALlPrice");

    var data = {
      "grphcode": grphcode ?? "",
    };
    PostServices()
        .post(
      endpoint: ApiEndpoint.getAllPriceData,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: loader,
    )
        .then((value) {
      if (value != null) {
        allPriceDataModal = AllPriceDataModal.fromJson(json.decode(value.body));
        notifyListeners();
      }
    });
  }

  getGraphCodesByClassAndRegion({required BuildContext context, required bool loader}) async {
    print("getGraphCodesByClassAndRegion");

    var data = {
      "class": selectedClasses ?? "",
      "region": selectedRegion ?? "",
    };

    final value = await PostServices().post(
      endpoint: ApiEndpoint.getGraphCodesByClassAndRegion,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: loader,
    );

    if (value != null) {
      final body = json.decode(value.body);

      if (body is List && body.isNotEmpty) {
        grphcode = body.last.toString();
      }
    }
  }

  Future<void> graphData({required BuildContext context, required bool loader}) async {
    if (grphcode == null || grphcode!.isEmpty || prdate == null || prdate!.isEmpty) {
      chartData = [];
      return;
    }

    if (prdate!.length == 4) {
      prdate = "$prdate-01-01";
    }

    graphList.clear();
    chartData.clear();

    var data = {
      "grphcode": grphcode ?? "",
      "prdate": prdate ?? "",
    };

    final response = await PostServices().post(
      endpoint: ApiEndpoint.getGraphData,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: loader,
    );

    if (response != null) {
      List<dynamic> jsonList = json.decode(response.body);
      graphList = jsonList.map((e) => GraphDataModal.fromJson(e)).toList();
      final tempChartData = fixedMonths.map((month) {
        final monthEntries = graphList.where((e) {
          try {
            final dateString = e.pRDATE;
            if (dateString == null || dateString.isEmpty) return false;
            final date = DateTime.parse(dateString);
            return DateFormat('MMM').format(date) == month;
          } catch (_) {
            return false;
          }
        }).toList();

        final avgSales = monthEntries.isNotEmpty
            ? monthEntries.map((e) => e.cASHMT ?? 0).reduce((a, b) => a + b) / monthEntries.length
            : 0.0;

        return SalesData(month: month, sales: avgSales);
      }).toList();


      final hasValidData = tempChartData.any((e) => e.sales != 0.0);
      chartData = hasValidData ? tempChartData : [];

      if (graphList.isNotEmpty) {
        prdate = graphList.last.pRDATE;
        graphDate = graphList.last.pRDATE;
      }
    }
  }

  Future<void> showFilterDropdown({
    required BuildContext context,
    required TapDownDetails details,
    required Function(String region) onSelect,
  }) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    if (uniqueRegion.isEmpty) return;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(0, 0),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width / 2,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: uniqueRegion.length,
                itemBuilder: (context, index) {
                  final region = uniqueRegion[index];
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        region,
                        maxLines: 4,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context, region);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );

    if (selected != null) {
      selectedRegion = selected;
      uniqueClasses = regionsAndClasses?.toJson()[selectedRegion]?.cast<String>() ?? [];
      if (uniqueClasses.isNotEmpty) {
        selectedClasses = uniqueClasses.first;
      }

      await upDateGraphData(context: context);

      notifyListeners();
      onSelect(selected);
    }
  }

  Future<void> showClassesDropdown({
    required BuildContext context,
    required TapDownDetails details,
    required Function(String region) onSelect,
  }) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    if (selectedRegion == null) return;

    uniqueClasses = regionsAndClasses?.toJson()[selectedRegion]?.cast<String>() ?? [];

    if (uniqueClasses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No classes available for selected region")),
      );
      return;
    }

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(0, 0),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width / 2,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: uniqueClasses.length,
                itemBuilder: (context, index) {
                  final classes = uniqueClasses[index];
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(classes),
                    ),
                    onTap: () {
                      Navigator.pop(context, classes);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );

    if (selected != null) {
      selectedClasses = selected;
      await upDateGraphData(context: context);
      notifyListeners();
      onSelect(selected);
    }
  }

  Future<void> showYearsDropdown({
    required BuildContext context,
    required TapDownDetails details,
    required Function(num region) onSelect,
  }) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    if (uniqueYears.isEmpty) return;

    final selected = await showMenu<num>(
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(0, 0),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem<num>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width / 4,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: uniqueYears.length,
                itemBuilder: (context, index) {
                  final year = uniqueYears[index];
                  return ListTile(
                    dense: true,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        year.toString(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context, year);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );

    if (selected != null) {
      selectedYears = selected.toString();
      await upDateGraphData(context: context);
      notifyListeners();
      onSelect(selected);
    }
  }
}
