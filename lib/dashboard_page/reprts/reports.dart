import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/argument/report_detail_arg.dart';
import 'package:uswheat/provider/reports_provider.dart';
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
      Provider.of<ReportsProvider>(context, listen: false).getDefaultReports(context: context);
    });
    scrollController.addListener(() {
      final rp = Provider.of<ReportsProvider>(context, listen: false);

      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        if (!rp.isLoading && rp.hasMoreData) {
          if (rp.isRecentMode || (rp.selectedReportType == null && rp.selectedYear == null && rp.selectedCategory == null)) {
            rp.getDefaultReports(context: context);
          } else {
            rp.getReports(context: context);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ReportsProvider>(
        builder: (context, rp, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3.6,
                          color: AppColors.c95795d.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            child: GestureDetector(
                              onTapDown: (TapDownDetails details) {
                                rp.showFilterDropdown(
                                  context: context,
                                  details: details,
                                  onSelect: (reportType) {
                                    rp.selectedReportType = reportType;
                                    rp.resetPagination();
                                    rp.getReports(context: context);
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      AppStrings.rep,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.cab865a,
                                          ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.cab865a,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            rp.selectedReportType != null ? rp.selectedReportType![0].toUpperCase() + rp.selectedReportType!.substring(1) : "Select Report Type",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.c353d4a.withOpacity(0.7),
                                ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 1,
                      color: AppColors.cB6B6B6,
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3.6,
                          color: AppColors.c95795d.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            child: GestureDetector(
                              onTapDown: (TapDownDetails details) {
                                rp.showFilterYearDropdown(
                                  context: context,
                                  details: details,
                                  onSelect: (yearType) {
                                    rp.selectedYear = yearType;
                                    rp.resetPagination();
                                    rp.getReports(context: context);
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      AppStrings.ye,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.cab865a,
                                          ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.cab865a,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            rp.selectedYear ?? "Select Year Type",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.c353d4a.withOpacity(0.7),
                                ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 1,
                      color: AppColors.cB6B6B6,
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3.6,
                          color: AppColors.c95795d.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            child: GestureDetector(
                              onTapDown: (TapDownDetails details) {
                                rp.showLanguageDropdown(
                                  context: context,
                                  details: details,
                                  onSelect: (languageType) {
                                    rp.selectedCategory = languageType;
                                    rp.resetPagination();
                                    rp.getReports(context: context);
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      AppStrings.cat,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.cab865a,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.cab865a,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            rp.selectedCategory != null ? rp.selectedCategory![0].toUpperCase() + rp.selectedCategory!.substring(1) : "Select Category Type",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.c353d4a.withOpacity(0.7),
                                ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 1,
                      color: AppColors.cB6B6B6,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Transform.scale(
                    scale: 0.6,
                    child: Switch(
                      activeColor: AppColors.c5B8EDC,
                      inactiveThumbColor: AppColors.c353d4a.withOpacity(0.7),
                      value: rp.isFilterCleared,
                      onChanged: (value) {
                        rp.isFilterCleared = value;
                        if (value) {
                          rp.backupFilter();
                          rp.selectedReportType = null;
                          rp.selectedYear = null;
                          rp.selectedCategory = null;
                          rp.resetPagination();
                          rp.getDefaultReports(context: context);
                        } else {
                          rp.resetFilter();
                          rp.resetPagination();
                          rp.getReports(context: context);
                        }
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: List.generate(
                      rp.reports.length + 1,
                      (index) {
                        if (index < rp.reports.length) {
                          final report = rp.reports[index];
                          return GestureDetector(
                            onTap: () {
                              final arg = ReportDetailArg(
                                title: report.title ?? "",
                                pdfUrl: report.effectiveUrl ?? "",
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
                                        Image.asset(AppAssets.pdf, scale: 35),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            report.title ?? "",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        AppStrings.view,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.cB6B6B6),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 12,
                                        color: AppColors.cB6B6B6,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return rp.isLoading && rp.hasMoreData
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: AppWidgets.loading(),
                                )
                              : const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
