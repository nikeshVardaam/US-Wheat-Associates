import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/provider/dashboard_provider.dart';
import 'package:uswheat/dashboard_page/quality/quality.dart';
import 'package:uswheat/provider/estimates/wheat_page_provider.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_box_decoration.dart';

class WheatPages extends StatefulWidget {
  final String title;
  final Color appBarColor;
  final String imageAsset;
  final String selectedClass;

  const WheatPages({super.key, required this.title, required this.appBarColor, required this.imageAsset, required this.selectedClass});

  @override
  State<WheatPages> createState() => _WheatPagesState();
}

class _WheatPagesState extends State<WheatPages> {
  @override
  void initState() {
    super.initState();
    final wpp = Provider.of<WheatPageProvider>(context, listen: false);
    wpp.updateFinalDate();
    wpp.getQualityReport(context: context, wheatClass: widget.selectedClass);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WheatPageProvider>(
      builder: (context, wpp, child) {
        return Column(
          children: [
            Container(
              color: widget.appBarColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Consumer<DashboardProvider>(
                            builder: (context, dp, child) {
                              return GestureDetector(
                                onTap: () {
                                  dp.setChangeActivity(
                                    activity: const Quality(),
                                    pageName: AppStrings.quality,
                                  );
                                },
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 14,
                                  color: AppColors.cFFFFFF,
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.cFFFFFF, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: wpp.isInWatchlist(widget.selectedClass, wpp.prdate)
                          ? null // disable tap if already added
                          : () {
                              wpp.addWatchList(context: context, wheatClass: widget.selectedClass);
                            },
                      child: Row(
                        children: [
                          Text(
                            AppStrings.addToWatchlist,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.cFFFFFF,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(width: 8),
                          SvgPicture.asset(
                            wpp.isInWatchlist(widget.selectedClass, wpp.prdate) ? AppAssets.fillStar : AppAssets.star,
                            color: AppColors.cFFFFFF,
                            width: 18,
                            height: 18,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      wpp.showYearPicker(context, wheatClass: widget.selectedClass);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: AppBoxDecoration.blue(),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.c464646,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            wpp.finalDate != null ? DateFormat('dd-MMM-yyyy').format(DateTime.parse(wpp.finalDate!)) : 'Select Date',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.c464646,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Image.asset(widget.imageAsset),
            ),
            Container(
              color: AppColors.c95795d.withOpacity(0.1),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(width: 0.5, color: AppColors.cB6B6B6),
                  outside: BorderSide(width: 0.5, color: AppColors.cB6B6B6),
                ),
                columnWidths: const {
                  0: FixedColumnWidth(140),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FlexColumnWidth(),
                },
                children: [
                  // Header row
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(AppStrings.wheatData,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c353d4a.withOpacity(0.7), fontWeight: FontWeight.w900)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(AppStrings.currentAverage,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(AppStrings.finalAverage,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          AppStrings.yearAverage,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.c353d4a.withOpacity(0.7)),
                        ),
                      )
                    ],
                  ),

                  // Manually written data rows
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(AppStrings.lbBu, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.c95795d)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(wpp.current?.testWtlbbu ?? "--",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            wpp.lastYear?.testWtlbbu ?? "--",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7)),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(wpp.fiveYearsAgo?.testWtlbbu ?? "--",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(AppStrings.kgHl, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.c95795d)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(wpp.current?.testWtkghl ?? "--",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(wpp.lastYear?.testWtkghl ?? "--",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(wpp.fiveYearsAgo?.testWtkghl ?? "--",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(AppStrings.moisture, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.c95795d)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(wpp.current?.moisture ?? "--",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(wpp.lastYear?.moisture ?? "--",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(wpp.fiveYearsAgo?.moisture ?? "--",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(AppStrings.prot12, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.c95795d)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(wpp.current?.prot12Mb ?? "--",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(wpp.lastYear?.moisture ?? "--",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(wpp.fiveYearsAgo?.moisture ?? "--",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(AppStrings.dryBasisProt, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.c95795d)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(wpp.current?.dryBasisProt ?? "--",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(wpp.lastYear?.dryBasisProt ?? "--",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(wpp.fiveYearsAgo?.dryBasisProt ?? "--",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
