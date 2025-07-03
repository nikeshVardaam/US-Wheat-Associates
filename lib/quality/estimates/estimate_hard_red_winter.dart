import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/provider/dashboard_provider.dart';
import 'package:uswheat/quality/quality.dart';
import 'package:uswheat/utils/app_assets.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';

class EstimateHardRedWinter extends StatefulWidget {
  const EstimateHardRedWinter({super.key});

  @override
  State<EstimateHardRedWinter> createState() => _EstimateHardRedWinterState();
}

class _EstimateHardRedWinterState extends State<EstimateHardRedWinter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.c2a8741,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                              size: 12,
                              color: AppColors.cFFFFFF,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        AppStrings.hardRedWinter,
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
        Expanded(
          child: Image.asset(
            AppAssets.map,
            fit: BoxFit.contain,
          ),
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
                    child: Text("WHEAT DATA", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c353d4a.withOpacity(0.7), fontWeight: FontWeight.w700)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("Current Average", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child:
                        Text("2024 Final Average", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "5-Year Average",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7)),
                    ),
                  )
                ],
              ),

              // Manually written data rows
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("TW (lb/bu)", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c95795d)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("61.4", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "61.4",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7)),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("61.4", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("TW (kg/hl)", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c95795d)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("80.7", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("80.7", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("80.7", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("Moisture (%)", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c95795d)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("10.7", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("10.7", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("10.7", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("Protein (12% mb)", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c95795d)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("13.5", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("13.5", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("13.5", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("Protein (dry basis)", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c95795d)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("30.1", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("30.1", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text("30.1", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.c353d4a.withOpacity(0.7))),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
