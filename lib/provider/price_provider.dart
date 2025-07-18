import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uswheat/modal/prices_modal.dart';
import 'package:uswheat/service/get_api_services.dart';
import 'package:uswheat/service/post_services.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_colors.dart';
import '../modal/graph_modal.dart';
import '../modal/regions_and_classes_modal.dart';
import '../modal/sales_modal.dart';
import '../utils/app_widgets.dart';

class PricesProvider extends ChangeNotifier {
  Map<String, List<String>> regionsAndClassesMap = {};
  List<PricesModal> pricesList = [];
  List<String> uniqueRegion = [];
  List<String> uniqueClasses = [];
  List<num> uniqueYears = [];
  String? selectedRegion;
  String? selectedClasses;
  String? grphcode;
  String? prdate;
  String? selectedYears;
  List<GraphDataModal> graphList = [];
  List<SalesData> chartData = [];
  RegionsAndClassesModal? regionsAndClasses;

  Future<void> fetchData({required BuildContext context}) async {
    syncData(context: context).then(
      (value) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AppWidgets.loading(),
        );
        syncData(context: context);
        Navigator.pop(context);
      },
    );
  }

  Future<void> syncData({required BuildContext context}) async {
    await getRegionsAndClasses(context: context);
    await graphData(context: context);
    await getYears(context: context);
    await getNearBy(context: context);
    await getGraphCodesByClassAndRegion(context: context);
    notifyListeners();
  }

  upDateGraphData({required BuildContext context}) {
    if (selectedRegion != null && selectedClasses != null && selectedYears != null) {
      prdate = selectedYears;
      getGraphCodesByClassAndRegion(context: context);
      graphData(context: context);
    }
  }

  void setSelectedRegion(String region) {
    selectedRegion = region;
    selectedClasses = null;
    notifyListeners();
  }

  getRegionsAndClasses({required BuildContext context}) {
    GetApiServices().get(endpoint: ApiEndpoint.getRegionsAndClasses, context: context, loader: true).then((response) {
      if (response != null) {
        regionsAndClasses = RegionsAndClassesModal.fromJson(json.decode(response.body));
        uniqueRegion = regionsAndClasses?.toJson().keys.toList() ?? [];
        uniqueClasses = [];
        print(response.body);
        notifyListeners();
      }
    });
  }

  getYears({required BuildContext context}) {
    GetApiServices().get(endpoint: ApiEndpoint.getYears, context: context, loader: true).then(
      (response) {
        if (response != null) {
          final List<dynamic> data = json.decode(response.body);
          uniqueYears = List<num>.from(data);
          notifyListeners();
        }
      },
    );
  }

  getGraphCodesByClassAndRegion({required BuildContext context}) {
    var data = {
      "class": selectedClasses?.trim(),
      "region": selectedRegion?.trim(),
    };
    PostServices().post(endpoint: ApiEndpoint.getGraphCodesByClassAndRegion, requestData: data, context: context, isBottomSheet: false, loader: false).then(
      (value) {

        if (value != null) {
          print("graphDAta");
          print(value.body);
        }
      },
    );
  }

  graphData({required BuildContext context}) {
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
      loader: false,
    )
        .then((response) {
      if (response != null) {
        print("graphDAta");
        print(response.body); // 👈 Shows actual response data
        List<dynamic> jsonList = json.decode(response.body);
        graphList = jsonList.map((e) => GraphDataModal.fromJson(e)).toList();

        chartData = graphList.map((e) => SalesData(month: e.pRDATE ?? "", sales: e.cASHMT ?? 0.0)).toList();

        notifyListeners();
      }
    });
  }

  getNearBy({
    required BuildContext context,
  }) {
    var data = {
      "grphcode": "HRW",
      "nrbyoffset": 0,
      "prdate": "2024-07-17",
    };
    PostServices().post(endpoint: ApiEndpoint.getNearby, requestData: data, context: context, isBottomSheet: false, loader: false).then(
      (value) {
        if (value != null) {
          print(value);
        }
      },
    );
  }

  List<PricesModal> get filteredPrices {
    if (selectedRegion == null) return pricesList;
    return pricesList.where((e) => e.portregn == selectedRegion).toList();
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
