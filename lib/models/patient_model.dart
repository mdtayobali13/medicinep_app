import 'designation_model.dart';
import 'police_unit_model.dart';

String? _parseLocationName(dynamic val) {
  if (val == null) return null;
  if (val is Map) {
    final name = val['name']?.toString();
    if (name != null && name.isNotEmpty) return name;
    final bnName = val['bn_name']?.toString();
    if (bnName != null && bnName.isNotEmpty) return bnName;
  }
  final str = val.toString().trim();
  if (str.startsWith('{') && str.endsWith('}')) {
    final nameMatch = RegExp(r'name:\s*([^,}]+)').firstMatch(str);
    if (nameMatch != null) {
      final matched = nameMatch.group(1)?.trim();
      if (matched != null && matched.isNotEmpty) return matched;
    }
  }
  return str;
}

class SpouseModel {
  final int id;
  final int patientId;
  final String name;
  final String? gender;
  final String? dob;
  final String? mobile;

  SpouseModel({
    required this.id,
    required this.patientId,
    required this.name,
    this.gender,
    this.dob,
    this.mobile,
  });

  factory SpouseModel.fromJson(Map<String, dynamic> json) {
    return SpouseModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      patientId: json['patient_id'] is int ? json['patient_id'] : int.tryParse(json['patient_id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      gender: json['gender']?.toString(),
      dob: json['dob']?.toString(),
      mobile: json['mobile']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'name': name,
      if (gender != null) 'gender': gender,
      if (dob != null) 'dob': dob,
      if (mobile != null) 'mobile': mobile,
    };
  }
}

class ChildModel {
  final int id;
  final int patientId;
  final String name;
  final String? gender;
  final String? dob;

  ChildModel({
    required this.id,
    required this.patientId,
    required this.name,
    this.gender,
    this.dob,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      patientId: json['patient_id'] is int ? json['patient_id'] : int.tryParse(json['patient_id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      gender: json['gender']?.toString(),
      dob: json['dob']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'name': name,
      if (gender != null) 'gender': gender,
      if (dob != null) 'dob': dob,
    };
  }
}

class PatientModel {
  final int id;
  final String name;
  final String? patientType;
  final String? bpNo;
  final String? father;
  final String? mother;
  final String? nid;
  final String? dob;
  final String? gender;
  final String? maritalStatus;
  final String? bloodGroup;
  final String? height;
  final String? weight;
  final String? eyesight;
  final String? mobile;
  final String? workPlace;
  final String? joiningDate;
  final String? employmentStatus;
  final int? designationId;
  final int? policeUnitId;
  final DesignationModel? designation;
  final PoliceUnitModel? policeUnit;
  final String? address;
  final String? presentVillage;
  final String? presentDivision;
  final String? presentDistrict;
  final String? presentUpazila;
  final String? presentUnion;
  final String? permanentVillage;
  final String? permanentDivision;
  final String? permanentDistrict;
  final String? permanentUpazila;
  final String? permanentUnion;
  final List<SpouseModel>? spouses;
  final List<ChildModel>? childrens;
  final String? createdAt;
  final String? updatedAt;
  final Map<String, dynamic>? rawJson;

  PatientModel({
    required this.id,
    required this.name,
    this.patientType,
    this.bpNo,
    this.father,
    this.mother,
    this.nid,
    this.dob,
    this.gender,
    this.maritalStatus,
    this.bloodGroup,
    this.height,
    this.weight,
    this.eyesight,
    this.mobile,
    this.workPlace,
    this.joiningDate,
    this.employmentStatus,
    this.designationId,
    this.policeUnitId,
    this.designation,
    this.policeUnit,
    this.address,
    this.presentVillage,
    this.presentDivision,
    this.presentDistrict,
    this.presentUpazila,
    this.presentUnion,
    this.permanentVillage,
    this.permanentDivision,
    this.permanentDistrict,
    this.permanentUpazila,
    this.permanentUnion,
    this.spouses,
    this.childrens,
    this.createdAt,
    this.updatedAt,
    this.rawJson,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      patientType: json['patient_type']?.toString(),
      bpNo: json['bp_no']?.toString() ?? json['bp_number']?.toString() ?? json['bp']?.toString(),
      father: json['father']?.toString() ?? json['father_name']?.toString(),
      mother: json['mother']?.toString() ?? json['mother_name']?.toString(),
      nid: json['nid']?.toString() ?? json['nid_no']?.toString() ?? json['nid_number']?.toString(),
      dob: json['dob']?.toString() ?? json['date_of_birth']?.toString() ?? json['birth_date']?.toString(),
      gender: json['gender']?.toString(),
      maritalStatus: json['marital']?.toString() ?? json['marital_status']?.toString(),
      bloodGroup: json['blood_group']?.toString(),
      height: json['height']?.toString() ?? json['height_ft']?.toString() ?? json['patient_height']?.toString(),
      weight: json['weight']?.toString() ?? json['weight_kg']?.toString() ?? json['patient_weight']?.toString(),
      eyesight: json['eyesight']?.toString() ?? json['eye_sight']?.toString() ?? json['eye_vision']?.toString(),
      mobile: json['mobile']?.toString() ?? json['phone_number']?.toString() ?? json['phone_no']?.toString() ?? json['phone']?.toString() ?? json['number']?.toString() ?? json['contact']?.toString() ?? json['contact_no']?.toString(),
      workPlace: json['work_place']?.toString() ?? json['workplace']?.toString(),
      joiningDate: json['joining_date']?.toString(),
      employmentStatus: json['employment_status']?.toString() ?? json['employee_status']?.toString() ?? json['status']?.toString(),
      designationId: json['designation_id'] is int ? json['designation_id'] : int.tryParse(json['designation_id']?.toString() ?? ''),
      policeUnitId: json['police_unit_id'] is int ? json['police_unit_id'] : int.tryParse(json['police_unit_id']?.toString() ?? ''),
      address: json['address']?.toString() ?? json['present_village']?.toString(),
      presentVillage: json['present_village']?.toString() ?? json['present_address']?.toString() ?? json['address']?.toString(),
      presentDivision: _parseLocationName(json['present_division']),
      presentDistrict: _parseLocationName(json['present_district']),
      presentUpazila: _parseLocationName(json['present_upazila']),
      presentUnion: _parseLocationName(json['present_union']),
      permanentVillage: json['permanent_village']?.toString() ?? json['permanent_address']?.toString(),
      permanentDivision: _parseLocationName(json['permanent_division']),
      permanentDistrict: _parseLocationName(json['permanent_district']),
      permanentUpazila: _parseLocationName(json['permanent_upazila']),
      permanentUnion: _parseLocationName(json['permanent_union']),
      designation: json['designation'] is Map<String, dynamic> ? DesignationModel.fromJson(json['designation']) : null,
      policeUnit: json['police_unit'] is Map<String, dynamic> ? PoliceUnitModel.fromJson(json['police_unit']) : null,
      spouses: json['spouses'] is List
          ? (json['spouses'] as List).map((e) => SpouseModel.fromJson(e as Map<String, dynamic>)).toList()
          : null,
      childrens: json['childrens'] is List
          ? (json['childrens'] as List).map((e) => ChildModel.fromJson(e as Map<String, dynamic>)).toList()
          : null,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      rawJson: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (patientType != null) 'patient_type': patientType,
      if (bpNo != null) 'bp_no': bpNo,
      if (father != null) 'father': father,
      if (mother != null) 'mother': mother,
      if (nid != null) 'nid': nid,
      if (dob != null) 'dob': dob,
      if (gender != null) 'gender': gender,
      if (maritalStatus != null) 'marital': maritalStatus,
      if (bloodGroup != null) 'blood_group': bloodGroup,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (eyesight != null) 'eyesight': eyesight,
      if (designationId != null) 'designation_id': designationId,
      if (policeUnitId != null) 'police_unit_id': policeUnitId,
      if (mobile != null) 'mobile': mobile,
      if (workPlace != null) 'work_place': workPlace,
      if (joiningDate != null) 'joining_date': joiningDate,
      if (employmentStatus != null) 'employment_status': employmentStatus,
      if (address != null) 'address': address,
      if (presentVillage != null) 'present_village': presentVillage,
      if (presentDivision != null) 'present_division': presentDivision,
      if (presentDistrict != null) 'present_district': presentDistrict,
      if (presentUpazila != null) 'present_upazila': presentUpazila,
      if (presentUnion != null) 'present_union': presentUnion,
      if (permanentVillage != null) 'permanent_village': permanentVillage,
      if (permanentDivision != null) 'permanent_division': permanentDivision,
      if (permanentDistrict != null) 'permanent_district': permanentDistrict,
      if (permanentUpazila != null) 'permanent_upazila': permanentUpazila,
      if (permanentUnion != null) 'permanent_union': permanentUnion,
    };
  }
}
