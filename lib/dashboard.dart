import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/auth/SyncData.dart';
import 'package:uswheat/dashboard_page/watch_list/watchList.dart';
import 'package:uswheat/dashboard_page/price/prices.dart';
import 'package:uswheat/provider/dashboard_provider.dart';
import 'package:uswheat/dashboard_page/quality/quality.dart';
import 'package:uswheat/utils/app_assets.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_delete_dialog.dart';
import 'package:uswheat/utils/app_logout_dialog.dart' show AppLogoutDialogs;
import 'package:uswheat/utils/app_routes.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/app_widgets.dart';
import 'dashboard_page/calculator.dart';
import 'dashboard_page/reprts/reports.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<DashboardProvider>(context, listen: false).getPrefData();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext perentContext) {
    return SafeArea(
      top: false,
      right: false,
      left: false,
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.c3d3934,
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
          ),
          drawer: SizedBox(
            width: MediaQuery.of(perentContext).size.width / 1.8,
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
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.account,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                            color: AppColors.cFFFFFF,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      AppWidgets.initial(
                                        context,
                                        dp.user?.name ?? "",
                                        AppColors.c656e79,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dp.user?.name ?? "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge
                                                    ?.copyWith(
                                                      color: AppColors.cFFFFFF,
                                                    ),
                                              ),
                                              Text(
                                                dp.user?.email ?? "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Divider(
                                color: AppColors.cAB865A,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                AppStrings.pages,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                        color: AppColors.cFFFFFF,
                                        fontWeight: FontWeight.w500),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              leading: SvgPicture.asset(
                                AppAssets.star,
                                height: 18,
                                colorFilter: ColorFilter.mode(
                                  dp.currentIndex == 2
                                      ? AppColors.cFFc166
                                      : AppColors.cFFFFFF,
                                  BlendMode.srcIn,
                                ),
                              ),
                              title: Text(
                                AppStrings.watchlist,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: dp.currentIndex == 2
                                          ? AppColors.cFFc166
                                          : AppColors.cFFFFFF,
                                    ),
                              ),
                              onTap: () {
                                dp.setChangeActivity(
                                    activity: const Watchlist(),
                                    pageName: AppStrings.watchlist);
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              dense: true,
                              leading: SvgPicture.asset(
                                AppAssets.percentage,
                                height: 18,
                                colorFilter: ColorFilter.mode(
                                  dp.currentIndex == 0
                                      ? AppColors.cFFc166
                                      : AppColors.cFFFFFF,
                                  BlendMode.srcIn,
                                ),
                              ),
                              title: Text(
                                AppStrings.price,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: dp.currentIndex == 0
                                          ? AppColors.cFFc166
                                          : AppColors.cFFFFFF,
                                    ),
                              ),
                              onTap: () {
                                dp.setChangeActivity(
                                    activity: const Prices(
                                      region: '',
                                      cls: '',
                                      year: '',
                                    ),
                                    pageName: AppStrings.price);
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              dense: true,
                              leading: SvgPicture.asset(
                                AppAssets.done,
                                height: 18,
                                colorFilter: ColorFilter.mode(
                                  dp.currentIndex == 1
                                      ? AppColors.cFFc166
                                      : AppColors.cFFFFFF,
                                  BlendMode.srcIn,
                                ),
                              ),
                              title: Text(
                                AppStrings.quality,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: dp.currentIndex == 1
                                          ? AppColors.cFFc166
                                          : AppColors.cFFFFFF,
                                    ),
                              ),
                              onTap: () {
                                dp.setChangeActivity(
                                    activity: const Quality(),
                                    pageName: AppStrings.quality);
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              dense: true,
                              leading: SvgPicture.asset(
                                AppAssets.chartPie,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  dp.currentIndex == 3
                                      ? AppColors.cFFc166
                                      : AppColors.cFFFFFF,
                                  BlendMode.srcIn,
                                ),
                              ),
                              title: Text(
                                AppStrings.reports,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: dp.currentIndex == 3
                                          ? AppColors.cFFc166
                                          : AppColors.cFFFFFF,
                                    ),
                              ),
                              onTap: () {
                                dp.setChangeActivity(
                                    activity: const Reports(),
                                    pageName: AppStrings.reports);
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              dense: true,
                              leading: SvgPicture.asset(
                                AppAssets.equal,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  dp.currentIndex == 4
                                      ? AppColors.cFFc166
                                      : AppColors.cFFFFFF,
                                  BlendMode.srcIn,
                                ),
                              ),
                              title: Text(
                                AppStrings.calculator,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: dp.currentIndex == 4
                                          ? AppColors.cFFc166
                                          : AppColors.cFFFFFF,
                                    ),
                              ),
                              onTap: () {
                                dp.setChangeActivity(
                                    activity: const Calculator(),
                                    pageName: AppStrings.calculator);
                                Navigator.pop(context);
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.newsFeed,
                                );
                              },
                              child: ListTile(
                                dense: true,
                                leading: SvgPicture.asset(
                                  AppAssets.news,
                                  height: 16,
                                  color: AppColors.cFFFFFF,
                                ),
                                title: Text(
                                  AppStrings.newFeed,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.cFFFFFF,
                                      ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(perentContext);
                                dp.syncData(perentContext).then((value) async {

                                });
                              },
                              child: ListTile(
                                dense: true,
                                leading: Image.asset(
                                  AppAssets.sync,
                                  height: 16,
                                  color: AppColors.cFFFFFF,
                                ),
                                title: Text(
                                  AppStrings.syncNewData,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.cFFFFFF,
                                      ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AppLogoutDialogs(
                                      onTap: () {
                                        dp.logOut(context);
                                      },
                                    );
                                  },
                                );
                              },
                              child: ListTile(
                                dense: true,
                                leading: SvgPicture.asset(
                                  AppAssets.logout,
                                  height: 18,
                                  color: Colors.red,
                                ),
                                title: Text(
                                  AppStrings.logout,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.red,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Divider(
                          color: AppColors.cAB865A,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    child: const AppDeleteDialog(),
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AppAssets.delete,
                                  height: 14,
                                  color: AppColors.cFFFFFF,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  AppStrings.deleteUser,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: AppColors.cFFFFFF,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: AppColors.cAB865A,
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
          bottomNavigationBar: Consumer<DashboardProvider>(
            builder: (context, dp, _) {
              return BottomNavigationBar(
                currentIndex: dp.currentIndex,
                onTap: (value) {
                  dp.changePageFromBottomNavigation(index: value);
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: AppColors.c3d3934,
                selectedItemColor: AppColors.cFFc166,
                unselectedItemColor: AppColors.cFFFFFF,
                items: [
                  BottomNavigationBarItem(
                    label: AppStrings.price,
                    icon: SvgPicture.asset(
                      AppAssets.percentage,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        dp.currentIndex == 0
                            ? AppColors.cFFc166
                            : AppColors.cFFFFFF,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: AppStrings.quality,
                    icon: SvgPicture.asset(
                      AppAssets.done,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        dp.currentIndex == 1
                            ? AppColors.cFFc166
                            : AppColors.cFFFFFF,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: AppStrings.watchlist,
                    icon: SvgPicture.asset(
                      AppAssets.star,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        dp.currentIndex == 2
                            ? AppColors.cFFc166
                            : AppColors.cFFFFFF,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: AppStrings.reports,
                    icon: SvgPicture.asset(
                      AppAssets.chartPie,
                      height: 23,
                      colorFilter: ColorFilter.mode(
                        dp.currentIndex == 3
                            ? AppColors.cFFc166
                            : AppColors.cFFFFFF,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: AppStrings.calculator,
                    icon: SvgPicture.asset(
                      AppAssets.equal,
                      height: 23,
                      colorFilter: ColorFilter.mode(
                        dp.currentIndex == 4
                            ? AppColors.cFFc166
                            : AppColors.cFFFFFF,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
// GestureDetector(
//   onTap: (){
//     showDialog(
//       context: context,
//       builder: (context) {
//         return ChangePassword(
//           onTap: () {
//             dp.logOut(context);
//           },
//         );
//       },
//     );
//   },
//   child: ListTile(
//     dense: true,
//     leading: SvgPicture.asset(
//       AppAssets.passwordChange,
//       height: 18,
//       colorFilter: ColorFilter.mode(
//         dp.currentIndex == 5 ? AppColors.cFFc166 : AppColors.cFFFFFF,
//         BlendMode.srcIn,
//       ),
//     ),
//     title: Text(
//       AppStrings.changePassword,
//       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//         color: dp.currentIndex == 5 ? AppColors.cFFc166 : AppColors.cFFFFFF,
//       ),
//     ),
//   ),
// ),
