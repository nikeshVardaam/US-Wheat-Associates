import 'package:flutter/cupertino.dart';
import 'package:uswheat/dashboard_page/calculator.dart';
import 'package:uswheat/dashboard_page/prices.dart';
import 'package:uswheat/quality/quality.dart';
import 'package:uswheat/dashboard_page/reports.dart';
import 'package:uswheat/dashboard_page/watchList.dart';
import 'package:uswheat/utils/app_strings.dart';

class DashboardProvider extends ChangeNotifier {
  String? selectedPage = AppStrings.watchlist;
  Widget selectActivity = Container();
  String selectMenu = "";

  DashboardProvider() {
    selectActivity = const Watchlist();
    selectMenu = AppStrings.watchlist;
    notifyListeners();
  }

  setChangeActivity({required Widget activity, required String pageName}) {
    selectActivity = activity;
    selectMenu = pageName;
    notifyListeners();
  }
}
