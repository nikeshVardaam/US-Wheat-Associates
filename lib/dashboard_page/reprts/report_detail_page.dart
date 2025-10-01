import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:uswheat/utils/app_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
  final PdfViewerController _pdfViewerController = PdfViewerController();
  WebViewController? _webController;
  bool _isLoading = true;

  bool get _isPdf => widget.reportDetailArg.pdfUrl.toLowerCase().endsWith('.pdf');

  @override
  void initState() {
    super.initState();

    if (!_isPdf && widget.reportDetailArg.pdfUrl.isNotEmpty) {
      String url = widget.reportDetailArg.pdfUrl;

      if (url.endsWith('.docx') || url.endsWith('.odf') || url.endsWith('.pptx')) {
        url = "https://docs.google.com/viewer?url=$url&embedded=true";
      }

      _webController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => setState(() => _isLoading = true),
            onPageFinished: (_) => setState(() => _isLoading = false),
            onWebResourceError: (_) => setState(() => _isLoading = false),
          ),
        )
        ..loadRequest(Uri.parse(url));
    }
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.reportDetailArg.pdfUrl;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reportDetailArg.title),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: url.isNotEmpty
                ? _isPdf
                    ? SfPdfViewer.network(
                        url,
                        key: ValueKey(url),
                        controller: _pdfViewerController,
                        onDocumentLoaded: (details) {
                          setState(() => _isLoading = false);
                        },
                        onDocumentLoadFailed: (details) {
                          setState(() => _isLoading = false);
                        },
                      )
                    : _webController != null
                        ? WebViewWidget(controller: _webController!)
                        : const SizedBox()
                : Center(
                    child: Text(
                      AppStrings.noData,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
          ),
          if (_isLoading)
            Center(
              child: AppWidgets.loading(),
            ),
        ],
      ),
    );
  }
}
