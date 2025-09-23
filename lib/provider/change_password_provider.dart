import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_routes.dart';

import '../service/post_services.dart';
import '../utils/api_endpoint.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';

class ChangePasswordProvider extends ChangeNotifier {
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool passwordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  SharedPreferences? sp;

  void cleanData() {
    passwordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
  }

  setPasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  setNewPasswordVisibility() {
    newPasswordVisible = !newPasswordVisible;
    notifyListeners();
  }

  setConfirmPasswordVisibility() {
    confirmPasswordVisible = !confirmPasswordVisible;
    notifyListeners();
  }

  bool validation(BuildContext context) {
    if (passwordController.text.trim().isEmpty) {
      AppWidgets.appSnackBar(
        context: context,
        text: "Enter your current password",
        color: Colors.redAccent,
      );
      return false;
    } else if (newPasswordController.text.trim().isEmpty) {
      AppWidgets.appSnackBar(
        context: context,
        text: "Enter your new password",
        color: Colors.redAccent,
      );
      return false;
    } else if (confirmPasswordController.text.trim().isEmpty) {
      AppWidgets.appSnackBar(
        context: context,
        text: "Please confirm your new password",
        color: Colors.redAccent,
      );
      return false;
    } else if (newPasswordController.text.trim() != confirmPasswordController.text.trim()) {
      AppWidgets.appSnackBar(
        context: context,
        text: "New password and confirmation do not match",
        color: Colors.redAccent,
      );
      return false;
    } else if (passwordController.text.trim() == newPasswordController.text.trim()) {
      AppWidgets.appSnackBar(
        context: context,
        text: "New password must be different from current password",
        color: Colors.redAccent,
      );
      return false;
    }
    return true;
  }

  changePassword({required BuildContext context}) async {
    if (validation(context)) {
      var data = {
        "password": passwordController.text.trim(),
        "new_password": newPasswordController.text.trim(),
        "confirm_password": confirmPasswordController.text.trim(),
      };
      await PostServices()
          .post(
        endpoint: ApiEndpoint.changePassword,
        requestData: data,
        context: context,
        isBottomSheet: false,
        loader: true,
      )
          .then(
        (value) {
          AppWidgets.appSnackBar(
            context: context,
            text: AppStrings.passwordChangedSuccessfully,
            color: AppColors.c2a8741,
          );
          Navigator.pushNamed(context, AppRoutes.dashboard);
          cleanData();
        },
      );
    }
  }
}
