import 'medicine_category_model.dart';
import 'medicine_unit_model.dart';

class MedicineModel {
  final int id;
  final String brandName;
  final String? genericName;
  final int? categoryId;
  final int? unitId;
  final int? alertQuantity;
  final int? currentStock;
  final dynamic status;
  final String? description;
  final MedicineCategoryModel? category;
  final MedicineUnitModel? unit;
  final String? createdAt;
  final String? updatedAt;

  MedicineModel({
    required this.id,
    required this.brandName,
    this.genericName,
    this.categoryId,
    this.unitId,
    this.alertQuantity,
    this.currentStock,
    this.status,
    this.description,
    this.category,
    this.unit,
    this.createdAt,
    this.updatedAt,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      brandName: json['brand_name']?.toString() ?? json['name']?.toString() ?? '',
      genericName: json['generic_name']?.toString(),
      categoryId: json['category_id'] is int ? json['category_id'] : int.tryParse(json['category_id']?.toString() ?? ''),
      unitId: json['unit_id'] is int ? json['unit_id'] : int.tryParse(json['unit_id']?.toString() ?? ''),
      alertQuantity: json['alert_quantity'] is int ? json['alert_quantity'] : int.tryParse(json['alert_quantity']?.toString() ?? ''),
      currentStock: json['current_stock'] is int ? json['current_stock'] : int.tryParse(json['current_stock']?.toString() ?? ''),
      status: json['status'],
      description: json['description']?.toString(),
      category: json['category'] is Map<String, dynamic> ? MedicineCategoryModel.fromJson(json['category']) : null,
      unit: json['unit'] is Map<String, dynamic> ? MedicineUnitModel.fromJson(json['unit']) : null,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand_name': brandName,
      if (genericName != null) 'generic_name': genericName,
      if (categoryId != null) 'category_id': categoryId,
      if (unitId != null) 'unit_id': unitId,
      if (alertQuantity != null) 'alert_quantity': alertQuantity,
      if (status != null) 'status': status,
      if (description != null) 'description': description,
    };
  }
}
