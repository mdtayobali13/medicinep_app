import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicine_system/screens/users_screen/widgets/users_top_bar.dart';
import 'package:medicine_system/screens/users_screen/widgets/user_form_dialog.dart';
import 'package:medicine_system/screens/designations_screen/widgets/delete_confirmation_dialog.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 800;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const UsersTopBar(),
            const SizedBox(height: 16),
            if (isSmallScreen) ...[
              _buildMobileCards(context, isDark),
            ] else ...[
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 30 : 5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        isDark ? const Color(0xFF262B30) : Colors.grey.shade100,
                      ),
                      dataRowMaxHeight: 56,
                      dataRowMinHeight: 56,
                      columns: [
                        DataColumn(label: Text('Sl', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor))),
                        DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor))),
                        DataColumn(label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor))),
                        DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor))),
                        DataColumn(label: Text('status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor))),
                        DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor))),
                      ],
                      rows: [
                        _buildRow(context, '1', 'Admin User', 'Super Admin', 'admin@example.com', 'Active', isDark),
                        _buildRow(context, '2', 'mizan', 'Distributor', 'spnaogaon@police.gov.bd', 'Active', isDark),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildMobileCards(BuildContext context, bool isDark) {
    final List<Map<String, String>> users = [
      {'sl': '1', 'name': 'Admin User', 'role': 'Super Admin', 'email': 'admin@example.com', 'status': 'Active'},
      {'sl': '2', 'name': 'mizan', 'role': 'Distributor', 'email': 'spnaogaon@police.gov.bd', 'status': 'Active'},
    ];
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey.shade700;

    return Column(
      children: users.map((user) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2226) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 30 : 5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "#${user['sl']} ${user['name']}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                  ),
                  _buildStatusBadge(user['status']!),
                ],
              ),
              const SizedBox(height: 6),
              Text("Role: ${user['role']}", style: TextStyle(fontSize: 13, color: subTextColor)),
              Text("Email: ${user['email']}", style: TextStyle(fontSize: 13, color: subTextColor)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildActionBtn(
                    icon: CupertinoIcons.pencil,
                    color: isDark ? Colors.white : Colors.black87,
                    borderColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                    backgroundColor: isDark ? const Color(0xFF262B30) : Colors.white,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => UserFormDialog(
                          isEdit: true,
                          initialName: user['name'],
                          initialRole: user['role'],
                          initialEmail: user['email'],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildActionBtn(
                    icon: CupertinoIcons.trash,
                    color: Colors.red.shade400,
                    borderColor: isDark ? Colors.red.shade900 : Colors.red.shade200,
                    backgroundColor: isDark ? const Color(0xFF262B30) : Colors.white,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => DeleteConfirmationDialog(
                          onConfirm: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("User deleted successfully")),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  DataRow _buildRow(BuildContext context, String sl, String name, String role, String email, String status, bool isDark) {
    final subTextColor = isDark ? Colors.white70 : Colors.grey.shade700;

    return DataRow(
      cells: [
        DataCell(Text(sl, style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600, fontSize: 13))),
        DataCell(Text(name, style: TextStyle(color: subTextColor, fontSize: 13))),
        DataCell(Text(role, style: TextStyle(color: subTextColor, fontSize: 13))),
        DataCell(Text(email, style: TextStyle(color: subTextColor, fontSize: 13))),
        DataCell(_buildStatusBadge(status)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionBtn(
                icon: CupertinoIcons.pencil,
                color: isDark ? Colors.white : Colors.black87,
                borderColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                backgroundColor: isDark ? const Color(0xFF262B30) : Colors.white,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => UserFormDialog(
                      isEdit: true,
                      initialName: name,
                      initialRole: role,
                      initialEmail: email,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              _buildActionBtn(
                icon: CupertinoIcons.trash,
                color: Colors.red.shade400,
                borderColor: isDark ? Colors.red.shade900 : Colors.red.shade200,
                backgroundColor: isDark ? const Color(0xFF262B30) : Colors.white,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => DeleteConfirmationDialog(
                      onConfirm: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User deleted successfully")),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF2ECA7F),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          status,
          style: const TextStyle(
            color: Color(0xFF2ECA7F),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn({
    required IconData icon,
    required Color color,
    required Color borderColor,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6),
        color: backgroundColor,
      ),
      child: IconButton(
        icon: Icon(icon, size: 16, color: color),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        onPressed: onTap,
      ),
    );
  }
}
