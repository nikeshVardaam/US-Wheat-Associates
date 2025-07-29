import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/dashboard_page/calculator.dart';
import 'package:uswheat/dashboard_page/prices.dart';
import 'package:uswheat/quality/quality.dart';
import 'package:uswheat/dashboard_page/reports.dart';
import 'package:uswheat/dashboard_page/watchList.dart';
import 'package:uswheat/utils/app_strings.dart';

import '../utils/app_routes.dart';
import 'login_provider.dart';

class DashboardProvider extends ChangeNotifier {
  String? selectedPage = AppStrings.watchlist;
  Widget selectActivity = const Watchlist();
  String selectMenu = AppStrings.watchlist;
  int currentIndex = 2;
  SharedPreferences? sp;

  DashboardProvider() {
    selectActivity = const Watchlist();
    selectMenu = AppStrings.watchlist;
    notifyListeners();
  }

  setChangeActivity({required Widget activity, required String pageName}) {
    selectActivity = activity;
    selectMenu = AppStrings.watchlist;
    notifyListeners();
  }

  logOut(BuildContext context) async {
    sp = await SharedPreferences.getInstance();
    sp?.clear();
    Provider.of<LoginProvider>(context, listen: false).cleanData();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (Route<dynamic> route) => false);
  }

  changePageFromBottomNavigation({required int index}) {
    currentIndex = index;
    switch (index) {
      case 0:
        setChangeActivity(activity: const Prices(), pageName: AppStrings.price);
        break;
      case 1:
        setChangeActivity(activity: const Quality(), pageName: AppStrings.quality);
        break;
      case 2:
        setChangeActivity(activity: const Watchlist(), pageName: AppStrings.watchlist);
        break;
      case 3:
        setChangeActivity(activity: const Reports(), pageName: AppStrings.reports);
        break;
      case 4:
        setChangeActivity(activity:  Calculator(), pageName: AppStrings.calculator);
        break;
    }
    notifyListeners();
  }
}
