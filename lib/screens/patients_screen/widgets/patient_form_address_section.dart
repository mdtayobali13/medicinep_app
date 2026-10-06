import 'package:flutter/material.dart';
import 'package:medicine_system/models/address_lookup_model.dart';
import 'package:medicine_system/services/repository/address_lookup_repository.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_text_field.dart';
import 'package:medicine_system/screens/medicine_screen/widgets/form_fields/medicine_dropdown_field.dart';
import 'package:medicine_system/screens/patients_screen/widgets/section_container.dart';

class PatientFormAddressSection extends StatefulWidget {
  final bool isDesktop;
  final String title;
  final String villageLabel;
  final Color backgroundColor;
  final TextEditingController villageController;
  final String? selectedDivision;
  final ValueChanged<String?>? onDivisionChanged;
  final ValueChanged<int?>? onDivisionIdChanged;
  final String? selectedDistrict;
  final ValueChanged<String?>? onDistrictChanged;
  final ValueChanged<int?>? onDistrictIdChanged;
  final String? selectedUpazila;
  final ValueChanged<String?>? onUpazilaChanged;
  final ValueChanged<int?>? onUpazilaIdChanged;
  final String? selectedUnion;
  final ValueChanged<String?>? onUnionChanged;
  final ValueChanged<int?>? onUnionIdChanged;

  const PatientFormAddressSection({
    super.key,
    required this.isDesktop,
    required this.title,
    required this.villageLabel,
    required this.backgroundColor,
    required this.villageController,
    this.selectedDivision,
    this.onDivisionChanged,
    this.onDivisionIdChanged,
    this.selectedDistrict,
    this.onDistrictChanged,
    this.onDistrictIdChanged,
    this.selectedUpazila,
    this.onUpazilaChanged,
    this.onUpazilaIdChanged,
    this.selectedUnion,
    this.onUnionChanged,
    this.onUnionIdChanged,
  });

  @override
  State<PatientFormAddressSection> createState() => _PatientFormAddressSectionState();
}

class _PatientFormAddressSectionState extends State<PatientFormAddressSection> {
  final _repo = AddressLookupRepository.instance;

  List<LocationItemModel> _divisions = [];
  List<LocationItemModel> _districts = [];
  List<LocationItemModel> _upazilas = [];
  List<LocationItemModel> _unions = [];

  bool _loadingDivisions = false;
  bool _loadingDistricts = false;
  bool _loadingUpazilas = false;
  bool _loadingUnions = false;

  final Map<String, List<String>> _fallbackDistrictsMap = const {
    'Dhaka': ['Dhaka', 'Gazipur', 'Narayanganj', 'Manikganj', 'Munshiganj', 'Narsingdi', 'Tangail', 'Faridpur', 'Gopalganj', 'Madaripur', 'Rajbari', 'Shariatpur', 'Kishoreganj'],
    'Chittagong': ['Chittagong', 'Cox\'s Bazar', 'Bandarban', 'Rangamati', 'Khagrachhari', 'Feni', 'Noakhali', 'Lakshmipur', 'Comilla', 'Chandpur', 'Brahmanbaria'],
    'Rajshahi': ['Rajshahi', 'Bogra', 'Pabna', 'Sirajganj', 'Naogaon', 'Natore', 'Nawabganj', 'Joypurhat'],
    'Khulna': ['Khulna', 'Bagerhat', 'Satkhira', 'Jessore', 'Jhenaidah', 'Magura', 'Narail', 'Kushtia', 'Meherpur', 'Chuadanga'],
    'Barisal': ['Barisal', 'Bhopal', 'Bhola', 'Jhalokati', 'Patuakhali', 'Pirojpur', 'Barguna'],
    'Sylhet': ['Sylhet', 'Moulvibazar', 'Habiganj', 'Sunamganj'],
    'Rangpur': ['Rangpur', 'Dinajpur', 'Gaibandha', 'Kurigram', 'Lalmonirhat', 'Nilphamari', 'Panchagarh', 'Thakurgaon'],
    'Mymensingh': ['Mymensingh', 'Jamalpur', 'Netrokona', 'Sherpur'],
  };

  @override
  void initState() {
    super.initState();
    _fetchDivisions();
  }

  Future<void> _fetchDivisions() async {
    setState(() => _loadingDivisions = true);
    final res = await _repo.getDivisions();
    if (mounted) {
      setState(() {
        _loadingDivisions = false;
        _divisions = res;
      });
      if (widget.selectedDivision != null && widget.selectedDivision!.isNotEmpty) {
        _onDivisionSelected(widget.selectedDivision, triggerCallback: false);
      }
    }
  }

  Future<void> _onDivisionSelected(String? divisionName, {bool triggerCallback = true}) async {
    final found = _divisions.where((d) => d.name.toLowerCase() == (divisionName ?? '').toLowerCase()).firstOrNull;
    if (triggerCallback) {
      if (widget.onDivisionChanged != null) widget.onDivisionChanged!(divisionName);
      if (widget.onDivisionIdChanged != null) widget.onDivisionIdChanged!(found?.id);
      if (widget.onDistrictChanged != null) widget.onDistrictChanged!(null);
      if (widget.onDistrictIdChanged != null) widget.onDistrictIdChanged!(null);
      if (widget.onUpazilaChanged != null) widget.onUpazilaChanged!(null);
      if (widget.onUpazilaIdChanged != null) widget.onUpazilaIdChanged!(null);
      if (widget.onUnionChanged != null) widget.onUnionChanged!(null);
      if (widget.onUnionIdChanged != null) widget.onUnionIdChanged!(null);
    } else {
      if (widget.onDivisionIdChanged != null && found?.id != null) widget.onDivisionIdChanged!(found!.id);
    }

    setState(() {
      _districts = [];
      _upazilas = [];
      _unions = [];
    });

    if (divisionName == null || divisionName.isEmpty) return;

    if (found != null) {
      setState(() => _loadingDistricts = true);
      final res = await _repo.getDistricts(found.id);
      if (mounted) {
        setState(() {
          _loadingDistricts = false;
          _districts = res;
        });
        if (widget.selectedDistrict != null && widget.selectedDistrict!.isNotEmpty) {
          _onDistrictSelected(widget.selectedDistrict, triggerCallback: false);
        }
      }
    }
  }

  Future<void> _onDistrictSelected(String? districtName, {bool triggerCallback = true}) async {
    final found = _districts.where((d) => d.name.toLowerCase() == (districtName ?? '').toLowerCase()).firstOrNull;
    if (triggerCallback) {
      if (widget.onDistrictChanged != null) widget.onDistrictChanged!(districtName);
      if (widget.onDistrictIdChanged != null) widget.onDistrictIdChanged!(found?.id);
      if (widget.onUpazilaChanged != null) widget.onUpazilaChanged!(null);
      if (widget.onUpazilaIdChanged != null) widget.onUpazilaIdChanged!(null);
      if (widget.onUnionChanged != null) widget.onUnionChanged!(null);
      if (widget.onUnionIdChanged != null) widget.onUnionIdChanged!(null);
    } else {
      if (widget.onDistrictIdChanged != null && found?.id != null) widget.onDistrictIdChanged!(found!.id);
    }

    setState(() {
      _upazilas = [];
      _unions = [];
    });

    if (districtName == null || districtName.isEmpty) return;

    if (found != null) {
      setState(() => _loadingUpazilas = true);
      final res = await _repo.getUpazilas(found.id);
      if (mounted) {
        setState(() {
          _loadingUpazilas = false;
          _upazilas = res;
        });
        if (widget.selectedUpazila != null && widget.selectedUpazila!.isNotEmpty) {
          _onUpazilaSelected(widget.selectedUpazila, triggerCallback: false);
        }
      }
    }
  }

  Future<void> _onUpazilaSelected(String? upazilaName, {bool triggerCallback = true}) async {
    final found = _upazilas.where((u) => u.name.toLowerCase() == (upazilaName ?? '').toLowerCase()).firstOrNull;
    if (triggerCallback) {
      if (widget.onUpazilaChanged != null) widget.onUpazilaChanged!(upazilaName);
      if (widget.onUpazilaIdChanged != null) widget.onUpazilaIdChanged!(found?.id);
      if (widget.onUnionChanged != null) widget.onUnionChanged!(null);
      if (widget.onUnionIdChanged != null) widget.onUnionIdChanged!(null);
    } else {
      if (widget.onUpazilaIdChanged != null && found?.id != null) widget.onUpazilaIdChanged!(found!.id);
    }

    setState(() {
      _unions = [];
    });

    if (upazilaName == null || upazilaName.isEmpty) return;

    if (found != null) {
      setState(() => _loadingUnions = true);
      final res = await _repo.getUnions(found.id);
      if (mounted) {
        setState(() {
          _loadingUnions = false;
          _unions = res;
        });
        if (widget.selectedUnion != null && widget.selectedUnion!.isNotEmpty) {
          _onUnionSelected(widget.selectedUnion, triggerCallback: false);
        }
      }
    }
  }

  void _onUnionSelected(String? unionName, {bool triggerCallback = true}) {
    final found = _unions.where((u) => u.name.toLowerCase() == (unionName ?? '').toLowerCase()).firstOrNull;
    if (triggerCallback) {
      if (widget.onUnionChanged != null) widget.onUnionChanged!(unionName);
      if (widget.onUnionIdChanged != null) widget.onUnionIdChanged!(found?.id);
    } else {
      if (widget.onUnionIdChanged != null && found?.id != null) widget.onUnionIdChanged!(found!.id);
    }
  }

  List<String> _getDivisionOptions() {
    if (_divisions.isNotEmpty) {
      return _divisions.map((d) => d.name).toSet().toList();
    }
    return ['Dhaka', 'Chittagong', 'Rajshahi', 'Khulna', 'Barisal', 'Sylhet', 'Rangpur', 'Mymensingh'];
  }

  List<String> _getDistrictOptions() {
    List<String> list = [];
    if (_districts.isNotEmpty) {
      list = _districts.map((d) => d.name).toList();
    } else {
      final selDiv = widget.selectedDivision;
      if (selDiv != null && _fallbackDistrictsMap.containsKey(selDiv)) {
        list = _fallbackDistrictsMap[selDiv]!;
      } else {
        list = ['Dhaka', 'Gazipur', 'Narayanganj', 'Chittagong', 'Comilla', 'Rangpur', 'Dinajpur'];
      }
    }
    final selDist = widget.selectedDistrict;
    if (selDist != null && selDist.isNotEmpty && !list.contains(selDist)) {
      list = [selDist, ...list];
    }
    return list.toSet().toList();
  }

  List<String> _getUpazilaOptions() {
    List<String> list = [];
    if (_upazilas.isNotEmpty) {
      list = _upazilas.map((u) => u.name).toList();
    } else {
      list = ['Mirpur', 'Dhanmondi', 'Gulshan', 'Uttara', 'Savar', 'Sadulapur', 'Pirganj', 'Rangpur Sadar'];
    }
    final selUpazila = widget.selectedUpazila;
    if (selUpazila != null && selUpazila.isNotEmpty && !list.contains(selUpazila)) {
      list = [selUpazila, ...list];
    }
    return list.toSet().toList();
  }

  List<String> _getUnionOptions() {
    List<String> list = [];
    if (_unions.isNotEmpty) {
      list = _unions.map((u) => u.name).toList();
    } else {
      list = ['Union 1', 'Union 2', 'Union 3', 'Union 4'];
    }
    final selUnion = widget.selectedUnion;
    if (selUnion != null && selUnion.isNotEmpty && !list.contains(selUnion)) {
      list = [selUnion, ...list];
    }
    return list.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: widget.title,
      backgroundColor: widget.backgroundColor,
      child: widget.isDesktop ? _buildDesktop(context) : _buildMobile(context),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.white70 : Colors.grey.shade800;

    final divisionItems = _getDivisionOptions().map((e) => DropdownMenuItem(value: e, child: Text(e))).toList();
    final districtItems = _getDistrictOptions().map((e) => DropdownMenuItem(value: e, child: Text(e))).toList();
    final upazilaItems = _getUpazilaOptions().map((e) => DropdownMenuItem(value: e, child: Text(e))).toList();
    final unionItems = _getUnionOptions().map((e) => DropdownMenuItem(value: e, child: Text(e))).toList();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MedicineDropdownField<String>(
                label: "Division",
                hint: "Select division",
                value: widget.selectedDivision,
                isLoading: _loadingDivisions,
                items: divisionItems,
                onChanged: (val) => _onDivisionSelected(val),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MedicineDropdownField<String>(
                label: "District",
                hint: "Select district",
                value: widget.selectedDistrict,
                isLoading: _loadingDistricts,
                items: districtItems,
                onChanged: (val) => _onDistrictSelected(val),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MedicineDropdownField<String>(
                label: "Upazila",
                hint: "Select upazila",
                value: widget.selectedUpazila,
                isLoading: _loadingUpazilas,
                items: upazilaItems,
                onChanged: (val) => _onUpazilaSelected(val),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MedicineDropdownField<String>(
                label: "Union",
                hint: "Select union",
                value: widget.selectedUnion,
                isLoading: _loadingUnions,
                items: unionItems,
                onChanged: (val) => _onUnionSelected(val),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(
              width: 140,
              child: Text(widget.villageLabel, style: TextStyle(color: labelColor, fontSize: 13)),
            ),
            Expanded(
              child: MedicineTextField(
                label: "",
                hint: "Enter village / house details",
                controller: widget.villageController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    final divisionItems = _getDivisionOptions().map((e) => DropdownMenuItem(value: e, child: Text(e))).toList();
    final districtItems = _getDistrictOptions().map((e) => DropdownMenuItem(value: e, child: Text(e))).toList();
    final upazilaItems = _getUpazilaOptions().map((e) => DropdownMenuItem(value: e, child: Text(e))).toList();
    final unionItems = _getUnionOptions().map((e) => DropdownMenuItem(value: e, child: Text(e))).toList();

    return Column(
      children: [
        MedicineDropdownField<String>(
          label: "Division",
          hint: "Select division",
          value: widget.selectedDivision,
          isLoading: _loadingDivisions,
          items: divisionItems,
          onChanged: (val) => _onDivisionSelected(val),
        ),
        const SizedBox(height: 16),
        MedicineDropdownField<String>(
          label: "District",
          hint: "Select district",
          value: widget.selectedDistrict,
          isLoading: _loadingDistricts,
          items: districtItems,
          onChanged: (val) => _onDistrictSelected(val),
        ),
        const SizedBox(height: 16),
        MedicineDropdownField<String>(
          label: "Upazila",
          hint: "Select upazila",
          value: widget.selectedUpazila,
          isLoading: _loadingUpazilas,
          items: upazilaItems,
          onChanged: (val) => _onUpazilaSelected(val),
        ),
        const SizedBox(height: 16),
        MedicineDropdownField<String>(
          label: "Union",
          hint: "Select union",
          value: widget.selectedUnion,
          isLoading: _loadingUnions,
          items: unionItems,
          onChanged: (val) => _onUnionSelected(val),
        ),
        const SizedBox(height: 16),
        MedicineTextField(
          label: widget.villageLabel,
          hint: "Enter village / house details",
          controller: widget.villageController,
        ),
      ],
    );
  }
}
