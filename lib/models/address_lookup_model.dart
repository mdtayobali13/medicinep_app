class LocationItemModel {
  final int id;
  final String name;
  final String? bnName;

  LocationItemModel({
    required this.id,
    required this.name,
    this.bnName,
  });

  factory LocationItemModel.fromJson(Map<String, dynamic> json) {
    return LocationItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      bnName: json['bn_name']?.toString(),
    );
  }
}
