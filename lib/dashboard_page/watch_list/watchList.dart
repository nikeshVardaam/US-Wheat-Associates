import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:uswheat/modal/graph_modal.dart';
import 'package:uswheat/utils/app_assets.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';
import '../../provider/watchList_provider.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({super.key});

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await Provider.of<WatchlistProvider>(context, listen: false).getPrefData();
        Provider.of<WatchlistProvider>(context, listen: false).getWatchList(context: context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext perentContext) {
    return Consumer<WatchlistProvider>(
      builder: (context, wp, child) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: (wp.qList.isNotEmpty || wp.pList.isNotEmpty)
                ? Column(
                    children: [
                      Column(
                          children: List.generate(
                        wp.qList.length,
                        (index) {
                          var data = wp.qList[index];
                          Color c = Color(int.parse(data.filterData?.color ?? "", radix: 16));
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  wp.navigateToQualityReport(
                                    context: context,
                                    dateTime: data.filterData?.date ?? "",
                                    wheatClass: data.filterData?.classs ?? "",
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.cAB865A.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 40.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: c,
                                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      AppStrings.wheatAssociates,
                                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                            color: AppColors.cFFFFFF,
                                                          ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                      child: Container(
                                                        height: 12,
                                                        width: 2,
                                                        color: AppColors.cFFFFFF,
                                                      ),
                                                    ),
                                                    Text(
                                                      data.filterData?.region ?? "",
                                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                            color: AppColors.cFFFFFF,
                                                          ),
                                                    ),
                                                    Text(
                                                      data.filterData?.classs ?? "",
                                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                            color: AppColors.cFFFFFF,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    wp.deleteWatchList(
                                                      context: context,
                                                      id: data.id ?? "",
                                                      date: data.filterData?.date ?? "",
                                                      cls: data.filterData?.classs ?? "",
                                                      type: "quality",
                                                    );
                                                  },
                                                  child: SvgPicture.asset(
                                                    AppAssets.fillStar,
                                                    height: 30,
                                                    color: AppColors.cFFFFFF,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                          child: Column(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${AppStrings.currentAverage} :",
                                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: c),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        // Moisture
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppStrings.testWtbbu,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                    color: AppColors.c737373,
                                                                  ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              data.current?.testWtlbbu != null
                                                                  ? double.parse(data.current!.testWtlbbu.toString())
                                                                      .toStringAsFixed(2)
                                                                  : "--",
                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: c,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(width: 16),
                                                        // Prot12%mb
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppStrings.testWtkghl,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                    color: AppColors.c737373,
                                                                  ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              data.current?.testWtkghl != null
                                                                  ? double.parse(data.current!.testWtkghl.toString())
                                                                      .toStringAsFixed(2)
                                                                  : "--",
                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: c,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(width: 16),
                                                        // DryBasisProt%
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppStrings.moist,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                    color: AppColors.c737373,
                                                                  ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              data.current?.moisture != null
                                                                  ? double.parse(data.current!.moisture.toString())
                                                                      .toStringAsFixed(2)
                                                                  : "--",
                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: c,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(width: 16),
                                                        // DryBasisProt%
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppStrings.prot12,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                    color: AppColors.c737373,
                                                                  ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              data.current?.prot12Mb != null
                                                                  ? double.parse(data.current!.prot12Mb.toString())
                                                                      .toStringAsFixed(2)
                                                                  : "--",
                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: c,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(width: 16),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppStrings.proDb,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                    color: AppColors.c737373,
                                                                  ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              data.current?.dryBasisProt != null
                                                                  ? double.parse(data.current!.dryBasisProt.toString())
                                                                      .toStringAsFixed(2)
                                                                  : "--",
                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: c,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${AppStrings.fiveYearAverage} :",
                                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: c),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        // Moisture
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppStrings.testWtbbu,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                    color: AppColors.c737373,
                                                                  ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              data.yearAverage?.testWtlbbu != null
                                                                  ? double.parse(
                                                                          data.yearAverage!.testWtlbbu.toString())
                                                                      .toStringAsFixed(2)
                                                                  : "--",
                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: c,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(width: 16),
                                                        // Prot12%mb
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppStrings.testWtkghl,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                    color: AppColors.c737373,
                                                                  ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              data.yearAverage?.testWtkghl != null
                                                                  ? double.parse(
                                                                          data.yearAverage!.testWtkghl.toString())
                                                                      .toStringAsFixed(2)
                                                                  : "--",
                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: c,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(width: 16),
                                                        // DryBasisProt%
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppStrings.moist,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                    color: AppColors.c737373,
                                                                  ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              data.yearAverage?.moisture != null
                                                                  ? double.parse(data.yearAverage!.moisture.toString())
                                                                      .toStringAsFixed(2)
                                                                  : "--",
                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: c,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(width: 16),
                                                        // DryBasisProt%
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppStrings.prot12,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                    color: AppColors.c737373,
                                                                  ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              data.yearAverage?.prot12Mb != null
                                                                  ? double.parse(data.yearAverage!.prot12Mb.toString())
                                                                      .toStringAsFixed(2)
                                                                  : "--",
                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: c,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(width: 16),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppStrings.proDb,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                    color: AppColors.c737373,
                                                                  ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              data.yearAverage?.dryBasisProt != null
                                                                  ? double.parse(
                                                                          data.yearAverage!.dryBasisProt.toString())
                                                                      .toStringAsFixed(2)
                                                                  : "--",
                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: c,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${AppStrings.finalAverage} :",
                                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: c),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        // Moisture
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppStrings.testWtbbu,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                    color: AppColors.c737373,
                                                                  ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              data.fiveYearAverage?.testWtlbbu != null
                                                                  ? double.parse(
                                                                          data.fiveYearAverage!.testWtlbbu.toString())
                                                                      .toStringAsFixed(2)
                                                                  : "--",
                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: c,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(width: 16),
                                                        // Prot12%mb
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppStrings.testWtkghl,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                    color: AppColors.c737373,
                                                                  ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              data.fiveYearAverage?.testWtkghl != null
                                                                  ? double.parse(
                                                                          data.fiveYearAverage!.testWtkghl.toString())
                                                                      .toStringAsFixed(2)
                                                                  : "--",
                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: c,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(width: 16),
                                                        // DryBasisProt%
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppStrings.moist,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                    color: AppColors.c737373,
                                                                  ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              data.fiveYearAverage?.moisture != null
                                                                  ? double.parse(
                                                                          data.fiveYearAverage!.moisture.toString())
                                                                      .toStringAsFixed(2)
                                                                  : "--",
                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: c,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(width: 16),
                                                        // DryBasisProt%
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppStrings.prot12,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                    color: AppColors.c737373,
                                                                  ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              data.fiveYearAverage?.prot12Mb != null
                                                                  ? double.parse(
                                                                          data.fiveYearAverage!.prot12Mb.toString())
                                                                      .toStringAsFixed(2)
                                                                  : "--",
                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: c,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(width: 16),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppStrings.proDb,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                    color: AppColors.c737373,
                                                                  ),
                                                            ),
                                                            const SizedBox(height: 4),
                                                            Text(
                                                              data.fiveYearAverage?.dryBasisProt != null
                                                                  ? double.parse(
                                                                          data.fiveYearAverage!.dryBasisProt.toString())
                                                                      .toStringAsFixed(2)
                                                                  : "--",
                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                    color: c,
                                                                  ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      )),
                      Column(
                          children: List.generate(
                        wp.pList.length,
                        (index) {
                          var data = wp.pList[index];
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  wp.navigateToPriceReport(
                                      context: context,
                                      region: data.filterData?.region ?? "",
                                      classs: data.filterData?.classs ?? "",
                                      date: data.filterData?.date ?? "");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.cAB865A.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.cab865a,
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    AppStrings.wheatAssociates,
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                          color: AppColors.cFFFFFF,
                                                        ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                    child: Container(
                                                      height: 12,
                                                      width: 2,
                                                      color: AppColors.cFFFFFF,
                                                    ),
                                                  ),
                                                  Text(
                                                    data.filterData?.region ?? "",
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                          color: AppColors.cFFFFFF,
                                                        ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                    child: Container(
                                                      height: 12,
                                                      width: 2,
                                                      color: AppColors.cFFFFFF,
                                                    ),
                                                  ),
                                                  Text(
                                                    data.filterData?.classs ?? "",
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                          color: AppColors.cFFFFFF,
                                                        ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                    child: Container(
                                                      height: 12,
                                                      width: 2,
                                                      color: AppColors.cFFFFFF,
                                                    ),
                                                  ),
                                                  Text(
                                                    data.filterData?.date ?? "",
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                          color: AppColors.cFFFFFF,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                wp.deleteWatchList(
                                                  context: context,
                                                  id: data.id ?? "",
                                                  date: data.filterData?.date ?? "",
                                                  cls: data.filterData?.classs ?? "",
                                                  type: "price",
                                                );
                                              },
                                              child: SvgPicture.asset(
                                                AppAssets.fillStar,
                                                height: 30,
                                                color: AppColors.cFFFFFF,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: MediaQuery.of(context).size.width / 3,
                                                child: Container(
                                                  margin: EdgeInsets.zero,
                                                  padding: EdgeInsets.zero,
                                                  decoration: const BoxDecoration(),
                                                  child: FutureBuilder(
                                                    future: wp.fetchChartDataForItem(context, null),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                                        return const Center(
                                                          child: Padding(
                                                            padding: EdgeInsets.all(8.0),
                                                            child: CupertinoActivityIndicator(
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        );
                                                      }

                                                      return data.graphData?.isEmpty ?? true
                                                          ? Center(
                                                              child: Text(
                                                                AppStrings.noDataFound,
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .bodySmall
                                                                    ?.copyWith(color: AppColors.c464646),
                                                              ),
                                                            )
                                                          : Padding(
                                                              padding: const EdgeInsets.only(bottom: 6, left: 16),
                                                              child: SfCartesianChart(
                                                                margin: EdgeInsets.zero,
                                                                plotAreaBorderWidth: 0,
                                                                backgroundColor: AppColors.cAB865A.withOpacity(0.0),
                                                                plotAreaBackgroundColor:
                                                                    AppColors.cAB865A.withOpacity(0.0),
                                                                primaryXAxis: DateTimeAxis(
                                                                  dateFormat: DateFormat('MM/dd'),
                                                                  intervalType: DateTimeIntervalType.hours,
                                                                  majorGridLines: const MajorGridLines(width: 0),
                                                                ),
                                                                primaryYAxis: const NumericAxis(
                                                                  isVisible: false,
                                                                  majorGridLines: MajorGridLines(width: 0),
                                                                  axisLine: AxisLine(width: 0),
                                                                  rangePadding: ChartRangePadding.round,
                                                                ),
                                                                series: <CartesianSeries>[
                                                                  LineSeries<GraphDataModal, DateTime>(
                                                                    dataSource: data.graphData,
                                                                    xValueMapper: (GraphDataModal data, _) =>
                                                                        DateTime.parse(data.pRDATE.toString()),
                                                                    yValueMapper: (GraphDataModal data, _) =>
                                                                        data.cASHMT,
                                                                    color: AppColors.c464646,
                                                                    width: 1,
                                                                    name: 'CASHMT',
                                                                    markerSettings:
                                                                        const MarkerSettings(isVisible: false),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          );
                        },
                      )),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Center(
                      child: Text(
                        AppStrings.noWatchlistAdded,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.caebbc8,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
