import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/routes/app_routes_key.dart';
import 'package:medicine_system/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class TopRightHeaderActions extends ConsumerWidget {
  const TopRightHeaderActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNotificationBell(context, isDark),
          const SizedBox(width: 16),
          const UserProfileDropdown(),
        ],
      ),
    );
  }

  Widget _buildNotificationBell(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () {
        final currentUri = GoRouterState.of(context).uri.toString();
        if (!currentUri.contains(AppRoutesKey.instance.notificationsScreen)) {
          GoRouter.of(context).pushNamed(AppRoutesKey.instance.notificationsScreen);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(CupertinoIcons.bell, size: 22, color: isDark ? Colors.white70 : Colors.grey.shade700),
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFFF4D4F),
                shape: BoxShape.circle,
              ),
              child: const Text(
                '2',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfileDropdown extends ConsumerStatefulWidget {
  const UserProfileDropdown({super.key});

  @override
  ConsumerState<UserProfileDropdown> createState() => _UserProfileDropdownState();
}

class _UserProfileDropdownState extends ConsumerState<UserProfileDropdown> {
  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return MenuAnchor(
      controller: _menuController,
      alignmentOffset: const Offset(-80, 8),
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(cardBg),
        surfaceTintColor: WidgetStatePropertyAll(cardBg),
        elevation: const WidgetStatePropertyAll(8),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 8)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          ),
        ),
      ),
      builder: (context, controller, child) {
        return InkWell(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                child: const Icon(CupertinoIcons.person_fill, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Admin User',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'Super Admin',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Icon(CupertinoIcons.chevron_down, size: 12, color: isDark ? Colors.white60 : Colors.grey.shade600),
            ],
          ),
        );
      },
      menuChildren: [
        InkWell(
          onTap: () {
            _menuController.close();
            final currentUri = GoRouterState.of(context).uri.toString();
            if (!currentUri.contains(AppRoutesKey.instance.profileScreen)) {
              GoRouter.of(context).pushNamed(AppRoutesKey.instance.profileScreen);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(CupertinoIcons.person, size: 16, color: textColor),
                const SizedBox(width: 10),
                Text('Profile', style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            ref.read(themeProvider.notifier).toggleTheme();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isDark ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill,
                      size: 16,
                      color: textColor,
                    ),
                    const SizedBox(width: 10),
                    Text('Theme', style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(width: 16),
                _buildRealtimeThemeTogglePill(ref, isDark),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
        ),
        InkWell(
          onTap: () {
            _menuController.close();
            GoRouter.of(context).goNamed(AppRoutesKey.instance.signInScreen);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(CupertinoIcons.square_arrow_right, size: 16, color: Color(0xFFFF4D4F)),
                SizedBox(width: 10),
                Text('Logout', style: TextStyle(fontSize: 13, color: Color(0xFFFF4D4F), fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRealtimeThemeTogglePill(WidgetRef ref, bool isDark) {
    const activeColor = Color(0xFF1890FF);

    return Container(
      height: 30,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF262B30) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              ref.read(themeProvider.notifier).setDarkMode(false);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: !isDark ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: !isDark
                    ? [
                        BoxShadow(
                          color: activeColor.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                !isDark ? CupertinoIcons.sun_max_fill : CupertinoIcons.sun_max,
                size: 14,
                color: !isDark ? Colors.white : Colors.grey.shade500,
              ),
            ),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            onTap: () {
              ref.read(themeProvider.notifier).setDarkMode(true);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isDark
                    ? [
                        BoxShadow(
                          color: activeColor.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isDark ? CupertinoIcons.moon_fill : CupertinoIcons.moon,
                size: 14,
                color: isDark ? Colors.white : Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
