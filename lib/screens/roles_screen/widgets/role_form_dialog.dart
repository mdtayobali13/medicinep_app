import 'package:flutter/material.dart';

class RoleFormDialog extends StatefulWidget {
  final bool isEdit;
  final String? initialName;

  const RoleFormDialog({super.key, this.isEdit = false, this.initialName});

  @override
  State<RoleFormDialog> createState() => _RoleFormDialogState();
}

class _RoleFormDialogState extends State<RoleFormDialog> {
  late final TextEditingController _roleNameController;
  final Map<String, bool> _selectedPermissions = {};

  final Map<String, List<String>> _permissionGroups = {
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

  @override
  void initState() {
    super.initState();
    _roleNameController = TextEditingController(text: widget.initialName ?? '');
    
    // If edit mode and Super Admin, select all by default
    final bool defaultVal = widget.isEdit && (widget.initialName == "Super Admin");
    for (var group in _permissionGroups.values) {
      for (var item in group) {
        _selectedPermissions[item] = defaultVal;
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

                      // Permission Matrix Grid
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
                            children: _permissionGroups.entries.map((entry) {
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
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            widget.isEdit ? "Role updated successfully" : "Role created successfully",
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Save", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
    List<String> permissions,
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
              final bool isChecked = _selectedPermissions[permission] ?? false;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedPermissions[permission] = !isChecked;
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
                              _selectedPermissions[permission] = val ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          permission,
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
