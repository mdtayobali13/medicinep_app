class AppRoutesKey {
  ////////////// constructor
  AppRoutesKey._privateConstructor();
  static final AppRoutesKey _instance = AppRoutesKey._privateConstructor();
  static AppRoutesKey get instance => _instance;
  //////////////// routes
  /// initial routes

  final String initial = "/";
  final String splash = "/";
  final String onBoardScreen = "onboardScreen";
  final String notFoundScreen = "notFoundScreen";
  final String errorScreen = "errorScreen";
  final String noInternetScreen = "noInternetScreen";

  /// base routes
  final String aboutScreen = "aboutScreen";
  final String faqsScreen = "faqScreen";
  final String privacyPolicyScreen = "privacyPolicyScreen";
  final String termsAndConditionsScreen = "termsAndConditionsScreen";

  ////////////// auth
  final String signInScreen = "signInScreen";
  final String signUpScreen = "signUPScreen";
  final String forgotScreen = "forgotScreen";
  final String signUpVerifyScreen = "signUpVerifyScreen";
  final String createNewPasswordScreen = "createNewPasswordScreen";
  final String changePasswordScreen = "changePasswordScreen";

  /////////////// app navigation
  final String homeScreen = "homeScreen";
  final String profileScreen = "profileScreen";
  final String designationsScreen = "designationsScreen";
  final String policeUnitsScreen = "policeUnitsScreen";
  final String medicineCategoriesScreen = "medicineCategoriesScreen";
  final String medicineUnitsScreen = "medicineUnitsScreen";
  final String medicineScreen = "medicineScreen";
  final String medicineStocksScreen = "medicineStocksScreen";
  final String patientsScreen = "patientsScreen";
  final String distributionsScreen = "distributionsScreen";
  final String stockReportsScreen = "stockReportsScreen";
  final String rolesScreen = "rolesScreen";
  final String usersScreen = "usersScreen";
  final String notificationsScreen = "notificationsScreen";
}
