class MedicineUnitModel {
  final int id;
  final String name;
  final String? symbol;
  final dynamic status;
  final dynamic index;
  final String? createdAt;
  final String? updatedAt;

  MedicineUnitModel({
    required this.id,
    required this.name,
    this.symbol,
    this.status,
    this.index,
    this.createdAt,
    this.updatedAt,
  });

  factory MedicineUnitModel.fromJson(Map<String, dynamic> json) {
    return MedicineUnitModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      symbol: json['symbol']?.toString(),
      status: json['status'],
      index: json['index'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (symbol != null) 'symbol': symbol,
      if (status != null) 'status': status,
      if (index != null) 'index': index,
    };
  }
}
