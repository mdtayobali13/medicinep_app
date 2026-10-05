import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/models/patient_model.dart';
import 'package:medicine_system/providers/patients_provider.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_form_personal_section.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_form_job_section.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_form_physical_section.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_form_address_section.dart';

class PatientFormDialog extends ConsumerStatefulWidget {
  final bool isEdit;
  final PatientModel? item;
  final Map<String, String>? initialData;

  const PatientFormDialog({
    super.key,
    this.isEdit = false,
    this.item,
    this.initialData,
  });

  @override
  ConsumerState<PatientFormDialog> createState() => _PatientFormDialogState();
}

class _PatientFormDialogState extends ConsumerState<PatientFormDialog> {
  bool _isSaving = false;

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);

    final Map<String, dynamic> data = {
      'name': widget.initialData?['name'] ?? widget.item?.name ?? 'Patient',
      'bp_no': widget.initialData?['bp_number'] ?? widget.item?.bpNo ?? '',
      'mobile': widget.initialData?['phone'] ?? widget.item?.mobile ?? '',
      'patient_type': widget.initialData?['status'] ?? widget.item?.patientType ?? 'Regular',
    };

    bool success = false;
    if (widget.isEdit && widget.item != null) {
      success = await ref.read(patientsProvider.notifier).updatePatient(widget.item!.id, data);
    } else {
      success = await ref.read(patientsProvider.notifier).createPatient(data);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save patient record.')),
        );
      }
    }
  }

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
                  Text(
                    widget.isEdit ? "Edit Patient" : "Add Patient",
                    style: TextStyle(color: headerTitleColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
                    PatientFormPersonalSection(isDesktop: isDesktop, initialData: widget.initialData),
                    const SizedBox(height: 16),
                    PatientFormJobSection(isDesktop: isDesktop, initialData: widget.initialData),
                    const SizedBox(height: 16),
                    PatientFormPhysicalSection(isDesktop: isDesktop, initialData: widget.initialData),
                    const SizedBox(height: 16),
                    PatientFormAddressSection(
                      isDesktop: isDesktop,
                      initialData: widget.initialData,
                      prefix: 'present_',
                      title: "Present Address",
                      villageLabel: "Present Village:",
                      backgroundColor: isDark ? const Color(0xFF262B30) : Colors.grey.shade50,
                    ),
                    const SizedBox(height: 16),
                    PatientFormAddressSection(
                      isDesktop: isDesktop,
                      initialData: widget.initialData,
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
                    onPressed: _isSaving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            widget.isEdit ? "Update Patient" : "Save Patient",
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
