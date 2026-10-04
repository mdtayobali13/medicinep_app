import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_form_personal_section.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_form_job_section.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_form_physical_section.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_form_address_section.dart';

class PatientFormDialog extends StatelessWidget {
  final bool isEdit;
  final Map<String, String>? initialData;
  
  const PatientFormDialog({super.key, this.isEdit = false, this.initialData});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final headerBg = isDark ? const Color(0xFF262B30) : Colors.blue.shade50.withValues(alpha: 0.5);
    final headerTitleColor = isDark ? Colors.lightBlueAccent : Colors.blue.shade800;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: dialogBg,
      surfaceTintColor: dialogBg,
      insetPadding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 16, vertical: 24),
      child: Container(
        width: 900,
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: headerBg,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(isEdit ? "Edit Patient" : "Add Patient", style: TextStyle(color: headerTitleColor, fontSize: 18, fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(CupertinoIcons.clear, size: 20, color: isDark ? Colors.white70 : Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    PatientFormPersonalSection(isDesktop: isDesktop, initialData: initialData),
                    const SizedBox(height: 16),
                    PatientFormJobSection(isDesktop: isDesktop, initialData: initialData),
                    const SizedBox(height: 16),
                    PatientFormPhysicalSection(isDesktop: isDesktop, initialData: initialData),
                    const SizedBox(height: 16),
                    PatientFormAddressSection(
                      isDesktop: isDesktop,
                      initialData: initialData,
                      prefix: 'present_',
                      title: "Present Address",
                      villageLabel: "Present Village:",
                      backgroundColor: isDark ? const Color(0xFF262B30) : Colors.grey.shade50,
                    ),
                    const SizedBox(height: 16),
                    PatientFormAddressSection(
                      isDesktop: isDesktop,
                      initialData: initialData,
                      prefix: 'permanent_',
                      title: "Permanent Address",
                      villageLabel: "Permanent Village:",
                      backgroundColor: isDark ? const Color(0xFF262B30) : Colors.indigo.shade50.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Text(isEdit ? "Update Patient" : "Save Patient", style: const TextStyle(fontWeight: FontWeight.bold)),
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
