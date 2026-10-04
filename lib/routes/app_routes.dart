import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/error_handling_screen/error_screen/error_screen.dart';
import 'package:medicine_system/error_handling_screen/no_internet_screen/no_internet_screen.dart';
import 'package:medicine_system/error_handling_screen/not_found_screen/not_found_screen.dart';
import 'package:medicine_system/routes/app_routes_key.dart';
import 'package:medicine_system/routes/internet_check_provider.dart';
import 'package:medicine_system/screens/app_navigation/app_navigation_screen.dart';
import 'package:medicine_system/screens/auth_screen/forgot_screen/forgot_screen.dart';
import 'package:medicine_system/screens/auth_screen/on_board_screen/on_board_screen.dart';
import 'package:medicine_system/screens/auth_screen/sign_in_screen/sign_in_screen.dart';
import 'package:medicine_system/screens/auth_screen/sign_up_screen/sign_up_screen.dart';
import 'package:medicine_system/screens/auth_screen/sign_up_verify_screen/sign_up_verify_screen.dart';
import 'package:medicine_system/screens/base_screen/about_us_screen/about_us_screen.dart';
import 'package:medicine_system/screens/base_screen/faq_screen/faq_screen.dart';
import 'package:medicine_system/screens/base_screen/privacy_policy_screen/privacy_policy_screen.dart';
import 'package:medicine_system/screens/base_screen/terms_and_conditions_screen/terms_and_conditions_screen.dart';
import 'package:medicine_system/screens/home_screen/home_screen.dart';
import 'package:medicine_system/screens/profile_screen/profile_screen.dart';
import 'package:medicine_system/screens/splash_screen/splash_screen.dart';
import 'package:medicine_system/screens/designations_screen/designations_screen.dart';
import 'package:medicine_system/screens/police_units_screen/police_units_screen.dart';
import 'package:medicine_system/screens/medicine_categories_screen/medicine_categories_screen.dart';
import 'package:medicine_system/screens/medicine_units_screen/medicine_units_screen.dart';
import 'package:medicine_system/screens/medicine_screen/medicine_screen.dart';
import 'package:medicine_system/screens/medicine_stocks_screen/medicine_stocks_screen.dart';
import 'package:medicine_system/screens/patients_screen/patients_screen.dart';
import 'package:medicine_system/screens/distributions_screen/distributions_screen.dart';
import 'package:medicine_system/screens/stock_reports_screen/stock_reports_screen.dart';
import 'package:medicine_system/screens/roles_screen/roles_screen.dart';
import 'package:medicine_system/screens/users_screen/users_screen.dart';
import 'package:medicine_system/screens/notifications_screen/notifications_screen.dart';
import 'package:medicine_system/utils/app_log.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  ////////////// constructor
  AppRoutes._privateConstructor();
  static final AppRoutes _instance = AppRoutes._privateConstructor();
  static AppRoutes get instance => _instance;
  //////////////// routes

  GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppRoutesKey.instance.initial,
    routes: [
      /// initial routes
      GoRoute(path: AppRoutesKey.instance.initial, name: AppRoutesKey.instance.splash, builder: (context, state) => SplashScreen()),
      GoRoute(
        path: "/${AppRoutesKey.instance.noInternetScreen}",
        name: AppRoutesKey.instance.noInternetScreen,
        builder: (context, state) => NoInternetScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.notFoundScreen}",
        name: AppRoutesKey.instance.notFoundScreen,
        builder: (context, state) => NotFoundScreen(),
      ),
      GoRoute(path: "/${AppRoutesKey.instance.errorScreen}", name: AppRoutesKey.instance.errorScreen, builder: (context, state) => ErrorScreen()),
      ////// base routes
      GoRoute(path: "/${AppRoutesKey.instance.aboutScreen}", name: AppRoutesKey.instance.aboutScreen, builder: (context, state) => AboutUsScreen()),
      GoRoute(path: "/${AppRoutesKey.instance.faqsScreen}", name: AppRoutesKey.instance.faqsScreen, builder: (context, state) => FaqScreen()),
      GoRoute(
        path: "/${AppRoutesKey.instance.privacyPolicyScreen}",
        name: AppRoutesKey.instance.privacyPolicyScreen,
        builder: (context, state) => PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.termsAndConditionsScreen}",
        name: AppRoutesKey.instance.termsAndConditionsScreen,
        builder: (context, state) => TermsAndConditionsScreen(),
      ),

      ////// auth routes
      GoRoute(path: "/${AppRoutesKey.instance.signInScreen}", name: AppRoutesKey.instance.signInScreen, builder: (context, state) => SignInScreen()),
      GoRoute(path: "/${AppRoutesKey.instance.signUpScreen}", name: AppRoutesKey.instance.signUpScreen, builder: (context, state) => SignUpScreen()),
      GoRoute(
        path: "/${AppRoutesKey.instance.signUpVerifyScreen}",
        name: AppRoutesKey.instance.signUpVerifyScreen,
        builder: (context, state) => SignUpVerifyScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.onBoardScreen}",
        name: AppRoutesKey.instance.onBoardScreen,
        builder: (context, state) => OnBoardScreen(),
      ),

      GoRoute(path: "/${AppRoutesKey.instance.forgotScreen}", name: AppRoutesKey.instance.forgotScreen, builder: (context, state) => ForgotScreen()),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/${AppRoutesKey.instance.homeScreen}",
                name: AppRoutesKey.instance.homeScreen,
                builder: (context, state) => HomeScreen(),
              ),
            ],
          ),
        ],
      ),
      /////// other screen
      GoRoute(
        path: "/${AppRoutesKey.instance.profileScreen}",
        name: AppRoutesKey.instance.profileScreen,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.designationsScreen}",
        name: AppRoutesKey.instance.designationsScreen,
        builder: (context, state) => const DesignationsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.policeUnitsScreen}",
        name: AppRoutesKey.instance.policeUnitsScreen,
        builder: (context, state) => const PoliceUnitsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.medicineCategoriesScreen}",
        name: AppRoutesKey.instance.medicineCategoriesScreen,
        builder: (context, state) => const MedicineCategoriesScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.medicineUnitsScreen}",
        name: AppRoutesKey.instance.medicineUnitsScreen,
        builder: (context, state) => const MedicineUnitsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.medicineScreen}",
        name: AppRoutesKey.instance.medicineScreen,
        builder: (context, state) => const MedicineScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.medicineStocksScreen}",
        name: AppRoutesKey.instance.medicineStocksScreen,
        builder: (context, state) => const MedicineStocksScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.patientsScreen}",
        name: AppRoutesKey.instance.patientsScreen,
        builder: (context, state) => const PatientsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.distributionsScreen}",
        name: AppRoutesKey.instance.distributionsScreen,
        builder: (context, state) => const DistributionsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.stockReportsScreen}",
        name: AppRoutesKey.instance.stockReportsScreen,
        builder: (context, state) => const StockReportsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.rolesScreen}",
        name: AppRoutesKey.instance.rolesScreen,
        builder: (context, state) => const RolesScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.usersScreen}",
        name: AppRoutesKey.instance.usersScreen,
        builder: (context, state) => const UsersScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.notificationsScreen}",
        name: AppRoutesKey.instance.notificationsScreen,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
    errorBuilder: (context, state) {
      return NotFoundScreen();
    },
    redirect: (context, state) {
      final container = ProviderScope.containerOf(context, listen: false);
      final asyncStatus = container.read(internetStatusProvider);
      if (asyncStatus.isLoading) return null;
      if (asyncStatus.hasError) return "/${AppRoutesKey.instance.errorScreen}";
      final isOnline = asyncStatus.value ?? true;
      final goingToNoInternet = state.name == AppRoutesKey.instance.noInternetScreen;

      // Auth flow screens that should not be interrupted by connectivity changes
      final currentPath = state.uri.toString();
      final authPaths = [
        // AppRoutesKey.instance.signInScreen,
        // AppRoutesKey.instance.signUpScreen,
      ];
      final isInAuthFlow = authPaths.any((p) => currentPath.contains(p));

      // Don't redirect to noInternet if user is in the auth flow
      if (!isOnline && !goingToNoInternet && !isInAuthFlow) {
        return "/${AppRoutesKey.instance.noInternetScreen}";
      }
      // When internet comes back from noInternet screen, go to sign-in instead of splash
      if (isOnline && goingToNoInternet) {
        return "/${AppRoutesKey.instance.signInScreen}";
      }
      return null;
    },
  );

  ////////////////////. route operation start
  String _normalize(String value) => value.startsWith("/") ? value : "/$value";

  void go(String value) {
    try {
      router.go(_normalize(value));
    } catch (e) {
      errorLog("goNamed", e);
    }
  }

  void goNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
    String? fragment,
  }) {
    try {
      router.goNamed(value, pathParameters: pathParameters, extra: extra, fragment: fragment, queryParameters: queryParameters);
    } catch (e) {
      errorLog("goNamed", e);
    }
  }

  void replace(String value, {Object? extra}) {
    try {
      router.replace(_normalize(value), extra: extra);
    } catch (e) {
      errorLog("replaceNamed", e);
    }
  }

  void replaceNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.replaceNamed(value, pathParameters: pathParameters, extra: extra, queryParameters: queryParameters);
    } catch (e) {
      errorLog("replaceNamed", e);
    }
  }

  void push(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.push(_normalize(value), extra: extra);
    } catch (e) {
      errorLog("push", e);
    }
  }

  void pushNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.pushNamed(value, pathParameters: pathParameters, extra: extra, queryParameters: queryParameters);
    } catch (e) {
      errorLog("pushNamed", e);
    }
  }

  void pushReplacement(String value, {Object? extra}) {
    try {
      router.pushReplacement(_normalize(value), extra: extra);
    } catch (e) {
      errorLog("pushReplacement", e);
    }
  }

  void pushReplacementNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.pushReplacementNamed(value, pathParameters: pathParameters, extra: extra, queryParameters: queryParameters);
    } catch (e) {
      errorLog("pushReplacementNamed", e);
    }
  }

  void pop() {
    try {
      GoRouter.of(rootNavigatorKey.currentContext!).pop();
    } catch (e) {
      errorLog("pop", e);
    }
  }

  ////////////////////. route operation end
}
