import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/dashboard_page/price/custome_date_picker.dart';
import 'package:uswheat/modal/all_price_data_modal.dart';
import 'package:uswheat/modal/model_region.dart';
import 'package:uswheat/service/get_api_services.dart';
import 'package:uswheat/service/post_services.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/common_date_picker.dart';
import '../modal/graph_modal.dart';
import '../modal/regions_and_classes_modal.dart';
import '../modal/sales_modal.dart';
import '../modal/watch_list_state.dart';
import '../utils/app_buttons.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';

class PricesProvider extends ChangeNotifier {
  List<RegionAndClasses> regionsList = [];
  RegionAndClasses? region;
  List<String> classes = [];
  List<int> uniqueYears = [];
  bool _isGraphUpdating = false;

  String? selectedRegion;
  String? classs;
  String? selectedYears;

  String? grphcode;
  String? prdate;
  String? graphDate;

  AllPriceDataModal? allPriceDataModal;
  List<GraphDataModal> graphList = [];
  List<SalesData> chartData = [];

  RegionsAndClassesModal? regionsAndClasses;

  bool loader = false;
  bool _isPickerOpen = false;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  final List<String> fixedMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  String get graphCacheKey =>
      'graph_${selectedRegion ?? ""}_${classs ?? ""}_${selectedYears ?? ""}';

  String get allPriceDataCacheKey =>
      'allPriceData_${selectedRegion ?? ""}_${classs ?? ""}_${selectedYears ?? ""}';

  String get selectedFullDate {
    final int year = int.tryParse(selectedYears ?? '') ?? DateTime.now().year;
    final date = DateTime(year, selectedMonth, selectedDay);
    return DateFormat('dd-MMM-yyyy').format(date).toUpperCase();
  }

  String get selectedPrevYearDate {
    final int year = int.tryParse(selectedYears ?? '') ?? DateTime.now().year;
    final nextYear = year - 1;
    final date = DateTime(nextYear, selectedMonth, selectedDay);
    return DateFormat('dd-MMM-yyyy').format(date).toUpperCase();
  }

  void setRegion(BuildContext context, String? region) {
    if (region == null || region.isEmpty) return;
    selectedRegion = region;
    upDateGraphData(context);
    // saveFiltersLocally();
  }

  void setClass(BuildContext context, String? classs) {
    if (classs == null || classs.isEmpty) return;
    this.classs = classs;
    upDateGraphData(context);
    // saveFiltersLocally();
  }

  setSelectedRegion(RegionAndClasses region) {
    this.region = region;
    notifyListeners();
  }

  setSelectedClass(String classs) {
    this.classs = classs;
    notifyListeners();
  }

  void setYear(BuildContext context, String? yearOrDate) {
    if (yearOrDate == null || yearOrDate.isEmpty) return;

    try {
      if (yearOrDate.contains('-')) {
        final dt = DateTime.parse(yearOrDate);
        selectedYears = dt.year.toString();
        selectedMonth = dt.month;
        selectedDay = dt.day;
      } else {
        selectedYears = yearOrDate;
        selectedMonth = DateTime.now().month;
        selectedDay = DateTime.now().day;
      }
    } catch (e) {
      selectedYears = yearOrDate;
    }

    prdate = DateFormat('yyyy-MM-dd').format(DateTime(
      int.tryParse(selectedYears ?? '') ?? DateTime.now().year,
      selectedMonth,
      selectedDay,
    ));

    upDateGraphData(context);
    // saveFiltersLocally();
  }

  void updateSelectedDate({int? year, int? month, int? day}) {
    final int y =
        year ?? int.tryParse(selectedYears ?? '') ?? DateTime.now().year;
    final int m = month ?? selectedMonth;
    final int d = day ?? selectedDay;

    selectedYears = y.toString();
    selectedMonth = m;
    selectedDay = d;

    prdate = DateFormat('yyyy-MM-dd').format(DateTime(y, m, d));

    final endDate = DateTime(y, m, d);
    final startDate = DateTime(y - 1, m, d);

    graphList = graphList.where((e) {
      final dt = DateTime.tryParse(e.pRDATE ?? '');
      if (dt == null) return false;
      return !dt.isBefore(startDate) && !dt.isAfter(endDate);
    }).toList();

    _generateChartDataFromGraphList();
    notifyListeners();
  }

  Future<void> fetchData({
    required BuildContext context,
    required String classs,
    required String region,
    required String year,
  }) async {
    await loadFiltersLocally();

    final prefs = await SharedPreferences.getInstance();
    final hasCachedGraph = prefs.getString(graphCacheKey)?.isNotEmpty ?? false;

    if (hasCachedGraph && graphList.isNotEmpty && allPriceDataModal != null) {
      notifyListeners();

      return;
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AppWidgets.loading(),
    );

    try {
      await Future.wait([
        getRegionsAndClasses(context: context, loader: false),
        getYears(context: context, loader: false),
      ]);

      //selectedRegion ??= (region.isNotEmpty ? region.first : null);
      // if (selectedRegion != null) {
      //   uniqueClasses =
      //       regionsAndClasses?.toJson()[selected
      //
      //
      //       ]?.cast<String>() ?? [];
      //   selectedClasses ??=
      //       (uniqueClasses.isNotEmpty ? uniqueClasses.first : null);
      // }
      //
      // prdate ??= DateFormat('yyyy-MM-dd').format(DateTime(
      //   int.tryParse(selectedYears ?? '') ?? DateTime.now().year,
      //   selectedMonth,
      //   selectedDay,
      // ));

      await getGraphCodesByClassAndRegion(context: context, loader: true);

      await Future.wait([
        graphData(context: context, loader: false),
        getAllPriceData(context: context, loader: false),
      ]);

      // await saveFiltersLocally();
    } finally {
      Navigator.pop(context);
      notifyListeners();
    }
  }

  Future<void> saveFiltersLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selectedRegion", selectedRegion ?? "");
    await prefs.setString("selectedClass", classs ?? "");
    await prefs.setString("selectedYear", selectedYears ?? "");

    final graphJson = jsonEncode(graphList.map((e) => e.toJson()).toList());
    await prefs.setString(graphCacheKey, graphJson);

    if (allPriceDataModal != null) {
      await prefs.setString(
          allPriceDataCacheKey, jsonEncode(allPriceDataModal!.toJson()));
    }
  }

  Future<void> loadFiltersLocally() async {
    final sp = await SharedPreferences.getInstance();
    selectedRegion = sp.getString("selectedRegion") ?? "";
    classs = sp.getString("selectedClass") ?? "";
    selectedYears = sp.getString("selectedYear") ?? "";
    loader = sp.getBool("isDataFetched") ?? false;

    final graphString = sp.getString(graphCacheKey);
    if (graphString != null && graphString.isNotEmpty) {
      try {
        List<dynamic> jsonList = json.decode(graphString);
        graphList = jsonList.map((e) => GraphDataModal.fromJson(e)).toList();
        _generateChartDataFromGraphList();
      } catch (e) {
        debugPrint("❌ Error decoding cached graphList: $e");
      }
    }
  }

  void _generateChartDataFromGraphList() {
    final tempChartData = fixedMonths.map((month) {
      final entries = graphList.where((e) {
        try {
          final date = DateTime.parse(e.pRDATE ?? '');
          return DateFormat('MMM').format(date) == month;
        } catch (_) {
          return false;
        }
      }).toList();

      final avg = entries.isNotEmpty
          ? entries.map((e) => e.cASHMT ?? 0).reduce((a, b) => a + b) /
              entries.length
          : 0.0;

      return SalesData(month: month, sales: avg);
    }).toList();

    chartData = tempChartData.any((e) => e.sales != 0.0) ? tempChartData : [];
  }

  Future<void> upDateGraphData(BuildContext context) async {
    if (_isGraphUpdating) return;

    _isGraphUpdating = true;
    notifyListeners();

    try {
      await getGraphCodesByClassAndRegion(context: context, loader: true);

      await Future.wait([
        graphData(context: context, loader: true),
        getAllPriceData(context: context, loader: true),
      ]);

      await saveFiltersLocally();
    } catch (e) {
      rethrow;
    } finally {
      _isGraphUpdating = false;
      notifyListeners();
    }
  }

  void updateFilter({String? region, String? className, String? year}) {
    selectedRegion = region;
    classs = className;
    selectedYears = year;
    loader = false;
    notifyListeners();
  }

  bool isInWatchlist(String region, String wheatClass, String? date) {
    if (date == null) return false;
    String key = "$region|$wheatClass|$date";
    return WatchlistState.watchlistKeys.contains(key);
  }

  Future<bool> storeWatchList({
    required BuildContext context,
    required bool loader,
  }) async {
    if (selectedRegion == null || classs == null || graphList.isEmpty) {
      AppWidgets.appSnackBar(
        context: context,
        text: "Please select all fields",
        color: AppColors.c2a8741,
      );
      return false;
    }

    final fullDate = DateFormat('yyyy-MM-dd').format(
        DateTime(int.parse(selectedYears!), selectedMonth, selectedDay));

    final data = {
      "type": "price",
      "filterdata": {
        "region": selectedRegion ?? "",
        "class": classs ?? "",
        "date": fullDate,
        "color": "ffab865a",
      }
    };

    final response = await PostServices().post(
      endpoint: ApiEndpoint.storeWatchlist,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: loader,
    );

    if (response != null) {
      final body = json.decode(response.body);
      final added = body['isInWatchlist'] ?? true;

      if (added) {
        WatchlistState.watchlistKeys
            .add("$selectedRegion|$classs|$selectedYears");
        notifyListeners();

        AppWidgets.appSnackBar(
          context: context,
          text: "Watchlist Added Successfully",
          color: AppColors.c2a8741,
        );
        return true;
      }
    }

    return false;
  }

  Future<void> getRegionsAndClasses(
      {required BuildContext context, required bool loader}) async {
    regionsList.clear();
    await GetApiServices()
        .get(
      endpoint: ApiEndpoint.getRegionsAndClasses,
      context: context,
      loader: loader,
    )
        .then(
      (value) {
        if (value != null) {
          final modelRegion = ModelRegion.fromJson(jsonDecode(value.body));
          modelRegion.regions.forEach((key, list) {
            final RegionAndClasses regionAndClasses =
                RegionAndClasses(region: key, classes: list);
            regionsList.add(regionAndClasses);
          });
        }
      },
    );
  }

  Future<void> getYears(
      {required BuildContext context, required bool loader}) async {
    final response = await GetApiServices().get(
      endpoint: ApiEndpoint.getYears,
      context: context,
      loader: loader,
    );

    if (response != null) {
      uniqueYears = List<int>.from(json.decode(response.body));
      uniqueYears.sort((a, b) => b.compareTo(a));
      final currentYear = DateTime.now().year;
      selectedYears = uniqueYears
          .firstWhere(
            (year) => year == currentYear,
            orElse: () => uniqueYears.first,
          )
          .toString();
      prdate = DateFormat('yyyy-MM-dd').format(
        DateTime(
          int.parse(selectedYears ?? ""),
          DateTime.now().month,
          DateTime.now().day,
        ),
      );
    }
  }

  Future<void> showYearPicker(BuildContext context,
      {required String wheatClass}) async {
    if (_isPickerOpen) return;
    _isPickerOpen = true;

    if (uniqueYears.isEmpty) {
      // getYears(context: context, loader: false).then((_) async {
      //   await CommonDatePicker.open(
      //     context: context,
      //     uniqueYears: uniqueYears,
      //     fixedMonths: fixedMonths,
      //     initialYear: int.tryParse(selectedYears ?? ''),
      //     initialMonth: selectedMonth,
      //     initialDay: selectedDay,
      //   ).then(
      //     (value) {
      //       (value) async {
      //         if (value != null) {
      //           DateTime d = DateTime.parse(value as String);
      //
      //           prdate = DateFormat('yyyy-MM-dd').format(d);
      //           await getGraphCodesByClassAndRegion(context: context, loader: true);
      //           graphData(context: context, loader: false);
      //           getAllPriceData(context: context, loader: false);
      //
      //           final DateTime startDate = DateTime(d.year - 1, d.month, d.day);
      //           final DateTime endDate = d;
      //
      //           graphList = graphList.where((e) {
      //             final DateTime? dt = DateTime.tryParse(e.pRDATE ?? '');
      //             return dt != null && !dt.isBefore(startDate) && !dt.isAfter(endDate);
      //           }).toList();
      //
      //           _generateChartDataFromGraphList();
      //           notifyListeners();
      //         }
      //       };
      //     },
      //   );
      // });
    } else {
      // await CommonDatePicker.open(
      //   context: context,
      //   uniqueYears: uniqueYears,
      //   fixedMonths: fixedMonths,
      //   initialYear: int.tryParse(selectedYears ?? ''),
      //   initialMonth: selectedMonth,
      //   initialDay: selectedDay,
      // ).then(
      //   (value) {
      //     (value) async {
      //       if (value != null) {
      //         DateTime d = DateTime.parse(value as String);
      //
      //         prdate = DateFormat('yyyy-MM-dd').format(d);
      //         await getGraphCodesByClassAndRegion(context: context, loader: true);
      //         graphData(context: context, loader: false);
      //         getAllPriceData(context: context, loader: false);
      //
      //         final DateTime startDate = DateTime(d.year - 1, d.month, d.day);
      //         final DateTime endDate = d;
      //
      //         graphList = graphList.where((e) {
      //           final DateTime? dt = DateTime.tryParse(e.pRDATE ?? '');
      //           return dt != null && !dt.isBefore(startDate) && !dt.isAfter(endDate);
      //         }).toList();
      //
      //         _generateChartDataFromGraphList();
      //         notifyListeners();
      //       }
      //     };
      //   },
      // );
    }
  }

  Future<void> getGraphCodesByClassAndRegion({
    required BuildContext context,
    required bool loader,
  }) async {
    final data = {
      "class": classs ?? "",
      "region": selectedRegion ?? "",
    };

    final value = await PostServices().post(
      endpoint: ApiEndpoint.getGraphCodesByClassAndRegion,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: loader,
    );

    print("getGraphCodesByClassAndRegion called");
    if (value != null) {
      final body = json.decode(value.body);
      if (body is List && body.isNotEmpty) {
        grphcode = body.last.toString();
      }
    }
  }

  Future<void> graphData({
    required BuildContext context,
    required bool loader,
  }) async {
    if ((grphcode ?? "").isEmpty || (prdate ?? "").isEmpty) return;

    final data = {"grphcode": grphcode!, "prdate": prdate!};

    final response = await PostServices().post(
      endpoint: ApiEndpoint.getGraphData,
      requestData: data,
      context: context,
      isBottomSheet: false,
      loader: loader,
    );

    print(" graphData called");
    if (response != null) {
      final list = json.decode(response.body) as List;

      graphList = list.map((e) => GraphDataModal.fromJson(e)).toList();
      _generateChartDataFromGraphList();

      if (graphList.isNotEmpty) {
        graphDate = graphList.last.pRDATE;
      }
    }
  }

  Future<void> getAllPriceData({
    required BuildContext context,
    required bool loader,
  }) async {
    final response = await PostServices().post(
      endpoint: ApiEndpoint.getAllPriceData,
      requestData: {
        "grphcode": grphcode,
        "date": prdate,
      },
      context: context,
      isBottomSheet: false,
      loader: loader,
    );

    print("getAllPriceData called");

    if (response != null) {
      final body = json.decode(response.body);
      allPriceDataModal = AllPriceDataModal.fromJson(
        body is Map
            ? body
            : (body is List && body.isNotEmpty ? body.first : {}),
      );
      notifyListeners();
    }
  }

  Future<void> showClassesDropdown({
    required BuildContext context,
    required TapDownDetails details,
    required Function(String region) onSelect,
  }) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    if (selectedRegion == null) return;

    this.classes =
        regionsAndClasses?.toJson()[selectedRegion]?.cast<String>() ?? [];

    if (this.classes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("No classes available for selected region")),
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
                itemCount: this.classes.length,
                itemBuilder: (context, index) {
                  final classes = this.classes[index];
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
      classs = selected;
      await upDateGraphData(context);
      notifyListeners();
      onSelect(selected);
    }
  }

  Future<void> showYearsDropdown({
    required BuildContext context,
    required TapDownDetails details,
    required Function(num region) onSelect,
  }) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

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
      await upDateGraphData(context);
      notifyListeners();
      onSelect(selected);
    }
  }
}
