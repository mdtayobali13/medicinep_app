import 'package:flutter_riverpod/legacy.dart';
import 'package:medicine_system/models/medicine_category_model.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/services/repository/medicine_categories_repository.dart';

class MedicineCategoriesState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<MedicineCategoryModel> list;
  final String searchText;
  final int perPage;
  final PaginationMeta? meta;
  final String? error;

  bool get hasMore => meta == null ? (list.length >= perPage) : (meta!.currentPage < meta!.lastPage);

  MedicineCategoriesState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.list = const [],
    this.searchText = '',
    this.perPage = 10,
    this.meta,
    this.error,
  });

  MedicineCategoriesState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<MedicineCategoryModel>? list,
    String? searchText,
    int? perPage,
    PaginationMeta? meta,
    String? error,
  }) {
    return MedicineCategoriesState(
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

class MedicineCategoriesNotifier extends StateNotifier<MedicineCategoriesState> {
  MedicineCategoriesNotifier() : super(MedicineCategoriesState()) {
    fetchCategories();
  }

  final _repo = MedicineCategoriesRepository.instance;

  Future<void> fetchCategories({int page = 1, int? perPage, String? search}) async {
    final querySearch = search ?? state.searchText;
    final queryPerPage = perPage ?? state.perPage;
    state = state.copyWith(isLoading: true, searchText: querySearch, perPage: queryPerPage, error: null);

    final res = await _repo.getCategories(page: page, perPage: queryPerPage, searchText: querySearch);
    if (res != null) {
      state = state.copyWith(
        isLoading: false,
        list: res.data,
        meta: res.meta,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load categories from API',
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    final nextPage = (state.meta?.currentPage ?? (state.list.length ~/ state.perPage)) + 1;
    state = state.copyWith(isLoadingMore: true);

    final res = await _repo.getCategories(
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

  Future<bool> createCategory(String name, {String? description}) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.createCategory({
      'name': name,
      if (description != null && description.isNotEmpty) 'description': description,
      'status': 1,
    });
    if (success) {
      final newItem = MedicineCategoryModel(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        name: name,
        description: description,
        index: (state.meta?.total ?? state.list.length) + 1,
        createdAt: DateTime.now().toIso8601String(),
      );
      state = state.copyWith(isLoading: false, list: [newItem, ...state.list]);
    }
    await fetchCategories();
    return success;
  }

  Future<bool> updateCategory(int id, String name, {String? description}) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.updateCategory(id, {
      'name': name,
      if (description != null && description.isNotEmpty) 'description': description,
      'status': 1,
    });
    if (success) {
      final updatedList = state.list.map((e) => e.id == id ? MedicineCategoryModel(id: id, name: name, description: description, index: e.index, createdAt: e.createdAt) : e).toList();
      state = state.copyWith(isLoading: false, list: updatedList);
    }
    await fetchCategories();
    return success;
  }

  Future<bool> deleteCategory(int id) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.deleteCategory(id);
    if (success) {
      final updatedList = state.list.where((e) => e.id != id).toList();
      state = state.copyWith(isLoading: false, list: updatedList);
    }
    await fetchCategories();
    return success;
  }
}

final medicineCategoriesProvider = StateNotifierProvider<MedicineCategoriesNotifier, MedicineCategoriesState>((ref) {
  return MedicineCategoriesNotifier();
});
