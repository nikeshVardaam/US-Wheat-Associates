import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/modal/all_price_data_modal.dart';
import 'package:uswheat/service/get_api_services.dart';
import 'package:uswheat/service/post_services.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_colors.dart';
import '../modal/graph_modal.dart';
import '../modal/regions_and_classes_modal.dart';
import '../modal/sales_modal.dart';
import '../modal/watch_list_state.dart';
import '../utils/app_buttons.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';

class PricesProvider extends ChangeNotifier {
  List<String> uniqueRegion = [];
  List<String> uniqueClasses = [];
  List<num> uniqueYears = [];
  bool _isGraphUpdating = false;

  String? selectedRegion;
  String? selectedClasses;
  String? grphcode;
  String? prdate;
  String? graphDate;
  String? selectedYears;

  AllPriceDataModal? allPriceDataModal;
  List<GraphDataModal> graphList = [];
  List<SalesData> chartData = [];

  RegionsAndClassesModal? regionsAndClasses;

  bool loader = false;
  bool _isPickerOpen = false;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  final List<String> fixedMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  String get graphCacheKey => 'graph_${selectedRegion ?? ""}_${selectedClasses ?? ""}_${selectedYears ?? ""}';

  String get allPriceDataCacheKey => 'allPriceData_${selectedRegion ?? ""}_${selectedClasses ?? ""}_${selectedYears ?? ""}';

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
    saveFiltersLocally();
  }

  void setClass(BuildContext context, String? classs) {
    if (classs == null || classs.isEmpty) return;
    selectedClasses = classs;
    upDateGraphData(context);
    saveFiltersLocally();
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
    saveFiltersLocally();
  }

  void updateSelectedDate({int? year, int? month, int? day}) {
    final int y = year ?? int.tryParse(selectedYears ?? '') ?? DateTime.now().year;
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
      return;
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AppWidgets.loading(),
    );

    await getRegionsAndClasses(context: context, loader: false);
    await getYears(context: context, loader: false);
    await getGraphCodesByClassAndRegion(context: context, loader: false);
    await graphData(context: context, loader: false);
    await getAllPriceData(context: context, loader: false);

    await saveFiltersLocally();

    Navigator.pop(context);
    notifyListeners();
  }

  Future<void> saveFiltersLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selectedRegion", selectedRegion ?? "");
    await prefs.setString("selectedClass", selectedClasses ?? "");
    await prefs.setString("selectedYear", selectedYears ?? "");

    final graphJson = jsonEncode(graphList.map((e) => e.toJson()).toList());
    await prefs.setString(graphCacheKey, graphJson);

    if (allPriceDataModal != null) {
      await prefs.setString(allPriceDataCacheKey, jsonEncode(allPriceDataModal!.toJson()));
    }
  }

  Future<void> loadFiltersLocally() async {
    final sp = await SharedPreferences.getInstance();
    selectedRegion = sp.getString("selectedRegion") ?? "";
    selectedClasses = sp.getString("selectedClass") ?? "";
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

      final avg = entries.isNotEmpty ? entries.map((e) => e.cASHMT ?? 0).reduce((a, b) => a + b) / entries.length : 0.0;

      return SalesData(month: month, sales: avg);
    }).toList();

    chartData = tempChartData.any((e) => e.sales != 0.0) ? tempChartData : [];
  }

  Future<void> upDateGraphData(BuildContext context) async {
    if (_isGraphUpdating) return;
    _isGraphUpdating = true;

    final sp = await SharedPreferences.getInstance();
    int apiCount = 0;

    await getGraphCodesByClassAndRegion(context: context, loader: true);

    apiCount++;
    await graphData(context: context, loader: true);
    await getAllPriceData(context: context, loader: false);

    await saveFiltersLocally();
    _isGraphUpdating = false;
    notifyListeners();
  }

  void updateFilter({String? region, String? className, String? year}) {
    selectedRegion = region;
    selectedClasses = className;
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
    if (selectedRegion == null || selectedClasses == null || graphList.isEmpty) {
      AppWidgets.appSnackBar(
        context: context,
        text: "Please select all fields",
        color: AppColors.c2a8741,
      );
      return false;
    }

    final fullDate = DateFormat('yyyy-MM-dd').format(DateTime(int.parse(selectedYears!), selectedMonth, selectedDay));

    final data = {
      "type": "price",
      "filterdata": {
        "region": selectedRegion ?? "",
        "class": selectedClasses ?? "",
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
        WatchlistState.watchlistKeys.add("$selectedRegion|$selectedClasses|$selectedYears");
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

  Future<void> getRegionsAndClasses({required BuildContext context, required bool loader}) async {
    final response = await GetApiServices().get(
      endpoint: ApiEndpoint.getRegionsAndClasses,
      context: context,
      loader: loader,
    );

    if (response != null) {
      regionsAndClasses = RegionsAndClassesModal.fromJson(json.decode(response.body));
      uniqueRegion = regionsAndClasses?.toJson().keys.toList() ?? [];
      if (uniqueRegion.isNotEmpty) {
        selectedRegion = uniqueRegion.first;
        uniqueClasses = regionsAndClasses?.toJson()[selectedRegion]?.cast<String>() ?? [];
        if (uniqueClasses.isNotEmpty) {
          selectedClasses = uniqueClasses.first;
        }
      }
    }
  }

  Future<void> getYears({required BuildContext context, required bool loader}) async {
    final response = await GetApiServices().get(
      endpoint: ApiEndpoint.getYears,
      context: context,
      loader: loader,
    );

    if (response != null) {
      uniqueYears = List<num>.from(json.decode(response.body));
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
          int.parse(selectedYears ?? "") ?? currentYear,
          DateTime.now().month,
          DateTime.now().day,
        ),
      );
    }
  }

  void showYearPicker(BuildContext context, {required String wheatClass}) {
    if (_isPickerOpen) return;
    _isPickerOpen = true;

    if (uniqueYears.isEmpty) {
      getYears(context: context, loader: false).then((_) {
        Future.delayed(Duration(milliseconds: 100), () {
          _openPicker(context, wheatClass);
        });
      });
    } else {
      Future.delayed(Duration(milliseconds: 100), () {
        _openPicker(context, wheatClass);
      });
    }
  }

  void _openPicker(BuildContext context, String wheatClass) {
    _isPickerOpen = true;
    int initialYearIndex = uniqueYears.indexOf(int.tryParse(selectedYears ?? '') ?? uniqueYears.first);

    int year = int.tryParse(selectedYears ?? '') ?? DateTime.now().year;
    int daysInMonth = DateTime(year, selectedMonth + 1, 0).day;

    showCupertinoModalPopup(
      context: context,
      builder: (_) => SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height / 2.5,
          color: AppColors.cFFFFFF,
          child: Column(
            children: [
              // Pickers
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: initialYearIndex),
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          selectedYears = uniqueYears[index].toString();
                        },
                        children: uniqueYears.map((y) => Center(child: Text(y.toString()))).toList(),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: selectedMonth - 1),
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          selectedMonth = index + 1;
                        },
                        children: fixedMonths.map((m) => Center(child: Text(m))).toList(),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: selectedDay - 1),
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          selectedDay = index + 1;
                        },
                        children: List.generate(daysInMonth, (i) => Center(child: Text((i + 1).toString()))),
                      ),
                    ),
                  ],
                ),
              ),
              // Buttons
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: AppButtons().filledButton(true, AppStrings.cancel, context),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final int year = int.tryParse(selectedYears ?? '') ?? DateTime.now().year;
                        final DateTime selectedDate = DateTime(year, selectedMonth, selectedDay);
                        final DateTime endDate = selectedDate;
                        final DateTime startDate = DateTime(selectedDate.year - 1, selectedDate.month, selectedDate.day);

                        prdate = DateFormat('yyyy-MM-dd').format(selectedDate);

                        await upDateGraphData(context);

                        final filteredList = graphList.where((e) {
                          final DateTime? dt = DateTime.tryParse(e.pRDATE ?? '');
                          if (dt == null) return false;
                          return !dt.isBefore(startDate) && !dt.isAfter(endDate);
                        }).toList();

                        graphList = filteredList;

                        _generateChartDataFromGraphList();

                        notifyListeners();
                        Navigator.pop(context);
                      },
                      child: AppButtons().filledButton(true, AppStrings.confirm, context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() {
      _isPickerOpen = false;
    });
  }

  Future<void> getGraphCodesByClassAndRegion({
    required BuildContext context,
    required bool loader,
  }) async {
    final data = {
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

    if (response != null) {
      final list = json.decode(response.body) as List;
      // debugPrint(response.body.toString(), wrapWidth: 1024);

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
      requestData: {"grphcode": grphcode ?? ""},
      context: context,
      isBottomSheet: false,
      loader: loader,
    );

    if (response != null) {
      final body = json.decode(response.body);
      allPriceDataModal = AllPriceDataModal.fromJson(
        body is Map ? body : (body is List && body.isNotEmpty ? body.first : {}),
      );
      notifyListeners();
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
            height: MediaQuery.of(context).size.height / 6,
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

      await upDateGraphData(context);
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
