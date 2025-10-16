import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/provider/dashboard_provider.dart';
import 'package:uswheat/dashboard_page/quality/quality.dart';
import 'package:uswheat/provider/estimates/wheat_page_provider.dart';
import 'package:uswheat/provider/watchList_provider.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/app_widgets.dart';
import '../../../provider/price_provider.dart';
import '../../../utils/app_box_decoration.dart';
import '../../../utils/common_date_picker.dart';
import '../../../utils/miscellaneous.dart';

class WheatPages extends StatefulWidget {
  final String title;
  final Color appBarColor;
  final String imageAsset;
  final String selectedClass;
  final String date;
  final bool fromWatchList;

  const WheatPages(
      {super.key, required this.title, required this.fromWatchList, required this.appBarColor, required this.date, required this.imageAsset, required this.selectedClass});

  @override
  State<WheatPages> createState() => _WheatPagesState();
}

class _WheatPagesState extends State<WheatPages> {
  defaultData() async {
    final wp = context.read<WheatPageProvider>();
    ;
    await wp.getDefaultDate(context: context, wheatClass: widget.selectedClass).then(
      (value) {
        wp.updateFinalDate(prDate: wp.defaultDate.toString(), context: context, wClass: wp.defaultClass.toString());
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wp = context.read<WheatPageProvider>();
      wp.getPrefData();
      if (widget.selectedClass.isEmpty && widget.date.isEmpty) {
        defaultData();
      } else {
        // wp.(prDate: widget.date.toString(), context: context, wClass: widget.selectedClass);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext perentContext) {
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
                      onTap: () {
                        if (wpp.current == null && wpp.yearAverage == null && wpp.fiveYearAverage == null) {
                          AppWidgets.appSnackBar(context: context, text: AppStrings.dataNotAvailable, color: AppColors.cb01c32);
                        } else {
                          String hexCode = '${widget.appBarColor.alpha.toRadixString(16).padLeft(2, '0')}'
                              '${widget.appBarColor.red.toRadixString(16).padLeft(2, '0')}'
                              '${widget.appBarColor.green.toRadixString(16).padLeft(2, '0')}'
                              '${widget.appBarColor.blue.toRadixString(16).padLeft(2, '0')}';
                          wpp.addWatchList(context: context, wheatClass: widget.selectedClass, color: hexCode);
                        }
                      },
                      child: Row(
                        children: [
                          Container(
                            decoration: AppBoxDecoration.filledContainer(AppColors.cEFEEED),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Text(
                                AppStrings.addToWatchlist,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.c000000, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height / 3,
                                    child: DatePickerSheet(),
                                  );
                                },
                              ).then(
                                (value) {
                                  if (value != null) {
                                    wpp.updatedDate(date: Miscellaneous.ymd(value.toString()));
                                    wpp.updateFinalDate(prDate: wpp.selectedDate ?? "", context: context, wClass: widget.selectedClass);
                                  }
                                },
                              );
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
                                    wpp.selectedDate ?? "Select Date",
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
                    Image.asset(
                      widget.imageAsset,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    Container(
                      color: AppColors.c95795d.withOpacity(0.1),
                      child: SingleChildScrollView(
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
                                  child: wpp.selectedDate?.isNotEmpty ?? false
                                      ? Text("${AppStrings.finalAverage} ${Miscellaneous.yyyy(wpp.selectedDate ?? "")}",
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.c353d4a.withOpacity(0.7)))
                                      : Text("${AppStrings.finalAverage} ${"--"}",
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.c353d4a.withOpacity(0.7))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    AppStrings.fiveYearAverage,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.c353d4a.withOpacity(0.7)),
                                  ),
                                )
                              ],
                            ),
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
                                      wpp.yearAverage?.testWtlbbu ?? "--",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7)),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(wpp.fiveYearAverage?.testWtlbbu ?? "--",
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
                                  child: Text(wpp.yearAverage?.testWtkghl ?? "--",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(wpp.fiveYearAverage?.testWtkghl ?? "--",
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
                                  child: Text(wpp.yearAverage?.moisture ?? "--",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(wpp.fiveYearAverage?.moisture ?? "--",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(AppStrings.proteinMb, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.c95795d)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(wpp.current?.prot12Mb ?? "--",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(wpp.yearAverage?.moisture ?? "--",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(wpp.fiveYearAverage?.moisture ?? "--",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(AppStrings.proteinDryBasis,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.c95795d)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(wpp.current?.dryBasisProt != null ? double.parse(wpp.current!.dryBasisProt.toString()).toStringAsFixed(2) : "--",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(wpp.yearAverage?.dryBasisProt != null ? double.parse(wpp.yearAverage!.dryBasisProt.toString()).toStringAsFixed(2) : "--",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(wpp.fiveYearAverage?.dryBasisProt != null ? double.parse(wpp.fiveYearAverage!.dryBasisProt.toString()).toStringAsFixed(2) : "--",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                                ),
                              ],
                            ),
                            (widget.selectedClass == "HRS")
                                ? TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          'DHV',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.c95795d),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(wpp.current?.dhv ?? "--",
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(wpp.yearAverage?.dhv ?? "--",
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(wpp.fiveYearAverage?.dhv ?? "--",
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                                      ),
                                    ],
                                  )
                                : (widget.selectedClass == "Durum")
                                    ? TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Text(
                                              'HVAC',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.c95795d),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Text(wpp.current?.hvac ?? "--",
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Text(wpp.yearAverage?.hvac ?? "--",
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Text(wpp.fiveYearAverage?.hvac ?? "--",
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                                          ),
                                        ],
                                      )
                                    : const TableRow(children: [
                                        SizedBox(),
                                        SizedBox(),
                                        SizedBox(),
                                        SizedBox(),
                                      ])
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
