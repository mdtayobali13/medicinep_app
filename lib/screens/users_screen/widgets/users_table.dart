import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/providers/admin_users_provider.dart';
import 'package:medicine_system/models/user_model.dart';
import 'package:medicine_system/screens/users_screen/widgets/users_top_bar.dart';
import 'package:medicine_system/screens/users_screen/widgets/user_form_dialog.dart';
import 'package:medicine_system/screens/designations_screen/widgets/delete_confirmation_dialog.dart';

class UsersTable extends ConsumerWidget {
  const UsersTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final state = ref.watch(adminUsersProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmallScreen = constraints.maxWidth < 800;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const UsersTopBar(),
            const SizedBox(height: 16),
            if (state.isLoading && state.users.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (state.users.isEmpty)
              Center(
                child: Text(
                  state.error ?? "No users found",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              )
            else if (isSmallScreen) ...[
              _buildMobileCards(context, ref, state.users, isDark),
            ] else ...[
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  ),
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
                        DataColumn(
                          label: Text(
                            'Sl',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: textColor,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: textColor,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Role',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: textColor,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Email',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: textColor,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'status',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: textColor,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Action',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                      rows: state.users.asMap().entries.map((entry) {
                        final index = entry.key;
                        final user = entry.value;
                        final sl = (index + 1).toString(); // or use paginated index
                        final role = user.roles.isNotEmpty ? user.roles.first : 'Unknown';
                        final statusStr = user.status?.toString() == '1' || user.status?.toString().toLowerCase() == 'active' ? 'Active' : 'Inactive';
                        return _buildRow(context, ref, user, sl, user.name, role, user.email, statusStr, isDark);
                      }).toList(),
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

  Widget _buildMobileCards(BuildContext context, WidgetRef ref, List<UserModel> users, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey.shade700;

    return Column(
      children: users.asMap().entries.map((entry) {
        final index = entry.key;
        final user = entry.value;
        final sl = (index + 1).toString();
        final role = user.roles.isNotEmpty ? user.roles.first : 'Unknown';
        final statusStr = user.status?.toString() == '1' || user.status?.toString().toLowerCase() == 'active' ? 'Active' : 'Inactive';
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2226) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 30 : 5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "#$sl ${user.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusBadge(statusStr),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Role: $role",
                style: TextStyle(fontSize: 12, color: subTextColor),
              ),
              Text(
                "Email: ${user.email}",
                style: TextStyle(fontSize: 12, color: subTextColor),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildActionBtn(
                    icon: CupertinoIcons.pencil,
                    color: isDark ? Colors.white : Colors.black87,
                    borderColor: isDark
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                    backgroundColor: isDark
                        ? const Color(0xFF262B30)
                        : Colors.white,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => UserFormDialog(
                          isEdit: true,
                          initialUser: user,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildActionBtn(
                    icon: CupertinoIcons.trash,
                    color: Colors.red.shade400,
                    borderColor: isDark
                        ? Colors.red.shade900
                        : Colors.red.shade200,
                    backgroundColor: isDark
                        ? const Color(0xFF262B30)
                        : Colors.white,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => DeleteConfirmationDialog(
                          onConfirm: () async {
                            final success = await ref.read(adminUsersProvider.notifier).deleteUser(user.id);
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("User deleted successfully"),
                                ),
                              );
                            }
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

  DataRow _buildRow(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
    String sl,
    String name,
    String role,
    String email,
    String status,
    bool isDark,
  ) {
    final subTextColor = isDark ? Colors.white70 : Colors.grey.shade700;

    return DataRow(
      cells: [
        DataCell(
          Text(
            sl,
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ),
        DataCell(
          Text(name, style: TextStyle(color: subTextColor, fontSize: 13)),
        ),
        DataCell(
          Text(role, style: TextStyle(color: subTextColor, fontSize: 13)),
        ),
        DataCell(
          Text(email, style: TextStyle(color: subTextColor, fontSize: 13)),
        ),
        DataCell(_buildStatusBadge(status)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionBtn(
                icon: CupertinoIcons.pencil,
                color: isDark ? Colors.white : Colors.black87,
                borderColor: isDark
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
                backgroundColor: isDark
                    ? const Color(0xFF262B30)
                    : Colors.white,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => UserFormDialog(
                      isEdit: true,
                      initialUser: user,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              _buildActionBtn(
                icon: CupertinoIcons.trash,
                color: Colors.red.shade400,
                borderColor: isDark ? Colors.red.shade900 : Colors.red.shade200,
                backgroundColor: isDark
                    ? const Color(0xFF262B30)
                    : Colors.white,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => DeleteConfirmationDialog(
                      onConfirm: () async {
                        final success = await ref.read(adminUsersProvider.notifier).deleteUser(user.id);
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("User deleted successfully"),
                            ),
                          );
                        }
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
