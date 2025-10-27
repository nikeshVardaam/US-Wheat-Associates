import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:uswheat/dashboard_page/price/class_selector.dart';
import 'package:uswheat/dashboard_page/price/region_selector.dart';
import 'package:uswheat/provider/price_provider.dart';
import 'package:uswheat/utils/app_box_decoration.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/common_date_picker.dart';
import 'package:uswheat/utils/miscellaneous.dart';
import '../../modal/graph_modal.dart';
import '../../utils/app_widgets.dart';

class Prices extends StatefulWidget {
  final String? region;
  final String? cls;
  final String? year;

  const Prices({super.key, required this.region, required this.cls, required this.year});

  @override
  State<Prices> createState() => _PricesState();
}

class _PricesState extends State<Prices> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<PricesProvider>(context, listen: false).getPrefData();
      if ((widget.region?.isNotEmpty ?? false) && (widget.cls?.isNotEmpty ?? false) && (widget.year?.isNotEmpty ?? false)) {
        Provider.of<PricesProvider>(context, listen: false).initCallFromWatchList(
          context: context,
          region: widget.region,
          cls: widget.cls,
          year: widget.year,
        );
      } else {
        Provider.of<PricesProvider>(context, listen: false).initCall(context: context);
      }
    });
  }

  @override
  Widget build(BuildContext perentContext) {
    return Consumer<PricesProvider>(
      builder: (context, pp, child) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.cab865a,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppStrings.pricess,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.cFFFFFF, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      pp.alreadyHasInWatchlist
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                if (pp.graphDataList.isEmpty) {
                                  AppWidgets.appSnackBar(context: context, text: AppStrings.dataNotAvailable, color: AppColors.cb01c32);
                                } else {
                                  pp.addToWatchlist(context: context);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(
                                  size: 30,
                                  Icons.star_border_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return RegionSelector(
                            regionList: pp.regionsList,
                          );
                        },
                      ).then(
                        (value) {
                          if (value != null) {
                            pp.setSelectedRegion(rg: value, context: context);
                          }
                        },
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          // selecting the region
                          Container(
                            width: MediaQuery.of(context).size.width / 3.6,
                            color: AppColors.c95795d.withOpacity(0.1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              child: GestureDetector(
                                onTap: () async {
                                  await showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return RegionSelector(
                                        regionList: pp.regionsList,
                                      );
                                    },
                                  ).then(
                                    (value) {
                                      if (value != null) {
                                        pp.setSelectedRegion(rg: value, context: context);
                                      }
                                    },
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppStrings.region.toUpperCase(),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w700,
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
                              pp.selectedRegion?.region ?? "Select Region",
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
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
                    onTap: () async {
                      await showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return ClassSelector(classList: pp.selectedRegion?.classes ?? []);
                        },
                      ).then((value) {
                        if (value != null) {
                          pp.setSelectedClass(cls: value, context: context);
                        }
                      });
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
                                onTap: () async {
                                  await showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return ClassSelector(classList: pp.selectedRegion?.classes ?? []);
                                    },
                                  ).then((value) {
                                    if (value != null) {
                                      pp.setSelectedClass(cls: value, context: context);
                                    }
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppStrings.classs.toUpperCase(),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w700,
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
                              pp.selectedClass ?? "Select Class",
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
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
                            child: DatePickerSheet(),
                          );
                        },
                      ).then(
                        (value) {
                          if (value != null) {
                            pp.setSelectedPrDate(date: Miscellaneous.ymd(value.toString()), context: context);
                          }
                        },
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
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
                                    pp.setSelectedPrDate(date: Miscellaneous.ymd(value.toString()), context: context);
                                  }
                                },
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3.6,
                              color: AppColors.c95795d.withOpacity(0.1),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppStrings.date.toUpperCase(),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w700,
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
                            child: Row(
                              children: [
                                Text(
                                  pp.getLastOneYearRange(pp.pRDate ?? ""),
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.c353d4a.withOpacity(0.7),
                                      ),
                                ),
                              ],
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
                  pp.graphDataList.isNotEmpty
                      ? SfCartesianChart(
                          tooltipBehavior: TooltipBehavior(enable: true),
                          zoomPanBehavior: pp.zoomPanBehavior,
                          enableAxisAnimation: true,
                          primaryXAxis: DateTimeAxis(
                            dateFormat: DateFormat('MMM-dd'),
                            intervalType: DateTimeIntervalType.hours,
                            majorGridLines: const MajorGridLines(width: 0),
                          ),
                          primaryYAxis: const NumericAxis(
                            majorGridLines: MajorGridLines(dashArray: [5, 5]),
                          ),
                          series: [
                            LineSeries<GraphDataModal, DateTime>(
                              dataSource: pp.graphDataList,
                              xValueMapper: (GraphDataModal data, _) => DateTime.parse(data.pRDATE.toString()),
                              yValueMapper: (GraphDataModal data, _) => data.cASHMT,
                              color: AppColors.c464646,
                              width: 1,
                              name: 'CASHMT',
                              markerSettings: const MarkerSettings(isVisible: false),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(
                              AppStrings.noDataAvailable,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                  Divider(
                    thickness: 0.5,
                    height: 1,
                    color: AppColors.cB6B6B6,
                  ),
                  Container(
                    color: AppColors.c95795d.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  AppStrings.nearby,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.cab865a,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            pp.allPriceDataModal?.nearby?.cASHBU.toString().substring(0, 3) ?? "--",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.c353d4a.withOpacity(0.7),
                                ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            "FOB \$/BU ",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.c353d4a.withOpacity(0.7),
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              height: 16,
                              color: AppColors.c353d4a.withOpacity(0.7),
                              width: 2,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "\$/MT -",
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.c353d4a.withOpacity(0.7),
                                    ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                pp.allPriceDataModal?.nearby?.cASHMT.toString().substring(0, 6) ?? "",
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.c353d4a.withOpacity(0.7),
                                    ),
                              ),
                            ],
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
                  Container(
                    color: AppColors.c95795d.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  AppStrings.weekChange,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.cab865a,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                pp.allPriceDataModal?.weekly?.cASHBU.toString().substring(0, 3) ?? "--",
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.cd63a3a,
                                    ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                "FOB \$/BU ",
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.cd63a3a,
                                    ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              height: 16,
                              color: AppColors.c353d4a.withOpacity(0.7),
                              width: 2,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "\$/MT -",
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.cd63a3a,
                                    ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                pp.allPriceDataModal?.weekly?.cASHMT?.toStringAsFixed(2) ?? "--",
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.cd63a3a,
                                    ),
                              ),
                            ],
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
                  Container(
                    color: AppColors.c95795d.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  AppStrings.oneYearAgo,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.cab865a,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "\$/MT",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.c353d4a.withOpacity(0.7),
                                ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            pp.allPriceDataModal?.yearly?.cASHMT?.toStringAsFixed(2) ?? "--",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.c353d4a.withOpacity(0.7),
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    height: 1,
                    color: AppColors.cB6B6B6,
                  ),
                  Container(
                    color: AppColors.c95795d.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  AppStrings.lastPrDate,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.cab865a,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            Miscellaneous.formatPrDate(pp.allPriceDataModal?.prdate ?? ""),
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.c353d4a.withOpacity(0.7),
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
                  Container(
                    color: AppColors.c95795d.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                AppStrings.fwdPrice,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.cab865a,
                                    ),
                              ),
                            ],
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
              )
            ],
          ),
        );
      },
    );
  }
}
