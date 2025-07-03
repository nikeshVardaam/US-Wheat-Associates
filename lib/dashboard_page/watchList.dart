import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uswheat/utils/app_assets.dart';
import 'package:uswheat/utils/app_colors.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({super.key});

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
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
                      Icon(Icons.star, color: AppColors.cFFFFFF, size: 18),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8)),
                            child: Image.asset(
                              AppAssets.chart,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.c45413b,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "APRIL - 2024 / APRIL - 2025",
                                style: TextStyle(color: AppColors.cFFFFFF, fontSize: 10),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Gulf | HRS 14.0%",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.cAB865A,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "(15.9% dry matter basis) Min",
                            style: TextStyle(fontSize: 12, color: AppColors.c656e79),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.arrow_drop_up, color: AppColors.c2a8741),
                              Text(
                                "2.75 | \$280/MT",
                                style: TextStyle(color: AppColors.c2a8741, fontSize: 14),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.c45413b,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "APRIL",
                              style: TextStyle(color: AppColors.cFFFFFF, fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                      Icon(Icons.star, color: AppColors.cFFFFFF, size: 18),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8)),
                            child: Image.asset(
                              AppAssets.chart,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.c45413b,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "APRIL - 2024 / APRIL - 2025",
                                style: TextStyle(color: AppColors.cFFFFFF, fontSize: 10),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Gulf | HRS 14.0%",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.cAB865A,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "(15.9% dry matter basis) Min",
                            style: TextStyle(fontSize: 12, color: AppColors.c656e79),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.arrow_drop_up, color: AppColors.c2a8741),
                              Text(
                                "2.75 | \$280/MT",
                                style: TextStyle(color: AppColors.c2a8741, fontSize: 14),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.c45413b,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "APRIL",
                              style: TextStyle(color: AppColors.cFFFFFF, fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                        child: Text(
                          "U.S. Wheat Associates | FOB \$/MT | April 28",
                          style: TextStyle(color: AppColors.cFFFFFF, fontSize: 12),
                        ),
                      ),
                      Icon(Icons.star, color: AppColors.cFFFFFF, size: 18),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Wheat Data",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.c2a8741,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                "Moisture%",
                                style: TextStyle(fontSize: 12, color: AppColors.c656e79),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text("11.3%", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800, color: AppColors.c2a8741)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                "Protein %%",
                                style: TextStyle(fontSize: 12, color: AppColors.c656e79),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text("11.3%", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800, color: AppColors.c2a8741)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                "FN%",
                                style: TextStyle(fontSize: 12, color: AppColors.c656e79),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text("365", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800, color: AppColors.c2a8741)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                "Grade / Test Weight% ",
                                style: TextStyle(fontSize: 12, color: AppColors.c656e79),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text("60.8lb/bu", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800, color: AppColors.c2a8741)),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Text("80.1 kg/nl", style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800, color: AppColors.c2a8741)),
                                ],
                              ),
                            ],
                          ),
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
    );
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
