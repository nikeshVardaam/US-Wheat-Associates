import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/dashboard_page/calculator.dart';
import 'package:uswheat/dashboard_page/prices.dart';
import 'package:uswheat/dashboard_page/quality/quality.dart';
import 'package:uswheat/dashboard_page/reprts/reports.dart';
import 'package:uswheat/dashboard_page/watchList.dart';
import 'package:uswheat/modal/login_modal.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/pref_keys.dart';

import '../utils/app_routes.dart';
import 'login_provider.dart';

class DashboardProvider extends ChangeNotifier {
  String? selectedPage = AppStrings.watchlist;
  Widget selectActivity = const Watchlist();
  String selectMenu = AppStrings.watchlist;
  int currentIndex = 2;
  SharedPreferences? sp;
  User? user;

  DashboardProvider() {
    selectActivity = const Watchlist();
    selectMenu = AppStrings.watchlist;
    notifyListeners();
  }

  getPrefData() async {
    sp = await SharedPreferences.getInstance();
    var data = sp?.getString(PrefKeys.user);
    if (data?.isNotEmpty ?? false) {
      user = User.fromJson(jsonDecode(data!));
    }
  }

  setChangeActivity({required Widget activity, required String pageName}) {
    selectActivity = activity;
    selectMenu = pageName;
    currentIndex = _getIndexFromPageName(pageName);
    notifyListeners();
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
        setChangeActivity(activity: Calculator(), pageName: AppStrings.calculator);
        break;
    }
  }

  logOut(BuildContext context) async {
    sp = await SharedPreferences.getInstance();
    sp?.clear();
    Provider.of<LoginProvider>(context, listen: false).cleanData();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (Route<dynamic> route) => false);
  }

  int _getIndexFromPageName(String pageName) {
    switch (pageName) {
      case AppStrings.price:
        return 0;
      case AppStrings.quality:
        return 1;
      case AppStrings.watchlist:
        return 2;
      case AppStrings.reports:
        return 3;
      case AppStrings.calculator:
        return 4;
      default:
        return 0;
    }
  }
}
