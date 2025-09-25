import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uswheat/utils/api_endpoint.dart';

import '../utils/app_strings.dart';
import '../utils/app_widgets.dart';
import '../utils/pref_keys.dart';
import 'exception_dialogs.dart';

class DeleteService {
  SharedPreferences? sp;

  DeleteService._privateConstructor();

  static final DeleteService _instance = DeleteService._privateConstructor();

  factory DeleteService() {
    return _instance;
  }

  Future<http.Response?> deleteWithId({
    required String endpoint,
    required BuildContext context,
    required String id,
  }) async {
    sp = await SharedPreferences.getInstance();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AppWidgets.loading(),
    );
    String url = "${(ApiEndpoint.baseUrl)}$endpoint/$id";
    String bearerToken = 'Bearer ${sp?.getString(PrefKeys.token)}';
    print(url);
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearerToken,
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));
      var data = json.decode(response.body);
      Navigator.pop(context);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else if (response.statusCode == 401) {
        ExceptionDialogs.networkDialog(
          context: context,
          message: data["message"],
          onPressed: () {},
        );
        return null;
      } else if (response.statusCode == 404) {
        ExceptionDialogs.networkDialog(
          context: context,
          message: data["message"],
          onPressed: () {},
        );
        return null;
      } else if (response.statusCode == 422) {
        ExceptionDialogs.networkDialog(
          context: context,
          message: data["message"],
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
      if (context.mounted) {
        print(e);
        Navigator.pop(context);
        ExceptionDialogs.networkDialog(
          context: context,
          message: e.message ?? "",
          onPressed: () {},
        );
        // show dialog
      }
      return null;
    } on HttpException catch (e) {
      if (context.mounted) {
        print(e);
        Navigator.pop(context);
        ExceptionDialogs.networkDialog(
          context: context,
          message: e.message ?? "",
          onPressed: () {},
        );
      }
      return null;
    } on SocketException catch (e) {
      if (context.mounted) {
        print(e);
        Navigator.pop(context);
        ExceptionDialogs.networkDialog(
          context: context,
          message: "No Internet connection.",
          onPressed: () {

          },
        );
        // show dialog
      }
      return null;
    } on FormatException catch (e) {
      if (context.mounted) {
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
      if (context.mounted) {
        print(e);

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
  } Future<http.Response?> delete({
    required String endpoint,
    required BuildContext context,
  }) async {
    sp = await SharedPreferences.getInstance();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AppWidgets.loading(),
    );
    String url = "${(ApiEndpoint.baseUrl)}$endpoint";
    String bearerToken = 'Bearer ${sp?.getString(PrefKeys.token)}';
    print(url);
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearerToken,
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));
      var data = json.decode(response.body);
      Navigator.pop(context);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else if (response.statusCode == 401) {
        ExceptionDialogs.networkDialog(
          context: context,
          message: data["message"],
          onPressed: () {},
        );
        return null;
      } else if (response.statusCode == 404) {
        ExceptionDialogs.networkDialog(
          context: context,
          message: data["message"],
          onPressed: () {},
        );
        return null;
      } else if (response.statusCode == 422) {
        ExceptionDialogs.networkDialog(
          context: context,
          message: data["message"],
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
      if (context.mounted) {
        print(e);
        Navigator.pop(context);
        ExceptionDialogs.networkDialog(
          context: context,
          message: e.message ?? "",
          onPressed: () {},
        );
        // show dialog
      }
      return null;
    } on HttpException catch (e) {
      if (context.mounted) {
        print(e);
        Navigator.pop(context);
        ExceptionDialogs.networkDialog(
          context: context,
          message: e.message ?? "",
          onPressed: () {},
        );
      }
      return null;
    } on SocketException catch (e) {
      if (context.mounted) {
        print(e);
        Navigator.pop(context);
        ExceptionDialogs.networkDialog(
          context: context,
          message: "No Internet connection.",
          onPressed: () {

          },
        );
        // show dialog
      }
      return null;
    } on FormatException catch (e) {
      if (context.mounted) {
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
      if (context.mounted) {
        print(e);

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
