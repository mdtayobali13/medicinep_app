import 'package:flutter/material.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_text_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_dropdown_field.dart';
import 'package:medicine_system/screens/patients_screen/widgets/section_container.dart';

class PatientFormPhysicalSection extends StatelessWidget {
  final bool isDesktop;
  final Map<String, String>? initialData;

  const PatientFormPhysicalSection({super.key, required this.isDesktop, this.initialData});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: "Physical Attributes",
      backgroundColor: Colors.blue.shade50.withValues(alpha: 0.5),
      child: isDesktop ? _buildDesktop() : _buildMobile(),
    );
  }

  Widget _buildDesktop() {
    return Row(
      children: [
        Expanded(
          child: MedicineDropdownField<String>(
            label: "Blood group",
            hint: "Select blood group",
            value: initialData?['blood_group'],
            items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: MedicineTextField(label: "Height (ft)", hint: "", initialValue: initialData?['height'])),
        const SizedBox(width: 16),
        Expanded(child: MedicineTextField(label: "Weight (kg)", hint: "", initialValue: initialData?['weight'])),
        const SizedBox(width: 16),
        Expanded(child: MedicineTextField(label: "Eyesight", hint: "", initialValue: initialData?['eyesight'])),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      children: [
        MedicineDropdownField<String>(
          label: "Blood group",
          hint: "Select blood group",
          value: initialData?['blood_group'],
          items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),
        const SizedBox(height: 16),
        MedicineTextField(label: "Height (ft)", hint: "", initialValue: initialData?['height']),
        const SizedBox(height: 16),
        MedicineTextField(label: "Weight (kg)", hint: "", initialValue: initialData?['weight']),
        const SizedBox(height: 16),
        MedicineTextField(label: "Eyesight", hint: "", initialValue: initialData?['eyesight']),
      ],
    );
  }
}
