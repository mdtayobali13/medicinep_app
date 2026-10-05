import 'medicine_model.dart';

class StockModel {
  final int id;
  final int medicineId;
  final int quantity;
  final String? batchNumber;
  final String? expireDate;
  final String? purchaseDate;
  final String? supplierName;
  final MedicineModel? medicine;
  final String? createdAt;
  final String? updatedAt;

  StockModel({
    required this.id,
    required this.medicineId,
    required this.quantity,
    this.batchNumber,
    this.expireDate,
    this.purchaseDate,
    this.supplierName,
    this.medicine,
    this.createdAt,
    this.updatedAt,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      medicineId: json['medicine_id'] is int ? json['medicine_id'] : int.tryParse(json['medicine_id']?.toString() ?? '0') ?? 0,
      quantity: json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      batchNumber: json['batch_number']?.toString(),
      expireDate: json['expire_date']?.toString(),
      purchaseDate: json['purchase_date']?.toString(),
      supplierName: json['supplier_name']?.toString(),
      medicine: json['medicine'] is Map<String, dynamic> ? MedicineModel.fromJson(json['medicine']) : null,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicine_id': medicineId,
      'quantity': quantity,
      if (batchNumber != null) 'batch_number': batchNumber,
      if (expireDate != null) 'expire_date': expireDate,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (supplierName != null) 'supplier_name': supplierName,
    };
  }
}
