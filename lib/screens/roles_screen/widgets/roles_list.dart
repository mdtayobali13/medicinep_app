import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicine_system/screens/roles_screen/widgets/role_form_dialog.dart';
import 'package:medicine_system/screens/designations_screen/widgets/delete_confirmation_dialog.dart';

class RolesList extends StatelessWidget {
  const RolesList({super.key});

  static final Map<String, List<String>> _superAdminPermissions = {
    'Dashboard': ['View Dashboard'],
    'User Management': ['Create User', 'Edit User', 'Delete User', 'View User'],
    'Role': ['Create Role', 'Edit Role', 'Delete Role', 'View Role', 'Assign Role'],
    'Permission': ['View Permission'],
    'Category': ['Create Category', 'Edit Category', 'Delete Category', 'View Category'],
    'Designation': ['Create Designation', 'Edit Designation', 'Delete Designation', 'View Designation'],
    'Distribution': ['Create Distribution', 'Edit Distribution', 'Delete Distribution', 'View Distribution'],
    'Medicine': ['Create Medicine', 'Edit Medicine', 'Delete Medicine', 'View Medicine', 'Assign Medicine'],
    'Medicine Unit': ['Create Medicine Unit', 'Edit Medicine Unit', 'Delete Medicine Unit', 'View Medicine Unit'],
    'Patient': ['Create Patient', 'Edit Patient', 'Delete Patient', 'View Patient', 'Assign Patient'],
    'Police Unit': ['Create Police Unit', 'Edit Police Unit', 'Delete Police Unit', 'View Police Unit'],
    'Stock': ['Create Stock', 'Edit Stock', 'Delete Stock', 'View Stock'],
    'Website Setting': ['View Website Setting'],
  };

  static final Map<String, List<String>> _distributorPermissions = {
    'Dashboard': ['View Dashboard'],
    'Distribution': ['Create Distribution', 'Edit Distribution', 'View Distribution'],
    'Medicine': ['View Medicine'],
    'Stock': ['View Stock'],
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2226) : Colors.white;

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
        children: [
          RoleExpandableItem(
            roleName: "Super Admin",
            permissions: _superAdminPermissions,
            initialExpanded: true,
          ),
          Divider(height: 1, color: isDark ? Colors.grey.shade800 : const Color(0xFFEEEEEE)),
          RoleExpandableItem(
            roleName: "Distributor",
            permissions: _distributorPermissions,
            initialExpanded: false,
          ),
        ],
      ),
    );
  }
}

class RoleExpandableItem extends StatefulWidget {
  final String roleName;
  final Map<String, List<String>> permissions;
  final bool initialExpanded;

  const RoleExpandableItem({
    super.key,
    required this.roleName,
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
                          widget.roleName,
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
                initialName: widget.roleName,
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
                    const SnackBar(content: Text("Role deleted successfully")),
                  );
                },
              ),
            );
          },
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
