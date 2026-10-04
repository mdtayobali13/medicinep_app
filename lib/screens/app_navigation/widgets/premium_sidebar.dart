import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicine_system/constant/app_colors.dart';
import 'package:medicine_system/screens/app_navigation/widgets/sidebar_items.dart';
import 'package:medicine_system/screens/app_navigation/widgets/sidebar_collapsible.dart';
import 'package:go_router/go_router.dart';
import 'package:medicine_system/routes/app_routes_key.dart';

class PremiumSidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PremiumSidebar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  void _closeDrawerIfOpen(BuildContext context) {
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold != null && scaffold.isDrawerOpen) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sidebarBg = isDark ? const Color(0xFF1E2226) : Colors.white;

    return Material(
      color: sidebarBg,
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: sidebarBg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 15,
              offset: const Offset(4, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/icons/AppLogo.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Medicine System",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.instance.textBlack800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  SidebarNavItem(
                    isSelected:
                        currentIndex == 0 ||
                        GoRouterState.of(context).uri.toString().contains(
                          AppRoutesKey.instance.homeScreen,
                        ),
                    title: "Dashboard",
                    icon: CupertinoIcons.square_grid_2x2,
                    onTap: () {
                      _closeDrawerIfOpen(context);
                      final currentUri = GoRouterState.of(
                        context,
                      ).uri.toString();
                      if (!currentUri.contains(
                        AppRoutesKey.instance.homeScreen,
                      )) {
                        GoRouter.of(
                          context,
                        ).goNamed(AppRoutesKey.instance.homeScreen);
                      }
                      onTap(0);
                    },
                  ),
                  const SidebarSectionHeader(title: "Other tools"),
                  SidebarCollapsibleItem(
                    title: "Other Tools",
                    icon: CupertinoIcons.folder,
                    children: [
                      SidebarSubNavItem(
                        title: "Designations",
                        onTap: () {
                          _closeDrawerIfOpen(context);
                          GoRouter.of(
                            context,
                          ).pushNamed(AppRoutesKey.instance.designationsScreen);
                        },
                      ),
                      SidebarSubNavItem(
                        title: "Police Units",
                        onTap: () {
                          _closeDrawerIfOpen(context);
                          GoRouter.of(
                            context,
                          ).pushNamed(AppRoutesKey.instance.policeUnitsScreen);
                        },
                      ),
                      SidebarSubNavItem(
                        title: "Medicine Categories",
                        onTap: () {
                          _closeDrawerIfOpen(context);
                          GoRouter.of(context).pushNamed(
                            AppRoutesKey.instance.medicineCategoriesScreen,
                          );
                        },
                      ),
                      SidebarSubNavItem(
                        title: "Medicine Units",
                        onTap: () {
                          _closeDrawerIfOpen(context);
                          GoRouter.of(context).pushNamed(
                            AppRoutesKey.instance.medicineUnitsScreen,
                          );
                        },
                      ),
                    ],
                  ),
                  SidebarCollapsibleItem(
                    title: "Medicine",
                    icon: CupertinoIcons.drop,
                    children: [
                      SidebarSubNavItem(
                        title: "Medicine",
                        onTap: () {
                          _closeDrawerIfOpen(context);
                          GoRouter.of(
                            context,
                          ).pushNamed(AppRoutesKey.instance.medicineScreen);
                        },
                      ),
                      SidebarSubNavItem(
                        title: "Medicine Stocks",
                        onTap: () {
                          _closeDrawerIfOpen(context);
                          GoRouter.of(context).pushNamed(
                            AppRoutesKey.instance.medicineStocksScreen,
                          );
                        },
                      ),
                    ],
                  ),
                  SidebarNavItem(
                    isSelected: GoRouterState.of(context).uri
                        .toString()
                        .contains(AppRoutesKey.instance.patientsScreen),
                    title: "Patients",
                    icon: CupertinoIcons.person_2,
                    onTap: () {
                      _closeDrawerIfOpen(context);
                      GoRouter.of(
                        context,
                      ).pushNamed(AppRoutesKey.instance.patientsScreen);
                    },
                  ),
                  SidebarNavItem(
                    isSelected: GoRouterState.of(context).uri
                        .toString()
                        .contains(AppRoutesKey.instance.distributionsScreen),
                    title: "Local Distributions",
                    icon: CupertinoIcons.plus_app,
                    onTap: () {
                      _closeDrawerIfOpen(context);
                      final currentUri = GoRouterState.of(
                        context,
                      ).uri.toString();
                      if (!currentUri.contains(
                        AppRoutesKey.instance.distributionsScreen,
                      )) {
                        GoRouter.of(
                          context,
                        ).pushNamed(AppRoutesKey.instance.distributionsScreen);
                      }
                    },
                  ),
                  SidebarNavItem(
                    isSelected:
                        currentIndex == 4 ||
                        GoRouterState.of(context).uri.toString().contains(
                          AppRoutesKey.instance.stockReportsScreen,
                        ),
                    title: "Stock Reports",
                    icon: CupertinoIcons.doc_text,
                    onTap: () {
                      _closeDrawerIfOpen(context);
                      final currentUri = GoRouterState.of(
                        context,
                      ).uri.toString();
                      if (!currentUri.contains(
                        AppRoutesKey.instance.stockReportsScreen,
                      )) {
                        GoRouter.of(
                          context,
                        ).pushNamed(AppRoutesKey.instance.stockReportsScreen);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const SidebarSectionHeader(title: "System Control"),
                  SidebarCollapsibleItem(
                    title: "Authorized",
                    icon: CupertinoIcons.shield,
                    children: [
                      SidebarSubNavItem(
                        title: "Roles",
                        onTap: () {
                          _closeDrawerIfOpen(context);
                          GoRouter.of(
                            context,
                          ).pushNamed(AppRoutesKey.instance.rolesScreen);
                        },
                      ),
                      SidebarSubNavItem(
                        title: "Users",
                        onTap: () {
                          _closeDrawerIfOpen(context);
                          GoRouter.of(
                            context,
                          ).pushNamed(AppRoutesKey.instance.usersScreen);
                        },
                      ),
                    ],
                  ),
                  SidebarNavItem(
                    isSelected:
                        currentIndex == 5 ||
                        GoRouterState.of(context).uri.toString().contains(
                          AppRoutesKey.instance.notificationsScreen,
                        ),
                    title: "Notifications",
                    icon: CupertinoIcons.bell,
                    onTap: () {
                      _closeDrawerIfOpen(context);
                      final currentUri = GoRouterState.of(
                        context,
                      ).uri.toString();
                      if (!currentUri.contains(
                        AppRoutesKey.instance.notificationsScreen,
                      )) {
                        GoRouter.of(
                          context,
                        ).pushNamed(AppRoutesKey.instance.notificationsScreen);
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
