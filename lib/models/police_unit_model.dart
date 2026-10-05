class PoliceUnitModel {
  final int id;
  final String name;
  final String? code;
  final dynamic status;
  final dynamic index;
  final String? createdAt;
  final String? updatedAt;

  PoliceUnitModel({
    required this.id,
    required this.name,
    this.code,
    this.status,
    this.index,
    this.createdAt,
    this.updatedAt,
  });

  factory PoliceUnitModel.fromJson(Map<String, dynamic> json) {
    return PoliceUnitModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString(),
      status: json['status'],
      index: json['index'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (code != null) 'code': code,
      if (status != null) 'status': status,
      if (index != null) 'index': index,
    };
  }
}
