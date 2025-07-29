import 'package:uswheat/modal/sales_modal.dart';

class WatchlistModel {
  final bool success;
  final List<WatchlistItem> data;


  WatchlistModel({required this.success, required this.data});

  factory WatchlistModel.fromJson(Map<String, dynamic> json) {
    return WatchlistModel(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => WatchlistItem.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class WatchlistItem {
  final String id;
  final String userId;
  final FilterData filterdata;
  final String createdAt;
  final String updatedAt;
  List<SalesData> chartData;

  WatchlistItem({
    required this.id,
    required this.userId,
    required this.filterdata,
    required this.createdAt,
    required this.updatedAt,
    this.chartData = const [],
  });

  factory WatchlistItem.fromJson(Map<String, dynamic> json) {
    return WatchlistItem(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      filterdata: FilterData.fromJson(json['filterdata'] ?? {}),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class FilterData {
  final String region;
  final String classs; // 'class' is reserved in Dart, renamed to 'classs'
  final String date;

  FilterData({
    required this.region,
    required this.classs,
    required this.date,
  });

  factory FilterData.fromJson(Map<String, dynamic> json) {
    return FilterData(
      region: json['region'] ?? '',
      classs: json['class'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
