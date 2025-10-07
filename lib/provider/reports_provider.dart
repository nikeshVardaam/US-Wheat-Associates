import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart' show PdfViewerController;
import 'package:webview_flutter/webview_flutter.dart';
import '../modal/repots_modal.dart';

class ReportsProvider extends ChangeNotifier {
  final PdfViewerController pdfController = PdfViewerController();
  WebViewController? webController;

  bool isRecentMode = false;
  bool isFilterCleared = false;
  String? backupReportType;
  String? backupYear;
  String? backupCategory;
  final List<Map<String, String>> reportTypes = [
    {'name': 'Commercial Sales Report', 'value': 'commercial-sales'},
    {'name': 'Crop Quality Report', 'value': 'crop-quality'},
    {'name': 'Harvest Reports', 'value': 'harvest-report'},
    {'name': 'Price Report', 'value': 'price-report'},
    {'name': 'Spanish Reports', 'value': 'spanish-report'},
    {'name': 'Supply and Demand Report', 'value': 'supply-and-demand'},
  ];

  final List<String> years = List.generate(DateTime.now().year - 2015 + 1, (index) => (2015 + index).toString());

  final List<String> languages = ['english'];

  String? selectedReportType;
  String? selectedYear;

  String? selectedCategory;

  final List<ReportModel> _reports = [];

  List<ReportModel> get reports => _reports;

  bool _isLoading = false;

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

  Future<void> getDefaultReports({required BuildContext context}) async {
    if (_isLoading || !hasMoreData) return;

    _isLoading = true;
    notifyListeners();

    const url = "https://uswheat.org/wp-json/uswheat/v1/post-type-data";
    final prefs = await SharedPreferences.getInstance();

    try {
      // Attempt network request with retries
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

  /// Retry logic for network requests
  Future<http.Response> _getWithRetry(Uri uri, {int retries = 2}) async {
    int attempt = 0;
    while (attempt <= retries) {
      try {
        return await http
            .get(uri, headers: {
          'User-Agent': 'FlutterApp/1.0 (https://uswheat.org)',
          'Accept': 'application/json',
        })
            .timeout(const Duration(seconds: 15));
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

  Future<void> getReports({required BuildContext context}) async {
    if (_isLoading || !hasMoreData) return;

    _isLoading = true;
    notifyListeners();

    final int maxRetries = 3;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        String url;
        if (isRecentMode) {
          url = "https://uswheat.org/wp-json/uswheat/v1/reports"
              "?per_page=20&page=$currentPage"
              "&report_type=all";
        } else {
          if (selectedReportType == null || selectedYear == null || selectedCategory == null) {
            _isLoading = false;
            notifyListeners();
            return;
          }

          url =
              "https://uswheat.org/wp-json/uswheat/v1/reports?per_page=20&page=$currentPage&year=$selectedYear&category=$selectedCategory&report_type=$selectedReportType&taxonomy=${getTaxonomy()}";
        }

        final response = await http.get(
          Uri.parse(url),
          headers: {
            'User-Agent': 'FlutterApp',
          },
        );

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          final List<dynamic> data = decoded['data'] ?? [];

          if (data.isEmpty) {
            hasMoreData = false;
          } else {
            if (currentPage == 1) _reports.clear();
            currentPage++;
            _reports.addAll(data.map((e) => ReportModel.fromJson(e)).toList());
          }
          break;
        } else {
          print("Failed: ${response.statusCode}");
          break;
        }
      } on SocketException catch (e) {
        retryCount++;
        print("SocketException, retrying $retryCount/$maxRetries: $e");
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        print("Other error: $e");
        break;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> showFilterDropdown({
    required BuildContext context,
    required TapDownDetails details,
    required Function(String selectedReportType) onSelect,
  }) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

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
                itemCount: reportTypes.length,
                itemBuilder: (context, index) {
                  final reportType = reportTypes[index];
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(reportType['name'] ?? ''),
                    ),
                    onTap: () => Navigator.pop(context, reportType['value']),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );

    if (selected != null && selected.isNotEmpty) {
      selectedReportType = selected;
      onSelect(selected);
      notifyListeners();
    }
  }

  Future<void> showFilterYearDropdown({
    required BuildContext context,
    required TapDownDetails details,
    required Function(String selectedYear) onSelect,
  }) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

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
                itemCount: years.length,
                itemBuilder: (context, index) {
                  final year = years[index];
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(year),
                    ),
                    onTap: () => Navigator.pop(context, year),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );

    if (selected != null) {
      selectedYear = selected;
      onSelect(selected);
      notifyListeners();
    }
  }

  Future<void> showLanguageDropdown({
    required BuildContext context,
    required TapDownDetails details,
    required Function(String selectedLang) onSelect,
  }) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

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
            height: MediaQuery.of(context).size.height / 14,
            width: MediaQuery.of(context).size.width / 2,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(lang[0].toUpperCase() + lang.substring(1)),
                    ),
                    onTap: () => Navigator.pop(context, lang),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );

    if (selected != null) {
      selectedCategory = selected;
      onSelect(selected);
      notifyListeners();
    }
  }
}
