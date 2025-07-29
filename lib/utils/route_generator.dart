import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uswheat/auth/login.dart';
import 'package:uswheat/auth/sign_up.dart';
import 'package:uswheat/calculator/distance_area/meters_yards_feet.dart';
import 'package:uswheat/calculator/distance_area/miles_kilometer.dart';
import 'package:uswheat/calculator/weight/bushels_metric_tons.dart';
import 'package:uswheat/dashboard.dart';
import 'package:uswheat/quality/estimates/estimate_hard_red_winter.dart';
import 'package:uswheat/utils/app_routes.dart';

import '../calculator/distance_area/acres_hectares_mu.dart';
import '../calculator/weight/long_metric_ton_page.dart';
import '../calculator/weight/metric_ton_to_kg_pound_page.dart';
import '../calculator/weight/short_ton_to_pound_page.dart';
import '../calculator/weight/short_tons_metric_tons.dart';
import '../calculator/distance_area/square_feet_square_meters.dart';
import '../calculator/temperature/temperature_converter_pag.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return buildRoute(const Login(), settings: settings);
      case AppRoutes.dashboard:
        return buildRoute(const Dashboard(), settings: settings);
      case AppRoutes.estimateHardRedWinter:
        return buildRoute(const EstimateHardRedWinter(), settings: settings);
      case AppRoutes.signUp:
        return buildRoute(const SignUp(), settings: settings);
      case AppRoutes.bushelsMetricTons:
        return buildRoute(const BushelsMetricTons(), settings: settings);
      case AppRoutes.milesKilometer:
        return buildRoute(const MilesKilometer(), settings: settings);
      case AppRoutes.squareFeetToSquareMeter:
        return buildRoute(const SquareFeetToSquareMeter(), settings: settings);
      case AppRoutes.metersYardsFeet:
        return buildRoute(const MetersYardsFeet(), settings: settings);
      case AppRoutes.acresHectaresMu:
        return buildRoute(const AcresHectaresMu(), settings: settings);
      case AppRoutes.shortMetricTonPage:
        return buildRoute(const ShortMetricTonPage(), settings: settings);
      case AppRoutes.longMetricTonPage:
        return buildRoute(const LongMetricTonPage(), settings: settings);
      case AppRoutes.shortTonToPoundPage:
        return buildRoute(const ShortTonToPoundPage(), settings: settings);
        case AppRoutes.metricTonToKgPoundPage:
        return buildRoute(const MetricTonToKgPoundPage(), settings: settings);
        case AppRoutes.temperatureConverterPage:
        return buildRoute(const TemperatureConverterPage(), settings: settings);


      default:
        return _errorRoute();
    }
  }

  static MaterialPageRoute buildRoute(Widget child, {required RouteSettings settings}) {
    return MaterialPageRoute(settings: settings, builder: (BuildContext context) => child);
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(
                'Seems the route you\'ve navigated to doesn\'t exist!!',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    });
  }
}
