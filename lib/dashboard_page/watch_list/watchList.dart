import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    Provider.of<WatchlistProvider>(context, listen: false).getWatchList(context: context);
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
                      // Column(
                      //     children: List.generate(
                      //   wp.watchlist.length,
                      //   (index) {
                      //     var data = wp.watchlist[index];
                      //     if (data.type == "price") {
                      //       return Column(
                      //         children: [
                      //           GestureDetector(
                      //             onTap: () {
                      //               wp.navigateToPriceReport(
                      //                 context: context,
                      //                 region: data.filterdata.region,
                      //                 classs: data.filterdata.classs,
                      //                 date: data.filterdata.date,
                      //               );
                      //             },
                      //             child: Container(
                      //               decoration: BoxDecoration(
                      //                 color: AppColors.cAB865A.withOpacity(0.2),
                      //                 borderRadius: BorderRadius.circular(16),
                      //               ),
                      //               child: Column(
                      //                 crossAxisAlignment: CrossAxisAlignment.start,
                      //                 children: [
                      //                   // Header
                      //                   Container(
                      //                     decoration: BoxDecoration(
                      //                       color: AppColors.cab865a,
                      //                       borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      //                     ),
                      //                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      //                     child: Row(
                      //                       children: [
                      //                         Expanded(
                      //                           child: Row(
                      //                             children: [
                      //                               Text(
                      //                                 AppStrings.wheatAssociates,
                      //                                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      //                                       color: AppColors.cFFFFFF,
                      //                                     ),
                      //                               ),
                      //                               Padding(
                      //                                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      //                                 child: Container(
                      //                                   height: 12,
                      //                                   width: 2,
                      //                                   color: AppColors.cFFFFFF,
                      //                                 ),
                      //                               ),
                      //                               Text(
                      //                                 data.filterdata.region ?? "",
                      //                                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      //                                       color: AppColors.cFFFFFF,
                      //                                     ),
                      //                               ),
                      //                             ],
                      //                           ),
                      //                         ),
                      //                         GestureDetector(
                      //                           onTap: () {
                      //                             wp.deleteWatchList(
                      //                               context: context,
                      //                               id: data.id ?? "",
                      //                               wheatClass: data.filterdata.classs,
                      //                               date: data.filterdata.date,
                      //                             );
                      //                           },
                      //                           child: SvgPicture.asset(
                      //                             AppAssets.fillStar,
                      //                             height: 18,
                      //                             color: AppColors.cFFFFFF,
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                   Row(
                      //                     mainAxisAlignment: MainAxisAlignment.start,
                      //                     crossAxisAlignment: CrossAxisAlignment.start,
                      //                     children: [
                      //                       Expanded(
                      //                         flex: 2,
                      //                         child: SizedBox(
                      //                           height: MediaQuery.of(context).size.width / 3,
                      //                           child: Container(
                      //                             margin: EdgeInsets.zero,
                      //                             padding: EdgeInsets.zero,
                      //                             decoration: const BoxDecoration(),
                      //                             child: FutureBuilder(
                      //                               future: wp.fetchChartDataForItem(context, data),
                      //                               builder: (context, snapshot) {
                      //                                 if (snapshot.connectionState == ConnectionState.waiting) {
                      //                                   return const Center(
                      //                                     child: Padding(
                      //                                       padding: EdgeInsets.all(8.0),
                      //                                       child: CupertinoActivityIndicator(
                      //                                         color: Colors.black,
                      //                                       ),
                      //                                     ),
                      //                                   );
                      //                                 }
                      //
                      //                                 return data.chartData.isEmpty ?? true
                      //                                     ? Center(
                      //                                         child: Text(
                      //                                           AppStrings.noDataFound,
                      //                                           style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c464646),
                      //                                         ),
                      //                                       )
                      //                                     : Padding(
                      //                                         padding: const EdgeInsets.only(bottom: 6, left: 8),
                      //                                         child: SfCartesianChart(
                      //                                           margin: EdgeInsets.zero,
                      //                                           plotAreaBorderWidth: 0,
                      //                                           backgroundColor: AppColors.cAB865A.withOpacity(0.0),
                      //                                           plotAreaBackgroundColor: AppColors.cAB865A.withOpacity(0.0),
                      //                                           primaryXAxis: CategoryAxis(
                      //                                             isVisible: true,
                      //                                             majorGridLines: MajorGridLines(
                      //                                               width: 0.1,
                      //                                               color: AppColors.cab865a.withOpacity(0.6),
                      //                                             ),
                      //                                             axisLine: const AxisLine(width: 0),
                      //                                             interval: 1,
                      //                                             labelStyle: Theme.of(context).textTheme.labelSmall,
                      //                                             tickPosition: TickPosition.inside,
                      //                                             labelPlacement: LabelPlacement.betweenTicks,
                      //                                             // ← important
                      //                                             edgeLabelPlacement: EdgeLabelPlacement.shift,
                      //                                             // ← prevents clipping
                      //                                             majorTickLines: const MajorTickLines(width: 0),
                      //                                           ),
                      //                                           primaryYAxis: const NumericAxis(
                      //                                             isVisible: false,
                      //                                             majorGridLines: MajorGridLines(width: 0),
                      //                                             axisLine: AxisLine(width: 0),
                      //                                             rangePadding: ChartRangePadding.round,
                      //                                           ),
                      //                                           series: <CartesianSeries>[
                      //                                             LineSeries<SalesData, String>(
                      //                                               dataSource: data.chartData,
                      //                                               xValueMapper: (SalesData d, _) => d.month,
                      //                                               yValueMapper: (SalesData d, _) => d.sales,
                      //                                               color: AppColors.c000000,
                      //                                               width: 0.5,
                      //                                               dataLabelSettings: const DataLabelSettings(isVisible: false),
                      //                                             ),
                      //                                           ],
                      //                                         ),
                      //                                       );
                      //                               },
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       const SizedBox(width: 16),
                      //                       Expanded(
                      //                         flex: 2,
                      //                         child: Column(
                      //                           crossAxisAlignment: CrossAxisAlignment.start,
                      //                           children: [
                      //                             Row(
                      //                               children: [
                      //                                 Text(
                      //                                   data.filterdata.region ?? "",
                      //                                   style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      //                                         color: AppColors.cab865a,
                      //                                         fontWeight: FontWeight.w900,
                      //                                       ),
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                             Text(
                      //                               "(${data.filterdata.classs ?? ""})",
                      //                               style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      //                                     color: AppColors.c656e79,
                      //                                   ),
                      //                               maxLines: 1,
                      //                               overflow: TextOverflow.ellipsis,
                      //                             ),
                      //                             const SizedBox(
                      //                               height: 16,
                      //                             ),
                      //                             Container(
                      //                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      //                               decoration: BoxDecoration(
                      //                                 color: AppColors.c45413b,
                      //                                 borderRadius: BorderRadius.circular(12),
                      //                               ),
                      //                               child: Text(
                      //                                 data.filterdata.formattedDate ?? " ",
                      //                                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      //                                       color: AppColors.cFFFFFF,
                      //                                     ),
                      //                                 maxLines: 1,
                      //                                 overflow: TextOverflow.ellipsis,
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //           const SizedBox(
                      //             height: 16,
                      //           ),
                      //         ],
                      //       );
                      //     } else if (data.type == "quality") {
                      //       Color c = Color(int.parse(data.filterdata.color, radix: 16));
                      //       return Column(
                      //         children: [
                      //           GestureDetector(
                      //             onTap: () {
                      //               wp.navigateToQualityReport(
                      //                 context: context,
                      //                 dateTime: data.filterdata.date,
                      //                 wheatClass: data.filterdata.classs,
                      //               );
                      //             },
                      //             child: Container(
                      //               decoration: BoxDecoration(
                      //                 color: AppColors.cAB865A.withOpacity(0.2),
                      //                 borderRadius: BorderRadius.circular(16),
                      //               ),
                      //               child: Padding(
                      //                 padding: const EdgeInsets.only(bottom: 40.0),
                      //                 child: Column(
                      //                   crossAxisAlignment: CrossAxisAlignment.start,
                      //                   children: [
                      //                     // Header
                      //                     Container(
                      //                       decoration: BoxDecoration(
                      //                         color: c,
                      //                         borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      //                       ),
                      //                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      //                       child: Row(
                      //                         children: [
                      //                           Expanded(
                      //                             child: Row(
                      //                               children: [
                      //                                 Text(
                      //                                   AppStrings.wheatAssociates,
                      //                                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      //                                         color: AppColors.cFFFFFF,
                      //                                       ),
                      //                                 ),
                      //                                 Padding(
                      //                                   padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      //                                   child: Container(
                      //                                     height: 12,
                      //                                     width: 2,
                      //                                     color: AppColors.cFFFFFF,
                      //                                   ),
                      //                                 ),
                      //                                 Text(
                      //                                   data.filterdata.region ?? "",
                      //                                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      //                                         color: AppColors.cFFFFFF,
                      //                                       ),
                      //                                 ),
                      //                                 Text(
                      //                                   data.filterdata.classs ?? "",
                      //                                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      //                                         color: AppColors.cFFFFFF,
                      //                                       ),
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ),
                      //                           GestureDetector(
                      //                               onTap: () {
                      //                                 wp.deleteWatchList(
                      //                                   context: context,
                      //                                   id: data.id ?? "",
                      //                                   wheatClass: data.filterdata.classs,
                      //                                   date: data.filterdata.date,
                      //                                 );
                      //                               },
                      //                               child: SvgPicture.asset(
                      //                                 AppAssets.fillStar,
                      //                                 height: 18,
                      //                                 color: AppColors.cFFFFFF,
                      //                               )),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                     Padding(
                      //                       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                      //                       child: Column(
                      //                         crossAxisAlignment: CrossAxisAlignment.start,
                      //                         children: [
                      //                           Text(
                      //                             AppStrings.data,
                      //                             style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      //                                   color: c,
                      //                                   fontWeight: FontWeight.w900,
                      //                                 ),
                      //                           ),
                      //                           const SizedBox(height: 8),
                      //                           SingleChildScrollView(
                      //                             scrollDirection: Axis.horizontal,
                      //                             child: Row(
                      //                               children: [
                      //                                 // Moisture
                      //                                 Column(
                      //                                   crossAxisAlignment: CrossAxisAlignment.start,
                      //                                   children: [
                      //                                     Text(
                      //                                       AppStrings.testWtbbu,
                      //                                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      //                                             color: AppColors.c737373,
                      //                                           ),
                      //                                     ),
                      //                                     const SizedBox(height: 4),
                      //                                     Text(
                      //                                       (data.wheatData?.testWtlbbu != null && data.wheatData!.testWtlbbu!.isNotEmpty) ? "${data.wheatData!.testWtlbbu}" : "--",
                      //                                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      //                                             color: c,
                      //                                             fontWeight: FontWeight.w900,
                      //                                           ),
                      //                                     )
                      //                                   ],
                      //                                 ),
                      //                                 const SizedBox(width: 16),
                      //                                 // Prot12%mb
                      //                                 Column(
                      //                                   crossAxisAlignment: CrossAxisAlignment.start,
                      //                                   children: [
                      //                                     Text(
                      //                                       AppStrings.testWtkghl,
                      //                                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      //                                             color: AppColors.c737373,
                      //                                           ),
                      //                                     ),
                      //                                     const SizedBox(height: 4),
                      //                                     Text(
                      //                                       (data.wheatData?.testWtkghl != null && data.wheatData!.testWtkghl!.isNotEmpty)
                      //                                           ? "${data.wheatData!.testWtkghl} "
                      //                                           : "--",
                      //                                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      //                                             color: c,
                      //                                             fontWeight: FontWeight.w900,
                      //                                           ),
                      //                                     )
                      //                                   ],
                      //                                 ),
                      //                                 const SizedBox(width: 16),
                      //                                 // DryBasisProt%
                      //                                 Column(
                      //                                   crossAxisAlignment: CrossAxisAlignment.start,
                      //                                   children: [
                      //                                     Text(
                      //                                       AppStrings.moist,
                      //                                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      //                                             color: AppColors.c737373,
                      //                                           ),
                      //                                     ),
                      //                                     const SizedBox(height: 4),
                      //                                     Text(
                      //                                       (data.wheatData?.moisture != null && data.wheatData!.moisture!.isNotEmpty) ? "${data.wheatData!.moisture}%" : "--",
                      //                                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      //                                             color: c,
                      //                                             fontWeight: FontWeight.w900,
                      //                                           ),
                      //                                     )
                      //                                   ],
                      //                                 ),
                      //                                 const SizedBox(width: 16),
                      //                                 // DryBasisProt%
                      //                                 Column(
                      //                                   crossAxisAlignment: CrossAxisAlignment.start,
                      //                                   children: [
                      //                                     Text(
                      //                                       AppStrings.prot12,
                      //                                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      //                                             color: AppColors.c737373,
                      //                                           ),
                      //                                     ),
                      //                                     const SizedBox(height: 4),
                      //                                     Text(
                      //                                       (data.wheatData?.prot12Mb != null && data.wheatData!.prot12Mb!.isNotEmpty) ? "${data.wheatData!.prot12Mb}%" : "--",
                      //                                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      //                                             color: c,
                      //                                             fontWeight: FontWeight.w900,
                      //                                           ),
                      //                                     )
                      //                                   ],
                      //                                 ),
                      //                                 const SizedBox(width: 16),
                      //                                 Column(
                      //                                   crossAxisAlignment: CrossAxisAlignment.start,
                      //                                   children: [
                      //                                     Text(
                      //                                       AppStrings.proDb,
                      //                                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      //                                             color: AppColors.c737373,
                      //                                           ),
                      //                                     ),
                      //                                     const SizedBox(height: 4),
                      //                                     Text(
                      //                                       (data.wheatData?.dryBasisProt != null && data.wheatData!.dryBasisProt!.isNotEmpty)
                      //                                           ? "${data.wheatData!.dryBasisProt}%"
                      //                                           : "--",
                      //                                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      //                                             color: c,
                      //                                             fontWeight: FontWeight.w900,
                      //                                           ),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //           const SizedBox(height: 16),
                      //         ],
                      //       );
                      //     } else {
                      //       return const SizedBox.shrink();
                      //     }
                      //   },
                      // )),

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
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
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
                                                              data.current?.testWtlbbu.toString() ?? "--",
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
                                                              data.current?.testWtkghl.toString() ?? "--",
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
                                                              data.current?.moisture.toString() ?? "--",
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
                                                              data.current?.prot12Mb.toString() ?? "--",
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
                                                              data.current?.dryBasisProt.toString() ?? "--",
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
                                                              data.yearAverage?.testWtlbbu.toString() ?? "--",
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
                                                              data.yearAverage?.testWtkghl.toString() ?? "--",
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
                                                              data.yearAverage?.moisture.toString() ?? "--",
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
                                                              data.yearAverage?.prot12Mb.toString() ?? "--",
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
                                                              data.yearAverage?.dryBasisProt.toString() ?? "--",
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
                                                              data.fiveYearAverage?.testWtlbbu.toString() ?? "--",
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
                                                              data.fiveYearAverage?.testWtkghl.toString() ?? "--",
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
                                                              data.fiveYearAverage?.moisture.toString() ?? "--",
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
                                                              data.fiveYearAverage?.prot12Mb.toString() ?? "--",
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
                                                              data.fiveYearAverage?.dryBasisProt.toString() ?? "--",
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
                                onTap: () {},
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
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {},
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

                                                      return data.graphDataList?.isEmpty ?? true
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
                                                                  interval: 1,
                                                                  labelStyle: Theme.of(context).textTheme.labelSmall,
                                                                  tickPosition: TickPosition.inside,
                                                                  labelPlacement: LabelPlacement.betweenTicks,
                                                                  // ← important
                                                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
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
                                                                  LineSeries<GraphDataModal, DateTime>(
                                                                    dataSource: data.graphDataList,
                                                                    xValueMapper: (GraphDataModal data, _) => DateTime.parse(data.pRDATE.toString()),
                                                                    yValueMapper: (GraphDataModal data, _) => data.cASHMT,
                                                                    color: AppColors.c464646,
                                                                    width: 1,
                                                                    name: 'CASHMT',
                                                                    markerSettings: const MarkerSettings(isVisible: false),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      data.filterData?.region ?? "",
                                                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                            color: AppColors.cab865a,
                                                            fontWeight: FontWeight.w900,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "(${data.filterData?.classs ?? ""})",
                                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                        color: AppColors.c656e79,
                                                      ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.c45413b,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    data.filterData?.formattedDate ?? " ",
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                          color: AppColors.cFFFFFF,
                                                        ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
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
