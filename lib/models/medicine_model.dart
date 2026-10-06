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
  final String? currentStockRaw;
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
    this.currentStockRaw,
    this.status,
    this.description,
    this.category,
    this.unit,
    this.createdAt,
    this.updatedAt,
  });

  static int _parseStockInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    if (val is double) return val.toInt();
    final str = val.toString().trim();
    if (str.isEmpty) return 0;
    final direct = int.tryParse(str);
    if (direct != null) return direct;
    final dDirect = double.tryParse(str);
    if (dDirect != null) return dDirect.toInt();
    final match = RegExp(r'^\d+').firstMatch(str);
    if (match != null) {
      return int.tryParse(match.group(0)!) ?? 0;
    }
    return 0;
  }

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    final rawStock = json['current_stock'] ??
        json['stock'] ??
        json['total_stock'] ??
        json['quantity'] ??
        json['current_stocks'] ??
        json['total_current_stock'] ??
        json['available_stock'] ??
        json['available_quantity'] ??
        json['stock_quantity'] ??
        json['remaining_stock'] ??
        json['balance'];
    final rawStockStr = rawStock?.toString();
    final parsedStock = _parseStockInt(rawStock);

    MedicineUnitModel? unitObj;
    if (json['unit'] is Map<String, dynamic>) {
      unitObj = MedicineUnitModel.fromJson(json['unit']);
    } else if (json['medicine_unit'] is Map<String, dynamic>) {
      unitObj = MedicineUnitModel.fromJson(json['medicine_unit']);
    } else {
      final uName = json['unit_name']?.toString() ?? json['medicine_unit_name']?.toString() ?? json['unit_symbol']?.toString();
      if (uName != null && uName.isNotEmpty) {
        unitObj = MedicineUnitModel(id: json['unit_id'] is int ? json['unit_id'] : 0, name: uName);
      }
    }

    return MedicineModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      brandName: json['brand_name']?.toString() ?? json['name']?.toString() ?? '',
      genericName: json['generic_name']?.toString(),
      categoryId: json['category_id'] is int ? json['category_id'] : int.tryParse(json['category_id']?.toString() ?? ''),
      unitId: json['unit_id'] is int ? json['unit_id'] : int.tryParse(json['unit_id']?.toString() ?? ''),
      alertQuantity: json['alert_quantity'] is int ? json['alert_quantity'] : int.tryParse(json['alert_quantity']?.toString() ?? ''),
      currentStock: parsedStock,
      currentStockRaw: rawStockStr,
      status: json['status'],
      description: json['description']?.toString(),
      category: json['category'] is Map<String, dynamic> ? MedicineCategoryModel.fromJson(json['category']) : null,
      unit: unitObj,
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
