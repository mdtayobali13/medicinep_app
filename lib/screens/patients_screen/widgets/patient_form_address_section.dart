import 'package:flutter/material.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_text_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_dropdown_field.dart';
import 'package:medicine_system/screens/patients_screen/widgets/section_container.dart';

class PatientFormAddressSection extends StatelessWidget {
  final bool isDesktop;
  final String title;
  final String villageLabel;
  final Color backgroundColor;
  final Map<String, String>? initialData;
  final String prefix; // 'present_' or 'permanent_'

  const PatientFormAddressSection({
    super.key,
    required this.isDesktop,
    required this.title,
    required this.villageLabel,
    required this.backgroundColor,
    this.initialData,
    this.prefix = '',
  });

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: title,
      backgroundColor: backgroundColor,
      child: isDesktop ? _buildDesktop() : _buildMobile(),
    );
  }

  Widget _buildDesktop() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: MedicineDropdownField(label: "Division", hint: "", initialValue: initialData?['${prefix}division'])),
            const SizedBox(width: 16),
            Expanded(child: MedicineDropdownField(label: "District", hint: "", initialValue: initialData?['${prefix}district'])),
            const SizedBox(width: 16),
            Expanded(child: MedicineDropdownField(label: "Upazila", hint: "", initialValue: initialData?['${prefix}upazila'])),
            const SizedBox(width: 16),
            Expanded(child: MedicineDropdownField(label: "Union", hint: "", initialValue: initialData?['${prefix}union'])),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(
              width: 140, // Label on the left
              child: Text(villageLabel, style: TextStyle(color: Colors.grey.shade800, fontSize: 13)),
            ),
            Expanded(child: MedicineTextField(label: "", hint: "", initialValue: initialData?['${prefix}village'])),
          ],
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      children: [
        MedicineDropdownField(label: "Division", hint: "", initialValue: initialData?['${prefix}division']),
        const SizedBox(height: 16),
        MedicineDropdownField(label: "District", hint: "", initialValue: initialData?['${prefix}district']),
        const SizedBox(height: 16),
        MedicineDropdownField(label: "Upazila", hint: "", initialValue: initialData?['${prefix}upazila']),
        const SizedBox(height: 16),
        MedicineDropdownField(label: "Union", hint: "", initialValue: initialData?['${prefix}union']),
        const SizedBox(height: 16),
        MedicineTextField(label: villageLabel, hint: "", initialValue: initialData?['${prefix}village']),
      ],
    );
  }
}

