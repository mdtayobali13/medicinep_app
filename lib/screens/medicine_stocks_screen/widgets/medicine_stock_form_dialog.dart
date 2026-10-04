import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_text_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_dropdown_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_date_field.dart';

class MedicineStockFormDialog extends StatelessWidget {
  final bool isEdit;
  final String? initialName;
  final String? initialIndex;

  const MedicineStockFormDialog({
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
        width: 600, // Slightly narrower than Medicine form
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
                    isEdit ? "Edit Medicine Stocks" : "Add Medicine Stocks",
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
                    children: [
                      const Expanded(
                        child: MedicineTextField(
                          label: "Lot Memo Number",
                          hint: "Enter lot memo number",
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: MedicineDateField(
                          label: "Received Date",
                          hint: "Select date",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Row 2
                  Row(
                    children: const [
                      Expanded(
                        child: MedicineDropdownField(
                          label: "Medicine",
                          hint: "Select medicine",
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: MedicineTextField(
                          label: "Current stocks",
                          hint: "",
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Row 3
                  Row(
                    children: [
                      const Expanded(
                        child: MedicineTextField(
                          label: "Quantity (New stock)",
                          hint: "0",
                          initialValue: "0",
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: MedicineDateField(
                          label: "Expiry Date",
                          hint: "Select date",
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  Divider(height: 1, color: isDark ? Colors.white12 : const Color(0xFFEEEEEE)),
                  const SizedBox(height: 24),

                  // Footer Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Add Stock Button
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.add_circled, size: 18),
                        label: const Text("Add Stock"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.white70 : Colors.grey.shade800,
                          side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                      
                      // Save Button
                      ElevatedButton.icon(
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
                    ],
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
