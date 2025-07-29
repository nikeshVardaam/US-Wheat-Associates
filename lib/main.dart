import 'package:firebase_core/firebase_core.dart' show Firebase, FirebaseOptions;
import 'package:firebase_messaging/firebase_messaging.dart' show FirebaseMessaging, RemoteMessage;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/provider/calculator_provider.dart';
import 'package:uswheat/provider/dashboard_provider.dart';
import 'package:uswheat/provider/login_provider.dart';
import 'package:uswheat/provider/price_provider.dart';
import 'package:uswheat/provider/sign_provider.dart';
import 'package:uswheat/provider/watchList_provider.dart';
import 'package:uswheat/utils/app_routes.dart';
import 'package:uswheat/utils/route_generator.dart';
import 'package:uswheat/utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAGkVDE68ChgSkWRt4451f1L-QaZNoebmQ",
      appId: "1:802117704671:android:ae477273b39032281d026a",
      messagingSenderId: "802117704671",
      projectId: "uswheat-39289",
      storageBucket: "uswheat-39289.firebasestorage.app",
    ),
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  runApp(const MyApp());
}

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔔 Background Message: ${message.messageId}');
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
