import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api_endpoint.dart';
import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';
import '../utils/pref_keys.dart';
import 'exception_dialogs.dart';

class PostServices {
  SharedPreferences? sp;

  Future<http.Response?> post({
    required String endpoint,
    required Map<String, dynamic> requestData,
    required BuildContext context,
    required isBottomSheet,
    required bool loader,
  }) async {
    sp = await SharedPreferences.getInstance();
    if (loader) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AppWidgets.loading(),
      );
    }

    String url = "${ApiEndpoint.baseUrl}$endpoint";
    String bearerToken = 'Bearer ${sp?.getString(PrefKeys.token)}';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(requestData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearerToken,
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));
      var jsonData = json.decode(response.body);
      if (loader) {
        Navigator.pop(context);
      }
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 409) {
        return response;
      } else if (response.statusCode == 401) {
        ExceptionDialogs.networkDialog(
          context: context,
          message: jsonData["message"] ?? "",
          onPressed: () {},
        );
        return null;
      } else if (response.statusCode == 422) {
        ExceptionDialogs.networkDialog(
          context: context,
          message: jsonData["message"] ?? "",
          onPressed: () {},
        );
        return null;
      } else if (response.statusCode == 404) {
        ExceptionDialogs.networkDialog(
          context: context,
          message: jsonData["message"] ?? "",
          onPressed: () {},
        );
        return null;
      } else if (response.statusCode == 500) {
        ExceptionDialogs.networkDialog(
          context: context,
          message: AppStrings.error500,
          onPressed: () {},
        );
        return null;
      } else if (response.statusCode == 503) {
        ExceptionDialogs.networkDialog(
          context: context,
          message: AppStrings.error503,
          onPressed: () {},
        );
        return null;
      }
    } on TimeoutException catch (e) {
      if (context.mounted && loader) {
        Navigator.pop(context);
        ExceptionDialogs.networkDialog(
          context: context,
          message:  "Request timed out. Please check your internet and try again.",
          onPressed: () {},
        );
        // show dialog
      }
      return null;
    } on HttpException catch (e) {
      if (context.mounted && loader) {
        Navigator.pop(context);
        ExceptionDialogs.networkDialog(
          context: context,
          message: e.message ?? "",
          onPressed: () {},
        );
      }
      return null;
    } on SocketException catch (e) {
      if (context.mounted && loader) {
        Navigator.pop(context);
        ExceptionDialogs.networkDialog(
          context: context,
          message: "No Internet connection.",
          onPressed: () {},
        );
        // show dialog
      }
      return null;
    } on FormatException catch (e) {
      if (context.mounted && loader) {
        Navigator.pop(context);
        ExceptionDialogs.networkDialog(
          context: context,
          message: e.message ?? "",
          onPressed: () {},
        );
        // show dialog
      }
      return null;
    } on Exception catch (e) {
      if (context.mounted && loader) {
        Navigator.pop(context);
        ExceptionDialogs.networkDialog(
          context: context,
          message: e.toString() ?? "",
          onPressed: () {},
        );
        // show dialog
      }
      return null;
    }
    return null;
  }
}
