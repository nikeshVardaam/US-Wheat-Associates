import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/dashboard_page/calculator.dart';
import 'package:uswheat/dashboard_page/price/prices.dart';
import 'package:uswheat/dashboard_page/quality/quality.dart';
import 'package:uswheat/dashboard_page/reprts/reports.dart';
import 'package:uswheat/dashboard_page/watchList.dart';
import 'package:uswheat/modal/login_modal.dart';
import 'package:uswheat/service/delete_service.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/app_widgets.dart';
import 'package:uswheat/utils/pref_keys.dart';

import '../auth/SyncData.dart';
import '../utils/app_routes.dart';
import 'login_provider.dart';

class DashboardProvider extends ChangeNotifier {
  String? selectedPage = AppStrings.watchlist;
  TextEditingController deleteController = TextEditingController();
  Widget selectActivity = const Prices(
    region: '',
    cls: '',
    year: '',
  );
  String selectMenu = AppStrings.pricess;
  int currentIndex = 0;
  SharedPreferences? sp;
  User? user;

  Future<void> syncData(BuildContext context) async {
    await SyncData().syncData(context: context);
  }

  confirmDelete({required BuildContext context}) {
    final text = deleteController.text.trim();
    if (text.isEmpty) {
      AppWidgets.topSnackBar(
        context: context,
        message: "Field cannot be empty",
        color: AppColors.cd63a3a,
      );
      return;
    }

    final delete = text.toUpperCase();

    if (delete != "DELETE") {
      AppWidgets.topSnackBar(
        context: context,
        message: "Please type DELETE in capital letters",
        color: AppColors.cd63a3a,
      );
    } else {
      AppWidgets.topSnackBar(
        context: context,
        message: "Account deleted successfully",
        color: AppColors.c2a8741,
      );
      deleteUser(context: context);
    }
  }

  deleteUser({required BuildContext context}) {
    DeleteService()
        .delete(endpoint: ApiEndpoint.deleteAccount, context: context)
        .then(
      (value) async {
        if (value != null) {
          sp = await SharedPreferences.getInstance();
          sp?.clear();
          Provider.of<LoginProvider>(context, listen: false).cleanData();
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.login, (Route<dynamic> route) => false);
        }
      },
    );
  }

  getPrefData() async {
    sp = await SharedPreferences.getInstance();
    var data = sp?.getString(PrefKeys.user);
    if (data?.isNotEmpty ?? false) {
      user = User.fromJson(jsonDecode(data!));
    }
  }

  void navigateToScreen({
    required BuildContext context,
    required Widget screen,
    required String pageName,
  }) {
    final dp = Provider.of<DashboardProvider>(context, listen: false);
    dp.setChangeActivity(
      activity: screen,
      pageName: pageName,
    );
  }

  setChangeActivity(
      {required Widget activity,
      required String pageName,
      bool isBottomTab = false}) {
    selectActivity = activity;
    selectMenu = pageName;

    // pageName ke hisaab se currentIndex set karo
    currentIndex = _getIndexFromPageName(pageName);

    notifyListeners();
  }

  changePageFromBottomNavigation({required int index}) {
    currentIndex = index;
    switch (index) {
      case 0:
        setChangeActivity(
            activity: const Prices(
              region: '',
              cls: '',
              year: '',
            ),
            pageName: AppStrings.price,
            isBottomTab: true);
        break;
      case 1:
        setChangeActivity(
            activity: const Quality(),
            pageName: AppStrings.quality,
            isBottomTab: true);
        break;
      case 2:
        setChangeActivity(
            activity: const Watchlist(),
            pageName: AppStrings.watchlist,
            isBottomTab: true);
        break;
      case 3:
        setChangeActivity(
            activity: const Reports(),
            pageName: AppStrings.reports,
            isBottomTab: true);
        break;
      case 4:
        setChangeActivity(
            activity: const Calculator(),
            pageName: AppStrings.calculator,
            isBottomTab: true);
        break;
    }
  }

  logOut(BuildContext context) async {
    sp = await SharedPreferences.getInstance();
    sp?.clear();
    Provider.of<LoginProvider>(context, listen: false).cleanData();
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.login, (Route<dynamic> route) => false);
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
