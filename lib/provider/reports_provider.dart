import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uswheat/service/get_api_services.dart';

class ReportsProvider extends ChangeNotifier {
  List<dynamic> reportsOptions = [];
  List<dynamic> reports = [];

  int pageNumber = 1;
  String reportTypeNameParam = "";
  String termParam = "";
  int perPage = 100;
  int page = 20;

  var selectedReportOption;
  var selectedCategory;

  setSelectedReportOption(var r) {
    selectedReportOption = r;
    selectedCategory = null;
    notifyListeners();
  }

  setSelectedCategory(var c) {
    selectedCategory = c;
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

  Future<void> getFilterReport({required BuildContext context}) async {
    reportTypeNameParam = selectedReportOption["report_type"][0]['slug'];
    termParam = selectedCategory['slug'];
    String url =
        "https://uswheat.org/wp-json/uswheat/v1/get-reports?report_type_name=$reportTypeNameParam&term=$termParam&per_page=$perPage&page=$pageNumber";

    await GetApiServices()
        .getWithDynamicUrl(url: url, loader: true, context: context)
        .then(
      (value) {
        if (value != null) {
          var data = jsonDecode(value.body);

          for (var i = 0; i < data.length; ++i) {
            reports = data[i]['reports'];
          }
        }
      },
    );
    notifyListeners();
  }

  Future<void> getReports({required BuildContext context}) async {
    reports.clear();
    await GetApiServices()
        .getWithDynamicUrl(
            url: "https://uswheat.org/wp-json/uswheat/v1/get-reports",
            loader: true,
            context: context)
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
