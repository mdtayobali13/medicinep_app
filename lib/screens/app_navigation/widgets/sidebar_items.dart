import 'package:flutter/material.dart';
import 'package:medicine_system/constant/app_colors.dart';

class SidebarSectionHeader extends StatelessWidget {
  final String title;
  const SidebarSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 20, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white54 : AppColors.instance.gray300,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class SidebarNavItem extends StatelessWidget {
  final bool isSelected;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SidebarNavItem({
    super.key,
    required this.isSelected,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.instance.blue.withValues(alpha: 0.25) : AppColors.instance.blue.withValues(alpha: 0.1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? AppColors.instance.blue
                  : (isDark ? Colors.white70 : AppColors.instance.textBlack500),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.instance.blue
                    : (isDark ? Colors.white : AppColors.instance.textBlack600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
