import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uswheat/auth/login.dart';
import 'package:uswheat/dashboard.dart';
import 'package:uswheat/quality/estimates/estimate_hard_red_winter.dart';
import 'package:uswheat/utils/app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return buildRoute(const Login(), settings: settings);
      case AppRoutes.dashboard:
        return buildRoute(const Dashboard(), settings: settings);
      case AppRoutes.estimateHardRedWinter:
        return buildRoute(const EstimateHardRedWinter(), settings: settings);
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
