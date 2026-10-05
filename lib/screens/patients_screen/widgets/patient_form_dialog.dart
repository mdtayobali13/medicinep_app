import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_system/models/designation_model.dart';
import 'package:medicine_system/models/patient_model.dart';
import 'package:medicine_system/models/police_unit_model.dart';
import 'package:medicine_system/providers/designations_provider.dart';
import 'package:medicine_system/providers/patients_provider.dart';
import 'package:medicine_system/providers/police_units_provider.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_form_personal_section.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_form_job_section.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_form_physical_section.dart';
import 'package:medicine_system/screens/patients_screen/widgets/patient_form_address_section.dart';

class PatientFormDialog extends ConsumerStatefulWidget {
  final bool isEdit;
  final PatientModel? item;
  final Map<String, String>? initialData;

  const PatientFormDialog({
    super.key,
    this.isEdit = false,
    this.item,
    this.initialData,
  });

  @override
  ConsumerState<PatientFormDialog> createState() => _PatientFormDialogState();
}

class _PatientFormDialogState extends ConsumerState<PatientFormDialog> {
  bool _isSaving = false;

  late TextEditingController _nameController;
  late TextEditingController _nidController;
  late TextEditingController _fatherController;
  late TextEditingController _motherController;
  late TextEditingController _dobController;
  String? _selectedGender;
  String? _selectedMaritalStatus;

  late TextEditingController _bpNoController;
  late TextEditingController _workPlaceController;
  late TextEditingController _phoneController;
  PoliceUnitModel? _selectedPoliceUnit;
  DesignationModel? _selectedDesignation;
  String? _selectedEmployeeStatus = 'Active';
  late TextEditingController _joiningDateController;

  String? _selectedBloodGroup;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _eyesightController;

  late TextEditingController _presentVillageController;
  late TextEditingController _permanentVillageController;

  @override
  void initState() {
    super.initState();
    final p = widget.item;
    final d = widget.initialData;

    _nameController = TextEditingController(text: d?['name'] ?? p?.name ?? '');
    _nidController = TextEditingController(text: d?['nid'] ?? '');
    _fatherController = TextEditingController(text: d?['father'] ?? '');
    _motherController = TextEditingController(text: d?['mother'] ?? '');
    _dobController = TextEditingController(text: d?['dob'] ?? p?.dob ?? '');
    _selectedGender = d?['gender'] ?? p?.gender;
    _selectedMaritalStatus = d?['marital'];

    _bpNoController = TextEditingController(text: d?['bp_number'] ?? p?.bpNo ?? '');
    _workPlaceController = TextEditingController(text: d?['work_place'] ?? '');
    _phoneController = TextEditingController(text: d?['phone'] ?? p?.mobile ?? '');
    _selectedPoliceUnit = p?.policeUnit;
    _selectedDesignation = p?.designation;
    _selectedEmployeeStatus = d?['status'] ?? 'Active';
    _joiningDateController = TextEditingController(text: d?['joining_date'] ?? '');

    _selectedBloodGroup = d?['blood_group'];
    _heightController = TextEditingController(text: d?['height'] ?? '');
    _weightController = TextEditingController(text: d?['weight'] ?? '');
    _eyesightController = TextEditingController(text: d?['eyesight'] ?? '');

    _presentVillageController = TextEditingController(text: d?['present_village'] ?? p?.address ?? '');
    _permanentVillageController = TextEditingController(text: d?['permanent_village'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nidController.dispose();
    _fatherController.dispose();
    _motherController.dispose();
    _dobController.dispose();
    _bpNoController.dispose();
    _workPlaceController.dispose();
    _phoneController.dispose();
    _joiningDateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _eyesightController.dispose();
    _presentVillageController.dispose();
    _permanentVillageController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter patient name.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    // Try finding selected police unit or designation from providers if only ID matches
    final policeUnitsList = ref.read(policeUnitsProvider).list;
    final designationsList = ref.read(designationsProvider).list;

    final selectedUnit = _selectedPoliceUnit ??
        (widget.item?.policeUnitId != null
            ? policeUnitsList.where((e) => e.id == widget.item!.policeUnitId).firstOrNull
            : null);

    final selectedDesig = _selectedDesignation ??
        (widget.item?.designationId != null
            ? designationsList.where((e) => e.id == widget.item!.designationId).firstOrNull
            : null);

    final Map<String, dynamic> data = {
      'name': name,
      'bp_no': _bpNoController.text.trim(),
      'mobile': _phoneController.text.trim(),
      'phone_number': _phoneController.text.trim(),
      'patient_type': widget.item?.patientType ?? 'Regular',
      if (selectedUnit != null) 'police_unit_id': selectedUnit.id,
      if (selectedDesig != null) 'designation_id': selectedDesig.id,
      if (_selectedGender != null) 'gender': _selectedGender,
      if (_selectedMaritalStatus != null) 'marital_status': _selectedMaritalStatus,
      if (_dobController.text.trim().isNotEmpty) 'dob': _dobController.text.trim(),
      if (_workPlaceController.text.trim().isNotEmpty) 'work_place': _workPlaceController.text.trim(),
      if (_selectedEmployeeStatus != null) 'employee_status': _selectedEmployeeStatus,
      if (_joiningDateController.text.trim().isNotEmpty) 'joining_date': _joiningDateController.text.trim(),
      if (_selectedBloodGroup != null) 'blood_group': _selectedBloodGroup,
      if (_heightController.text.trim().isNotEmpty) 'height': _heightController.text.trim(),
      if (_weightController.text.trim().isNotEmpty) 'weight': _weightController.text.trim(),
      if (_eyesightController.text.trim().isNotEmpty) 'eyesight': _eyesightController.text.trim(),
      if (_nidController.text.trim().isNotEmpty) 'nid_no': _nidController.text.trim(),
      if (_fatherController.text.trim().isNotEmpty) 'father_name': _fatherController.text.trim(),
      if (_motherController.text.trim().isNotEmpty) 'mother_name': _motherController.text.trim(),
      if (_presentVillageController.text.trim().isNotEmpty) 'address': _presentVillageController.text.trim(),
    };

    bool success = false;
    if (widget.isEdit && widget.item != null) {
      success = await ref.read(patientsProvider.notifier).updatePatient(widget.item!.id, data);
    } else {
      success = await ref.read(patientsProvider.notifier).createPatient(data);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save patient record. Please check fields.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF1E2226) : Colors.white;
    final headerBg = isDark ? const Color(0xFF262B30) : Colors.blue.shade50.withValues(alpha: 0.5);
    final headerTitleColor = isDark ? Colors.lightBlueAccent : Colors.blue.shade800;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: dialogBg,
      surfaceTintColor: dialogBg,
      insetPadding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 16, vertical: 24),
      child: Container(
        width: 900,
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: headerBg,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isEdit ? "Edit Patient" : "Add Patient",
                    style: TextStyle(color: headerTitleColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(CupertinoIcons.clear, size: 20, color: isDark ? Colors.white70 : Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    PatientFormPersonalSection(
                      isDesktop: isDesktop,
                      nameController: _nameController,
                      nidController: _nidController,
                      fatherController: _fatherController,
                      motherController: _motherController,
                      dobController: _dobController,
                      selectedGender: _selectedGender,
                      onGenderChanged: (val) => setState(() => _selectedGender = val),
                      selectedMaritalStatus: _selectedMaritalStatus,
                      onMaritalStatusChanged: (val) => setState(() => _selectedMaritalStatus = val),
                    ),
                    const SizedBox(height: 16),
                    PatientFormJobSection(
                      isDesktop: isDesktop,
                      bpNoController: _bpNoController,
                      workPlaceController: _workPlaceController,
                      phoneController: _phoneController,
                      selectedPoliceUnit: _selectedPoliceUnit,
                      onPoliceUnitChanged: (val) => setState(() => _selectedPoliceUnit = val),
                      selectedDesignation: _selectedDesignation,
                      onDesignationChanged: (val) => setState(() => _selectedDesignation = val),
                      selectedStatus: _selectedEmployeeStatus,
                      onStatusChanged: (val) => setState(() => _selectedEmployeeStatus = val),
                      joiningDateController: _joiningDateController,
                    ),
                    const SizedBox(height: 16),
                    PatientFormPhysicalSection(
                      isDesktop: isDesktop,
                      selectedBloodGroup: _selectedBloodGroup,
                      onBloodGroupChanged: (val) => setState(() => _selectedBloodGroup = val),
                      heightController: _heightController,
                      weightController: _weightController,
                      eyesightController: _eyesightController,
                    ),
                    const SizedBox(height: 16),
                    PatientFormAddressSection(
                      isDesktop: isDesktop,
                      title: "Present Address",
                      villageLabel: "Present Village:",
                      backgroundColor: isDark ? const Color(0xFF262B30) : Colors.grey.shade50,
                      villageController: _presentVillageController,
                    ),
                    const SizedBox(height: 16),
                    PatientFormAddressSection(
                      isDesktop: isDesktop,
                      title: "Permanent Address",
                      villageLabel: "Permanent Village:",
                      backgroundColor: isDark ? const Color(0xFF262B30) : Colors.indigo.shade50.withValues(alpha: 0.3),
                      villageController: _permanentVillageController,
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _isSaving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            widget.isEdit ? "Update Patient" : "Save Patient",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
