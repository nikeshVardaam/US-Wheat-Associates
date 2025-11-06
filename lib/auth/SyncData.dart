import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uswheat/service/get_api_services.dart';
import 'package:uswheat/utils/api_endpoint.dart';
import 'package:uswheat/utils/app_widgets.dart';

import '../service/post_services.dart';
import '../utils/pref_keys.dart';

class SyncData {
  late final SharedPreferences sp;

  Future<void> syncData({required BuildContext context}) async {
    await getRegionAndClass(context: context).then(
      (value) async {
         await getAvailableDates(context: context);
      },
    );
  }

  Future<void> getAvailableDates({required BuildContext context}) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AppWidgets.loading(),
    );

    try {
      List<String> availableDates = [];
      sp = await SharedPreferences.getInstance();

      final response = await PostServices().post(
        endpoint: ApiEndpoint.availableDates,
        requestData: {},
        context: context,
        isBottomSheet: false,
        loader: false,
      );

      if (response != null) {
        final data = jsonDecode(response.body);
        final dates = data["data"];
        for (int i = 0; i < dates.length; i++) {
          availableDates.add(dates[i].toString());
        }
      }
      sp.setStringList(PrefKeys.availableDateList, availableDates);
    } finally {
      Navigator.pop(context);
    }
  }

  Future<void> getRegionAndClass({required BuildContext context}) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AppWidgets.loading(),
    );

    try {
      await GetApiServices()
          .get(
        endpoint: ApiEndpoint.getRegionsAndClasses,
        context: context,
        loader: false,
      )
          .then(
            (response) async {
          if (response != null) {
            Map<String, dynamic> decoded;
            try {
              decoded = json.decode(response.body) as Map<String, dynamic>;
            } on FormatException catch (e) {
              print('Body: ${response.body}');
              return;
            }
            final sp = await SharedPreferences.getInstance();
            await sp.setString("region", jsonEncode(decoded));
          }
        },
      );
    } finally {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }
  Future<void> getYear({required BuildContext context}) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AppWidgets.loading(),
    );

    try {
      List<String> yearList = [];
      sp = await SharedPreferences.getInstance();

      final response = await GetApiServices().get(endpoint: ApiEndpoint.getYears, context: context, loader: false);

      if (response != null) {
        final data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          yearList.add(data[i].toString());
        }
      }
      sp.setStringList(PrefKeys.yearList, yearList);
    } finally {
      Navigator.pop(context);
    }
  }
}
