import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/providers/roles_provider.dart';
import 'package:medicine_system/models/role_permission_model.dart';
import 'package:medicine_system/screens/roles_screen/widgets/role_form_dialog.dart';
import 'package:medicine_system/screens/designations_screen/widgets/delete_confirmation_dialog.dart';

class RolesList extends ConsumerWidget {
  const RolesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rolesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;

    if (state.isLoading && state.roles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.roles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            state.error ?? "No roles found",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      child: Column(
        children: state.roles.asMap().entries.map((entry) {
          final index = entry.key;
          final role = entry.value;

          // Group permissions by 'group'
          final Map<String, List<String>> groupedPermissions = {};
          for (var perm in role.permissions) {
            final g = perm.group.isNotEmpty ? perm.group : 'General';
            groupedPermissions.putIfAbsent(g, () => []);
            groupedPermissions[g]!.add(perm.name);
          }

          return Column(
            children: [
              RoleExpandableItem(
                roleModel: role,
                permissions: groupedPermissions,
                initialExpanded: index == 0,
              ),
              if (index < state.roles.length - 1)
                Divider(height: 1, color: isDark ? Colors.grey.shade800 : const Color(0xFFEEEEEE)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class RoleExpandableItem extends StatefulWidget {
  final RoleModel roleModel;
  final Map<String, List<String>> permissions;
  final bool initialExpanded;

  const RoleExpandableItem({
    super.key,
    required this.roleModel,
    required this.permissions,
    this.initialExpanded = false,
  });

  @override
  State<RoleExpandableItem> createState() => _RoleExpandableItemState();
}

class _RoleExpandableItemState extends State<RoleExpandableItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Role Row Header
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        _isExpanded ? CupertinoIcons.chevron_down : CupertinoIcons.chevron_right,
                        size: 14,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.roleModel.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (!_isExpanded) _buildActionButtons(isDark),
              ],
            ),
          ),
        ),

        // Expanded Permission Details
        if (_isExpanded) ...[
          Padding(
            padding: const EdgeInsets.only(left: 36, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Permissions",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                for (var entry in widget.permissions.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: entry.value.map((permissionName) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2ECA7F),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                permissionName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButtons(isDark),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Consumer(
      builder: (context, ref, child) {
        return Row(
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
                  builder: (context) => RoleFormDialog(
                    isEdit: true,
                    initialRole: widget.roleModel,
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
                    onConfirm: () async {
                      final success = await ref.read(rolesProvider.notifier).deleteRole(widget.roleModel.id);
                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Role deleted successfully")),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
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
