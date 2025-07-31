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
      id: json['id'],
      title: json['title'],
      pdfUrl: json['pdf_url'],
    );
  }
}
