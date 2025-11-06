// To parse this JSON data, do
//
//     final qualityReport = qualityReportFromJson(jsonString);

import 'dart:convert';

QualityReport qualityReportFromJson(String str) => QualityReport.fromJson(json.decode(str));

String qualityReportToJson(QualityReport data) => json.encode(data.toJson());

class QualityReport {
  bool? success;
  Data? data;

  QualityReport({
    this.success,
    this.data,
  });

  factory QualityReport.fromJson(Map<String, dynamic> json) => QualityReport(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class Data {
  YearAverage? current;
  YearAverage? yearAverage;
  YearAverage? fiveYearAverage;

  Data({
    this.current,
    this.yearAverage,
    this.fiveYearAverage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        current: (json["current"] != null) ? YearAverage.fromJson(json["current"]) : null,
        yearAverage: (json["year_average"] != null) ? YearAverage.fromJson(json["year_average"]) : null,
        fiveYearAverage: (json["five_year_average"] != null) ? YearAverage.fromJson(json["five_year_average"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "current": current?.toJson(),
        "year_average": yearAverage?.toJson(),
        "five_year_average": fiveYearAverage?.toJson(),
      };
}

class YearAverage {
  String? yearsRange;
  String? yearAverageClass;
  String? testWtlbbu;
  String? testWtkghl;
  String? moisture;
  String? prot12Mb;
  String? dryBasisProt;
  String? dhv;
  String? hvac;
  String? fallingNum;
  String? totalRecords;
  String? year;

  YearAverage({
    this.yearsRange,
    this.yearAverageClass,
    this.testWtlbbu,
    this.testWtkghl,
    this.moisture,
    this.prot12Mb,
    this.dryBasisProt,
    this.dhv,
    this.hvac,
    this.fallingNum,
    this.totalRecords,
    this.year,
  });

  factory YearAverage.fromJson(Map<String, dynamic> json) => YearAverage(
        yearsRange: json["years_range"].toString(),
        yearAverageClass: json["class"].toString(),
        testWtlbbu: json["testWtlbbu"].toString(),
        testWtkghl: json["testWtkghl"].toString(),
        moisture: json["Moisture%"].toString(),
        prot12Mb: json["Prot12%mb"].toString(),
        dryBasisProt: json["DryBasisProt%"].toString(),
        dhv: json["DHV"].toString(),
        hvac: json["HVAC"].toString(),
        fallingNum: json["FallingNum"].toString(),
        totalRecords: json["total_records"].toString(),
        year: json["year"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "years_range": yearsRange,
        "class": yearAverageClass,
        "testWtlbbu": testWtlbbu.toString(),
        "testWtkghl": testWtkghl,
        "Moisture%": moisture,
        "Prot12%mb": prot12Mb,
        "DryBasisProt%": dryBasisProt,
        "DHV": dhv,
        "HVAC": hvac,
        "FallingNum": fallingNum,
        "total_records": totalRecords,
        "year": year,
      };
}
