import 'package:flutter/material.dart';
import 'package:medicine_system/routes/app_routes.dart';
import 'package:medicine_system/routes/app_routes_key.dart';
import 'package:medicine_system/services/storage/storage_services.dart';
import 'package:medicine_system/utils/app_log.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final token = await StorageServices.instance.getToken();
      appLog("SplashScreen token check: '${token.isNotEmpty ? 'Token Found' : 'No Token'}'");
      if (token.isNotEmpty) {
        AppRoutes.instance.go(AppRoutesKey.instance.homeScreen);
      } else {
        AppRoutes.instance.go(AppRoutesKey.instance.signInScreen);
      }
    } catch (e) {
      errorLog("_checkAuthAndNavigate", e);
      AppRoutes.instance.go(AppRoutesKey.instance.signInScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2226) : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.3 : 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/icons/AppLogo.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.local_hospital_rounded,
                      size: 50,
                      color: Color(0xFF10B981),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Medicine System",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
