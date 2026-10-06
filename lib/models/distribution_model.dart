import 'medicine_model.dart';
import 'patient_model.dart';

class DistributionItemModel {
  final int id;
  final int? distributionId;
  final int medicineId;
  final int quantity;
  final int? durationDays;
  final String? instructions;
  final MedicineModel? medicine;

  DistributionItemModel({
    required this.id,
    this.distributionId,
    required this.medicineId,
    required this.quantity,
    this.durationDays,
    this.instructions,
    this.medicine,
  });

  factory DistributionItemModel.fromJson(Map<String, dynamic> json) {
    return DistributionItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      distributionId: json['distribution_id'] is int ? json['distribution_id'] : int.tryParse(json['distribution_id']?.toString() ?? ''),
      medicineId: json['medicine_id'] is int ? json['medicine_id'] : int.tryParse(json['medicine_id']?.toString() ?? '0') ?? 0,
      quantity: json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      durationDays: json['duration_days'] is int ? json['duration_days'] : int.tryParse(json['duration_days']?.toString() ?? ''),
      instructions: json['instructions']?.toString(),
      medicine: json['medicine'] is Map<String, dynamic> ? MedicineModel.fromJson(json['medicine']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicine_id': medicineId,
      'quantity': quantity,
      if (durationDays != null) 'duration_days': durationDays,
      if (instructions != null) 'instructions': instructions,
    };
  }
}

class DistributionModel {
  final int id;
  final int? patientId;
  final String? patientName;
  final String? bpNo;
  final String? receiverType;
  final String? prescriptionCode;
  final String? createdBy;
  final String? distributionDate;
  final String? notes;
  final PatientModel? patient;
  final List<DistributionItemModel> items;
  final String? createdAt;

  DistributionModel({
    required this.id,
    this.patientId,
    this.patientName,
    this.bpNo,
    this.receiverType,
    this.prescriptionCode,
    this.createdBy,
    this.distributionDate,
    this.notes,
    this.patient,
    required this.items,
    this.createdAt,
  });

  factory DistributionModel.fromJson(Map<String, dynamic> json) {
    List<DistributionItemModel> itemList = [];
    if (json['items'] is List) {
      itemList = (json['items'] as List).map((e) => DistributionItemModel.fromJson(e as Map<String, dynamic>)).toList();
    } else if (json['details'] is List) {
      itemList = (json['details'] as List).map((e) => DistributionItemModel.fromJson(e as Map<String, dynamic>)).toList();
    }

    String? createdByName;
    if (json['created_by'] is Map<String, dynamic>) {
      createdByName = json['created_by']['name']?.toString();
    } else if (json['created_by'] != null) {
      createdByName = json['created_by'].toString();
    }

    return DistributionModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      patientId: json['patient_id'] is int ? json['patient_id'] : int.tryParse(json['patient_id']?.toString() ?? ''),
      patientName: json['patient_name']?.toString() ?? json['patient']?['name']?.toString(),
      bpNo: json['bp_no']?.toString() ?? json['bp_number']?.toString() ?? json['patient']?['bp_number']?.toString() ?? json['patient']?['bp_no']?.toString(),
      receiverType: json['receiver_type']?.toString(),
      prescriptionCode: json['prescription_code']?.toString(),
      createdBy: createdByName,
      distributionDate: json['distribution_date']?.toString() ?? json['created_at']?.toString(),
      notes: json['notes']?.toString(),
      patient: json['patient'] is Map<String, dynamic> ? PatientModel.fromJson(json['patient']) : null,
      items: itemList,
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (patientId != null) 'patient_id': patientId,
      if (patientName != null) 'patient_name': patientName,
      if (bpNo != null) 'bp_no': bpNo,
      if (distributionDate != null) 'distribution_date': distributionDate,
      if (notes != null) 'notes': notes,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}
