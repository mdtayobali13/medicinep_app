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
import 'package:medicine_system/services/repository/patients_repository.dart';

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
  String? _selectedEmployeeStatus = 'Regular';
  late TextEditingController _joiningDateController;

  String? _selectedBloodGroup;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _eyesightController;

  late TextEditingController _presentVillageController;
  late TextEditingController _permanentVillageController;

  String? _presentDivision;
  int? _presentDivisionId;
  String? _presentDistrict;
  int? _presentDistrictId;
  String? _presentUpazila;
  int? _presentUpazilaId;
  String? _presentUnion;
  int? _presentUnionId;

  String? _permanentDivision;
  int? _permanentDivisionId;
  String? _permanentDistrict;
  int? _permanentDistrictId;
  String? _permanentUpazila;
  int? _permanentUpazilaId;
  String? _permanentUnion;
  int? _permanentUnionId;

  @override
  void initState() {
    super.initState();
    final p = widget.item;
    final d = widget.initialData;

    _nameController = TextEditingController(text: d?['name'] ?? p?.name ?? '');
    _nidController = TextEditingController(text: d?['nid'] ?? p?.nid ?? '');
    _fatherController = TextEditingController(text: d?['father'] ?? p?.father ?? '');
    _motherController = TextEditingController(text: d?['mother'] ?? p?.mother ?? '');
    _dobController = TextEditingController(text: d?['dob'] ?? p?.dob ?? '');
    _selectedGender = d?['gender'] ?? p?.gender;
    _selectedMaritalStatus = d?['marital'] ?? p?.maritalStatus;

    _bpNoController = TextEditingController(text: d?['bp_number'] ?? d?['bp_no'] ?? p?.bpNo ?? '');
    _workPlaceController = TextEditingController(text: d?['work_place'] ?? p?.workPlace ?? '');
    _phoneController = TextEditingController(text: d?['phone'] ?? p?.mobile ?? '');
    _selectedPoliceUnit = p?.policeUnit;
    _selectedDesignation = p?.designation;
    _selectedEmployeeStatus = d?['status'] ?? p?.employmentStatus ?? p?.patientType ?? 'Regular';
    _joiningDateController = TextEditingController(text: d?['joining_date'] ?? p?.joiningDate ?? '');

    _selectedBloodGroup = d?['blood_group'] ?? p?.bloodGroup;
    _heightController = TextEditingController(text: d?['height'] ?? p?.height ?? '');
    _weightController = TextEditingController(text: d?['weight'] ?? p?.weight ?? '');
    _eyesightController = TextEditingController(text: d?['eyesight'] ?? p?.eyesight ?? '');

    _presentVillageController = TextEditingController(text: d?['present_village'] ?? p?.presentVillage ?? p?.address ?? '');
    _permanentVillageController = TextEditingController(text: d?['permanent_village'] ?? p?.permanentVillage ?? '');

    _presentDivision = d?['present_division'] ?? p?.presentDivision;
    _presentDistrict = d?['present_district'] ?? p?.presentDistrict;
    _presentUpazila = d?['present_upazila'] ?? p?.presentUpazila;
    _presentUnion = d?['present_union'] ?? p?.presentUnion;

    _permanentDivision = d?['permanent_division'] ?? p?.permanentDivision;
    _permanentDistrict = d?['permanent_district'] ?? p?.permanentDistrict;
    _permanentUpazila = d?['permanent_upazila'] ?? p?.permanentUpazila;
    _permanentUnion = d?['permanent_union'] ?? p?.permanentUnion;

    if (widget.isEdit && widget.item != null) {
      _fetchPatientFullDetails();
    }
  }

  String _getCleanTextVal(String? val, Map<String, dynamic>? rawJson, List<String> keys) {
    if (val != null && val.trim().isNotEmpty && val.trim() != 'N/A' && val.trim() != 'null') {
      return val.trim();
    }
    if (rawJson != null) {
      for (final key in keys) {
        final v = rawJson[key]?.toString().trim();
        if (v != null && v.isNotEmpty && v != 'N/A' && v != 'null') {
          return v;
        }
      }
    }
    return '';
  }

  void _fetchPatientFullDetails() async {
    if (widget.item == null) return;
    final detailed = await PatientsRepository.instance.getPatientDetails(widget.item!.id);
    if (detailed != null && mounted) {
      final raw = detailed.rawJson;
      setState(() {
        final hVal = _getCleanTextVal(detailed.height, raw, ['height', 'height_ft', 'patient_height']);
        if (hVal.isNotEmpty) _heightController.text = hVal;

        final wVal = _getCleanTextVal(detailed.weight, raw, ['weight', 'weight_kg', 'patient_weight']);
        if (wVal.isNotEmpty) _weightController.text = wVal;

        final eVal = _getCleanTextVal(detailed.eyesight, raw, ['eyesight', 'eye_sight', 'eye_vision']);
        if (eVal.isNotEmpty) _eyesightController.text = eVal;

        final phoneVal = _getCleanTextVal(detailed.mobile, raw, ['mobile', 'phone', 'phone_number', 'phone_no', 'number', 'contact', 'contact_no']);
        if (phoneVal.isNotEmpty) _phoneController.text = phoneVal;

        final nameVal = _getCleanTextVal(detailed.name, raw, ['name']);
        if (nameVal.isNotEmpty) _nameController.text = nameVal;

        final fVal = _getCleanTextVal(detailed.father, raw, ['father', 'father_name']);
        if (fVal.isNotEmpty) _fatherController.text = fVal;

        final mVal = _getCleanTextVal(detailed.mother, raw, ['mother', 'mother_name']);
        if (mVal.isNotEmpty) _motherController.text = mVal;

        final nidVal = _getCleanTextVal(detailed.nid, raw, ['nid', 'nid_no', 'nid_number']);
        if (nidVal.isNotEmpty) _nidController.text = nidVal;

        final dobVal = _getCleanTextVal(detailed.dob, raw, ['dob', 'date_of_birth', 'birth_date']);
        if (dobVal.isNotEmpty) _dobController.text = dobVal;

        final bpVal = _getCleanTextVal(detailed.bpNo, raw, ['bp_no', 'bp_number', 'bp']);
        if (bpVal.isNotEmpty) _bpNoController.text = bpVal;

        final wpVal = _getCleanTextVal(detailed.workPlace, raw, ['work_place', 'workplace']);
        if (wpVal.isNotEmpty) _workPlaceController.text = wpVal;

        final jVal = _getCleanTextVal(detailed.joiningDate, raw, ['joining_date']);
        if (jVal.isNotEmpty) _joiningDateController.text = jVal;

        final pVil = _getCleanTextVal(detailed.presentVillage, raw, ['present_village', 'present_address', 'address']);
        if (pVil.isNotEmpty) _presentVillageController.text = pVil;

        final permVil = _getCleanTextVal(detailed.permanentVillage, raw, ['permanent_village', 'permanent_address']);
        if (permVil.isNotEmpty) _permanentVillageController.text = permVil;

        if (detailed.gender != null) _selectedGender = detailed.gender;
        if (detailed.maritalStatus != null) _selectedMaritalStatus = detailed.maritalStatus;
        if (detailed.employmentStatus != null) _selectedEmployeeStatus = detailed.employmentStatus;
        if (detailed.bloodGroup != null) _selectedBloodGroup = detailed.bloodGroup;

        if (detailed.presentDivision != null) _presentDivision = detailed.presentDivision;
        if (detailed.presentDistrict != null) _presentDistrict = detailed.presentDistrict;
        if (detailed.presentUpazila != null) _presentUpazila = detailed.presentUpazila;
        if (detailed.presentUnion != null) _presentUnion = detailed.presentUnion;

        if (detailed.permanentDivision != null) _permanentDivision = detailed.permanentDivision;
        if (detailed.permanentDistrict != null) _permanentDistrict = detailed.permanentDistrict;
        if (detailed.permanentUpazila != null) _permanentUpazila = detailed.permanentUpazila;
        if (detailed.permanentUnion != null) _permanentUnion = detailed.permanentUnion;

        final policeUnitsList = ref.read(policeUnitsProvider).list;
        final designationsList = ref.read(designationsProvider).list;

        if (detailed.policeUnit != null || detailed.policeUnitId != null) {
          final pId = detailed.policeUnitId ?? detailed.policeUnit?.id;
          _selectedPoliceUnit = policeUnitsList.where((e) => e.id == pId).firstOrNull ?? detailed.policeUnit;
        }

        if (detailed.designation != null || detailed.designationId != null) {
          final dId = detailed.designationId ?? detailed.designation?.id;
          _selectedDesignation = designationsList.where((e) => e.id == dId).firstOrNull ?? detailed.designation;
        }
      });
    }
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

  String _formatDateForApi(String rawDate) {
    final trimmed = rawDate.trim();
    if (trimmed.isEmpty) return trimmed;
    try {
      if (trimmed.contains('-')) {
        final parts = trimmed.split('-');
        if (parts.length == 3 && parts[0].length == 2 && parts[2].length == 4) {
          return '${parts[2]}-${parts[1]}-${parts[0]}';
        }
      }
    } catch (_) {}
    return trimmed;
  }

  int _getDivisionId(String? name) {
    if (name == null || name.isEmpty) return 1;
    final n = name.toLowerCase();
    if (n.contains('dhaka')) return 1;
    if (n.contains('chittagong') || n.contains('chatogram')) return 2;
    if (n.contains('rajshahi')) return 3;
    if (n.contains('khulna')) return 4;
    if (n.contains('barisal') || n.contains('barishal')) return 5;
    if (n.contains('sylhet')) return 6;
    if (n.contains('rangpur')) return 7;
    if (n.contains('mymensingh')) return 8;
    return 1;
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

    final bpVal = _bpNoController.text.trim();
    final fatherVal = _fatherController.text.trim();
    final motherVal = _motherController.text.trim();
    final nidVal = _nidController.text.trim();
    final phoneVal = _phoneController.text.trim();
    final workPlaceVal = _workPlaceController.text.trim();
    final presentVillageVal = _presentVillageController.text.trim();
    final permanentVillageVal = _permanentVillageController.text.trim();

    final rawDob = _dobController.text.trim();
    final apiDob = _formatDateForApi(rawDob);

    final rawJoining = _joiningDateController.text.trim();
    final apiJoining = _formatDateForApi(rawJoining);

    final empStatusRaw = (_selectedEmployeeStatus ?? 'Regular').trim();
    final validEmpStatus = (empStatusRaw == 'Active' || empStatusRaw.isEmpty) ? 'Regular' : empStatusRaw;

    String? finalJoiningDate;
    if (rawJoining.isNotEmpty) {
      try {
        final parsed = DateTime.tryParse(apiJoining);
        if (parsed != null) {
          final today = DateTime.now();
          final todayStart = DateTime(today.year, today.month, today.day);
          if (parsed.isBefore(todayStart)) {
            finalJoiningDate = apiJoining;
          } else {
            final yesterday = todayStart.subtract(const Duration(days: 1));
            finalJoiningDate = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";
          }
        } else {
          finalJoiningDate = apiJoining;
        }
      } catch (_) {
        finalJoiningDate = apiJoining;
      }
    }

    final int presentDivId = _presentDivisionId ?? _getDivisionId(_presentDivision);
    final int presentDistId = _presentDistrictId ?? 1;
    final int presentUpzId = _presentUpazilaId ?? 1;
    final int presentUniId = _presentUnionId ?? 1;

    final int permDivId = _permanentDivisionId ?? _presentDivisionId ?? _getDivisionId(_permanentDivision ?? _presentDivision);
    final int permDistId = _permanentDistrictId ?? _presentDistrictId ?? 1;
    final int permUpzId = _permanentUpazilaId ?? _presentUpazilaId ?? 1;
    final int permUniId = _permanentUnionId ?? _presentUnionId ?? 1;

    final Map<String, dynamic> data = {
      'name': name,
      'patient_type': widget.item?.patientType ?? validEmpStatus,
      'bp_no': bpVal.isNotEmpty ? bpVal : '100',
      'bp_number': bpVal.isNotEmpty ? bpVal : '100',
      'bp': bpVal.isNotEmpty ? bpVal : '100',
      'father': fatherVal.isNotEmpty ? fatherVal : 'N/A',
      'father_name': fatherVal.isNotEmpty ? fatherVal : 'N/A',
      'mother': motherVal.isNotEmpty ? motherVal : 'N/A',
      'mother_name': motherVal.isNotEmpty ? motherVal : 'N/A',
      'nid': nidVal.isNotEmpty ? nidVal : '0000000000',
      'nid_no': nidVal.isNotEmpty ? nidVal : '0000000000',
      'nid_number': nidVal.isNotEmpty ? nidVal : '0000000000',
      'mobile': phoneVal.isNotEmpty ? phoneVal : '01700000000',
      'phone': phoneVal.isNotEmpty ? phoneVal : '01700000000',
      'phone_number': phoneVal.isNotEmpty ? phoneVal : '01700000000',
      'number': phoneVal.isNotEmpty ? phoneVal : (bpVal.isNotEmpty ? bpVal : '01700000000'),
      if (selectedUnit != null) 'police_unit_id': selectedUnit.id,
      if (selectedDesig != null) 'designation_id': selectedDesig.id,
      'gender': _selectedGender ?? 'Male',
      'marital': _selectedMaritalStatus ?? 'Single',
      'marital_status': _selectedMaritalStatus ?? 'Single',
      if (rawDob.isNotEmpty) ...{
        'dob': apiDob,
        'date_of_birth': apiDob,
        'birth_date': apiDob,
      },
      if (workPlaceVal.isNotEmpty) ...{
        'work_place': workPlaceVal,
        'workplace': workPlaceVal,
      },
      'employment_status': validEmpStatus,
      'employee_status': validEmpStatus,
      'status': validEmpStatus,
      if (finalJoiningDate != null && finalJoiningDate.isNotEmpty) 'joining_date': finalJoiningDate,
      if (_selectedBloodGroup != null) 'blood_group': _selectedBloodGroup,
      if (_heightController.text.trim().isNotEmpty) ...{
        'height': _heightController.text.trim(),
        'height_ft': _heightController.text.trim(),
        'patient_height': _heightController.text.trim(),
      },
      if (_weightController.text.trim().isNotEmpty) ...{
        'weight': _weightController.text.trim(),
        'weight_kg': _weightController.text.trim(),
        'patient_weight': _weightController.text.trim(),
      },
      if (_eyesightController.text.trim().isNotEmpty) ...{
        'eyesight': _eyesightController.text.trim(),
        'eye_sight': _eyesightController.text.trim(),
        'eye_vision': _eyesightController.text.trim(),
      },

      'address': presentVillageVal.isNotEmpty ? presentVillageVal : 'N/A',
      'present_village': presentVillageVal.isNotEmpty ? presentVillageVal : 'N/A',
      'present_address': presentVillageVal.isNotEmpty ? presentVillageVal : 'N/A',
      'permanent_village': permanentVillageVal.isNotEmpty ? permanentVillageVal : 'N/A',
      'permanent_address': permanentVillageVal.isNotEmpty ? permanentVillageVal : 'N/A',

      'present_division': _presentDivision ?? 'Barisal',
      'present_division_id': presentDivId,
      'present_district': _presentDistrict ?? 'Patuakhali',
      'present_district_id': presentDistId,
      'present_upazila': _presentUpazila ?? 'Patuakhali Sadar',
      'present_upazila_id': presentUpzId,
      'present_union': _presentUnion ?? 'Kalikapur',
      'present_union_id': presentUniId,

      'permanent_division': _permanentDivision ?? _presentDivision ?? 'Barisal',
      'permanent_division_id': permDivId,
      'permanent_district': _permanentDistrict ?? _presentDistrict ?? 'Patuakhali',
      'permanent_district_id': permDistId,
      'permanent_upazila': _permanentUpazila ?? _presentUpazila ?? 'Patuakhali Sadar',
      'permanent_upazila_id': permUpzId,
      'permanent_union': _permanentUnion ?? _presentUnion ?? 'Kalikapur',
      'permanent_union_id': permUniId,
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
                      selectedDivision: _presentDivision,
                      onDivisionChanged: (val) => setState(() => _presentDivision = val),
                      onDivisionIdChanged: (id) => setState(() => _presentDivisionId = id),
                      selectedDistrict: _presentDistrict,
                      onDistrictChanged: (val) => setState(() => _presentDistrict = val),
                      onDistrictIdChanged: (id) => setState(() => _presentDistrictId = id),
                      selectedUpazila: _presentUpazila,
                      onUpazilaChanged: (val) => setState(() => _presentUpazila = val),
                      onUpazilaIdChanged: (id) => setState(() => _presentUpazilaId = id),
                      selectedUnion: _presentUnion,
                      onUnionChanged: (val) => setState(() => _presentUnion = val),
                      onUnionIdChanged: (id) => setState(() => _presentUnionId = id),
                    ),
                    const SizedBox(height: 16),
                    PatientFormAddressSection(
                      isDesktop: isDesktop,
                      title: "Permanent Address",
                      villageLabel: "Permanent Village:",
                      backgroundColor: isDark ? const Color(0xFF262B30) : Colors.indigo.shade50.withValues(alpha: 0.3),
                      villageController: _permanentVillageController,
                      selectedDivision: _permanentDivision,
                      onDivisionChanged: (val) => setState(() => _permanentDivision = val),
                      onDivisionIdChanged: (id) => setState(() => _permanentDivisionId = id),
                      selectedDistrict: _permanentDistrict,
                      onDistrictChanged: (val) => setState(() => _permanentDistrict = val),
                      onDistrictIdChanged: (id) => setState(() => _permanentDistrictId = id),
                      selectedUpazila: _permanentUpazila,
                      onUpazilaChanged: (val) => setState(() => _permanentUpazila = val),
                      onUpazilaIdChanged: (id) => setState(() => _permanentUpazilaId = id),
                      selectedUnion: _permanentUnion,
                      onUnionChanged: (val) => setState(() => _permanentUnion = val),
                      onUnionIdChanged: (id) => setState(() => _permanentUnionId = id),
                    ),
                  ],
                ),
              ),
            ),

            // Footer / Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: dialogBg,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                border: Border(top: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _isSaving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isSaving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(widget.isEdit ? "Update Patient" : "Save Patient", style: const TextStyle(fontWeight: FontWeight.bold)),
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
