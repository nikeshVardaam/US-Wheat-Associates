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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ReportsProvider>(
        builder: (context, rp, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
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
                                    print("You selected: $reportType");
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.reports,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.cab865a,
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
                            rp.selectedReportType ?? "Select Report Type",
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
                          width: MediaQuery.of(context).size.width / 4,
                          color: AppColors.c95795d.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: GestureDetector(
                              onTapDown: (TapDownDetails details) {
                                rp.showFilterYearDropdown(
                                  context: context,
                                  details: details,
                                  onSelect: (yearType) {
                                    rp.selectedYear = yearType;
                                    rp.resetPagination();
                                    rp.getReports(context: context);
                                    print("You selected: $yearType");
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.year,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.cab865a,
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
                            rp.selectedYear ?? "Select Report Type",
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
                          width: MediaQuery.of(context).size.width / 4,
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
                                    print("You selected: $languageType");
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.category,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.cab865a,
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
                            rp.selectedCategory ?? "Select Report Type",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.c353d4a.withOpacity(0.7),
                                ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                      height: 1,
                      color: AppColors.cB6B6B6,
                    ),
                  ],
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
