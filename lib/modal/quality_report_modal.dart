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
  num? testWtlbbu;
  num? testWtkghl;
  num? moisture;
  num? prot12Mb;
  num? dryBasisProt;
  num? dhv;
  num? hvac;
  num? fallingNum;
  num? totalRecords;
  num? year;

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
        yearsRange: json["years_range"],
        yearAverageClass: json["class"],
        testWtlbbu: json["testWtlbbu"].toDouble(),
        testWtkghl: json["testWtkghl"].toDouble(),
        moisture: json["Moisture%"].toDouble(),
        prot12Mb: json["Prot12%mb"].toDouble(),
        dryBasisProt: json["DryBasisProt%"].toDouble(),
        dhv: json["DHV"],
        hvac: json["HVAC"],
        fallingNum: json["FallingNum"].toDouble(),
        totalRecords: json["total_records"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "years_range": yearsRange,
        "class": yearAverageClass,
        "testWtlbbu": testWtlbbu,
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
