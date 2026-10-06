import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  final TextEditingController spouseNameController;
  final TextEditingController parentNameController;
  final List<TextEditingController> childrenControllers;
  final VoidCallback onAddChild;
  final ValueChanged<int> onRemoveChild;

  const DistributionFormFields({
    super.key,
    required this.selectedPatient,
    required this.onPatientChanged,
    required this.selectedReceiver,
    required this.onReceiverChanged,
    required this.prescriptionController,
    required this.notesController,
    required this.spouseNameController,
    required this.parentNameController,
    required this.childrenControllers,
    required this.onAddChild,
    required this.onRemoveChild,
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

    final String receiver = selectedReceiver ?? 'Self';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Patient Dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("BP/CIV Number or Name", style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w600)),
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
            Text("Receiver Type", style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w600)),
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

        // Dynamic Fields based on Receiver Type
        if (receiver == 'Spouse') ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Spouse Name", style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              SizedBox(
                height: 42,
                child: TextField(
                  controller: spouseNameController,
                  style: TextStyle(color: textColor, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "Enter spouse name",
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
        ] else if (receiver == 'Parents') ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Parent Name", style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              SizedBox(
                height: 42,
                child: TextField(
                  controller: parentNameController,
                  style: TextStyle(color: textColor, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "Enter parent name (father / mother)",
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
        ] else if (receiver == 'Children') ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Children Names", style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w600)),
                  TextButton.icon(
                    onPressed: onAddChild,
                    icon: const Icon(CupertinoIcons.add, size: 14),
                    label: const Text("Add Child", style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue.shade600,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ...childrenControllers.asMap().entries.map((entry) {
                final idx = entry.key;
                final ctrl = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: TextField(
                            controller: ctrl,
                            style: TextStyle(color: textColor, fontSize: 13),
                            decoration: InputDecoration(
                              hintText: "Enter child #${idx + 1} name",
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
                      ),
                      if (childrenControllers.length > 1) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => onRemoveChild(idx),
                          icon: const Icon(CupertinoIcons.minus_circle_fill, color: Colors.red, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Prescription Code
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Prescription Code", style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w600)),
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
            Text("Notes", style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w600)),
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
