import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:uswheat/provider/price_provider.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/miscellaneous.dart';
import '../modal/sales_modal.dart';
import '../utils/app_assets.dart';

class Prices extends StatefulWidget {
  final String? region;
  final String? classs;
  final String? year;

  const Prices({super.key, required this.region, required this.classs, required this.year});

  @override
  State<Prices> createState() => _PricesState();
}

class _PricesState extends State<Prices> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PricesProvider>(context, listen: false).fetchData(
        context: context,
        classs: widget.classs ?? "",
        region: widget.region ?? "",
        year: widget.year ?? "",
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      GestureDetector(
                        child: Row(
                          children: [
                            Text(
                              AppStrings.addToWatchlist,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.cFFFFFF, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: (pp.selectedRegion != null && pp.selectedClasses != null && pp.selectedYears != null)
                                  ? () async {
                                      await pp.storeWatchList(context: context, loader: true);
                                    }
                                  : null,
                              child: SvgPicture.asset(
                                pp.isInWatchlist(
                                  pp.selectedRegion ?? '',
                                  pp.selectedClasses ?? '',
                                  pp.selectedYears ?? '',
                                )
                                    ? AppAssets.fillStar
                                    : AppAssets.star,
                                color: AppColors.cFFFFFF,
                                width: 18,
                                height: 18,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Column(
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
                              pp.showFilterDropdown(
                                context: context,
                                details: details,
                                onSelect: (selectedRegion) {},
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.region,
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
                          pp.selectedRegion ?? "Select Region",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w900,
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
                              pp.showClassesDropdown(
                                context: context,
                                details: details,
                                onSelect: (selectedClasses) {},
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.classs,
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
                          pp.selectedClasses ?? "Select Classes",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w900,
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
                      GestureDetector(
                        onTap: () {
                          pp.showYearPicker(
                            context,
                            wheatClass: '',
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
                                  AppStrings.date,
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
                              pp.selectedPrevYearDate,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.c353d4a.withOpacity(0.7),
                                  ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "/",
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.c353d4a.withOpacity(0.7),
                                  ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              pp.selectedFullDate,
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
                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width / 2,
                      child: pp.chartData.isEmpty
                          ? const Center(
                              child: Text(
                                'No data found',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            )
                          : Container(
                              height: 1,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 0.4,
                                    color: AppColors.cB6B6B6,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                                child: SfCartesianChart(
                                  borderColor: Colors.white,
                                  tooltipBehavior: TooltipBehavior(
                                    enable: true,
                                    activationMode: ActivationMode.singleTap,
                                    tooltipPosition: TooltipPosition.pointer,
                                  ),
                                  zoomPanBehavior: ZoomPanBehavior(
                                    enablePanning: true,
                                    zoomMode: ZoomMode.xy,
                                  ),
                                  plotAreaBorderWidth: 0,
                                  margin: const EdgeInsets.all(0),
                                  backgroundColor: Colors.white,
                                  annotations: <CartesianChartAnnotation>[
                                    CartesianChartAnnotation(
                                      widget: Container(
                                        width: MediaQuery.of(context).size.width / 2.4,
                                        decoration: BoxDecoration(
                                          color: AppColors.c3d3934,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                pp.selectedPrevYearDate,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.cFFFFFF,
                                                  fontFamily: 'proximanovaexcn',
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                child: Text(
                                                  "/",
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: AppColors.cFFFFFF,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: '',
                                                  ),
                                                ),
                                              ),
                                              Text(pp.selectedFullDate,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: AppColors.cFFFFFF,
                                                    fontFamily: 'proximanovaexcn',
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      coordinateUnit: CoordinateUnit.logicalPixel,
                                      region: AnnotationRegion.plotArea,
                                      x: MediaQuery.of(context).size.width / 3,
                                      y: MediaQuery.of(context).size.width / 2.5,
                                    ),
                                  ],
                                  primaryXAxis: CategoryAxis(
                                    isVisible: true,
                                    majorGridLines: MajorGridLines(
                                      width: 0.1,
                                      color: AppColors.cab865a.withOpacity(0.6),
                                    ),
                                    axisLine: const AxisLine(width: 0),
                                    //if i want months back then only set font size 10
                                    labelStyle: const TextStyle(fontSize: 0),
                                    tickPosition: TickPosition.inside,
                                    majorTickLines: const MajorTickLines(width: 0),
                                  ),
                                  primaryYAxis: const NumericAxis(
                                    interval: 10,

                                    isVisible: true,

                                    majorGridLines: MajorGridLines(width: 1),
                                    axisLine: AxisLine(width: 0.1),
                                    majorTickLines: MajorTickLines(width: 0),
                                    minorTickLines: MinorTickLines(width: 0),
                                    rangePadding: ChartRangePadding.round, // optional
                                  ),
                                  series: <CartesianSeries>[
                                    LineSeries<SalesData, String>(
                                      dataSource: pp.chartData,
                                      xValueMapper: (SalesData data, _) => data.month,
                                      yValueMapper: (SalesData data, _) => data.sales,
                                      color: AppColors.c000000,
                                      width: 0.5,
                                      dataLabelSettings: const DataLabelSettings(isVisible: false),
                                    ),
                                  ],
                                ),
                              ),
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
                          pp.allPriceDataModal?.nearby?.cASHBU != null && pp.allPriceDataModal?.nearby?.cASHMT != null
                              ? Row(
                                  children: [
                                    Text(
                                      pp.allPriceDataModal?.nearby?.cASHBU.toString().substring(0, 4) ?? "--",
                                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.c353d4a.withOpacity(0.7),
                                          ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    if (pp.allPriceDataModal?.nearby?.cASHBU != null)
                                      Text(
                                        "FOB \$/BU",
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
                                        if (pp.allPriceDataModal?.nearby?.cASHMT != null)
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
                                          pp.allPriceDataModal?.nearby?.cASHMT.toString().substring(0, 6) ?? "--",
                                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                fontWeight: FontWeight.w900,
                                                color: AppColors.c353d4a.withOpacity(0.7),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Text(
                                  "--",
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
                          pp.allPriceDataModal?.weekly?.cASHBU != null && pp.allPriceDataModal?.weekly?.cASHMT != null
                              ? Row(
                                  children: [
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
                                          "\$/MT",
                                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                fontWeight: FontWeight.w900,
                                                color: AppColors.cd63a3a,
                                              ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          pp.allPriceDataModal?.weekly?.cASHMT.toString().substring(0, 2) ?? "--",
                                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                fontWeight: FontWeight.w900,
                                                color: AppColors.cd63a3a,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Text(
                                  "--",
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
                          if (pp.allPriceDataModal?.yearly?.cASHMT != null)
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
                            pp.allPriceDataModal?.yearly?.cASHMT.toString().substring(0, 6) ?? "--",
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
                          if (pp.allPriceDataModal?.prdate != null)
                            Text(
                              Miscellaneous.formatPrDate(pp.allPriceDataModal?.prdate ?? "--"),
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
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  pp.allPriceDataModal?.forward?.isNotEmpty ?? false
                                      ? Row(
                                          children: List.generate(
                                            pp.allPriceDataModal?.forward?.length ?? 0,
                                            (index) {
                                              var data = pp.allPriceDataModal?.forward?[index];

                                              return Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${pp.fixedMonths[index]}:",
                                                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                            fontWeight: FontWeight.w900,
                                                            color: AppColors.c353d4a.withOpacity(0.7),
                                                          ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      data?.cASHMT.toString().substring(0, 6) ?? '--',
                                                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                            fontWeight: FontWeight.w900,
                                                            color: AppColors.c353d4a.withOpacity(0.7),
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                          child: Text(
                                            "--",
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
