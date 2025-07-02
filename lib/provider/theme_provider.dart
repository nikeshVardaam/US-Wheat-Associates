import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   // _isDarkMode = prefs.getBool(PrefKeys.isDarkMode) ?? false;
    _updateStatusBar();
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
 //   prefs.setBool(PrefKeys.isDarkMode, _isDarkMode);
  }

  bool get isDarkMode => _isDarkMode;

  //ThemeData get currentTheme => _isDarkMode ? ThemeClass.darkTheme : ThemeClass.lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemePreference();
    _updateStatusBar();
    notifyListeners();
  }

  void _updateStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
      //  statusBarColor: _isDarkMode ? ThemeClass().darkPrimaryColor : ThemeClass().lightPrimaryColor,
        // Optional: Set a transparent color
        statusBarIconBrightness: _isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: _isDarkMode ? Colors.black : Colors.white,
        // Change nav bar color
        systemNavigationBarIconBrightness: _isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );
  }
}
