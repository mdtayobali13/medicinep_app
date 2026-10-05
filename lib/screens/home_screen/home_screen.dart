import 'package:flutter/material.dart';
import 'package:medicine_system/constant/app_colors.dart';
import 'package:medicine_system/screens/home_screen/widgets/dashboard_stats_grid.dart';
import 'package:medicine_system/screens/home_screen/widgets/dashboard_chart_placeholder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Overview",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.instance.textBlack800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "App summary",
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : AppColors.instance.textBlack400,
              ),
            ),
            const SizedBox(height: 16),
            const DashboardStatsGrid(),
            const DashboardChartPlaceholder(title: "Medicine Overview (Line Chart)"),
            const DashboardChartPlaceholder(title: "Medicine Overview (Pie Chart)", isPieChart: true),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
