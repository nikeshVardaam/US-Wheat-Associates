import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Image.asset(
                    AppAssets.wheatProduction,
                    fit: BoxFit.contain,
                  ),
                ),
                Consumer<DashboardProvider>(
                  builder: (context, dp, child) {
                    return GestureDetector(
                      onTap: () {
                        dp.setChangeActivity(
                          activity: WheatPages(
                            title: AppStrings.hardRedWinter,
                            appBarColor: AppColors.c2a8741,
                            imageAsset: AppAssets.hardRedWinter,
                            selectedClass: 'HRW',
                          ),
                          pageName: AppStrings.hardRedWinter,
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
                            title: AppStrings.softRedWinter,
                            appBarColor: AppColors.c603c16,
                            imageAsset: AppAssets.softRedWinter,
                            selectedClass: 'SRW',
                          ),
                          pageName: AppStrings.softRedWinter,
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
                          title: AppStrings.softWhite,
                          appBarColor: AppColors.c007aa6,
                          imageAsset: AppAssets.softWhite,
                          selectedClass: 'SW',
                        ),
                        pageName: AppStrings.softWhite,
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
                            title: AppStrings.hardRedSpring,
                            appBarColor: AppColors.cb86a29,
                            imageAsset: AppAssets.hardRedSpring,
                            selectedClass: 'HRS',
                          ),
                          pageName: AppStrings.hardRedSpring,
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
                          title: AppStrings.northernDurum,
                          appBarColor: AppColors.cb01c32,
                          imageAsset: AppAssets.northernDurum,
                          selectedClass: "Durum",
                        ),
                        pageName: AppStrings.northernDurum,
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
