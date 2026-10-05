import 'package:flutter/material.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_text_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_dropdown_field.dart';
import 'package:medicine_system/screens/patients_screen/widgets/section_container.dart';

class PatientFormPhysicalSection extends StatelessWidget {
  final bool isDesktop;
  final String? selectedBloodGroup;
  final ValueChanged<String?> onBloodGroupChanged;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController eyesightController;

  const PatientFormPhysicalSection({
    super.key,
    required this.isDesktop,
    required this.selectedBloodGroup,
    required this.onBloodGroupChanged,
    required this.heightController,
    required this.weightController,
    required this.eyesightController,
  });

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
            value: selectedBloodGroup,
            items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onBloodGroupChanged,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: MedicineTextField(label: "Height (ft)", hint: "Enter height", controller: heightController)),
        const SizedBox(width: 16),
        Expanded(child: MedicineTextField(label: "Weight (kg)", hint: "Enter weight", controller: weightController)),
        const SizedBox(width: 16),
        Expanded(child: MedicineTextField(label: "Eyesight", hint: "Enter eyesight", controller: eyesightController)),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      children: [
        MedicineDropdownField<String>(
          label: "Blood group",
          hint: "Select blood group",
          value: selectedBloodGroup,
          items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onBloodGroupChanged,
        ),
        const SizedBox(height: 16),
        MedicineTextField(label: "Height (ft)", hint: "Enter height", controller: heightController),
        const SizedBox(height: 16),
        MedicineTextField(label: "Weight (kg)", hint: "Enter weight", controller: weightController),
        const SizedBox(height: 16),
        MedicineTextField(label: "Eyesight", hint: "Enter eyesight", controller: eyesightController),
      ],
    );
  }
}
