import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/modal/login_modal.dart';
import 'package:uswheat/service/post_services.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import '../utils/app_routes.dart';
import '../utils/app_widgets.dart';
import '../utils/miscellaneous.dart';
import '../utils/pref_keys.dart';

class LoginProvider extends ChangeNotifier {
  SharedPreferences? sp;
  bool passwordIsVisible = false;
  bool rememberMe = false;
  TextEditingController emailController = TextEditingController(text:"shrey@gmail.com");
  TextEditingController passwordController = TextEditingController(text: "shrey@123");

  void cleanData() {
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  setPasswordVisibility() {
    if (passwordIsVisible) {
      passwordIsVisible = false;
    } else {
      passwordIsVisible = true;
    }
    notifyListeners();
  }



  checkLogin({required BuildContext context}) async {
    sp = await SharedPreferences.getInstance();
    if (sp?.getString(PrefKeys.token) != null) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }

  logout(BuildContext context) async {
    sp = await SharedPreferences.getInstance();
    sp?.remove(PrefKeys.token);

    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  bool validation(BuildContext context) {
    RegExp regex = RegExp(Miscellaneous.emailPattern);
    if (emailController.text.trim().isEmpty) {
      AppWidgets.appSnackBar(context: context, text: "Enter email Id", color: Colors.redAccent);
      return false;
    } else if (!regex.hasMatch(emailController.text.trim())) {
      AppWidgets.appSnackBar(
        context: context,
        text: "Enter valid email",
        color: Colors.redAccent,
      );
      return false;
    } else if (passwordController.text.trim().isEmpty) {
      AppWidgets.appSnackBar(context: context, text: "Enter password", color: Colors.redAccent);
      return false;
    }
    return true;
  }

  logIn({required BuildContext context}) async {
    if (validation(context)) {
      var data = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };

      await PostServices()
          .post(
        endpoint: ApiEndpoint.login,
        requestData: data,
        context: context,
        isBottomSheet: false,
        loader: true,
      )
          .then(
        (value) async {
          if (value != null) {
            LoginModal loginModel = LoginModal.fromJson(json.decode(value.body));
            sp = await SharedPreferences.getInstance();
            await sp?.setString(PrefKeys.token, loginModel.token ?? "");
            await sp?.setString(PrefKeys.user, jsonEncode(loginModel.user ?? ""));

            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          }
        },
      );

      notifyListeners();
    }
  }
}
