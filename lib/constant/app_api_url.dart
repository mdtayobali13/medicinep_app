import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:medicine_system/utils/app_log.dart';

class AppApiUrl {
  AppApiUrl._privateConstructor();
  static final AppApiUrl _instance = AppApiUrl._privateConstructor();
  static AppApiUrl get instance => _instance;
  //////////////  app base api end point

  static final String domain = _getDomain();
  static final String socket = _getDomain();
  final String baseUrl = "$domain/api/v1";

  //////////////////////////////////  base
  String refreshToken = "/refreshToken";
  String userProfile = "/user/profile";
  String about = "/rule/about";
  String privacyPolicy = "/rule/privacy-policy";
  String termsAndConditions = "/rule/terms-and-conditions";
  String faq = "/faq";
  String notification = "/notification";
  ////////////
  String login = "/login";
  String authDeleteAccount = "/authDeleteAccount";
  String user = "/user";
  String changePassword = "/changePassword";
  String userResendOtp = "/userResendOtp";
  String authOtpVerify = "/authOtpVerify";
  String authForgotPassword = "/authForgotPassword";
  String authVerifyEmail = "/authVerifyEmail";
  String authResetPassword = "/authResetPassword";
}

String _getDomain({String baseKey = "BASE_URL"}) {
  String baseUrl = "https://api.yourapp.com";
  try {
    return dotenv.env[baseKey] ?? baseUrl;
  } catch (e) {
    errorLog("_getDomain", e);
  }
  return baseUrl;
}
