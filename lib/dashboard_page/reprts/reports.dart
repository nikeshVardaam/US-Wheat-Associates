import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/argument/report_detail_arg.dart';
import 'package:uswheat/dashboard_page/reprts/report_detail_page.dart';
import 'package:uswheat/provider/reports_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uswheat/utils/app_assets.dart';
import 'package:uswheat/utils/app_box_decoration.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_routes.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/app_widgets.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ReportsProvider>(context, listen: false).getReports(context: context);
    });
    scrollController.addListener(() {
      final provider = Provider.of<ReportsProvider>(context, listen: false);
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100 && provider.hasMoreData && !provider.isLoading) {
        provider.getReports(context: context);
      }
    });
  }

  void _onFilterChanged(BuildContext context) {
    final rp = Provider.of<ReportsProvider>(context, listen: false);
    if (rp.selectedReportType != null && rp.selectedYear != null && rp.selectedCategory != null) {
      rp.resetPagination();
      rp.getReports(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ReportsProvider>(
        builder: (context, rp, child) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(color: AppColors.cEFEEED),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Column(
                    children: [
                      Container(
                        decoration: AppBoxDecoration.greyBorder(context),
                        child: DropdownButton<String>(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          isExpanded: true,
                          hint: const Text("Select Report Type"),
                          underline: Container(),
                          value: rp.reportTypes.any((e) => e['value'] == rp.selectedReportType) ? rp.selectedReportType : null,
                          items: rp.reportTypes.map((type) {
                            return DropdownMenuItem(
                              value: type['value'],
                              child: Text(type['name']!, style: Theme.of(context).textTheme.labelLarge),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              rp.selectedReportType = value;
                              _onFilterChanged(context);
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: AppBoxDecoration.greyBorder(context),
                                  child: DropdownButton<String>(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    isExpanded: true,
                                    underline: Container(),
                                    hint: const Text("Select Year"),
                                    value: rp.years.contains(rp.selectedYear) ? rp.selectedYear : null,
                                    items: rp.years.map((year) {
                                      return DropdownMenuItem(
                                        value: year,
                                        child: Text(year, style: Theme.of(context).textTheme.labelLarge),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        rp.selectedYear = value;
                                        _onFilterChanged(context);
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: AppBoxDecoration.greyBorder(context),
                                  child: DropdownButton<String>(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    isExpanded: true,
                                    underline: Container(),
                                    hint: Text(
                                      "Select Category",
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(),
                                    ),
                                    value: rp.languages.contains(rp.selectedCategory) ? rp.selectedCategory : null,
                                    items: rp.languages.toSet().map((lang) {
                                      return DropdownMenuItem(
                                        value: lang,
                                        child: Text(
                                          lang,
                                          style: Theme.of(context).textTheme.labelLarge,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        rp.selectedCategory = value;
                                        _onFilterChanged(context);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                    child: rp.reports.isEmpty && !rp.isLoading
                        ? Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Text(
                              "No Data Found",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          )
                        : Column(
                            children: [
                              ...List.generate(rp.reports.length, (index) {
                                final report = rp.reports[index];
                                return GestureDetector(
                                  onTap: () {
                                    ReportDetailArg arg = ReportDetailArg(
                                      title: report.title ?? "",
                                      pdfUrl: report.pdfUrl ?? "",
                                    );
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.reportDetailPage,
                                      arguments: arg,
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: AppBoxDecoration.greyBorder(context),
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                AppAssets.pdf,
                                                scale: 35,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  report.title ?? "",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                        color: AppColors.c000000,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              AppStrings.view,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: AppColors.cB6B6B6,
                                                  ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 12,
                                              color: AppColors.cB6B6B6,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              if (rp.isLoading && rp.hasMoreData)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: AppWidgets.loading(),
                                ),
                            ],
                          ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
