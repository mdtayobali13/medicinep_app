class StockReportModel {
  final int medicineId;
  final String medicineName;
  final int previousStock;
  final int stockBetween;
  final int totalStock;
  final int remainingFromStocks;
  final int previousDistribution;
  final int distributionBetween;
  final int totalDistribution;
  final int remainingCalculated;
  final bool isOutOfStock;

  StockReportModel({
    required this.medicineId,
    required this.medicineName,
    required this.previousStock,
    required this.stockBetween,
    required this.totalStock,
    required this.remainingFromStocks,
    required this.previousDistribution,
    required this.distributionBetween,
    required this.totalDistribution,
    required this.remainingCalculated,
    required this.isOutOfStock,
  });

  factory StockReportModel.fromJson(Map<String, dynamic> json) {
    return StockReportModel(
      medicineId: json['medicine_id'] ?? 0,
      medicineName: json['medicine_name'] ?? 'Unknown',
      previousStock: json['previous_stock'] ?? 0,
      stockBetween: json['stock_between'] ?? 0,
      totalStock: json['total_stock'] ?? 0,
      remainingFromStocks: json['remaining_from_stocks'] ?? 0,
      previousDistribution: json['previous_distribution'] ?? 0,
      distributionBetween: json['distribution_between'] ?? 0,
      totalDistribution: json['total_distribution'] ?? 0,
      remainingCalculated: json['remaining_calculated'] ?? 0,
      isOutOfStock: json['is_out_of_stock'] == true || json['is_out_of_stock'] == 1,
    );
  }
}
