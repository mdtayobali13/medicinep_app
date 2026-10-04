import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'form_fields/medicine_image_upload.dart';
import 'form_fields/medicine_text_field.dart';
import 'form_fields/medicine_dropdown_field.dart';

class MedicineFormDialog extends StatelessWidget {
  final bool isEdit;
  final String? initialName;
  final String? initialIndex;

  const MedicineFormDialog({
    super.key,
    this.isEdit = false,
    this.initialName,
    this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final headerBg = isDark ? const Color(0xFF262B30) : const Color(0xFFE2E8F0);
    final headerTextColor = isDark ? Colors.lightBlueAccent : Colors.blue.shade900;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: dialogBg,
      surfaceTintColor: dialogBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    isEdit ? "Edit Medicine" : "Add Medicine",
                    style: TextStyle(
                      color: headerTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(CupertinoIcons.clear, size: 20, color: isDark ? Colors.white70 : Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // Form Fields
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MedicineImageUpload(),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          children: [
                            MedicineTextField(label: "Name", hint: "Enter medicine name", initialValue: initialName),
                            const SizedBox(height: 16),
                            const MedicineDropdownField(label: "Category", hint: "Select a category"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Row 2
                  Row(
                    children: const [
                      Expanded(child: MedicineDropdownField(label: "Medicine Unit", hint: "Select a medicine unit")),
                      SizedBox(width: 24),
                      Expanded(child: MedicineTextField(label: "Alert Quantity", hint: "Enter alert quantity")),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Row 3
                  Row(
                    children: const [
                      Expanded(child: MedicineTextField(label: "Expiration Reminder Days", hint: "Enter days")),
                      SizedBox(width: 24),
                      Expanded(child: MedicineTextField(label: "Origin", hint: "Enter origin")),
                      SizedBox(width: 24),
                      Expanded(child: MedicineDropdownField(label: "Status", hint: "Select status")),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(CupertinoIcons.floppy_disk, size: 18),
                      label: const Text("Save"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
