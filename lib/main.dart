import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/provider/dashboard_provider.dart';
import 'package:uswheat/provider/login_provider.dart';
import 'package:uswheat/provider/price_provider.dart';
import 'package:uswheat/provider/sign_provider.dart';
import 'package:uswheat/utils/app_routes.dart';
import 'package:uswheat/utils/route_generator.dart';
import 'package:uswheat/utils/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => DashboardProvider()),
          ChangeNotifierProvider(create: (context) => LoginProvider()),
          ChangeNotifierProvider(create: (context) => SignUpProvider()),
          ChangeNotifierProvider(create: (context) => PricesProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: ThemeClass.lightTheme,
          initialRoute: AppRoutes.login,
          onGenerateRoute: RouteGenerator.generateRoute,
        ));
  }
}
