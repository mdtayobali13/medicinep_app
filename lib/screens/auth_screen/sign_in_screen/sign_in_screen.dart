import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/constant/app_asserts_image_path.dart';
import 'package:medicine_system/routes/app_routes.dart';
import 'package:medicine_system/routes/app_routes_key.dart';
import 'package:medicine_system/screens/auth_screen/sign_in_screen/provider/sign_in_provider.dart';
import 'package:medicine_system/services/storage/storage_services.dart';
import 'package:medicine_system/utils/app_log.dart';
import 'package:medicine_system/utils/app_snack_bar.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late TextEditingController emailTextEditingController;
  late TextEditingController passwordTextEditingController;
  late GlobalKey<FormState> formKey;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    emailTextEditingController = TextEditingController();
    passwordTextEditingController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  Future<void> checkLoginFunction() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      final response = await ref
          .read(signInProvider.notifier)
          .signIn(emailTextEditingController.text.trim(), passwordTextEditingController.text.trim());
      if (response) {
        AppRoutes.instance.go(AppRoutesKey.instance.homeScreen);
      } else {
        AppSnackBar.instance.error("Invalid email or password");
      }
    } catch (e) {
      errorLog("checkLoginFunction", e);
    }
  }

  Future<void> continueAsGuest() async {
    try {
      await StorageServices.instance.setAppRoll("GUEST");
      AppRoutes.instance.pushNamed(AppRoutesKey.instance.homeScreen);
    } catch (e) {
      errorLog("continueAsGuest", e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF10B981);
    const secondaryColor = Color(0xFF0D9488);

    final bgColor = isDark ? const Color(0xFF14171A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subTextColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    final fieldFillColor = isDark ? const Color(0xFF262B30) : const Color(0xFFF1F5F9);
    final fieldBorderColor = isDark ? const Color(0xFF333A42) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: isDark ? 0.35 : 0.2),
                            blurRadius: 25,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          AppAssertsImagePath.instance.logo,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              CupertinoIcons.bandage_fill,
                              size: 40,
                              color: primaryColor,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                   Text(
                    "Medicine System",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Welcome back! Sign in to access your dashboard",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: subTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 28),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? const Color(0xFF2D333B) : const Color(0xFFE2E8F0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email Address",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: emailTextEditingController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(color: textColor, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "admin@medicine.com",
                              hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey.shade400, fontSize: 13),
                              prefixIcon: const Icon(CupertinoIcons.mail, size: 18, color: primaryColor),
                              filled: true,
                              fillColor: fieldFillColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: fieldBorderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: fieldBorderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: primaryColor, width: 1.5),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Enter your email address";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: passwordTextEditingController,
                            obscureText: !isPasswordVisible,
                            textInputAction: TextInputAction.done,
                            style: TextStyle(color: textColor, fontSize: 14),
                            onFieldSubmitted: (_) => checkLoginFunction(),
                            decoration: InputDecoration(
                              hintText: "••••••••",
                              hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey.shade400, fontSize: 13),
                              prefixIcon: const Icon(CupertinoIcons.lock, size: 18, color: primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                                  size: 18,
                                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: fieldFillColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: fieldBorderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: fieldBorderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: primaryColor, width: 1.5),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Enter your password";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                AppRoutes.instance.pushNamed(AppRoutesKey.instance.forgotScreen);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),

                          Consumer(
                            builder: (context, ref, child) {
                              final isLoading = ref.watch(signInProvider);
                              return Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [primaryColor, secondaryColor],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withValues(alpha: 0.35),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : checkLoginFunction,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : const Text(
                                          "Login",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: OutlinedButton(
                              onPressed: continueAsGuest,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Browse as Guest",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 13, color: subTextColor),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          AppRoutes.instance.pushNamed(AppRoutesKey.instance.signUpScreen);
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
