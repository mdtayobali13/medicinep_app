import 'package:flutter/material.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_text_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_dropdown_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_date_field.dart';
import 'package:medicine_system/screens/patients_screen/widgets/section_container.dart';

class PatientFormJobSection extends StatelessWidget {
  final bool isDesktop;
  final Map<String, String>? initialData;

  const PatientFormJobSection({super.key, required this.isDesktop, this.initialData});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: "Job information",
      backgroundColor: Colors.green.shade50.withValues(alpha: 0.5),
      child: isDesktop ? _buildDesktop() : _buildMobile(),
    );
  }

  Widget _buildDesktop() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: MedicineTextField(label: "BP number", hint: "", initialValue: initialData?['bp_number'])),
            const SizedBox(width: 16),
            Expanded(child: MedicineTextField(label: "Work place", hint: "", initialValue: initialData?['work_place'])),
            const SizedBox(width: 16),
            Expanded(child: MedicineTextField(label: "Phone number", hint: "", initialValue: initialData?['phone'])),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: MedicineDropdownField(label: "Police unit", hint: "", initialValue: initialData?['police_unit'])),
            const SizedBox(width: 16),
            Expanded(child: MedicineDropdownField(label: "Designation", hint: "", initialValue: initialData?['designation'])),
            const SizedBox(width: 16),
            Expanded(child: MedicineDropdownField(label: "Employee status", hint: "", initialValue: initialData?['status'])),
            const SizedBox(width: 16),
            Expanded(child: MedicineDateField(label: "Joining date", hint: "Select date", initialValue: initialData?['joining_date'])),
          ],
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      children: [
        MedicineTextField(label: "BP number", hint: "", initialValue: initialData?['bp_number']),
        const SizedBox(height: 16),
        MedicineTextField(label: "Work place", hint: "", initialValue: initialData?['work_place']),
        const SizedBox(height: 16),
        MedicineTextField(label: "Phone number", hint: "", initialValue: initialData?['phone']),
        const SizedBox(height: 16),
        MedicineDropdownField(label: "Police unit", hint: "", initialValue: initialData?['police_unit']),
        const SizedBox(height: 16),
        MedicineDropdownField(label: "Designation", hint: "", initialValue: initialData?['designation']),
        const SizedBox(height: 16),
        MedicineDropdownField(label: "Employee status", hint: "", initialValue: initialData?['status']),
        const SizedBox(height: 16),
        MedicineDateField(label: "Joining date", hint: "Select date", initialValue: initialData?['joining_date']),
      ],
    );
  }
}

