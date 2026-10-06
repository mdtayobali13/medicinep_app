import 'package:flutter/material.dart';
import 'package:medicine_system/constant/app_colors.dart';
import 'package:medicine_system/main_app_entry.dart';
import 'package:medicine_system/routes/app_routes.dart';
import 'package:medicine_system/utils/app_log.dart';
import 'package:medicine_system/utils/app_size.dart';
import 'package:medicine_system/widgets/texts/app_text.dart';

class AppSnackBar {
  // -------- Singleton Setup --------
  AppSnackBar._privateConstructor();
  static final AppSnackBar instance = AppSnackBar._privateConstructor();

  BuildContext? get _context => rootNavigatorKey.currentContext;

  // -------- Snackbar Methods --------
  void error(String message, {bool showTop = true}) {
    try {
      if (showTop) {
        final overlay = appOverlayKey.currentState;
        if (overlay != null) {
          OverlayEntry overlayEntry = OverlayEntry(
            builder: (context) => Positioned(
              top: AppSize.width(value: 50),
              left: AppSize.width(value: 20),
              right: AppSize.width(value: 20),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(AppSize.width(value: 14)),
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          message,
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

          overlay.insert(overlayEntry);
          Future.delayed(const Duration(seconds: 3)).then((_) {
            if (overlayEntry.mounted) overlayEntry.remove();
          });
          return;
        }
      }

      final messenger = rootScaffoldMessengerKey.currentState ?? (_context != null ? ScaffoldMessenger.of(_context!) : null);
      messenger?.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20), vertical: AppSize.width(value: 20)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      );
    } catch (e) {
      errorLog("error", e);
    }
  }

  void success(String message, {Duration? duration, bool showTop = true}) {
    try {
      if (showTop) {
        final overlay = appOverlayKey.currentState;
        if (overlay != null) {
          OverlayEntry overlayEntry = OverlayEntry(
            builder: (context) => Positioned(
              top: AppSize.width(value: 50),
              left: AppSize.width(value: 20),
              right: AppSize.width(value: 20),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(AppSize.width(value: 14)),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ECA7F),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppText(
                          text: message,
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

          overlay.insert(overlayEntry);
          Future.delayed(duration ?? const Duration(seconds: 3)).then((_) {
            if (overlayEntry.mounted) overlayEntry.remove();
          });
          return;
        }
      }

      final messenger = rootScaffoldMessengerKey.currentState ?? (_context != null ? ScaffoldMessenger.of(_context!) : null);
      messenger?.showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF2ECA7F),
          duration: duration ?? const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20), vertical: AppSize.width(value: 20)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.width(value: 5))),
          content: AppText(text: message, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      );
    } catch (e) {
      errorLog("error", e);
    }
  }

  void message(String message, {Color? backgroundColor, Color? textColor, bool showTop = true}) {
    try {
      if (showTop) {
        final overlay = appOverlayKey.currentState;
        if (overlay != null) {
          OverlayEntry overlayEntry = OverlayEntry(
            builder: (context) => Positioned(
              top: AppSize.width(value: 50),
              left: AppSize.width(value: 20),
              right: AppSize.width(value: 20),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(AppSize.width(value: 14)),
                  decoration: BoxDecoration(
                    color: backgroundColor ?? AppColors.instance.dark300,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  child: AppText(text: message, color: textColor ?? AppColors.instance.white300, fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          );

          overlay.insert(overlayEntry);
          Future.delayed(const Duration(seconds: 3)).then((_) {
            if (overlayEntry.mounted) overlayEntry.remove();
          });
          return;
        }
      }

      final messenger = rootScaffoldMessengerKey.currentState ?? (_context != null ? ScaffoldMessenger.of(_context!) : null);
      messenger?.showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor ?? AppColors.instance.dark300,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20), vertical: AppSize.width(value: 20)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.width(value: 5))),
          content: AppText(text: message, color: textColor ?? AppColors.instance.white300, fontSize: 14, fontWeight: FontWeight.w400),
        ),
      );
    } catch (e) {
      errorLog("error", e);
    }
  }
}
