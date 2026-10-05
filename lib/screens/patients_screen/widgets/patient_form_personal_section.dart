import 'package:flutter/material.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_text_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_dropdown_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_date_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_image_upload.dart';
import 'package:medicine_system/screens/patients_screen/widgets/section_container.dart';

class PatientFormPersonalSection extends StatelessWidget {
  final bool isDesktop;
  final Map<String, String>? initialData;

  const PatientFormPersonalSection({super.key, required this.isDesktop, this.initialData});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: "Job information",
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
                  Expanded(child: MedicineTextField(label: "Name", hint: "", initialValue: initialData?['name'])),
                  const SizedBox(width: 16),
                  Expanded(child: MedicineTextField(label: "NID number", hint: "", initialValue: initialData?['nid'])),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: MedicineTextField(label: "Father's Name", hint: "", initialValue: initialData?['father'])),
                  const SizedBox(width: 16),
                  Expanded(child: MedicineTextField(label: "Mother's Name", hint: "", initialValue: initialData?['mother'])),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: MedicineDateField(label: "Date of Birth", hint: "Select date", initialValue: initialData?['dob'])),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MedicineDropdownField<String>(
                      label: "Gender",
                      hint: "Select gender",
                      value: initialData?['gender'],
                      items: ['Male', 'Female', 'Other']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MedicineDropdownField<String>(
                      label: "Marital status",
                      hint: "Select marital status",
                      value: initialData?['marital'],
                      items: ['Single', 'Married', 'Divorced', 'Widowed']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
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
        MedicineTextField(label: "Name", hint: "", initialValue: initialData?['name']),
        const SizedBox(height: 16),
        MedicineTextField(label: "NID number", hint: "", initialValue: initialData?['nid']),
        const SizedBox(height: 16),
        MedicineTextField(label: "Father's Name", hint: "", initialValue: initialData?['father']),
        const SizedBox(height: 16),
        MedicineTextField(label: "Mother's Name", hint: "", initialValue: initialData?['mother']),
        const SizedBox(height: 16),
        MedicineDateField(label: "Date of Birth", hint: "Select date", initialValue: initialData?['dob']),
        const SizedBox(height: 16),
        MedicineDropdownField<String>(
          label: "Gender",
          hint: "Select gender",
          value: initialData?['gender'],
          items: ['Male', 'Female', 'Other']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),
        const SizedBox(height: 16),
        MedicineDropdownField<String>(
          label: "Marital status",
          hint: "Select marital status",
          value: initialData?['marital'],
          items: ['Single', 'Married', 'Divorced', 'Widowed']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),
      ],
    );
  }
}

