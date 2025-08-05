import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uswheat/service/post_services.dart';
import 'package:uswheat/utils/api_endpoint.dart';

import '../utils/app_routes.dart';
import '../utils/app_widgets.dart';
import '../utils/miscellaneous.dart';

class SignUpProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool passwordIsVisible = false;
  bool confirmPasswordIsVisible = false;

  void cleanData() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
  }
  void setPasswordVisibility() {
    passwordIsVisible = !passwordIsVisible;
    notifyListeners();
  }

  void setConfirmPasswordVisibility() {
    confirmPasswordIsVisible = !confirmPasswordIsVisible;
    notifyListeners();
  }

  bool validation(BuildContext context) {
    RegExp regex = RegExp(Miscellaneous.emailPattern);
    if (nameController.text.trim().isEmpty) {
      AppWidgets.appSnackBar(context: context, text: "Enter Full Name", color: Colors.redAccent);
      return false;
    } else if (emailController.text.trim().isEmpty || !regex.hasMatch(emailController.text.trim())) {
      AppWidgets.appSnackBar(context: context, text: "Enter valid email", color: Colors.redAccent);
      return false;
    } else if (passwordController.text.trim().isEmpty) {
      AppWidgets.appSnackBar(context: context, text: "Enter password", color: Colors.redAccent);
      return false;
    } else if (confirmPasswordController.text.trim().isEmpty) {
      AppWidgets.appSnackBar(context: context, text: "Enter confirm password", color: Colors.redAccent);
      return false;
    } else if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      AppWidgets.appSnackBar(context: context, text: "Passwords do not match", color: Colors.redAccent);
      return false;
    }
    return true;
  }

  createAccount({required BuildContext context}) {
    if (validation(context)) {
      var data = {
        "name": emailController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };
      PostServices()
          .post(
            endpoint: ApiEndpoint.signUp,
            requestData: data,
            context: context,
            isBottomSheet: false,
            loader: false,
          )
          .then(
            (value) {},
          );
      cleanData();
      Navigator.pushNamed(context, AppRoutes.dashboard);
      notifyListeners();
    }
  }
}
