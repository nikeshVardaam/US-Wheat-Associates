import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:uswheat/utils/app_colors.dart';
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
          padding: const EdgeInsets.all(24),
          child: wp.watchlist?.isNotEmpty ?? true
              ? Column(
                  children: List.generate(
                  wp.watchlist?.length ?? 0,
                  (index) {
                    var data = wp.watchlist?[index];
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
                                  color: AppColors.c95795d,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "U.S. Wheat Associates | FOB \$/MT | April 28",
                                        style: TextStyle(color: AppColors.cFFFFFF, fontSize: 12),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        wp.deleteWatchList(context: context, id: data?.id ?? "");
                                      },
                                      child: Icon(Icons.star, color: AppColors.cFFFFFF, size: 18),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
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
                                            return data.chartData.isEmpty ?? true
                                                ? const Center(
                                                    child: Text(
                                                      'No data found',
                                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                                    ),
                                                  )
                                                : SfCartesianChart(
                                                    plotAreaBorderWidth: 0,
                                                    backgroundColor: AppColors.cAB865A.withOpacity(0.0),
                                                    primaryXAxis: CategoryAxis(
                                                      isVisible: true,
                                                      majorGridLines: MajorGridLines(
                                                        width: 0.8,
                                                        color: AppColors.cDFDEDE,
                                                        dashArray: null,
                                                      ),
                                                      axisLine: const AxisLine(width: 0),
                                                      interval: 1,
                                                      labelStyle: const TextStyle(fontSize: 10),
                                                      tickPosition: TickPosition.inside,
                                                      majorTickLines: const MajorTickLines(width: 0),
                                                    ),
                                                    primaryYAxis: const NumericAxis(isVisible: false,interval: 0.1,),
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
                                                  );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.filterdata.region ?? "",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.cAB865A,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          data.filterdata.classs ?? "",
                                          style: TextStyle(fontSize: 12, color: AppColors.c656e79),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        // Row(
                                        //   children: [
                                        //     Icon(Icons.arrow_drop_up, color: AppColors.c2a8741),
                                        //     Expanded(
                                        //       child: Text(
                                        //         "2.75 | \$280/MT",
                                        //         style: TextStyle(color: AppColors.c2a8741, fontSize: 14),
                                        //       ),
                                        //     )
                                        //   ],
                                        // ),
                                        // const SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 16),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.c45413b,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              Miscellaneous.formatPrDate(data.filterdata.date ?? ""),
                                              style: TextStyle(color: AppColors.cFFFFFF, fontSize: 10),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
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
                  },
                ))
              : Center(
                  child: Text('No data found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.c656e79,
                          )),
                ),
        ),
      );
    });
  }
}
// Container(
//   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//   decoration: BoxDecoration(
//     color: AppColors.c45413b,
//     borderRadius: BorderRadius.circular(12),
//   ),
//   child: Text(
//     "APRIL",
//     style: TextStyle(color: AppColors.cFFFFFF, fontSize: 10),
//     maxLines: 1,
//     overflow: TextOverflow.ellipsis,
//   ),
// ),
