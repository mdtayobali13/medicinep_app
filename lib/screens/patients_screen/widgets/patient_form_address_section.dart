import 'package:flutter/material.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_text_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_dropdown_field.dart';
import 'package:medicine_system/screens/patients_screen/widgets/section_container.dart';

class PatientFormAddressSection extends StatelessWidget {
  final bool isDesktop;
  final String title;
  final String villageLabel;
  final Color backgroundColor;
  final TextEditingController villageController;
  final String? selectedDivision;
  final ValueChanged<String?>? onDivisionChanged;
  final String? selectedDistrict;
  final ValueChanged<String?>? onDistrictChanged;
  final String? selectedUpazila;
  final ValueChanged<String?>? onUpazilaChanged;
  final String? selectedUnion;
  final ValueChanged<String?>? onUnionChanged;

  const PatientFormAddressSection({
    super.key,
    required this.isDesktop,
    required this.title,
    required this.villageLabel,
    required this.backgroundColor,
    required this.villageController,
    this.selectedDivision,
    this.onDivisionChanged,
    this.selectedDistrict,
    this.onDistrictChanged,
    this.selectedUpazila,
    this.onUpazilaChanged,
    this.selectedUnion,
    this.onUnionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: title,
      backgroundColor: backgroundColor,
      child: isDesktop ? _buildDesktop(context) : _buildMobile(context),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white70 : Colors.grey.shade800;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MedicineDropdownField<String>(
                label: "Division",
                hint: "Select division",
                value: selectedDivision,
                items: ['Dhaka', 'Chittagong', 'Rajshahi', 'Khulna', 'Barisal', 'Sylhet', 'Rangpur', 'Mymensingh']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onDivisionChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MedicineDropdownField<String>(
                label: "District",
                hint: "Select district",
                value: selectedDistrict,
                items: ['Dhaka', 'Gazipur', 'Narayanganj', 'Chittagong', 'Comilla']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onDistrictChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MedicineDropdownField<String>(
                label: "Upazila",
                hint: "Select upazila",
                value: selectedUpazila,
                items: ['Mirpur', 'Dhanmondi', 'Gulshan', 'Uttara', 'Savar']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onUpazilaChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MedicineDropdownField<String>(
                label: "Union",
                hint: "Select union",
                value: selectedUnion,
                items: ['Union 1', 'Union 2', 'Union 3']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onUnionChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(
              width: 140,
              child: Text(villageLabel, style: TextStyle(color: labelColor, fontSize: 13)),
            ),
            Expanded(child: MedicineTextField(label: "", hint: "Enter village / house details", controller: villageController)),
          ],
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      children: [
        MedicineDropdownField<String>(
          label: "Division",
          hint: "Select division",
          value: selectedDivision,
          items: ['Dhaka', 'Chittagong', 'Rajshahi', 'Khulna', 'Barisal', 'Sylhet', 'Rangpur', 'Mymensingh']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onDivisionChanged,
        ),
        const SizedBox(height: 16),
        MedicineDropdownField<String>(
          label: "District",
          hint: "Select district",
          value: selectedDistrict,
          items: ['Dhaka', 'Gazipur', 'Narayanganj', 'Chittagong', 'Comilla']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onDistrictChanged,
        ),
        const SizedBox(height: 16),
        MedicineDropdownField<String>(
          label: "Upazila",
          hint: "Select upazila",
          value: selectedUpazila,
          items: ['Mirpur', 'Dhanmondi', 'Gulshan', 'Uttara', 'Savar']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onUpazilaChanged,
        ),
        const SizedBox(height: 16),
        MedicineDropdownField<String>(
          label: "Union",
          hint: "Select union",
          value: selectedUnion,
          items: ['Union 1', 'Union 2', 'Union 3']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onUnionChanged,
        ),
        const SizedBox(height: 16),
        MedicineTextField(label: villageLabel, hint: "Enter village / house details", controller: villageController),
      ],
    );
  }
}
