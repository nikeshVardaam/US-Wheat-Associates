import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/utils/api_endpoint.dart';

import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';
import '../utils/pref_keys.dart';

class GetApiServices {
  SharedPreferences? sp;

  Future<http.Response?> get({
    required String endpoint,
    required BuildContext context,
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
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearerToken,
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));

      var data = json.decode(response.body);
      if (loader) {
        Navigator.pop(context);
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else if (response.statusCode == 401) {
        AppWidgets.appSnackBar(context: context, text: data["message"], color: Colors.redAccent);
        return null;
      } else if (response.statusCode == 404) {
        AppWidgets.appSnackBar(context: context, text: data["message"], color: Colors.redAccent);
        return null;
      } else if (response.statusCode == 500) {
        AppWidgets.appSnackBar(context: context, text: AppStrings.error500, color: Colors.redAccent);
        return null;
      } else if (response.statusCode == 503) {
        AppWidgets.appSnackBar(context: context, text: AppStrings.error503, color: Colors.redAccent);
        return null;
      }
    } on TimeoutException catch (e) {
      Navigator.pop(context);
      return null;
    } on HttpException catch (e) {
      Navigator.pop(context);
      return null;
    } on SocketException catch (e) {
      return null;
    } on FormatException catch (e) {
      Navigator.pop(context);
      return null;
    } on Exception catch (e) {
      Navigator.pop(context);
      return null;
    }
    return null;
  }
}
