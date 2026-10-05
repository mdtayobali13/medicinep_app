import 'package:flutter/material.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_text_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_dropdown_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_date_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_image_upload.dart';
import 'package:medicine_system/screens/patients_screen/widgets/section_container.dart';

class PatientFormPersonalSection extends StatelessWidget {
  final bool isDesktop;
  final TextEditingController nameController;
  final TextEditingController nidController;
  final TextEditingController fatherController;
  final TextEditingController motherController;
  final TextEditingController dobController;
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;
  final String? selectedMaritalStatus;
  final ValueChanged<String?> onMaritalStatusChanged;

  const PatientFormPersonalSection({
    super.key,
    required this.isDesktop,
    required this.nameController,
    required this.nidController,
    required this.fatherController,
    required this.motherController,
    required this.dobController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.selectedMaritalStatus,
    required this.onMaritalStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: "Personal Information",
      backgroundColor: Colors.transparent,
      child: isDesktop ? _buildDesktop() : _buildMobile(),
    );
  }

  Widget _buildDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MedicineImageUpload(),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: MedicineTextField(label: "Name", hint: "Enter full name", controller: nameController)),
                  const SizedBox(width: 16),
                  Expanded(child: MedicineTextField(label: "NID number", hint: "Enter NID number", controller: nidController)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: MedicineTextField(label: "Father's Name", hint: "Enter father's name", controller: fatherController)),
                  const SizedBox(width: 16),
                  Expanded(child: MedicineTextField(label: "Mother's Name", hint: "Enter mother's name", controller: motherController)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: MedicineDateField(label: "Date of Birth", hint: "Select date", initialValue: dobController.text)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MedicineDropdownField<String>(
                      label: "Gender",
                      hint: "Select gender",
                      value: selectedGender,
                      items: ['Male', 'Female', 'Other']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: onGenderChanged,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MedicineDropdownField<String>(
                      label: "Marital status",
                      hint: "Select marital status",
                      value: selectedMaritalStatus,
                      items: ['Single', 'Married', 'Divorced', 'Widowed']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: onMaritalStatusChanged,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      children: [
        const MedicineImageUpload(),
        const SizedBox(height: 16),
        MedicineTextField(label: "Name", hint: "Enter full name", controller: nameController),
        const SizedBox(height: 16),
        MedicineTextField(label: "NID number", hint: "Enter NID number", controller: nidController),
        const SizedBox(height: 16),
        MedicineTextField(label: "Father's Name", hint: "Enter father's name", controller: fatherController),
        const SizedBox(height: 16),
        MedicineTextField(label: "Mother's Name", hint: "Enter mother's name", controller: motherController),
        const SizedBox(height: 16),
        MedicineDateField(label: "Date of Birth", hint: "Select date", initialValue: dobController.text),
        const SizedBox(height: 16),
        MedicineDropdownField<String>(
          label: "Gender",
          hint: "Select gender",
          value: selectedGender,
          items: ['Male', 'Female', 'Other']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onGenderChanged,
        ),
        const SizedBox(height: 16),
        MedicineDropdownField<String>(
          label: "Marital status",
          hint: "Select marital status",
          value: selectedMaritalStatus,
          items: ['Single', 'Married', 'Divorced', 'Widowed']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onMaritalStatusChanged,
        ),
      ],
    );
  }
}
