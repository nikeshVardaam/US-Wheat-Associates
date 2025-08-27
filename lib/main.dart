import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/auth/login.dart';
import 'package:uswheat/provider/calculator_provider.dart';
import 'package:uswheat/provider/dashboard_provider.dart';
import 'package:uswheat/provider/estimates/wheat_page_provider.dart';
import 'package:uswheat/provider/login_provider.dart';
import 'package:uswheat/provider/price_provider.dart';
import 'package:uswheat/provider/reports_provider.dart';
import 'package:uswheat/provider/sign_provider.dart';
import 'package:uswheat/provider/watchList_provider.dart';
import 'package:uswheat/splash_screen.dart';
import 'package:uswheat/utils/app_routes.dart';
import 'package:uswheat/utils/route_generator.dart';
import 'package:uswheat/utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          ChangeNotifierProvider(create: (context) => CalculatorProvider()),
          ChangeNotifierProvider(create: (context) => WatchlistProvider()),
          ChangeNotifierProvider(create: (context) => ReportsProvider()),
          ChangeNotifierProvider(create: (context) => WheatPageProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: ThemeClass.lightTheme,
          home: const SplashScreen(),
          onGenerateRoute: RouteGenerator.generateRoute,
        ));
  }
}
