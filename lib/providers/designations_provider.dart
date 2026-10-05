import 'package:flutter_riverpod/legacy.dart';
import 'package:medicine_system/models/designation_model.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/services/repository/designations_repository.dart';

class DesignationsState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<DesignationModel> list;
  final String searchText;
  final int perPage;
  final PaginationMeta? meta;
  final String? error;

  bool get hasMore => meta == null ? (list.length >= perPage) : (meta!.currentPage < meta!.lastPage);

  DesignationsState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.list = const [],
    this.searchText = '',
    this.perPage = 10,
    this.meta,
    this.error,
  });

  DesignationsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<DesignationModel>? list,
    String? searchText,
    int? perPage,
    PaginationMeta? meta,
    String? error,
  }) {
    return DesignationsState(
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

class DesignationsNotifier extends StateNotifier<DesignationsState> {
  DesignationsNotifier() : super(DesignationsState()) {
    fetchDesignations();
  }

  final _repo = DesignationsRepository.instance;

  Future<void> fetchDesignations({int page = 1, int? perPage, String? search}) async {
    final querySearch = search ?? state.searchText;
    final queryPerPage = perPage ?? state.perPage;
    state = state.copyWith(isLoading: true, searchText: querySearch, perPage: queryPerPage, error: null);

    final res = await _repo.getDesignations(page: page, perPage: queryPerPage, searchText: querySearch);
    if (res != null) {
      state = state.copyWith(
        isLoading: false,
        list: res.data,
        meta: res.meta,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load designations from API',
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    final nextPage = (state.meta?.currentPage ?? (state.list.length ~/ state.perPage)) + 1;
    state = state.copyWith(isLoadingMore: true);

    final res = await _repo.getDesignations(
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

  Future<bool> createDesignation(String name, {int? index}) async {
    state = state.copyWith(isLoading: true);
    final calculatedIndex = index ?? (state.meta?.total ?? state.list.length) + 1;
    final success = await _repo.createDesignation({'name': name, 'status': 1, 'index': calculatedIndex});
    if (success) {
      final newItem = DesignationModel(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        name: name,
        index: calculatedIndex,
        createdAt: DateTime.now().toIso8601String(),
      );
      state = state.copyWith(
        isLoading: false,
        list: [newItem, ...state.list],
      );
    }
    await fetchDesignations();
    return success;
  }

  Future<bool> updateDesignation(int id, String name, {int? index}) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.updateDesignation(id, {
      'name': name,
      'index': index,
      'status': 1,
    });
    if (success) {
      final updatedList = state.list
          .map((e) => e.id == id ? DesignationModel(id: id, name: name, index: index ?? e.index, createdAt: e.createdAt) : e)
          .toList();
      state = state.copyWith(isLoading: false, list: updatedList);
    }
    await fetchDesignations();
    return success;
  }

  Future<bool> deleteDesignation(int id) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.deleteDesignation(id);
    if (success) {
      final updatedList = state.list.where((e) => e.id != id).toList();
      state = state.copyWith(isLoading: false, list: updatedList);
    }
    await fetchDesignations();
    return success;
  }
}

final designationsProvider = StateNotifierProvider<DesignationsNotifier, DesignationsState>((ref) {
  return DesignationsNotifier();
});
