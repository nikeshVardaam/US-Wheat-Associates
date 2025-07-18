import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart'
    show
        SfCartesianChart,
        CategoryAxis,
        ChartSeries,
        ChartTitle,
        Legend,
        TooltipBehavior,
        DataLabelSettings,
        LineSeries,
        CartesianSeries,
        NumericAxis,
        MajorGridLines,
        AxisLine,
        TooltipPosition,
        TickPosition,
        MajorTickLines,
        CartesianChartAnnotation,
        CoordinateUnit,
        AnnotationRegion,
        ChartAlignment;
import 'package:uswheat/provider/price_provider.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';

import '../modal/sales_modal.dart';

class Prices extends StatefulWidget {
  const Prices({super.key});

  @override
  State<Prices> createState() => _PricesState();
}

class _PricesState extends State<Prices> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<PricesProvider>(context, listen: false).syncData(context: context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PricesProvider>(
      builder: (context, pp, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.c95795d,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            AppStrings.price,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          AppStrings.favoritePrice,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.cFFFFFF),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.star_border_outlined,
                          color: AppColors.cFFFFFF,
                        )
                      ],
                    ),
                  ],
                ),
              ),
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
                        pp.showFilterDropdown(
                          context: context,
                          details: details,
                          onSelect: (selectedRegion) {
                            print("You selected: $selectedRegion");
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.region,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.c95795d,
                                ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.c95795d,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    pp.selectedRegion ?? "--",
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
                        pp.showClassesDropdown(
                          context: context,
                          details: details,
                          onSelect: (selectedClasses) {
                            print("You selected: $selectedClasses");
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.classs,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.c95795d,
                                ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.c95795d,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    pp.selectedClasses ?? "--",
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
                        pp.showYearsDropdown(
                          context: context,
                          details: details,
                          onSelect: (selectedYears) {
                            print("You selected: $selectedYears");
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.date,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.c95795d,
                                ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.c95795d,
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
                          "01-Jan-${pp.selectedYears ?? ""}",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.c353d4a.withOpacity(0.7),
                              ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "to",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.c353d4a.withOpacity(0.7),
                              ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "31-Dec-${pp.selectedYears ?? ""}",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.c353d4a.withOpacity(0.7),
                              ),
                        ),
                      ],
                    )),
              ],
            ),
            Expanded(
              child: pp.chartData.isEmpty
                  ? Center(
                      child: Text(
                        'No data found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.c656e79, width: 0.5), bottom: BorderSide(color: AppColors.c656e79, width: 0.5))),
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        margin: const EdgeInsets.all(0),
                        backgroundColor: Colors.white,
                        annotations: <CartesianChartAnnotation>[
                          CartesianChartAnnotation(
                            widget: Container(
                              decoration: BoxDecoration(
                                color: AppColors.c3d3934,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                                child: Text(
                                  'APRIL - 2024 / APRIL - 2025',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.cFFFFFF,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            coordinateUnit: CoordinateUnit.logicalPixel,
                            region: AnnotationRegion.plotArea,
                            x: MediaQuery.of(context).size.width / 4,
                            y: MediaQuery.of(context).size.width / 2,
                          ),
                        ],
                        primaryXAxis: CategoryAxis(
                          isVisible: true,
                          majorGridLines: MajorGridLines(
                            width: 0.1,
                            color: AppColors.cab865a,
                          ),
                          axisLine: const AxisLine(width: 0),
                          labelStyle: const TextStyle(fontSize: 0),
                          tickPosition: TickPosition.inside,
                          majorTickLines: const MajorTickLines(width: 0),
                        ),
                        primaryYAxis: const NumericAxis(
                          isVisible: false,
                          majorGridLines: MajorGridLines(width: 0),
                          axisLine: AxisLine(width: 0),
                        ),
                        series: <CartesianSeries>[
                          LineSeries<SalesData, String>(
                            dataSource: pp.chartData,
                            xValueMapper: (SalesData data, _) => data.month,
                            yValueMapper: (SalesData data, _) => data.sales,
                            color: AppColors.caebbc8,
                            width: 1,
                            dataLabelSettings: const DataLabelSettings(isVisible: false),
                          ),
                        ],
                      )),
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
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.c95795d,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "FOB \$/BU ",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.c95795d,
                          ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      pp.filteredPrices.isNotEmpty ? pp.filteredPrices[0].cashmt.toString() : "- -",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.c95795d,
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
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.c95795d,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "\$/BU -0.04",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.cd4582d,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 16,
                        color: AppColors.c666666,
                        width: 0.5,
                      ),
                    ),
                    Text(
                      "\$/MT -2",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.cd4582d,
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
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.c95795d,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "\$/MT",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.c353d4a.withOpacity(0.7),
                          ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      pp.pricesList.isNotEmpty ? pp.pricesList[0].cashmt.toString() : "--",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
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
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.c95795d,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      pp.pricesList.isNotEmpty ? pp.pricesList[0].date ?? "" : "--",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
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
                                fontWeight: FontWeight.w600,
                                color: AppColors.c95795d,
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
                            children: List.generate(
                          pp.filteredPrices.length ?? 0,
                          (index) {
                            var data = pp.filteredPrices[index];

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      data.cashmt?.toString() ?? "--",
                                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.c353d4a.withOpacity(0.7),
                                          ),
                                    ),
                                  ),
                                  Text(
                                    " ,",
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.c353d4a.withOpacity(0.7),
                                        ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
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
