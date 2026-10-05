import 'package:flutter_riverpod/legacy.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/models/police_unit_model.dart';
import 'package:medicine_system/services/repository/police_units_repository.dart';

class PoliceUnitsState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<PoliceUnitModel> list;
  final String searchText;
  final int perPage;
  final PaginationMeta? meta;
  final String? error;

  bool get hasMore => meta == null ? (list.length >= perPage) : (meta!.currentPage < meta!.lastPage);

  PoliceUnitsState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.list = const [],
    this.searchText = '',
    this.perPage = 10,
    this.meta,
    this.error,
  });

  PoliceUnitsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<PoliceUnitModel>? list,
    String? searchText,
    int? perPage,
    PaginationMeta? meta,
    String? error,
  }) {
    return PoliceUnitsState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      list: list ?? this.list,
      searchText: searchText ?? this.searchText,
      perPage: perPage ?? this.perPage,
      meta: meta ?? this.meta,
      error: error,
    );
  }
}

class PoliceUnitsNotifier extends StateNotifier<PoliceUnitsState> {
  PoliceUnitsNotifier() : super(PoliceUnitsState()) {
    fetchPoliceUnits();
  }

  final _repo = PoliceUnitsRepository.instance;

  Future<void> fetchPoliceUnits({int page = 1, int? perPage, String? search}) async {
    final querySearch = search ?? state.searchText;
    final queryPerPage = perPage ?? state.perPage;
    state = state.copyWith(isLoading: true, searchText: querySearch, perPage: queryPerPage, error: null);

    final res = await _repo.getPoliceUnits(page: page, perPage: queryPerPage, searchText: querySearch);
    if (res != null) {
      state = state.copyWith(
        isLoading: false,
        list: res.data,
        meta: res.meta,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load police units from API',
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    final nextPage = (state.meta?.currentPage ?? (state.list.length ~/ state.perPage)) + 1;
    state = state.copyWith(isLoadingMore: true);

    final res = await _repo.getPoliceUnits(
      page: nextPage,
      perPage: state.perPage,
      searchText: state.searchText,
    );

    if (res != null) {
      state = state.copyWith(
        isLoadingMore: false,
        list: [...state.list, ...res.data],
        meta: res.meta,
      );
    } else {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  Future<bool> createPoliceUnit(String name, {String? code}) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.createPoliceUnit({
      'name': name,
      if (code != null && code.isNotEmpty) 'code': code,
      'status': 1,
    });
    if (success) {
      final newItem = PoliceUnitModel(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        name: name,
        code: code,
        index: (state.meta?.total ?? state.list.length) + 1,
        createdAt: DateTime.now().toIso8601String(),
      );
      state = state.copyWith(isLoading: false, list: [newItem, ...state.list]);
    }
    await fetchPoliceUnits();
    return success;
  }

  Future<bool> updatePoliceUnit(int id, String name, {String? code}) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.updatePoliceUnit(id, {
      'name': name,
      if (code != null && code.isNotEmpty) 'code': code,
      'status': 1,
    });
    if (success) {
      final updatedList = state.list.map((e) => e.id == id ? PoliceUnitModel(id: id, name: name, code: code, index: e.index, createdAt: e.createdAt) : e).toList();
      state = state.copyWith(isLoading: false, list: updatedList);
    }
    await fetchPoliceUnits();
    return success;
  }

  Future<bool> deletePoliceUnit(int id) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.deletePoliceUnit(id);
    if (success) {
      final updatedList = state.list.where((e) => e.id != id).toList();
      state = state.copyWith(isLoading: false, list: updatedList);
    }
    await fetchPoliceUnits();
    return success;
  }
}

final policeUnitsProvider = StateNotifierProvider<PoliceUnitsNotifier, PoliceUnitsState>((ref) {
  return PoliceUnitsNotifier();
});
