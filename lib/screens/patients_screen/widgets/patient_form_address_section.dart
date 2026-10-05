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
            Expanded(
              child: MedicineDropdownField<String>(
                label: "Division",
                hint: "Select division",
                value: initialData?['${prefix}division'],
                items: ['Dhaka', 'Chittagong', 'Rajshahi'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MedicineDropdownField<String>(
                label: "District",
                hint: "Select district",
                value: initialData?['${prefix}district'],
                items: ['District 1', 'District 2'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MedicineDropdownField<String>(
                label: "Upazila",
                hint: "Select upazila",
                value: initialData?['${prefix}upazila'],
                items: ['Upazila 1', 'Upazila 2'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MedicineDropdownField<String>(
                label: "Union",
                hint: "Select union",
                value: initialData?['${prefix}union'],
                items: ['Union 1', 'Union 2'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              ),
            ),
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
        MedicineDropdownField<String>(
          label: "Division",
          hint: "Select division",
          value: initialData?['${prefix}division'],
          items: ['Dhaka', 'Chittagong', 'Rajshahi'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        ),
        const SizedBox(height: 16),
        MedicineDropdownField<String>(
          label: "District",
          hint: "Select district",
          value: initialData?['${prefix}district'],
          items: ['District 1', 'District 2'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        ),
        const SizedBox(height: 16),
        MedicineDropdownField<String>(
          label: "Upazila",
          hint: "Select upazila",
          value: initialData?['${prefix}upazila'],
          items: ['Upazila 1', 'Upazila 2'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        ),
        const SizedBox(height: 16),
        MedicineDropdownField<String>(
          label: "Union",
          hint: "Select union",
          value: initialData?['${prefix}union'],
          items: ['Union 1', 'Union 2'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        ),
        const SizedBox(height: 16),
        MedicineTextField(label: villageLabel, hint: "", initialValue: initialData?['${prefix}village']),
      ],
    );
  }
}
