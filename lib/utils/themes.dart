import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uswheat/utils/app_colors.dart';

class ThemeClass {
  static Color lightPrimaryColor = const Color(0xffffffff);
  Color darkPrimaryColor = const Color(0xff1f2836);
  static Color appBarColor = const Color(0xFF3D3934);

  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeClass.lightPrimaryColor,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cFFFFFF,
      contentPadding: const EdgeInsets.all(5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors.cDFDEDE, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors.cDFDEDE, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: AppColors.cDFDEDE, width: 1),
      ),
      hintStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        fontFamily: "proximanovaexcn",
        color: AppColors.c666666,
      ),
    ),
    textSelectionTheme:
        TextSelectionThemeData(selectionHandleColor: AppColors.c000000),
    textTheme: TextTheme(
      labelLarge: const TextStyle().copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        fontFamily: "proximanovaexcn",
        color: AppColors.c464646,
      ),
      labelSmall: const TextStyle().copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 11,
        fontFamily: "proximanovaexcn",
        color: AppColors.c000000,
      ),
      headlineSmall: const TextStyle().copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 24,
        fontFamily: "proximanovaexcn",
        color: AppColors.c000000,
      ),
      bodySmall: const TextStyle().copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        fontFamily: "proximanovaexcn",
        color: AppColors.c000000,
      ),
      titleMedium: const TextStyle().copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        fontFamily: "proximanovaexcn",
        color: AppColors.c000000,
      ),
      titleLarge: const TextStyle().copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        fontFamily: "proximanovaexcn",
        color: AppColors.c464646,
      ),
      bodyLarge: const TextStyle().copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        fontFamily: "proximanovaexcn",
        color: Colors.black,
      ),
    ),
    scaffoldBackgroundColor: ThemeClass.lightPrimaryColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: ThemeClass.lightPrimaryColor,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: lightPrimaryColor,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: appBarColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
  );
}

ThemeClass _themeClass = ThemeClass();
