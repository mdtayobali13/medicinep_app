import 'designation_model.dart';
import 'police_unit_model.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? bpNumber;
  final int? designationId;
  final int? policeUnitId;
  final DesignationModel? designation;
  final PoliceUnitModel? policeUnit;
  final List<String> roles;
  final List<String> permissions;
  final dynamic status;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.bpNumber,
    this.designationId,
    this.policeUnitId,
    this.designation,
    this.policeUnit,
    this.roles = const [],
    this.permissions = const [],
    this.status,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<String> roleList = [];
    if (json['roles'] is List) {
      for (var r in json['roles']) {
        if (r is String) {
          roleList.add(r);
        } else if (r is Map && r['name'] != null) {
          roleList.add(r['name'].toString());
        }
      }
    }

    List<String> permList = [];
    if (json['permissions'] is List) {
      for (var p in json['permissions']) {
        if (p is String) {
          permList.add(p);
        } else if (p is Map && p['name'] != null) {
          permList.add(p['name'].toString());
        }
      }
    }

    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? json['mobile']?.toString(),
      bpNumber: json['bp_number']?.toString() ?? json['bp_no']?.toString(),
      designationId: json['designation_id'] is int ? json['designation_id'] : int.tryParse(json['designation_id']?.toString() ?? ''),
      policeUnitId: json['police_unit_id'] is int ? json['police_unit_id'] : int.tryParse(json['police_unit_id']?.toString() ?? ''),
      designation: json['designation'] is Map<String, dynamic> ? DesignationModel.fromJson(json['designation']) : null,
      policeUnit: json['police_unit'] is Map<String, dynamic> ? PoliceUnitModel.fromJson(json['police_unit']) : null,
      roles: roleList,
      permissions: permList,
      status: json['status'],
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (bpNumber != null) 'bp_number': bpNumber,
      if (designationId != null) 'designation_id': designationId,
      if (policeUnitId != null) 'police_unit_id': policeUnitId,
      if (status != null) 'status': status,
    };
  }
}
