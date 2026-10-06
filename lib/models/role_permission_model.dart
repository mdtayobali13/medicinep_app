class PermissionModel {
  final int id;
  final String name;
  final String? guardName;
  final String group;
  final String slug;

  PermissionModel({
    required this.id,
    required this.name,
    this.guardName,
    this.group = '',
    this.slug = '',
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      guardName: json['guard_name']?.toString(),
      group: json['group']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
    );
  }
}

class RoleModel {
  final int id;
  final String name;
  final List<PermissionModel> permissions;

  RoleModel({
    required this.id,
    required this.name,
    this.permissions = const [],
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    List<PermissionModel> permList = [];
    if (json['permissions'] is List) {
      permList = (json['permissions'] as List).map((e) => PermissionModel.fromJson(e as Map<String, dynamic>)).toList();
    }

    return RoleModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      permissions: permList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'permissions': permissions.map((e) => e.name).toList(),
    };
  }
}
