import 'package:flutter/material.dart';
import 'package:medicine_system/constant/app_colors.dart';

class SidebarCollapsibleItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SidebarCollapsibleItem({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white70 : AppColors.instance.textBlack500;
    final textColor = isDark ? Colors.white : AppColors.instance.textBlack600;

    return Material(
      color: Colors.transparent,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: const EdgeInsets.only(left: 20),
          leading: Icon(icon, size: 20, color: iconColor),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          iconColor: iconColor,
          collapsedIconColor: iconColor,
          children: children,
        ),
      ),
    );
  }
}

class SidebarSubNavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SidebarSubNavItem({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isDark ? Colors.white54 : AppColors.instance.gray300,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : AppColors.instance.textBlack500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
