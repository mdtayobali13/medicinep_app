import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:medicine_system/utils/app_log.dart';

class AppApiUrl {
  AppApiUrl._privateConstructor();
  static final AppApiUrl _instance = AppApiUrl._privateConstructor();
  static AppApiUrl get instance => _instance;

  static String get domain => _getDomain();
  static String get socket => _getDomain();
  String get baseUrl {
    final d = domain;
    return d.endsWith('/api') ? d : "$d/api";
  }

  // Auth & Profile
  String login = "/login";
  String register = "/register";
  String logout = "/logout";
  String forgotPassword = "/forgot-password";
  String authForgotPassword = "/forgot-password";
  String resetPassword = "/reset-password";
  String authResetPassword = "/reset-password";
  String changePassword = "/change-password";
  String userProfile = "/users/profile";
  String userRolePermissions = "/users/user-role-permissions";
  String refreshToken = "/refreshToken";
  String authDeleteAccount = "/authDeleteAccount";
  String user = "/users";
  String userResendOtp = "/userResendOtp";
  String authOtpVerify = "/authOtpVerify";
  String authVerifyEmail = "/authVerifyEmail";

  // Base rules / static info
  String about = "/rule/about";
  String privacyPolicy = "/rule/privacy-policy";
  String termsAndConditions = "/rule/terms-and-conditions";
  String faq = "/faq";
  String notification = "/notification";

  // Dashboard
  String dashboard = "/dashboard";

  // Address lookups
  String divisions = "/divisions";
  String districts(int divisionId) => "/divisions/$divisionId/districts";
  String upazilas(int districtId) => "/districts/$districtId/upazilas";
  String unions(int upazilaId) => "/upazilas/$upazilaId/unions";

  // Designations
  String designations = "/designations";
  String getAllDesignations = "/get-all-designations";

  // Police Units
  String policeUnits = "/police-units";
  String getAllPoliceUnits = "/get-all-police-units";

  // Categories
  String categories = "/categories";
  String getAllCategories = "/get-all-categories";

  // Medicine Units
  String medicineUnits = "/medicine-units";
  String getAllMedicineUnits = "/get-all-medicine-units";

  // Medicines
  String medicines = "/medicines";
  String getActiveMedicines = "/get-active-medicines";

  // Patients
  String patients = "/patients";
  String getRegularPatients = "/get-regular-patients";
  String patientWithMedicines(int id) => "/patient-with-medicines/$id";
  String spouses = "/spouses";
  String childrens = "/childrens";

  // Stocks
  String stocks = "/stocks";
  String stockReports = "/stock-reports";

  // Distributions
  String distributions = "/distributions";
  String localDistributions = "/localdistributions";

  // Alerts & Notifications
  String alertMessages = "/alert-messages";

  // Settings
  String websiteSettings = "/website-settings";

  // Users, Roles & Permissions
  String users = "/users";
  String roles = "/roles";
  String permissions = "/permissions";
}

String _getDomain({String baseKey = "BASE_URL"}) {
  String url = "https://medicinep-api.flitbd.com";
  try {
    url = dotenv.env[baseKey] ?? dotenv.env['BASE_URL_PROD'] ?? url;
  } catch (e) {
    errorLog("_getDomain", e);
  }

  // Automatic Android Emulator IP replacement for localhost if needed
  if (!kIsWeb && Platform.isAndroid && url.contains('localhost')) {
    url = url.replaceAll('localhost', '10.0.2.2').replaceAll('127.0.0.1', '10.0.2.2');
  }

  return url;
}
