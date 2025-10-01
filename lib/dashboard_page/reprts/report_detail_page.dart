import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:uswheat/argument/report_detail_arg.dart';
import 'package:uswheat/utils/app_widgets.dart';
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
  final PdfViewerController _pdfController = PdfViewerController();
  WebViewController? _webController;
  bool isLoading = true;

  bool get _isPdf =>
      widget.reportDetailArg.pdfUrl.toLowerCase().endsWith('.pdf');

  String get _url => widget.reportDetailArg.pdfUrl;

  @override
  void initState() {
    super.initState();

    if (_url.isEmpty) {
      Future.microtask(() => setState(() => isLoading = false));
      return;
    }

    if (!_isPdf) {
      String url = _url;
      if (url.endsWith('.docx') ||
          url.endsWith('.odf') ||
          url.endsWith('.pptx')) {
        url = "https://docs.google.com/viewer?url=$url&embedded=true";
      }

      _webController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => setState(() => isLoading = true),
            onPageFinished: (_) => setState(() => isLoading = false),
            onWebResourceError: (_) {
              setState(() => isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to load document")));
            },
          ),
        )
        ..setBackgroundColor(Colors.white)
        ..loadRequest(Uri.parse(url));
    }
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reportDetailArg.title),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: _url.isEmpty
                ? Center(
              child: Text(
                AppStrings.noData,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            )
                : _isPdf
                ? SfPdfViewer.network(
              _url,
              controller: _pdfController,
              onDocumentLoaded: (details) =>
                  setState(() => isLoading = false),
              onDocumentLoadFailed: (details) {
                setState(() => isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Failed to load PDF")));
              },
            )
                : _webController != null
                ? WebViewWidget(controller: _webController!)
                : Center(
              child: Text(
                AppStrings.noData,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.white,
              child: Center(child: AppWidgets.loading()),
            ),
        ],
      ),
    );
  }
}
