import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/models/designation_model.dart';
import 'package:medicine_system/models/police_unit_model.dart';
import 'package:medicine_system/providers/designations_provider.dart';
import 'package:medicine_system/providers/police_units_provider.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_text_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_dropdown_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_date_field.dart';
import 'package:medicine_system/screens/patients_screen/widgets/section_container.dart';

class PatientFormJobSection extends ConsumerWidget {
  final bool isDesktop;
  final TextEditingController bpNoController;
  final TextEditingController workPlaceController;
  final TextEditingController phoneController;
  final PoliceUnitModel? selectedPoliceUnit;
  final ValueChanged<PoliceUnitModel?> onPoliceUnitChanged;
  final DesignationModel? selectedDesignation;
  final ValueChanged<DesignationModel?> onDesignationChanged;
  final String? selectedStatus;
  final ValueChanged<String?> onStatusChanged;
  final TextEditingController joiningDateController;

  const PatientFormJobSection({
    super.key,
    required this.isDesktop,
    required this.bpNoController,
    required this.workPlaceController,
    required this.phoneController,
    required this.selectedPoliceUnit,
    required this.onPoliceUnitChanged,
    required this.selectedDesignation,
    required this.onDesignationChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.joiningDateController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policeUnitsState = ref.watch(policeUnitsProvider);
    final designationsState = ref.watch(designationsProvider);

    return SectionContainer(
      title: "Job information",
      backgroundColor: Colors.green.shade50.withValues(alpha: 0.5),
      child: isDesktop
          ? _buildDesktop(context, policeUnitsState, designationsState)
          : _buildMobile(context, policeUnitsState, designationsState),
    );
  }

  Widget _buildDesktop(BuildContext context, PoliceUnitsState policeUnitsState, DesignationsState designationsState) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: MedicineTextField(label: "BP number", hint: "Enter BP number", controller: bpNoController)),
            const SizedBox(width: 16),
            Expanded(child: MedicineTextField(label: "Work place", hint: "Enter workplace", controller: workPlaceController)),
            const SizedBox(width: 16),
            Expanded(child: MedicineTextField(label: "Phone number", hint: "Enter phone number", controller: phoneController)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: MedicineDropdownField<PoliceUnitModel>(
                label: "Police unit",
                hint: "Select unit",
                value: selectedPoliceUnit,
                isLoading: policeUnitsState.isLoading,
                items: policeUnitsState.list
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ))
                    .toList(),
                onChanged: onPoliceUnitChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MedicineDropdownField<DesignationModel>(
                label: "Designation",
                hint: "Select designation",
                value: selectedDesignation,
                isLoading: designationsState.isLoading,
                items: designationsState.list
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ))
                    .toList(),
                onChanged: onDesignationChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MedicineDropdownField<String>(
                label: "Employee status",
                hint: "Select status",
                value: selectedStatus,
                items: ['Active', 'Retired', 'Resigned']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onStatusChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: MedicineDateField(label: "Joining date", hint: "Select date", initialValue: joiningDateController.text)),
          ],
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context, PoliceUnitsState policeUnitsState, DesignationsState designationsState) {
    return Column(
      children: [
        MedicineTextField(label: "BP number", hint: "Enter BP number", controller: bpNoController),
        const SizedBox(height: 16),
        MedicineTextField(label: "Work place", hint: "Enter workplace", controller: workPlaceController),
        const SizedBox(height: 16),
        MedicineTextField(label: "Phone number", hint: "Enter phone number", controller: phoneController),
        const SizedBox(height: 16),
        MedicineDropdownField<PoliceUnitModel>(
          label: "Police unit",
          hint: "Select unit",
          value: selectedPoliceUnit,
          isLoading: policeUnitsState.isLoading,
          items: policeUnitsState.list
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.name),
                  ))
              .toList(),
          onChanged: onPoliceUnitChanged,
        ),
        const SizedBox(height: 16),
        MedicineDropdownField<DesignationModel>(
          label: "Designation",
          hint: "Select designation",
          value: selectedDesignation,
          isLoading: designationsState.isLoading,
          items: designationsState.list
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.name),
                  ))
              .toList(),
          onChanged: onDesignationChanged,
        ),
        const SizedBox(height: 16),
        MedicineDropdownField<String>(
          label: "Employee status",
          hint: "Select status",
          value: selectedStatus,
          items: ['Active', 'Retired', 'Resigned']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onStatusChanged,
        ),
        const SizedBox(height: 16),
        MedicineDateField(label: "Joining date", hint: "Select date", initialValue: joiningDateController.text),
      ],
    );
  }
}
