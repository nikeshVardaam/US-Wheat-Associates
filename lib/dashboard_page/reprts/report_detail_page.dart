import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:uswheat/argument/report_detail_arg.dart';
import 'package:uswheat/utils/app_strings.dart';

class ReportDetailPage extends StatefulWidget {
  final ReportDetailArg reportDetailArg;

  const ReportDetailPage({
    super.key,
    required this.reportDetailArg,
  });

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  @override
  Widget build(BuildContext context) {
    print("PDF URL: ${widget.reportDetailArg.pdfUrl}");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reportDetailArg.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.reportDetailArg.pdfUrl.isNotEmpty
            ? SfPdfViewer.network(widget.reportDetailArg.pdfUrl)
            : Center(
          child: Text(
            AppStrings.noData,
            style: Theme
                .of(context)
                .textTheme
                .labelLarge
                ?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
