import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/miscellaneous.dart';

import '../modal/sales_modal.dart';
import '../provider/watchList_provider.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({super.key});

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<WatchlistProvider>(context, listen: false).fetchData(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WatchlistProvider>(builder: (context, wp, child) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Column(
                    children: List.generate(
                  wp.watchlist.length,
                  (index) {
                    var data = wp.watchlist[index];
                    if (data.type == "price") {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.cAB865A.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
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
                                            Text(AppStrings.wheatAssociates, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.cFFFFFF)),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                              child: Container(
                                                height: 12,
                                                width: 2,
                                                color: AppColors.cFFFFFF,
                                              ),
                                            ),
                                            Text(data.filterdata.region ?? "", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.cFFFFFF)),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          wp.deleteWatchList(context: context, id: data.id ?? "");
                                        },
                                        child: Icon(Icons.star, color: AppColors.cFFFFFF, size: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: SizedBox(
                                        height: MediaQuery.of(context).size.width / 3,
                                        child: Container(
                                          margin: EdgeInsets.zero,
                                          padding: EdgeInsets.zero,
                                          decoration: const BoxDecoration(),
                                          child: FutureBuilder(
                                            future: wp.fetchChartDataForItem(context, data!),
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

                                              return data.chartData.isEmpty ?? true
                                                  ? Center(
                                                      child: Text(
                                                        AppStrings.noDataFound,
                                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c464646),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding: const EdgeInsets.only(bottom: 6, left: 8),
                                                      child: SfCartesianChart(
                                                        margin: EdgeInsets.zero,
                                                        plotAreaBorderWidth: 0,
                                                        backgroundColor: AppColors.cAB865A.withOpacity(0.0),
                                                        plotAreaBackgroundColor: AppColors.cAB865A.withOpacity(0.0),
                                                        primaryXAxis: CategoryAxis(
                                                          isVisible: true,
                                                          majorGridLines: MajorGridLines(
                                                            width: 0.1,
                                                            color: AppColors.cab865a.withOpacity(0.6),
                                                          ),
                                                          axisLine: const AxisLine(width: 0),
                                                          interval: 0.8,
                                                          labelStyle: Theme.of(context).textTheme.labelSmall,
                                                          tickPosition: TickPosition.outside,
                                                          labelPlacement: LabelPlacement.betweenTicks,
                                                          // ← important
                                                          edgeLabelPlacement: EdgeLabelPlacement.none,
                                                          // ← prevents clipping
                                                          majorTickLines: const MajorTickLines(width: 0),
                                                        ),
                                                        primaryYAxis: const NumericAxis(
                                                          isVisible: false,
                                                          majorGridLines: MajorGridLines(width: 0),
                                                          axisLine: AxisLine(width: 0),
                                                          rangePadding: ChartRangePadding.round,
                                                        ),
                                                        series: <CartesianSeries>[
                                                          LineSeries<SalesData, String>(
                                                            dataSource: data.chartData,
                                                            xValueMapper: (SalesData d, _) => d.month,
                                                            yValueMapper: (SalesData d, _) => d.sales,
                                                            color: AppColors.c000000,
                                                            width: 0.5,
                                                            dataLabelSettings: const DataLabelSettings(isVisible: false),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(data.filterdata.region ?? "",
                                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cab865a, fontWeight: FontWeight.w900)),
                                              ],
                                            ),
                                            Text(
                                              "(${data.filterdata.classs ?? ""})",
                                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                    color: AppColors.c656e79,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            // Row(
                                            //   children: [
                                            //     Icon(Icons.arrow_drop_up, color: AppColors.c2a8741),
                                            //     Text(
                                            //       wp.allPriceDataModal?.nearby?.cASHBU.toString().substring(0, 3) ?? "--",
                                            //       style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                            //         fontWeight: FontWeight.w600,
                                            //         color: AppColors.c2a8741,
                                            //       ),
                                            //     ),
                                            //     Padding(
                                            //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            //       child: Container(
                                            //         height: 12,
                                            //         width: 1,
                                            //         color: AppColors.c464646,
                                            //       ),
                                            //     ),
                                            //     Text(
                                            //       wp.allPriceDataModal?.yearly?.cASHMT.toString().substring(0, 6) ?? "--",
                                            //       style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                            //         fontWeight: FontWeight.w600,
                                            //         color: AppColors.c2a8741,
                                            //       ),
                                            //     ),
                                            //     Text(
                                            //       "/MT",
                                            //       style: TextStyle(color: AppColors.c2a8741, fontSize: 14),
                                            //     )
                                            //   ],
                                            // ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppColors.c45413b,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                Miscellaneous.formatPrDate(data.filterdata.date ?? " "),
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      color: AppColors.cFFFFFF,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                )),
                Column(
                  children: List.generate(
                    wp.watchlist.length,
                    (index) {
                      var data = wp.watchlist[index];
                      if (data.type == "quality") {
                        // final wheat = data.; // local reference

                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.cAB865A.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.c2a8741,
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
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.cFFFFFF),
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
                                                data.filterdata.region ?? "",
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.cFFFFFF),
                                              ),
                                              Text(
                                                data.filterdata.classs ?? "",
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.cFFFFFF),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            wp.deleteWatchList(context: context, id: data.id ?? "");
                                          },
                                          child: Icon(Icons.star, color: AppColors.cFFFFFF, size: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Text(
                                          AppStrings.data,
                                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c2a8741, fontWeight: FontWeight.w900),
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
                                                  Text(AppStrings.testWtbbu, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c464646)),
                                                  const SizedBox(height: 4),
                                                  Text(data.wheatData?.testWtlbbu ?? "--",
                                                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c2a8741, fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                              const SizedBox(width: 16),
                                              // Prot12%mb
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(AppStrings.testWtkghl, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c464646)),
                                                  const SizedBox(height: 4),
                                                  Text(data.wheatData?.testWtkghl ?? "--",
                                                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c2a8741, fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                              const SizedBox(width: 16),
                                              // DryBasisProt%
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(AppStrings.moisture, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c464646)),
                                                  const SizedBox(height: 4),
                                                  Text(data.wheatData?.moisture ?? "--",
                                                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c2a8741, fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                              const SizedBox(width: 16),
                                              // DryBasisProt%
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(AppStrings.prot12, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c464646)),
                                                  const SizedBox(height: 4),
                                                  Text(data.wheatData?.prot12Mb ?? "--",
                                                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c2a8741, fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                              const SizedBox(width: 16),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(AppStrings.dryBasisProt, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c464646)),
                                                  const SizedBox(height: 4),
                                                  Text(data.wheatData?.dryBasisProt ?? "--",
                                                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c2a8741, fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                )
              ],
            )),
      );
    });
  }
}
