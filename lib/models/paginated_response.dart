class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] is int ? json['current_page'] : int.tryParse(json['current_page']?.toString() ?? '1') ?? 1,
      lastPage: json['last_page'] is int ? json['last_page'] : int.tryParse(json['last_page']?.toString() ?? '1') ?? 1,
      perPage: json['per_page'] is int ? json['per_page'] : int.tryParse(json['per_page']?.toString() ?? '10') ?? 10,
      total: json['total'] is int ? json['total'] : int.tryParse(json['total']?.toString() ?? '0') ?? 0,
    );
  }
}

class PaginatedResponse<T> {
  final List<T> data;
  final PaginationMeta? meta;

  PaginatedResponse({
    required this.data,
    this.meta,
  });

  factory PaginatedResponse.fromJson(
    dynamic json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    List<T> items = [];
    PaginationMeta? meta;

    if (json is Map<String, dynamic>) {
      dynamic rawData = json['data'];

      if (rawData is Map && rawData['data'] is List) {
        items = (rawData['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => fromJsonT(e))
            .toList();
        if (rawData['meta'] is Map<String, dynamic>) {
          meta = PaginationMeta.fromJson(rawData['meta']);
        }
      } else if (rawData is List) {
        items = rawData
            .whereType<Map<String, dynamic>>()
            .map((e) => fromJsonT(e))
            .toList();
      } else if (json['data'] is List) {
        items = (json['data'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => fromJsonT(e))
            .toList();
      }

      if (meta == null && json['meta'] is Map<String, dynamic>) {
        meta = PaginationMeta.fromJson(json['meta']);
      }
    } else if (json is List) {
      items = json
          .whereType<Map<String, dynamic>>()
          .map((e) => fromJsonT(e))
          .toList();
    }

    return PaginatedResponse<T>(
      data: items,
      meta: meta,
    );
  }
}
