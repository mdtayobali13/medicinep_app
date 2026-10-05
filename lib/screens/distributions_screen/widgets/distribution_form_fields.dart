import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:medicine_system/models/patient_model.dart';
import 'package:medicine_system/providers/patients_provider.dart';

class DistributionFormFields extends ConsumerWidget {
  final PatientModel? selectedPatient;
  final ValueChanged<PatientModel?> onPatientChanged;
  final String? selectedReceiver;
  final ValueChanged<String?> onReceiverChanged;
  final TextEditingController prescriptionController;
  final TextEditingController notesController;

  const DistributionFormFields({
    super.key,
    required this.selectedPatient,
    required this.onPatientChanged,
    required this.selectedReceiver,
    required this.onReceiverChanged,
    required this.prescriptionController,
    required this.notesController,
  });

  static const List<String> receiverList = ['Self', 'Parents', 'Spouse', 'Children'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientsState = ref.watch(patientsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white38 : Colors.grey.shade400;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;
    final containerBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final dropdownBg = isDark ? const Color(0xFF262B30) : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Patient Dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("BP/CIV Number or Name", style: TextStyle(fontSize: 13, color: textColor)),
            const SizedBox(height: 6),
            Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: containerBg,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<PatientModel>(
                  isExpanded: true,
                  value: selectedPatient,
                  hint: patientsState.isLoading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text("Select Patient", style: TextStyle(color: hintColor, fontSize: 13)),
                  iconStyleData: IconStyleData(
                    icon: Icon(Icons.keyboard_arrow_down, color: hintColor),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      color: dropdownBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  items: patientsState.list.map((patient) {
                    final displayStr = "${patient.bpNo != null && patient.bpNo!.isNotEmpty ? '${patient.bpNo} - ' : ''}${patient.name}";
                    return DropdownMenuItem<PatientModel>(
                      value: patient,
                      child: Text(
                        displayStr,
                        style: TextStyle(fontSize: 13, color: textColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: onPatientChanged,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Receiver Type Dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Receiver Type", style: TextStyle(fontSize: 13, color: textColor)),
            const SizedBox(height: 6),
            Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: containerBg,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  value: selectedReceiver,
                  hint: Text("Select Receiver", style: TextStyle(color: hintColor, fontSize: 13)),
                  iconStyleData: IconStyleData(
                    icon: Icon(Icons.keyboard_arrow_down, color: hintColor),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      color: dropdownBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  items: receiverList
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, style: TextStyle(fontSize: 13, color: textColor)),
                          ))
                      .toList(),
                  onChanged: onReceiverChanged,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Prescription Code
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Prescription Code", style: TextStyle(fontSize: 13, color: textColor)),
            const SizedBox(height: 6),
            SizedBox(
              height: 42,
              child: TextField(
                controller: prescriptionController,
                style: TextStyle(color: textColor, fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Enter prescription code",
                  hintStyle: TextStyle(color: hintColor, fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Notes
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Notes", style: TextStyle(fontSize: 13, color: textColor)),
            const SizedBox(height: 6),
            TextField(
              controller: notesController,
              maxLines: 3,
              style: TextStyle(color: textColor, fontSize: 13),
              decoration: InputDecoration(
                hintText: "Enter any notes",
                hintStyle: TextStyle(color: hintColor, fontSize: 13),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
