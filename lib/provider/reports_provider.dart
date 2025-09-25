import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../modal/repots_modal.dart';

class ReportsProvider extends ChangeNotifier {
  bool isRecentMode = false;
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

    final url = "https://uswheat.org/wp-json/uswheat/v1/post-type-data?page&per_page";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as List<dynamic>;

        // Flatten all posts
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

        // Load only first 10 items
        final chunk = allPosts.take(10).toList();
        _reports.clear();
        _reports.addAll(chunk.map((e) => ReportModel.fromJson(e)).toList());

        hasMoreData = false; // 👈 disables any further pagination
      }
    } catch (e) {
      print("Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getReports({required BuildContext context}) async {
    if (_isLoading || !hasMoreData) return;

    // Check filters
    if (!isRecentMode && (selectedReportType == null || selectedYear == null || selectedCategory == null)) {
      // Filters incomplete, do not fetch
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      String url;
      if (isRecentMode) {
        url = "https://uswheat.org/wp-json/uswheat/v1/reports"
            "?per_page=20&page=$currentPage&report_type=all";
      } else {
        url = "https://uswheat.org/wp-json/uswheat/v1/reports"
            "?per_page=20&page=$currentPage"
            "&year=$selectedYear&category=$selectedCategory"
            "&report_type=$selectedReportType&taxonomy=${getTaxonomy()}";
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['data'] ?? [];

        if (currentPage == 1) _reports.clear();

        if (data.isEmpty) {
          hasMoreData = false;
          // Show empty state instead of default data
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
