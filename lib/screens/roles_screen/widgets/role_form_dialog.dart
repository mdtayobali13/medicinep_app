import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/providers/roles_provider.dart';
import 'package:medicine_system/models/role_permission_model.dart';
import 'package:medicine_system/utils/app_snack_bar.dart';

class RoleFormDialog extends ConsumerStatefulWidget {
  final bool isEdit;
  final RoleModel? initialRole;

  const RoleFormDialog({super.key, this.isEdit = false, this.initialRole});

  @override
  ConsumerState<RoleFormDialog> createState() => _RoleFormDialogState();
}

class _RoleFormDialogState extends ConsumerState<RoleFormDialog> {
  late final TextEditingController _roleNameController;
  final Map<int, bool> _selectedPermissions = {};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _roleNameController = TextEditingController(text: widget.initialRole?.name ?? '');
    
    if (widget.isEdit && widget.initialRole != null) {
      for (var perm in widget.initialRole!.permissions) {
        _selectedPermissions[perm.id] = true;
      }
    }
  }

  @override
  void dispose() {
    _roleNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rolesProvider);
    final allPermissions = state.permissions;
    
    // Group permissions by 'group'
    final Map<String, List<PermissionModel>> groupedPermissions = {};
    for (var perm in allPermissions) {
      final g = perm.group.isNotEmpty ? perm.group : 'General';
      groupedPermissions.putIfAbsent(g, () => []);
      groupedPermissions[g]!.add(perm);
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double dialogWidth = screenWidth > 900 ? 800 : screenWidth * 0.9;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final headerBg = isDark ? const Color(0xFF172554) : Colors.blue.shade50;
    final headerTextColor = isDark ? const Color(0xFF93C5FD) : Colors.blue.shade800;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardBg = isDark ? const Color(0xFF262B30) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF333A42) : Colors.grey.shade300;
    final fieldFillColor = isDark ? const Color(0xFF2A2F35) : Colors.white;

    return Dialog(
      backgroundColor: dialogBg,
      surfaceTintColor: dialogBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: dialogWidth,
        decoration: BoxDecoration(
          color: dialogBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dialog Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: headerBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isEdit ? "Edit Role" : "Add Role",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: headerTextColor,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, size: 20, color: headerTextColor),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Flexible(
              child: Container(
                color: dialogBg,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Role Name Input
                      Text(
                        "Name",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _roleNameController,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
                        decoration: InputDecoration(
                          hintText: "Enter role name",
                          hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.normal),
                          filled: true,
                          fillColor: fieldFillColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = 3;
                          if (constraints.maxWidth < 550) {
                            crossAxisCount = 1;
                          } else if (constraints.maxWidth < 750) {
                            crossAxisCount = 2;
                          }

                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: groupedPermissions.entries.map((entry) {
                              final double cardWidth = (constraints.maxWidth - ((crossAxisCount - 1) * 12)) / crossAxisCount;
                              return SizedBox(
                                width: cardWidth,
                                child: _buildPermissionGroupCard(entry.key, entry.value, isDark, cardBg, borderColor, textColor),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Dialog Footer Action
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: dialogBg,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : () async {
                      if (_roleNameController.text.trim().isEmpty) {
                        AppSnackBar.instance.error("Role name cannot be empty");
                        return;
                      }

                      final selectedIds = _selectedPermissions.entries
                          .where((e) => e.value)
                          .map((e) => e.key)
                          .toList();

                      final data = {
                        'name': _roleNameController.text.trim(),
                        'permissions': selectedIds,
                      };

                      setState(() => _isLoading = true);
                      bool success;
                      if (widget.isEdit && widget.initialRole != null) {
                        success = await ref.read(rolesProvider.notifier).updateRole(widget.initialRole!.id, data);
                      } else {
                        success = await ref.read(rolesProvider.notifier).createRole(data);
                      }
                      setState(() => _isLoading = false);

                      if (success && context.mounted) {
                        Navigator.pop(context);
                        AppSnackBar.instance.success(
                          widget.isEdit ? "Role updated successfully" : "Role created successfully",
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading 
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Save", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionGroupCard(
    String groupTitle,
    List<PermissionModel> permissions,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            groupTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: permissions.map((permission) {
              final bool isChecked = _selectedPermissions[permission.id] ?? false;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedPermissions[permission.id] = !isChecked;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: isChecked,
                          activeColor: const Color(0xFF10B981),
                          checkColor: Colors.white,
                          side: BorderSide(color: isDark ? Colors.white54 : Colors.grey.shade500, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                          onChanged: (bool? val) {
                            setState(() {
                              _selectedPermissions[permission.id] = val ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          permission.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
