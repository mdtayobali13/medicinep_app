import 'package:flutter/material.dart';
import 'package:medicine_system/constant/app_colors.dart';

class DashboardChartPlaceholder extends StatelessWidget {
  final String title;

  const DashboardChartPlaceholder({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      height: 250,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2226) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.instance.textBlack800,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Chart Data",
                style: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
