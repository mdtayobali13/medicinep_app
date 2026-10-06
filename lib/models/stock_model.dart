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
    Map<String, dynamic> medMap = {};
    if (json['medicine'] is Map<String, dynamic>) {
      medMap = Map<String, dynamic>.from(json['medicine']);
    }
    if (medMap['id'] == null && json['medicine_id'] != null) {
      medMap['id'] = json['medicine_id'];
    }
    if (medMap['brand_name'] == null && (json['medicine_name'] != null || json['brand_name'] != null)) {
      medMap['brand_name'] = json['medicine_name'] ?? json['brand_name'];
    }
    final rootStockVal = json['current_stock'] ??
        json['stock'] ??
        json['total_stock'] ??
        json['current_stocks'] ??
        json['total_current_stock'];
    if (medMap['current_stock'] == null && rootStockVal != null) {
      medMap['current_stock'] = rootStockVal;
    }
    final rootUnit = json['unit'] ?? json['medicine_unit'] ?? json['unit_name'] ?? json['medicine_unit_name'];
    if (medMap['unit'] == null && medMap['medicine_unit'] == null && medMap['unit_name'] == null && rootUnit != null) {
      medMap['unit'] = rootUnit;
    }
    if (medMap['unit_id'] == null && json['unit_id'] != null) {
      medMap['unit_id'] = json['unit_id'];
    }

    final medObj = medMap.isNotEmpty ? MedicineModel.fromJson(medMap) : null;
    final medId = json['medicine_id'] is int
        ? json['medicine_id']
        : (int.tryParse(json['medicine_id']?.toString() ?? '') ?? medObj?.id ?? 0);

    return StockModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      medicineId: medId,
      quantity: json['quantity'] is int
          ? json['quantity']
          : (int.tryParse(json['quantity']?.toString() ?? json['qty']?.toString() ?? '0') ?? 0),
      batchNumber: json['batch_number']?.toString() ??
          json['lot_memo_no']?.toString() ??
          json['lot_memo_number']?.toString() ??
          json['lot_memo']?.toString() ??
          json['lot_no']?.toString() ??
          json['memo_no']?.toString() ??
          json['memo_number']?.toString() ??
          json['batch_no']?.toString() ??
          json['batch']?.toString(),
      expireDate: json['expire_date']?.toString() ?? json['expiry_date']?.toString(),
      purchaseDate: json['purchase_date']?.toString() ??
          json['received_date']?.toString() ??
          json['date']?.toString() ??
          json['entry_date']?.toString() ??
          json['created_at']?.toString(),
      supplierName: json['supplier_name']?.toString(),
      medicine: medObj,
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
