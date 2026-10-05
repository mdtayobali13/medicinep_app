import 'designation_model.dart';
import 'police_unit_model.dart';

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
  final int? designationId;
  final int? policeUnitId;
  final String? mobile;
  final String? gender;
  final String? dob;
  final String? address;
  final DesignationModel? designation;
  final PoliceUnitModel? policeUnit;
  final List<SpouseModel>? spouses;
  final List<ChildModel>? childrens;
  final String? createdAt;
  final String? updatedAt;

  PatientModel({
    required this.id,
    required this.name,
    this.patientType,
    this.bpNo,
    this.designationId,
    this.policeUnitId,
    this.mobile,
    this.gender,
    this.dob,
    this.address,
    this.designation,
    this.policeUnit,
    this.spouses,
    this.childrens,
    this.createdAt,
    this.updatedAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      patientType: json['patient_type']?.toString(),
      bpNo: json['bp_no']?.toString(),
      designationId: json['designation_id'] is int ? json['designation_id'] : int.tryParse(json['designation_id']?.toString() ?? ''),
      policeUnitId: json['police_unit_id'] is int ? json['police_unit_id'] : int.tryParse(json['police_unit_id']?.toString() ?? ''),
      mobile: json['mobile']?.toString() ?? json['phone_number']?.toString(),
      gender: json['gender']?.toString(),
      dob: json['dob']?.toString(),
      address: json['address']?.toString(),
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (patientType != null) 'patient_type': patientType,
      if (bpNo != null) 'bp_no': bpNo,
      if (designationId != null) 'designation_id': designationId,
      if (policeUnitId != null) 'police_unit_id': policeUnitId,
      if (mobile != null) 'mobile': mobile,
      if (gender != null) 'gender': gender,
      if (dob != null) 'dob': dob,
      if (address != null) 'address': address,
    };
  }
}
