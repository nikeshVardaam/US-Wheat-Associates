import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'
    show PdfViewerController;
import 'package:uswheat/modal/model_report.dart';
import 'package:uswheat/service/get_api_services.dart';

import 'package:webview_flutter/webview_flutter.dart';
import '../modal/repots_modal.dart';

class ReportsProvider extends ChangeNotifier {
  final PdfViewerController pdfController = PdfViewerController();
  WebViewController? webController;

  List<ReportType> reportTypeList = [];
  List<Terms> termsList = [];

  bool isRecentMode = false;
  bool isFilterCleared = false;
  String? backupReportType;
  late List<Report> rootItems;
  String? backupCategory;
  late List<String> reportList;
  final List<Map<String, String>> reportTypes = [
    {'name': 'Commercial Sales Report', 'value': 'commercial-sales'},
    {'name': 'Crop Quality Report', 'value': 'crop-quality'},
    {'name': 'Harvest Reports', 'value': 'harvest-report'},
    {'name': 'Price Report', 'value': 'price-report'},
    {'name': 'Spanish Reports', 'value': 'spanish-report'},
    {'name': 'Supply and Demand Report', 'value': 'supply-and-demand'},
  ];

  final List<String> languages = ['english'];

  String? selectedReportType;
  String? selectedYear;

  String? selectedCategory;
  late List<int> yearList;

  final List<ReportModel> _reports = [];

  List<ReportModel> get reports => _reports;

  bool _isLoading = false;

  // late List<Terms> reportTypeList = [];
  late List<String> reportTypeNames = [];
  late List<String> reportTypeSlugs = [];

  bool get isLoading => _isLoading;

  int currentPage = 1;
  bool hasMoreData = true;

  clearFilter() {
    selectedReportType = null;
    selectedYear = null;
    selectedCategory = null;
    isFilterCleared = true;
    notifyListeners();
  }

  clearFilterAndReload({required BuildContext context}) {
    clearFilter();
    getDefaultReports(context: context);
  }

  void resetPagination() {
    currentPage = 1;
    _reports.clear();
    hasMoreData = true;
    notifyListeners();
  }

  String getTaxonomy(String selectedTaxonomy) {
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

  List<String> getReportNames() {
    return reportTypes.map((report) => report['name'] ?? '').toList();
  }

  Future<void> getDefaultReports({required BuildContext context}) async {
    if (_isLoading || !hasMoreData) return;

    _isLoading = true;
    notifyListeners();

    const url = "https://uswheat.org/wp-json/uswheat/v1/post-type-data";
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await _getWithRetry(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as List<dynamic>;
        final List<Map<String, dynamic>> allPosts = [];

        for (var item in decoded) {
          final posts = item['posts'] as List<dynamic>? ?? [];
          for (var post in posts) {
            allPosts.add({
              'title': post['title'] ?? '',
              'url': post['url'] ?? '',
            });
          }
        }

        // Take first 10 posts
        final chunk = allPosts.take(10).toList();

        _reports
          ..clear()
          ..addAll(chunk.map((e) => ReportModel.fromJson(e)).toList());

        hasMoreData = false;

        // Cache the response for offline use
        await prefs.setString('cached_reports', response.body);
      } else {
        print('Server error: ${response.statusCode}');
        await _loadFromCache(prefs);
      }
    } on TimeoutException {
      print('Request timed out');
      await _loadFromCache(prefs);
    } on SocketException catch (e) {
      print('Network error: $e');
      await _loadFromCache(prefs);
    } catch (e) {
      print('Unexpected error: $e');
      await _loadFromCache(prefs);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<http.Response> _getWithRetry(Uri uri, {int retries = 2}) async {
    int attempt = 0;
    while (attempt <= retries) {
      try {
        return await http.get(uri, headers: {
          'User-Agent': 'FlutterApp/1.0 (https://uswheat.org)',
          'Accept': 'application/json',
        }).timeout(const Duration(seconds: 15));
      } on SocketException catch (e) {
        attempt++;
        if (attempt > retries) rethrow;
        await Future.delayed(const Duration(seconds: 2));
      } on TimeoutException {
        attempt++;
        if (attempt > retries) rethrow;
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    throw Exception('Failed after $retries retries');
  }

  /// Load cached reports in case of network failure
  Future<void> _loadFromCache(SharedPreferences prefs) async {
    final cachedData = prefs.getString('cached_reports');
    if (cachedData != null) {
      final decoded = jsonDecode(cachedData) as List<dynamic>;
      final List<Map<String, dynamic>> allPosts = [];

      for (var item in decoded) {
        final posts = item['posts'] as List<dynamic>? ?? [];
        for (var post in posts) {
          allPosts.add({
            'title': post['title'] ?? '',
            'url': post['url'] ?? '',
          });
        }
      }

      final chunk = allPosts.take(10).toList();
      _reports
        ..clear()
        ..addAll(chunk.map((e) => ReportModel.fromJson(e)).toList());

      hasMoreData = false;
      print('Loaded reports from cache');
    } else {
      print('No cached reports available');
    }
  }

  Future<void> getCategory(
      {required BuildContext context, required String name}) async {
    final resp = await GetApiServices().getWithDynamicUrl(
      url: "https://uswheat.org/wp-json/uswheat/v1/get-report-options",
      loader: true,
      context: context,
    );
    if (resp == null) return;

    final decoded = jsonDecode(resp.body);

    if (decoded is Map<String, dynamic>) {
      final report = Report.fromJson(decoded);
      for (final rt in report.reportType) {
        debugPrint(rt.name);
        debugPrint(rt.slug);
      }
      return;
    }

    if (decoded is List) {
      final List<dynamic> reportTypeBlocks = decoded
          .map((e) => (e as Map<String, dynamic>)['report_type'])
          .where((x) => x is List)
          .toList();

      final List<dynamic> flattened =
          reportTypeBlocks.expand((e) => e as List).toList();

      final names = flattened
          .map((e) => (e as Map<String, dynamic>)['name'] as String?)
          .where((n) => n != null && n.trim().isNotEmpty)
          .map((n) => n!)
          .toList();

      for (final n in names) {
        reportTypeNames.add(n);
        debugPrint(n);
      }
      return;
    }

    throw Exception('Unexpected JSON shape for get-report-options');
  }

  Future<void> getReports(
      {required BuildContext context, required bool loader}) async {
    await GetApiServices()
        .getWithDynamicUrl(
      url: "https://uswheat.org/wp-json/uswheat/v1/get-report-options",
      loader: loader,
      context: context,
    )
        .then((value) {
      if (value != null) {
        final report = Report.fromJson(jsonDecode(value.body));
        for (var name in report.reportType) {
          reportTypeNames.add(name.name ?? "");
        }

        print(reportTypeNames);
        print(reportTypeNames);
      }
    });
  }
}
