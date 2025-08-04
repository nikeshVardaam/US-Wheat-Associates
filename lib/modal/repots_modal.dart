class ReportModel {
  final int id;
  final String title;
  final String pdfUrl;

  ReportModel({
    required this.id,
    required this.title,
    required this.pdfUrl,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] is String ? json['title'] : '',
      pdfUrl: json['pdf_url'] is String ? json['pdf_url'] : '',
    );
  }

}
