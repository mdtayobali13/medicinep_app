import 'package:flutter_riverpod/legacy.dart';
import 'package:medicine_system/models/distribution_model.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/services/repository/distributions_repository.dart';

class DistributionsState {
  final bool isLoading;
  final List<DistributionModel> list;
  final String searchText;
  final int perPage;
  final PaginationMeta? meta;
  final String? error;

  DistributionsState({
    this.isLoading = false,
    this.list = const [],
    this.searchText = '',
    this.perPage = 10,
    this.meta,
    this.error,
  });

  DistributionsState copyWith({
    bool? isLoading,
    List<DistributionModel>? list,
    String? searchText,
    int? perPage,
    PaginationMeta? meta,
    String? error,
  }) {
    return DistributionsState(
      isLoading: isLoading ?? this.isLoading,
      list: list ?? this.list,
      searchText: searchText ?? this.searchText,
      perPage: perPage ?? this.perPage,
      meta: meta ?? this.meta,
      error: error,
    );
  }
}

class DistributionsNotifier extends StateNotifier<DistributionsState> {
  DistributionsNotifier() : super(DistributionsState()) {
    fetchDistributions();
  }

  final _repo = DistributionsRepository.instance;

  Future<void> fetchDistributions({int page = 1, int? perPage, String? search}) async {
    final querySearch = search ?? state.searchText;
    final queryPerPage = perPage ?? state.perPage;
    state = state.copyWith(isLoading: true, searchText: querySearch, perPage: queryPerPage, error: null);

    final res = await _repo.getDistributions(page: page, perPage: queryPerPage, searchText: querySearch);
    if (res != null) {
      state = state.copyWith(
        isLoading: false,
        list: res.data,
        meta: res.meta,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load distribution records from API',
      );
    }
  }

  Future<bool> createDistribution(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.createDistribution(data);
    fetchDistributions();
    return success;
  }

  Future<bool> deleteDistribution(int id) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.deleteDistribution(id);
    fetchDistributions();
    return success;
  }
}

final distributionsProvider = StateNotifierProvider<DistributionsNotifier, DistributionsState>((ref) {
  return DistributionsNotifier();
});
