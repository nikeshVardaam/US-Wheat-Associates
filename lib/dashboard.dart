import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/dashboard_page/watchList.dart';
import 'package:uswheat/dashboard_page/prices.dart';
import 'package:uswheat/provider/dashboard_provider.dart';
import 'package:uswheat/quality/quality.dart';
import 'package:uswheat/utils/app_assets.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/app_widgets.dart';

import 'dashboard_page/calculator.dart';
import 'dashboard_page/reports.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      right: false,
      left: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.c45413b,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.cFFFFFF),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(8),
            child: SizedBox(),
          ),
          title: Image.asset(
            AppAssets.darkLogo,
            scale: 5,
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.notifications_none_outlined),
            )
          ],
        ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            backgroundColor: AppColors.c000000,
            child: Consumer<DashboardProvider>(
              builder: (context, dp, child) {
                return SafeArea(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            dense: true,
                            trailing: Icon(
                              Icons.search,
                              color: AppColors.cFFFFFF,
                              size: 18,
                            ),
                            title: Text(
                              AppStrings.search,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: AppColors.cFFFFFF,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                              color: AppColors.cAB865A,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.account,
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: AppColors.cFFFFFF,
                                      ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    AppWidgets.initial(
                                      context,
                                      "Meet Patel",
                                      AppColors.c656e79,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Welcome",
                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                    color: AppColors.cFFFFFF,
                                                  ),
                                            ),
                                            Text(
                                              "Meet....@gmail.com",
                                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                    color: AppColors.cFFFFFF,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 16),
                            child: Text(
                              AppStrings.pages,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: AppColors.cFFFFFF,
                                  ),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.star_border_outlined,
                              color: AppColors.cFFFFFF,
                              size: 18,
                            ),
                            title: Text(
                              AppStrings.watchlist,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.cFFFFFF,
                                  ),
                            ),
                            onTap: () {
                              dp.setChangeActivity(activity: const Watchlist(), pageName: AppStrings.watchlist);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.percent_rounded,
                              color: AppColors.cFFFFFF,
                              size: 18,
                            ),
                            title: Text(
                              AppStrings.price,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.cFFFFFF,
                                  ),
                            ),
                            onTap: () {
                              dp.setChangeActivity(activity: const Prices(), pageName: AppStrings.price);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.done_outlined,
                              color: AppColors.cFFFFFF,
                              size: 18,
                            ),
                            title: Text(
                              AppStrings.quality,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.cFFFFFF,
                                  ),
                            ),
                            onTap: () {
                              dp.setChangeActivity(activity: const Quality(), pageName: AppStrings.quality);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.auto_graph_rounded,
                              color: AppColors.cFFFFFF,
                              size: 18,
                            ),
                            title: Text(
                              AppStrings.reports,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.cFFFFFF,
                                  ),
                            ),
                            onTap: () {
                              dp.setChangeActivity(activity: const Reports(), pageName: AppStrings.reports);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.calculate_outlined,
                              color: AppColors.cFFFFFF,
                              size: 18,
                            ),
                            title: Text(
                              AppStrings.calculator,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.cFFFFFF,
                                  ),
                            ),
                            onTap: () {
                              dp.setChangeActivity(activity: const Calculator(), pageName: AppStrings.calculator);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.newspaper_rounded,
                              color: AppColors.cFFFFFF,
                              size: 18,
                            ),
                            title: Text(
                              AppStrings.news,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.cFFFFFF,
                                  ),
                            ),
                            onTap: () {},
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 16),
                            child: Text(
                              AppStrings.settings,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: AppColors.cFFFFFF,
                                  ),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.settings,
                              color: AppColors.cFFFFFF,
                              size: 18,
                            ),
                            title: Text(
                              AppStrings.settings,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.cFFFFFF,
                                  ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        body: Consumer<DashboardProvider>(
          builder: (context, dp, _) {
            return dp.selectActivity;
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: Provider.of<DashboardProvider>(context).currentIndex,
          onTap: (value) {
            Provider.of<DashboardProvider>(context, listen: false).changePageFromBottomNavigation(index: value);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.c45413b,
          selectedItemColor: AppColors.cFFc166,
          unselectedItemColor: AppColors.cFFFFFF,
          items: [
            BottomNavigationBarItem(
              label: AppStrings.price,
              icon: const Icon(Icons.percent),
              backgroundColor: AppColors.c45413b,
            ),
            BottomNavigationBarItem(
              label: AppStrings.quality,
              icon: const Icon(Icons.done),
              backgroundColor: AppColors.c45413b,
            ),
            BottomNavigationBarItem(
              label: AppStrings.watchlist,
              icon: const Icon(Icons.star_border_outlined),
              backgroundColor: AppColors.c45413b,
            ),
            BottomNavigationBarItem(
              label: AppStrings.reports,
              icon: const Icon(Icons.auto_graph_rounded),
              backgroundColor: AppColors.c45413b,
            ),
            BottomNavigationBarItem(
              label: AppStrings.calculator,
              icon: const Icon(Icons.calculate_outlined),
              backgroundColor: AppColors.c45413b,
            ),
          ],
        ),
      ),
    );
  }
}
