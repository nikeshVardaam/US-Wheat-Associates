import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../modal/repots_modal.dart';

class ReportsProvider extends ChangeNotifier {
  // Report types list
  final List<Map<String, String>> reportTypes = [
    {'name': 'Commercial Sales Report', 'value': 'commercial-sales'},
    {'name': 'Crop Quality Report', 'value': 'crop-quality'},
    {'name': 'Harvest Reports', 'value': 'harvest-report'},
    {'name': 'Price Report', 'value': 'price-report'},
    {'name': 'Spanish Reports', 'value': 'spanish-report'},
    {'name': 'Supply and Demand Report', 'value': 'supply-and-demand'},
  ];

  final List<String> years = List.generate(DateTime.now().year - 2015 + 1, (index) => (2015 + index).toString());

  final List<String> languages = ['english', 'chinese'];

  String? selectedReportType = "commercial-sales";
  String? selectedYear = DateTime.now().year.toString();
  String? selectedCategory = "english";

  final List<ReportModel> _reports = [];

  List<ReportModel> get reports => _reports;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  int currentPage = 1;
  bool hasMoreData = true;

  void resetPagination() {
    currentPage = 1;
    _reports.clear();
    hasMoreData = true;
    notifyListeners();
  }

  void updateFiltersAndFetch({
    required String reportType,
    required String year,
    required String category,
    required BuildContext context,
  }) {
    selectedReportType = reportType;
    selectedYear = year;
    selectedCategory = category;
    resetPagination();
    getReports(context: context);
  }

  String getTaxonomy() {
    switch (selectedReportType) {
      case 'commercial-sales':
        return 'commercial-sales-category';
      case 'crop-quality':
        return 'crop-quality-category';
      case 'harvest-report':
        return 'harvest-report-category';
      case 'price-report':
        return 'price-report-category';
      case 'spanish-report':
        return 'spanish-report-category';
      case 'supply-and-demand':
        return 'supply-and-demand-category';
      default:
        return '';
    }
  }

  Future<void> getReports({required BuildContext context}) async {
    if (_isLoading || !hasMoreData) return;
    if (selectedReportType == null || selectedYear == null || selectedCategory == null) return;

    _isLoading = true;
    notifyListeners();

    final url = "https://uswheat.org/wp-json/uswheat/v1/reports?per_page=20&page=$currentPage"
        "&year=$selectedYear&category=$selectedCategory"
        "&report_type=$selectedReportType&taxonomy=${getTaxonomy()}";
    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['data'] ?? [];

        if (data.isEmpty) {
          hasMoreData = false;
        } else {
          currentPage++;
          _reports.addAll(data.map((e) => ReportModel.fromJson(e)).toList());
        }
      } else {
        print("Failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
