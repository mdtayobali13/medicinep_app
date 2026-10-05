import 'distribution_model.dart';

class MonthlyReportModel {
  final String month;
  final int stockQuantity;
  final int distributionQuantity;
  final int remainingQuantity;
  final int damagedQuantity;
  final int expiredQuantity;

  MonthlyReportModel({
    required this.month,
    required this.stockQuantity,
    required this.distributionQuantity,
    required this.remainingQuantity,
    required this.damagedQuantity,
    required this.expiredQuantity,
  });

  factory MonthlyReportModel.fromJson(Map<String, dynamic> json) {
    int parseVal(dynamic v) {
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v) ?? (double.tryParse(v)?.toInt() ?? 0);
      return 0;
    }

    return MonthlyReportModel(
      month: json['month']?.toString() ?? '',
      stockQuantity: parseVal(json['stockQuantity'] ?? json['stock_quantity'] ?? json['stock']),
      distributionQuantity: parseVal(json['distributionQuantity'] ?? json['distribution_quantity'] ?? json['distributed']),
      remainingQuantity: parseVal(json['remainingQuantity'] ?? json['remaining_quantity'] ?? json['remaining']),
      damagedQuantity: parseVal(json['damaged_quantity'] ?? json['damagedQuantity'] ?? json['damaged']),
      expiredQuantity: parseVal(json['expired_quantity'] ?? json['expiredQuantity'] ?? json['expired']),
    );
  }
}

class DashboardModel {
  final int systemUsers;
  final int totalPatients;
  final int totalMedicines;
  final int medicineStock;
  final int totalDistributions;
  final int medicineRemaining;
  final int medicineExpiration;
  final int medicineDamaged;
  final double distributionPercentage;
  final double remainingPercentage;
  final double expiredPercentage;
  final double damagedPercentage;
  final int lowStockAlerts;
  final List<DistributionModel> recentDistributions;
  final List<MonthlyReportModel> monthlyReport;

  DashboardModel({
    required this.systemUsers,
    required this.totalPatients,
    required this.totalMedicines,
    required this.medicineStock,
    required this.totalDistributions,
    required this.medicineRemaining,
    required this.medicineExpiration,
    required this.medicineDamaged,
    this.distributionPercentage = 0.0,
    this.remainingPercentage = 0.0,
    this.expiredPercentage = 0.0,
    this.damagedPercentage = 0.0,
    required this.lowStockAlerts,
    required this.recentDistributions,
    this.monthlyReport = const [],
  });

  DashboardModel copyWith({
    int? systemUsers,
    int? totalPatients,
    int? totalMedicines,
    int? medicineStock,
    int? totalDistributions,
    int? medicineRemaining,
    int? medicineExpiration,
    int? medicineDamaged,
    double? distributionPercentage,
    double? remainingPercentage,
    double? expiredPercentage,
    double? damagedPercentage,
    int? lowStockAlerts,
    List<DistributionModel>? recentDistributions,
    List<MonthlyReportModel>? monthlyReport,
  }) {
    return DashboardModel(
      systemUsers: systemUsers ?? this.systemUsers,
      totalPatients: totalPatients ?? this.totalPatients,
      totalMedicines: totalMedicines ?? this.totalMedicines,
      medicineStock: medicineStock ?? this.medicineStock,
      totalDistributions: totalDistributions ?? this.totalDistributions,
      medicineRemaining: medicineRemaining ?? this.medicineRemaining,
      medicineExpiration: medicineExpiration ?? this.medicineExpiration,
      medicineDamaged: medicineDamaged ?? this.medicineDamaged,
      distributionPercentage: distributionPercentage ?? this.distributionPercentage,
      remainingPercentage: remainingPercentage ?? this.remainingPercentage,
      expiredPercentage: expiredPercentage ?? this.expiredPercentage,
      damagedPercentage: damagedPercentage ?? this.damagedPercentage,
      lowStockAlerts: lowStockAlerts ?? this.lowStockAlerts,
      recentDistributions: recentDistributions ?? this.recentDistributions,
      monthlyReport: monthlyReport ?? this.monthlyReport,
    );
  }

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    List<DistributionModel> list = [];
    final rawList = json['recent_distributions'] ?? json['recentDistributions'] ?? json['recent_distribution'] ?? json['distributions'];
    if (rawList is List) {
      list = rawList
          .whereType<Map>()
          .map((e) => DistributionModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    List<MonthlyReportModel> reportList = [];
    final rawReport = json['monthly_report'] ?? json['monthlyReport'] ?? json['report'];
    if (rawReport is List) {
      reportList = rawReport
          .whereType<Map>()
          .map((e) => MonthlyReportModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    int parseVal(dynamic v) {
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v) ?? (double.tryParse(v)?.toInt() ?? 0);
      if (v != null) return int.tryParse(v.toString()) ?? 0;
      return 0;
    }

    double parseDouble(dynamic v) {
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    int stockVal = parseVal(
      json['total_stock_quantity'] ??
      json['medicine_stock'] ??
      json['medicineStock'] ??
      json['total_stock'] ??
      json['stock'] ??
      json['stock_quantity'],
    );
    int distVal = parseVal(
      json['total_distributed_quantity'] ??
      json['total_distributions'] ??
      json['totalDistributions'] ??
      json['medicine_distributed'] ??
      json['distributed_quantity'] ??
      json['distributed'],
    );
    int remVal = parseVal(
      json['total_remaining_quantity'] ??
      json['medicine_remaining'] ??
      json['medicineRemaining'] ??
      json['remaining_stock'] ??
      json['remaining_quantity'] ??
      json['remaining'],
    );

    int totalMedVal = parseVal(
      json['total_medicines'] ??
      json['total_medicine'] ??
      json['totalMedicines'] ??
      json['totalMedicine'] ??
      json['medicines_count'] ??
      json['medicine_count'] ??
      json['total_medicines_count'] ??
      json['total_medicine_count'] ??
      json['medicines'] ??
      json['total_items'],
    );

    if (totalMedVal == 0 && (stockVal > 0 || distVal > 0 || remVal > 0)) {
      totalMedVal = stockVal + distVal;
    }

    double distPct = parseDouble(json['distribution_percentage'] ?? json['distributionPercentage']);
    double remPct = parseDouble(json['remaining_percentage'] ?? json['remainingPercentage']);
    double expPct = parseDouble(json['expired_percentage'] ?? json['expiredPercentage'] ?? json['expired_quantity']);
    double dmgPct = parseDouble(json['damaged_percentage'] ?? json['damagedPercentage'] ?? json['damaged_quantity']);

    if (distPct == 0.0 && remPct == 0.0 && stockVal > 0) {
      distPct = double.parse(((distVal / stockVal) * 100).toStringAsFixed(2));
      remPct = double.parse(((remVal / stockVal) * 100).toStringAsFixed(2));
    }

    return DashboardModel(
      systemUsers: parseVal(
        json['total_admin_users'] ??
        json['total_admin_user'] ??
        json['system_users'] ??
        json['systemUsers'] ??
        json['total_users'] ??
        json['total_user'] ??
        json['users_count'] ??
        json['users'],
      ),
      totalPatients: parseVal(
        json['total_patients'] ??
        json['total_patient'] ??
        json['totalPatients'] ??
        json['patients_count'] ??
        json['patient_count'] ??
        json['patients'],
      ),
      totalMedicines: totalMedVal,
      medicineStock: stockVal,
      totalDistributions: distVal,
      medicineRemaining: remVal,
      medicineExpiration: parseVal(
        json['expired_quantity'] ??
        json['medicine_expiration'] ??
        json['expired_count'] ??
        json['total_expired'] ??
        json['expired'],
      ),
      medicineDamaged: parseVal(
        json['damaged_quantity'] ??
        json['medicine_damaged'] ??
        json['damaged_count'] ??
        json['total_damaged'] ??
        json['damaged'],
      ),
      distributionPercentage: distPct,
      remainingPercentage: remPct,
      expiredPercentage: expPct,
      damagedPercentage: dmgPct,
      lowStockAlerts: parseVal(
        json['low_stock_count'] ??
        json['lowStockCount'] ??
        json['low_stock_alerts'],
      ),
      recentDistributions: list,
      monthlyReport: reportList,
    );
  }
}
