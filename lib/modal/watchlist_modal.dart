import 'package:intl/intl.dart';
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
  final String classs;
  final String date;
  final String year;
  final String color;

  FilterData({
    required this.region,
    required this.classs,
    required this.date,
    required this.year,
    required this.color,
  });

  factory FilterData.fromJson(Map<String, dynamic> json) {
    return FilterData(
      region: json['region'] ?? '',
      classs: json['class'] ?? '',
      date: json['date'] ?? '',
      year: json['year'] ?? '',
      color: json['color'] ?? '',
    );
  }

  String get formattedDate {
    try {
      if (date.isEmpty) return '';
      final dt = DateTime.parse(date);
      return DateFormat('dd-MMM-yyyy').format(dt).toUpperCase();
    } catch (_) {
      return date;
    }
  }
}

class WheatData {
  final String? testWtlbbu;
  final String? testWtkghl;
  final String? moisture;
  final String? prot12Mb;
  final String? dryBasisProt;
  final String? dhv;
  final String? hvac;
  final String? fallingNumber;

  WheatData({
    this.testWtlbbu,
    this.testWtkghl,
    this.moisture,
    this.prot12Mb,
    this.dryBasisProt,
    this.dhv,
    this.hvac,
    this.fallingNumber,
  });

  factory WheatData.fromJson(Map<String, dynamic> json) {
    return WheatData(
      testWtlbbu: json['testWtlbbu']?.toString(),
      testWtkghl: json['testWtkghl']?.toString(),
      moisture: json['Moisture%']?.toString(),
      prot12Mb: json['Prot12%mb']?.toString(),
      dryBasisProt: json['DryBasisProt%']?.toString(),
      dhv: json['DHV']?.toString(),
      hvac: json['HVAC']?.toString(),
      fallingNumber: json['FallingNumber']?.toString(),
    );
  }
}
