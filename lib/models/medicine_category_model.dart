class MedicineCategoryModel {
  final int id;
  final String name;
  final String? description;
  final dynamic status;
  final dynamic index;
  final String? createdAt;
  final String? updatedAt;

  MedicineCategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.status,
    this.index,
    this.createdAt,
    this.updatedAt,
  });

  factory MedicineCategoryModel.fromJson(Map<String, dynamic> json) {
    return MedicineCategoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      status: json['status'],
      index: json['index'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (index != null) 'index': index,
    };
  }
}
