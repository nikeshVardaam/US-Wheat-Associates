import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/argument/report_detail_arg.dart';
import 'package:uswheat/dashboard_page/reprts/category_selector.dart';
import 'package:uswheat/dashboard_page/reprts/reports_selector.dart';
import 'package:uswheat/dashboard_page/reprts/year_selector.dart';
import 'package:uswheat/provider/reports_provider.dart';
import 'package:uswheat/utils/app_assets.dart';
import 'package:uswheat/utils/app_box_decoration.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_routes.dart';
import 'package:uswheat/utils/app_strings.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ReportsProvider prov = Provider.of<ReportsProvider>(context, listen: false);
      prov.selectedReportOption = null;
      prov.selectedCategory = null;
      prov.selectedYear = null;
      prov.getReportsOptions(context: context);
      prov.getReports(context: context);
      prov.loadYear(context: context);
    });
  }

  @override
  Widget build(BuildContext perentContext) {
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
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                              child: ReportsSelector(
                                reportList: rp.reportsOptions,
                              ),
                            );
                          },
                        ).then(
                          (value) {
                            if (value != null) {
                              rp.setSelectedReportOption(value);
                            }
                          },
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3.6,
                              color: AppColors.c95795d.withOpacity(0.1),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          height: MediaQuery.of(context).size.height / 3,
                                          child: ReportsSelector(
                                            reportList: rp.reportsOptions,
                                          ),
                                        );
                                      },
                                    ).then(
                                      (value) {
                                        if (value != null) {
                                          rp.setSelectedReportOption(value);
                                        }
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          AppStrings.reports.toUpperCase(),
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
                                rp.selectedReportOption != null
                                    ? rp.selectedReportOption["report_type"][0]["name"]
                                    : "Select Report Type",
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.c353d4a.withOpacity(0.7),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 1,
                      color: AppColors.cB6B6B6,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (rp.selectedReportOption != null) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height / 3,
                                child: CategorySelector(
                                  categoryList: rp.selectedReportOption["terms"] ?? [],
                                ),
                              );
                            },
                          ).then(
                            (value) {
                              if (value != null) {
                                rp.setSelectedCategory(c: value, context: context);
                              }
                            },
                          );
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3.6,
                              color: AppColors.c95795d.withOpacity(0.1),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    if (rp.selectedReportOption != null) {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return SizedBox(
                                            height: MediaQuery.of(context).size.height / 3,
                                            child: CategorySelector(
                                              categoryList: rp.selectedReportOption["terms"] ?? [],
                                            ),
                                          );
                                        },
                                      ).then(
                                        (value) {
                                          if (value != null) {
                                            rp.setSelectedCategory(c: value, context: context);
                                          }
                                        },
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          AppStrings.category.toUpperCase(),
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
                                rp.selectedCategory != null ? rp.selectedCategory["name"] : "Select Category Type",
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.c353d4a.withOpacity(0.7),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 1,
                      color: AppColors.cB6B6B6,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                              child: YearSelector(
                                yearList: rp.yearList,
                              ),
                            );
                          },
                        ).then(
                          (value) {
                            if (value != null) {
                              rp.setSelectedYear(y: value, context: context);
                            }
                          },
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3.6,
                              color: AppColors.c95795d.withOpacity(0.1),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          height: MediaQuery.of(context).size.height / 3,
                                          child: YearSelector(
                                            yearList: rp.yearList,
                                          ),
                                        );
                                      },
                                    ).then(
                                      (value) {
                                        if (value != null) {
                                          rp.setSelectedYear(y: value, context: context);
                                        }
                                      },
                                    );
                                  },
                                  onTapDown: (TapDownDetails details) {},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          AppStrings.year.toUpperCase(),
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
                                (rp.selectedYear?.toString().isNotEmpty == true)
                                    ? rp.selectedYear.toString()
                                    : "Select Year",
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.c353d4a.withOpacity(0.7),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 1,
                      color: AppColors.cB6B6B6,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              rp.reports.isNotEmpty
                  ? Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: List.generate(
                            rp.reports.length,
                            (index) {
                              var report = rp.reports[index];
                              return GestureDetector(
                                onTap: () {
                                  final arg = ReportDetailArg(
                                    title: report["title"] ?? "",
                                    pdfUrl: report["url"] ?? "",
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
                                                report["title"],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(color: AppColors.c000000),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            AppStrings.view,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(color: AppColors.cB6B6B6),
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
                            },
                          ),
                        ),
                      ),
                    )
                  : const Expanded(
                      child: Center(
                        child: Text(
                          AppStrings.noReports,
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (rp.pageNumber > 1)
                          ? GestureDetector(
                              onTap: () {
                                if (rp.pageNumber > 0) {
                                  rp.previousPage(context: context);
                                }
                              },
                              child: Text(
                                AppStrings.back,
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.c0A64A4,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.c0A64A4),
                              ))
                          : Container(),
                      (rp.pageNumber < rp.totalPages)
                          ? GestureDetector(
                              onTap: () {
                                rp.nextPage(context: context);
                              },
                              child: Text(
                                AppStrings.next,
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.c0A64A4,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.c0A64A4),
                              ))
                          : Container()
                    ],
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
