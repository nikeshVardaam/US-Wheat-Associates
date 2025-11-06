class ReportModel {
  final int id;
  final String title;
  final String pdfUrl;
  final String? url;
  final String? publishDate;

  ReportModel({
    required this.id,
    required this.title,
    required this.pdfUrl,
    required this.url,
    required this.publishDate,
  });

  String get effectiveUrl => pdfUrl.isNotEmpty == true ? pdfUrl : url ?? '';

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] is String ? json['title'] : '',
      pdfUrl: json['pdf_url'] is String ? json['pdf_url'] : '',
      url: json['url'] is String ? json['url'] : '',
      publishDate: json['publish_date'] is String ? json['publish_date'] : '',
    );
  }
}


