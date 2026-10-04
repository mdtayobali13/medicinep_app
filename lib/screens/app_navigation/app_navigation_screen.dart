import 'package:flutter/material.dart';
import 'package:medicine_system/constant/app_colors.dart';
import 'package:medicine_system/screens/app_navigation/widgets/premium_sidebar.dart';
import 'package:medicine_system/widgets/top_right_header_actions.dart';
import 'package:go_router/go_router.dart';

class AppNavigationScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigationScreen({super.key, required this.navigationShell});

  void _onTap(int index) {
    if (index < navigationShell.route.branches.length) {
      navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : AppColors.instance.black500),
        title: Text(
          "Medicine System",
          style: TextStyle(
              color: isDark ? Colors.white : AppColors.instance.black500,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        actions: const [
          TopRightHeaderActions(),
        ],
      ),
      drawer: Drawer(
        child: PremiumSidebar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            Navigator.pop(context); // Close drawer
            _onTap(index);
          },
        ),
      ),
      body: navigationShell,
    );
  }
}
