import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/service/get_api_services.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/pref_keys.dart';

class ReportsProvider extends ChangeNotifier {
  List<dynamic> reportsOptions = [];
  List<dynamic> reports = [];
  List<int> yearList = [];

  SharedPreferences? sp;
  int pageNumber = 1;
  String reportTypeNameParam = "";
  String termParam = "";
  int perPage = 100;
  num totalPages = 0;

  var selectedReportOption;
  var selectedCategory;
  var selectedYear;

  setSelectedReportOption(var r) {
    selectedReportOption = r;
    selectedCategory = null;
    notifyListeners();
  }

  setSelectedCategory({required var c, required BuildContext context}) {
    selectedCategory = c;
    getFilterReport(context: context);
    notifyListeners();
  }

  setSelectedYear({required var y, required BuildContext context}) {
    selectedYear = y;
    if (selectedCategory != null) {
      getFilterReport(context: context);
    }
    notifyListeners();
  }

  void nextPage({required BuildContext context}) {
    pageNumber++;
    getFilterReport(context: context);
    notifyListeners();
  }

  void previousPage({required BuildContext context}) {
    if (pageNumber > 0) {
      pageNumber--;
      getFilterReport(context: context);
      notifyListeners();
    }
  }

  Future<void> loadYear({required BuildContext context}) async {
    sp = await SharedPreferences.getInstance();

    final stored = sp?.getStringList(PrefKeys.yearList) ?? const <String>[];

    final parsed = <int>[];
    for (final s in stored) {
      final v = int.tryParse(s);
      if (v != null) parsed.add(v);
    }

    if (parsed.isEmpty) {
      parsed.add(DateTime.now().year);
    }

    final sorted = List<int>.from(parsed)..sort((a, b) => b.compareTo(a));

    yearList = sorted;
    notifyListeners();
  }

  Future<void> getYearList({required BuildContext context}) async {
    GetApiServices().get(endpoint: ApiEndpoint.getYears, context: context, loader: true).then(
      (value) {
        if (value != null) {
          yearList.clear();
          var data = jsonDecode(value.body);

          for (var i = 0; i < data.length; ++i) {
            yearList.add(data[i]);
          }
          yearList.sort((a, b) => b.compareTo(a));
        }
      },
    );
    notifyListeners();
  }

  Future<void> getFilterReport({required BuildContext context}) async {
    reports.clear();
    reportTypeNameParam = selectedReportOption["report_type"][0]['slug'];
    termParam = selectedCategory['slug'];
    String url =
        "https://uswheat.org/wp-json/uswheat/v1/get-reports?report_type_name=$reportTypeNameParam&term=$termParam&per_page=$perPage&page=$pageNumber&year=$selectedYear";

    await GetApiServices().getWithDynamicUrl(url: url, loader: true, context: context).then(
      (value) {
        if (value != null) {
          var data = jsonDecode(value.body);

          if (data is List && data.isNotEmpty) {
            totalPages = data[0]["total_pages"];

            for (var i = 0; i < data.length; ++i) {
              reports = data[i]['reports'];
            }
          } else {
            totalPages = 0;
            reports.clear();
          }
        }
      },
    );
    notifyListeners();
  }

  Future<void> getReports({required BuildContext context}) async {
    reports.clear();
    await GetApiServices()
        .getWithDynamicUrl(url: "https://uswheat.org/wp-json/uswheat/v1/get-reports", loader: true, context: context)
        .then(
      (value) {
        if (value != null) {
          var data = jsonDecode(value.body);
          for (var i = 0; i < data.length; ++i) {
            if (data[i]["report_type_label"] == "News Releases") {
              reports = data[i]["reports"];
            }
          }
          notifyListeners();
        }
      },
    );
  }

  Future<void> getReportsOptions({required BuildContext context}) async {
    reportsOptions.clear();
    await GetApiServices()
        .getWithDynamicUrl(
      url: "https://uswheat.org/wp-json/uswheat/v1/get-report-options",
      loader: false,
      context: context,
    )
        .then(
      (value) {
        if (value != null) {
          var data = jsonDecode(value.body);
          reportsOptions.addAll(data);
        }
        notifyListeners();
      },
    );
  }
}

class ReportType {
  String? name;
  String? slug;

  ReportType({this.name, this.slug});

  ReportType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}
