class Report {
  final List<ReportType> reportType;
  final List<Terms> terms;

  Report({
    required this.reportType,
    required this.terms,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportType: (json['report_type'] as List<dynamic>?)
          ?.map((e) => ReportType.fromJson(e as Map<String, dynamic>))
          .toList() ??
          const <ReportType>[],
      terms: (json['terms'] as List<dynamic>?)
          ?.map((e) => Terms.fromJson(e as Map<String, dynamic>))
          .toList() ??
          const <Terms>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'report_type': reportType.map((e) => e.toJson()).toList(),
      'terms': terms.map((e) => e.toJson()).toList(),
    };
  }

  List<String> get reportTypeNameList => reportType
      .map((rt) => rt.name)
      .where((n) => n != null && n.trim().isNotEmpty)
      .map((n) => n!)
      .toList();
}

class ReportType {
  final String? name;
  final String? slug;

  ReportType({this.name, this.slug});

  factory ReportType.fromJson(Map<String, dynamic> json) {
    return ReportType(
      name: json['name'] as String?,
      slug: json['slug'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
    };
  }

}

class Terms {
  final String? id;
  final String? title;
  final String? name; // optional, if API sometimes provides name/slug

  Terms({this.id, this.title, this.name});

  factory Terms.fromJson(Map<String, dynamic> json) {
    return Terms(
      id: json['id']?.toString(),
      title: json['title'] as String?,
      name: json['name'] as String?, // tolerate presence
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': name,
    };
  }
}
