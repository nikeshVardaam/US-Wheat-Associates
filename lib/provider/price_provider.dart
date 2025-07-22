import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  String? selectedYears;
  List<GraphDataModal> graphList = [];
  List<NearbyModal> nearbyList = [];
  List<SalesData> chartData = [];
  List<ForwardPricesModal> forwardPricesList = [];
  LatestPrdateModal? latestPrdate;
  WeekDataModal? weekData;
  RegionsAndClassesModal? regionsAndClasses;
  bool isFormTouched = false;

  final List<String> fixedMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  Future<void> fetchData({required BuildContext context}) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AppWidgets.loading(),
    );
    syncData(context: context).then(
      (value) {
        Navigator.pop(context);
        notifyListeners();
      },
    );
  }

  Future<void> syncData({required BuildContext context}) async {
    await getRegionsAndClasses(context: context, loader: false);
    await getYears(context: context, loader: false);
    await getNearBy(context: context, loader: false);
    await getForwardPrices(context: context, loader: false);
    await getLastPRDates(context: context, loader: false);
    await getWeekData(context: context, loader: false);

    if (selectedRegion != null && selectedClasses != null && selectedYears != null) {
      prdate = selectedYears;
      await getGraphCodesByClassAndRegion(context: context, loader: false);
      await graphData(context: context, loader: false);
    }

    notifyListeners();
  }

  Future<void> upDateGraphData({required BuildContext context}) async {
    isFormTouched = true;

    if (selectedRegion != null && selectedClasses != null && selectedYears != null) {
      prdate = selectedYears;
      await getGraphCodesByClassAndRegion(context: context, loader: true);
      await graphData(context: context, loader: true);
    } else {
      chartData = [];
      notifyListeners();
    }
  }


  getRegionsAndClasses({required BuildContext context, required bool loader}) {
    GetApiServices().get(endpoint: ApiEndpoint.getRegionsAndClasses, context: context, loader: loader).then(
      (response) {
        if (response != null) {
          regionsAndClasses = RegionsAndClassesModal.fromJson(json.decode(response.body));
          uniqueRegion = regionsAndClasses?.toJson().keys.toList() ?? [];
          uniqueClasses = [];
          notifyListeners();
        }
      },
    );
  }

  getLastPRDates({required BuildContext context, required bool loader}) {
    GetApiServices().get(endpoint: ApiEndpoint.getLatestPrdate, context: context, loader: loader).then(
      (response) {
        if (response != null) {
          latestPrdate = LatestPrdateModal.fromJson(json.decode(response.body));
          notifyListeners();
        }
      },
    );
  }

  getYears({required BuildContext context, required bool loader}) {
    GetApiServices().get(endpoint: ApiEndpoint.getYears, context: context, loader: loader).then(
      (response) {
        if (response != null) {
          final List<dynamic> data = json.decode(response.body);
          uniqueYears = List<num>.from(data);
          notifyListeners();
        }
      },
    );
  }

  getGraphCodesByClassAndRegion({required BuildContext context, required bool loader}) async {
    var data = {
      "class": selectedClasses,
      "region": selectedRegion,
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
        for (var i = 0; i < body.length; ++i) {
          grphcode = body[i].toString();
        }
      }

      notifyListeners();
    }
  }

  getForwardPrices({required BuildContext context, required bool loader}) {
    var data = {"grphcode": grphcode, "prdate": prdate};
    PostServices()
        .post(
      endpoint: ApiEndpoint.getForwardPrices,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: loader,
    )
        .then((value) {
      if (value != null) {
        final decoded = json.decode(value.body);
        forwardPricesList = List<ForwardPricesModal>.from(
          decoded.map((e) => ForwardPricesModal.fromJson(e)),
        );
        notifyListeners();
      }
    });
  }

  Future<void> graphData({required BuildContext context, required bool loader}) async {
    if (grphcode == null || grphcode!.isEmpty || prdate == null || prdate!.isEmpty) {
      chartData = [];
      notifyListeners();
      return;
    }

    graphList.clear();
    chartData.clear();
    notifyListeners();

    var data = {
      "grphcode": grphcode,
      "prdate": prdate,
    };

    PostServices()
        .post(
      endpoint: ApiEndpoint.getGraphData,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: loader,
    )
        .then((response) async {
      if (response != null) {

        List<dynamic> jsonList = json.decode(response.body);
        graphList = jsonList.map((e) => GraphDataModal.fromJson(e)).toList();

        final tempChartData = fixedMonths.map((month) {
          final match = graphList.firstWhere(
            (e) => DateFormat('MMM').format(DateTime.parse(e.pRDATE ?? '')).toLowerCase() == month.toLowerCase(),
            orElse: () => GraphDataModal(pRDATE: '', cASHMT: null),
          );
          return SalesData(month: month, sales: match.cASHMT ?? 0.0);
        }).toList();

        final hasValidData = tempChartData.any((e) => e.sales != 0.0);

        chartData = hasValidData ? tempChartData : [];
        await getNearBy(context: context, loader: false);
        await getWeekData(context: context, loader: false);
        await getForwardPrices(context: context, loader: false);
        await  getLastPRDates(context: context, loader: false);

        notifyListeners();
      }
    });
  }

  getNearBy({
    required BuildContext context,
    required bool loader,
  }) {
    var data = {"grphcode": grphcode, "nrbyoffset": 0, "prdate": prdate};
    PostServices().post(endpoint: ApiEndpoint.getNearby, requestData: data, context: context, isBottomSheet: false, loader: loader).then(
      (value) {
        if (value != null) {
          List<dynamic> jsonList = json.decode(value.body);
          nearbyList = jsonList.map((e) => NearbyModal.fromJson(e)).toList();
        }
      },
    );
    notifyListeners();
  }

  getWeekData({
    required BuildContext context,
    required bool loader,
  }) {
    var data = {"grphcode": grphcode, "nrbyoffset": 0, "prdate": prdate};

    PostServices().post(endpoint: ApiEndpoint.getWeeklyData, requestData: data, context: context, isBottomSheet: false, loader: loader).then((response) {
      if (response != null) {
        weekData = WeekDataModal.fromList(json.decode(response.body));
      }

      notifyListeners();
    });
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
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width / 4,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: uniqueRegion.length,
                itemBuilder: (context, index) {
                  final region = uniqueRegion[index];
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(region),
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
      notifyListeners();
      onSelect(selected);
      upDateGraphData(context: context);
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
      notifyListeners();
      onSelect(selected);
      upDateGraphData(context: context);
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
      notifyListeners();
      onSelect(selected);
      upDateGraphData(context: context);
    }
  }
}
