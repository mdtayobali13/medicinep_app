import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicine_system/screens/medicine_categories_screen/widgets/medicine_category_form_dialog.dart';
import 'package:medicine_system/screens/medicine_categories_screen/widgets/delete_confirmation_dialog.dart';

class MedicineCategoriesTable extends StatelessWidget {
  const MedicineCategoriesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildListCard(context, "1", "Naek", "16", "11-04-2025"),
        _buildListCard(context, "2", "Constable", "17", "11-04-2025"),
        _buildListCard(context, "3", "ASI(AB)", "18", "30-05-2025"),
        _buildListCard(context, "4", "ASI(UB)", "19", "30-05-2025"),
        _buildListCard(context, "5", "SI", "20", "30-05-2025"),
        _buildListCard(context, "6", "Inspector", "21", "30-05-2025"),
        _buildListCard(context, "7", "Inspector(AB)", "22", "30-05-2025"),
        _buildListCard(context, "8", "Inspector(UB)", "23", "30-05-2025"),
        _buildListCard(context, "9", "ASP", "24", "30-05-2025"),
        _buildListCard(context, "10", "SASP", "25", "30-05-2025"),
      ],
    );
  }

  Widget _buildListCard(BuildContext context, String sl, String name, String index, String createdAt) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey.shade600;
    final iconColor = isDark ? Colors.white54 : Colors.grey.shade500;
    final circleBg = isDark ? const Color(0xFF262B30) : const Color(0xFFF0FDF4);
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade100;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          // SL Circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: circleBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                sl,
                style: const TextStyle(
                  color: Color(0xFF2ECC71),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Main Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(CupertinoIcons.tag, size: 14, color: iconColor),
                    const SizedBox(width: 4),
                    Text(
                      "Index: $index",
                      style: TextStyle(fontSize: 13, color: subTextColor),
                    ),
                    const SizedBox(width: 12),
                    Icon(CupertinoIcons.calendar, size: 14, color: iconColor),
                    const SizedBox(width: 4),
                    Text(
                      createdAt,
                      style: TextStyle(fontSize: 13, color: subTextColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                CupertinoIcons.pencil, 
                Colors.blue.shade700, 
                isDark ? Colors.blue.withValues(alpha: 0.2) : Colors.blue.shade50, 
                () {
                  showDialog(
                    context: context,
                    builder: (context) => MedicineCategoryFormDialog(
                      isEdit: true,
                      initialName: name,
                      initialIndex: index,
                    ),
                  );
                }
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                CupertinoIcons.trash, 
                Colors.red.shade700, 
                isDark ? Colors.red.withValues(alpha: 0.2) : Colors.red.shade50, 
                () {
                  showDialog(
                    context: context,
                    builder: (context) => DeleteConfirmationDialog(
                      onConfirm: () {
                        // Delete logic here
                      },
                    ),
                  );
                }
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color iconColor, Color bgColor, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
      ),
    );
  }
}
