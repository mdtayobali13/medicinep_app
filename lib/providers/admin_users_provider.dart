import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/models/user_model.dart';
import 'package:medicine_system/services/repository/admin_users_repository.dart';

class AdminUsersState {
  final bool isLoading;
  final bool isFetchingMore;
  final List<UserModel> users;
  final String? error;
  final PaginatedResponse<UserModel>? paginatedData;
  final String searchQuery;
  final int perPage;

  AdminUsersState({
    this.isLoading = false,
    this.isFetchingMore = false,
    this.users = const [],
    this.error,
    this.paginatedData,
    this.searchQuery = '',
    this.perPage = 10,
  });

  AdminUsersState copyWith({
    bool? isLoading,
    bool? isFetchingMore,
    List<UserModel>? users,
    String? error,
    PaginatedResponse<UserModel>? paginatedData,
    String? searchQuery,
    int? perPage,
  }) {
    return AdminUsersState(
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      users: users ?? this.users,
      error: error,
      paginatedData: paginatedData ?? this.paginatedData,
      searchQuery: searchQuery ?? this.searchQuery,
      perPage: perPage ?? this.perPage,
    );
  }
}

class AdminUsersNotifier extends StateNotifier<AdminUsersState> {
  AdminUsersNotifier() : super(AdminUsersState()) {
    fetchUsers(page: 1);
  }

  final _repo = AdminUsersRepository.instance;
  Timer? _debounce;

  Future<void> fetchUsers({int page = 1, bool isLoadMore = false}) async {
    if (isLoadMore) {
      state = state.copyWith(isFetchingMore: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    final res = await _repo.getUsers(
      page: page,
      perPage: state.perPage,
      searchText: state.searchQuery,
    );

    if (res != null) {
      if (isLoadMore) {
        state = state.copyWith(
          isFetchingMore: false,
          users: [...state.users, ...res.data],
          paginatedData: res,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          users: res.data,
          paginatedData: res,
        );
      }
    } else {
      state = state.copyWith(
        isLoading: false,
        isFetchingMore: false,
        error: 'Failed to load users',
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchUsers(page: 1);
    });
  }

  void setPerPage(int perPage) {
    state = state.copyWith(perPage: perPage);
    fetchUsers(page: 1);
  }

  Future<void> loadMore() async {
    if (state.isFetchingMore || state.isLoading) return;
    if (state.paginatedData?.meta?.currentPage != null && state.paginatedData?.meta?.lastPage != null) {
      if (state.paginatedData!.meta!.currentPage! < state.paginatedData!.meta!.lastPage!) {
        await fetchUsers(page: state.paginatedData!.meta!.currentPage! + 1, isLoadMore: true);
      }
    }
  }

  Future<bool> createUser(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.createUser(data);
    if (success) {
      fetchUsers(page: 1);
    } else {
      state = state.copyWith(isLoading: false);
    }
    return success;
  }

  Future<bool> updateUser(int id, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.updateUser(id, data);
    if (success) {
      fetchUsers(page: 1);
    } else {
      state = state.copyWith(isLoading: false);
    }
    return success;
  }

  Future<bool> deleteUser(int id) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.deleteUser(id);
    if (success) {
      fetchUsers(page: 1);
    } else {
      state = state.copyWith(isLoading: false);
    }
    return success;
  }
}

final adminUsersProvider = StateNotifierProvider<AdminUsersNotifier, AdminUsersState>((ref) {
  return AdminUsersNotifier();
});
