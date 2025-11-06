import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/dashboard_page/quality/estimates/wheat_pages.dart';
import 'package:uswheat/provider/dashboard_provider.dart';
import 'package:uswheat/utils/app_assets.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';

class Quality extends StatefulWidget {
  const Quality({super.key});

  @override
  State<Quality> createState() => _QualityState();
}

class _QualityState extends State<Quality> {
  @override
  Widget build(BuildContext perentContext) {
    return Column(
      children: [
        Container(
          color: AppColors.c656e79,
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
                        AppStrings.qua,
                        style: Theme.of(perentContext).textTheme.bodySmall?.copyWith(color: AppColors.cFFFFFF, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  AppAssets.star,
                  color: Colors.transparent,
                  height: 18,
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
                          // wpp.showYearPicker(context, wheatClass: widget.selectedClass);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.transparent),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.transparent,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "",
                                style: Theme.of(perentContext).textTheme.bodySmall?.copyWith(
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
                  AppAssets.wheatProduction,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(
                  height: 16,
                ),
                Divider(
                  thickness: 0.5,
                  height: 1,
                  color: AppColors.cB6B6B6,
                ),
                Consumer<DashboardProvider>(
                  builder: (context, dp, child) {
                    return GestureDetector(
                      onTap: () {
                        dp.setChangeActivity(
                          activity: WheatPages(
                            fromWatchList: false,
                            date: "",
                            title: AppStrings.hardRedWinter,
                            appBarColor: AppColors.c2a8741,
                            imageAsset: AppAssets.hardRedWinter,
                            selectedClass: 'HRW',
                          ),
                          pageName: AppStrings.quality,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        color: AppColors.c95795d.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.hardRedWinter,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.c2a8741,
                                    ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: AppColors.c2a8741,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Divider(
                  thickness: 0.5,
                  height: 1,
                  color: AppColors.cB6B6B6,
                ),
                Consumer<DashboardProvider>(builder: (context, dp, child) {
                  return GestureDetector(
                      onTap: () {
                        dp.setChangeActivity(
                          activity: WheatPages(
                            fromWatchList: false,
                            date: "",
                            title: AppStrings.softRedWinter,
                            appBarColor: AppColors.c603c16,
                            imageAsset: AppAssets.softRedWinter,
                            selectedClass: 'SRW',
                          ),
                          pageName: AppStrings.quality,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        color: AppColors.c95795d.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.softRedWinter,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.c603c16,
                                    ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: AppColors.c603c16,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ));
                }),
                Divider(
                  thickness: 0.5,
                  height: 1,
                  color: AppColors.cB6B6B6,
                ),
                Consumer<DashboardProvider>(builder: (context, dp, child) {
                  return GestureDetector(
                    onTap: () {
                      dp.setChangeActivity(
                        activity: WheatPages(
                          fromWatchList: false,
                          date: "",
                          title: AppStrings.softWhite,
                          appBarColor: AppColors.c007aa6,
                          imageAsset: AppAssets.softWhite,
                          selectedClass: 'SW',
                        ),
                        pageName: AppStrings.quality,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      color: AppColors.c95795d.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.softWhite,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.c007aa6,
                                  ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: AppColors.c007aa6,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                Divider(
                  thickness: 0.5,
                  height: 1,
                  color: AppColors.cB6B6B6,
                ),
                Consumer<DashboardProvider>(builder: (context, dp, child) {
                  return GestureDetector(
                      onTap: () {
                        dp.setChangeActivity(
                          activity: WheatPages(
                            fromWatchList: false,
                            date: "",
                            title: AppStrings.hardRedSpring,
                            appBarColor: AppColors.cb86a29,
                            imageAsset: AppAssets.hardRedSpring,
                            selectedClass: 'HRS',
                          ),
                          pageName: AppStrings.quality,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        color: AppColors.c95795d.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.hardRedSpring,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.cb86a29,
                                    ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: AppColors.cb86a29,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ));
                }),
                Divider(
                  thickness: 0.5,
                  height: 1,
                  color: AppColors.cB6B6B6,
                ),
                Consumer<DashboardProvider>(builder: (context, dp, child) {
                  return GestureDetector(
                    onTap: () {
                      dp.setChangeActivity(
                        activity: WheatPages(
                          fromWatchList: false,
                          date: "",
                          title: AppStrings.northernDurum,
                          appBarColor: AppColors.cb01c32,
                          imageAsset: AppAssets.northernDurum,
                          selectedClass: "Durum",
                        ),
                        pageName: AppStrings.quality,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      color: AppColors.c95795d.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.northernDurum,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.cb01c32,
                                  ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: AppColors.cb01c32,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                Divider(
                  thickness: 0.5,
                  height: 1,
                  color: AppColors.cB6B6B6,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
