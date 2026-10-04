import 'package:flutter/material.dart';
import 'package:medicine_system/constant/app_colors.dart';
import 'package:medicine_system/constant/app_constant.dart';

class AppThemeConfiguration {
  ////////////// constructor
  AppThemeConfiguration._privateConstructor();
  static final AppThemeConfiguration _instance = AppThemeConfiguration._privateConstructor();
  static AppThemeConfiguration get instance => _instance;

  ThemeData lightThemeData = ThemeData.light(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: AppColors.instance.white50,
    dividerColor: AppColors.instance.transparent,
    primaryColor: AppColors.instance.white50,
    primaryColorLight: AppColors.instance.white50,
    splashColor: AppColors.instance.transparent,
    hoverColor: AppColors.instance.transparent,
    appBarTheme: AppBarTheme(elevation: 5, surfaceTintColor: AppColors.instance.white50, backgroundColor: AppColors.instance.white50),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins),
      bodyMedium: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins),
      bodySmall: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins),
      displayLarge: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins),
      displayMedium: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins),
      displaySmall: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins),
      headlineLarge: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins),
      headlineMedium: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins),
      headlineSmall: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins),
      labelLarge: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins),
      labelMedium: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins),
      labelSmall: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins),
      titleLarge: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins),
      titleMedium: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins),
      titleSmall: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins),
    ),
    focusColor: AppColors.instance.blue500,

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.instance.gray200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.instance.gray200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.instance.gray200),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.instance.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.instance.error),
      ),
    ),
  );

  ThemeData darkThemeData = ThemeData.dark(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: const Color(0xFF14171A),
    cardColor: const Color(0xFF1E2226),
    canvasColor: const Color(0xFF1E2226),
    dividerColor: Colors.white12,
    primaryColor: const Color(0xFF1890FF),
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      surfaceTintColor: Color(0xFF1E2226),
      backgroundColor: Color(0xFF1E2226),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1890FF),
      surface: Color(0xFF1E2226),
      onPrimary: Colors.white,
      onSurface: Colors.white,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins, color: Colors.white),
      bodyMedium: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins, color: Colors.white),
      bodySmall: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins, color: Colors.white70),
      displayLarge: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins, color: Colors.white),
      displayMedium: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins, color: Colors.white),
      displaySmall: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins, color: Colors.white),
      headlineLarge: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins, color: Colors.white),
      headlineMedium: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins, color: Colors.white),
      headlineSmall: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins, color: Colors.white),
      labelLarge: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins, color: Colors.white),
      labelMedium: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins, color: Colors.white),
      labelSmall: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins, color: Colors.white70),
      titleLarge: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins, color: Colors.white),
      titleMedium: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins, color: Colors.white),
      titleSmall: TextStyle(fontFamily: AppConstant.instance.fontFamilyPoppins, color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF262B30),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF383E45)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF1890FF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF383E45)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.instance.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.instance.error),
      ),
    ),
  );
}
