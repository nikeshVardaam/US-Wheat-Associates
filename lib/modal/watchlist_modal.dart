import 'package:intl/intl.dart';
import 'package:uswheat/modal/sales_modal.dart';

import 'graph_modal.dart';

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

class Data {
  Current? current;
  YearAverage? yearAverage;
  FiveYearAverage? fiveYearAverage;

  Data({this.current, this.yearAverage, this.fiveYearAverage});

  Data.fromJson(Map<String, dynamic> json) {
    current = json['current'] != null ? new Current.fromJson(json['current']) : null;
    yearAverage = json['year_average'] != null ? new YearAverage.fromJson(json['year_average']) : null;
    fiveYearAverage = json['five_year_average'] != null ? new FiveYearAverage.fromJson(json['five_year_average']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.current != null) {
      data['current'] = this.current!.toJson();
    }
    if (this.yearAverage != null) {
      data['year_average'] = this.yearAverage!.toJson();
    }
    if (this.fiveYearAverage != null) {
      data['five_year_average'] = this.fiveYearAverage!.toJson();
    }
    return data;
  }
}

class Current {
  String date;
  String className; // renamed from 'class'
  String? testWtlbbu;
  String? testWtkghl;
  String? moisture;
  String? prot12Mb;
  String? dryBasisProt;
  String? dHV;
  String? hVAC;
  String? fallingNum;

  Current({
    required this.date,
    required this.className,
    this.testWtlbbu,
    this.testWtkghl,
    this.moisture,
    this.prot12Mb,
    this.dryBasisProt,
    this.dHV,
    this.hVAC,
    this.fallingNum,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      date: json['Date'] ?? '',
      className: json['class'] ?? '',
      // map JSON key 'class' to variable 'className'
      testWtlbbu: json['testWtlbbu']?.toString(),
      testWtkghl: json['testWtkghl']?.toString(),
      moisture: json['Moisture%']?.toString(),
      prot12Mb: json['Prot12%mb']?.toString(),
      dryBasisProt: json['DryBasisProt%']?.toString(),
      dHV: json['DHV']?.toString(),
      hVAC: json['HVAC']?.toString(),
      fallingNum: json['FallingNum']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Date': date,
      'class': className, // map back to JSON key
      'testWtlbbu': testWtlbbu,
      'testWtkghl': testWtkghl,
      'Moisture%': moisture,
      'Prot12%mb': prot12Mb,
      'DryBasisProt%': dryBasisProt,
      'DHV': dHV,
      'HVAC': hVAC,
      'FallingNum': fallingNum,
    };
  }
}

class YearAverage {
  int? year;
  String? className; // renamed from 'class'
  double? testWtlbbu;
  double? testWtkghl;
  double? moisture;
  double? prot12Mb;
  double? dryBasisProt;
  int? dHV;
  int? hVAC;
  int? fallingNum;
  int? totalRecords;

  YearAverage({
    this.year,
    this.className,
    this.testWtlbbu,
    this.testWtkghl,
    this.moisture,
    this.prot12Mb,
    this.dryBasisProt,
    this.dHV,
    this.hVAC,
    this.fallingNum,
    this.totalRecords,
  });

  YearAverage.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    className = json['class'];
    testWtlbbu = (json['testWtlbbu'] as num?)?.toDouble();
    testWtkghl = (json['testWtkghl'] as num?)?.toDouble();
    moisture = (json['Moisture%'] as num?)?.toDouble();
    prot12Mb = (json['Prot12%mb'] as num?)?.toDouble();
    dryBasisProt = (json['DryBasisProt%'] as num?)?.toDouble();
    dHV = json['DHV'];
    hVAC = json['HVAC'];
    fallingNum = json['FallingNum'];
    totalRecords = json['total_records'];
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'class': className,
      'testWtlbbu': testWtlbbu,
      'testWtkghl': testWtkghl,
      'Moisture%': moisture,
      'Prot12%mb': prot12Mb,
      'DryBasisProt%': dryBasisProt,
      'DHV': dHV,
      'HVAC': hVAC,
      'FallingNum': fallingNum,
      'total_records': totalRecords,
    };
  }
}

class FiveYearAverage {
  String? yearsRange;
  String? className;
  double? testWtlbbu;
  double? testWtkghl;
  double? moisture;
  double? prot12Mb;
  double? dryBasisProt;
  int? dHV;
  int? hVAC;
  int? fallingNum;
  int? totalRecords;

  FiveYearAverage({
    this.yearsRange,
    this.className,
    this.testWtlbbu,
    this.testWtkghl,
    this.moisture,
    this.prot12Mb,
    this.dryBasisProt,
    this.dHV,
    this.hVAC,
    this.fallingNum,
    this.totalRecords,
  });

  FiveYearAverage.fromJson(Map<String, dynamic> json) {
    yearsRange = json['years_range'];
    className = json['class']; // map JSON key to variable
    testWtlbbu = (json['testWtlbbu'] as num?)?.toDouble();
    testWtkghl = (json['testWtkghl'] as num?)?.toDouble();
    moisture = (json['Moisture%'] as num?)?.toDouble();
    prot12Mb = (json['Prot12%mb'] as num?)?.toDouble();
    dryBasisProt = (json['DryBasisProt%'] as num?)?.toDouble();
    dHV = json['DHV'];
    hVAC = json['HVAC'];
    fallingNum = json['FallingNum'];
    totalRecords = json['total_records'];
  }

  Map<String, dynamic> toJson() {
    return {
      'years_range': yearsRange,
      'class': className, // map variable back to JSON
      'testWtlbbu': testWtlbbu,
      'testWtkghl': testWtkghl,
      'Moisture%': moisture,
      'Prot12%mb': prot12Mb,
      'DryBasisProt%': dryBasisProt,
      'DHV': dHV,
      'HVAC': hVAC,
      'FallingNum': fallingNum,
      'total_records': totalRecords,
    };
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
  final String graphCode;
  List<GraphDataModal> graphDataList = [];

  WatchlistItem(
      {required this.id,
      required this.userId,
      required this.type,
      required this.filterdata,
      required this.createdAt,
      required this.updatedAt,
      this.chartData = const [],
      this.wheatData,
      required this.graphCode,
      required this.graphDataList});

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
        graphCode: json['grphcode'] ?? '',
        graphDataList: []);
  }
}

class FilterData {
  final String region;
  final String classs;
  final String date;
  final String year;
  final String color;
  final String graphCode;

  FilterData({required this.region, required this.classs, required this.date, required this.year, required this.color, required this.graphCode});

  factory FilterData.fromJson(Map<String, dynamic> json) {
    return FilterData(
      region: json['region'] ?? '',
      classs: json['class'] ?? '',
      date: json['date'] ?? '',
      year: json['year'] ?? '',
      color: json['color'] ?? '',
      graphCode: json['grphcode'] ?? '',
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

  Map<String, dynamic> toJson() {
    return {
      'testWtlbbu': testWtlbbu,
      'testWtkghl': testWtkghl,
      'Moisture%': moisture,
      'Prot12%mb': prot12Mb,
      'DryBasisProt%': dryBasisProt,
      'DHV': dhv,
      'HVAC': hvac,
      'FallingNumber': fallingNumber,
    };
  }
}
