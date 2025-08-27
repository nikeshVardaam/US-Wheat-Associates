import 'package:uswheat/modal/quality_report_modal.dart';
import 'package:uswheat/modal/sales_modal.dart';

class WatchlistModel {
  final bool success;
  final List<WatchlistItem> data;

  WatchlistModel({required this.success, required this.data});

  factory WatchlistModel.fromJson(Map<String, dynamic> json) {
    return WatchlistModel(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)?.map((e) => WatchlistItem.fromJson(e)).toList() ?? [],
    );
  }
}

class WatchlistItem {
  final String id;
  final String userId;
  final String type;
  final FilterData filterdata;
  final String createdAt;
  final String updatedAt;
  List<SalesData> chartData;
  WheatData? wheatData;

  WatchlistItem({
    required this.id,
    required this.userId,
    required this.type,
    required this.filterdata,
    required this.createdAt,
    required this.updatedAt,
    this.chartData = const [],
    this.wheatData,
  });

  factory WatchlistItem.fromJson(Map<String, dynamic> json) {
    WheatData? wheat;
    if (json['type'] == "quality") {
      // Backend me quality data agar alag object me hai to use parse karo
      wheat = WheatData.fromJson(json['qualityData'] ?? json);
    }

    return WatchlistItem(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      type: json['type'] ?? '',
      filterdata: FilterData.fromJson(json['filterdata'] ?? {}),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      wheatData: wheat,
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

class WheatData {
  final String? testWtlbbu;
  final String? testWtkghl;
  final String? moisture;
  final String? prot12Mb;
  final String? dryBasisProt;

  WheatData({
    this.testWtlbbu,
    this.testWtkghl,
    this.moisture,
    this.prot12Mb,
    this.dryBasisProt,
  });

  factory WheatData.fromJson(Map<String, dynamic> json) {
    return WheatData(
      testWtlbbu: json['testWtlbbu']?.toString(),
      testWtkghl: json['testWtkghl']?.toString(),
      moisture: json['Moisture%']?.toString(),
      prot12Mb: json['Prot12%mb']?.toString(),
      dryBasisProt: json['DryBasisProt%']?.toString(),
    );
  }
}
