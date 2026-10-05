class DesignationModel {
  final int id;
  final String name;
  final dynamic status;
  final dynamic index;
  final String? createdAt;
  final String? updatedAt;

  DesignationModel({
    required this.id,
    required this.name,
    this.status,
    this.index,
    this.createdAt,
    this.updatedAt,
  });

  factory DesignationModel.fromJson(Map<String, dynamic> json) {
    return DesignationModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      status: json['status'],
      index: json['index'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (status != null) 'status': status,
      if (index != null) 'index': index,
    };
  }
}
