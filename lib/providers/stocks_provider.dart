import 'package:flutter_riverpod/legacy.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/models/stock_model.dart';
import 'package:medicine_system/services/repository/stocks_repository.dart';

class StocksState {
  final bool isLoading;
  final List<StockModel> list;
  final String searchText;
  final PaginationMeta? meta;
  final String? error;

  StocksState({
    this.isLoading = false,
    this.list = const [],
    this.searchText = '',
    this.meta,
    this.error,
  });

  StocksState copyWith({
    bool? isLoading,
    List<StockModel>? list,
    String? searchText,
    PaginationMeta? meta,
    String? error,
  }) {
    return StocksState(
      isLoading: isLoading ?? this.isLoading,
      list: list ?? this.list,
      searchText: searchText ?? this.searchText,
      meta: meta ?? this.meta,
      error: error,
    );
  }
}

class StocksNotifier extends StateNotifier<StocksState> {
  StocksNotifier() : super(StocksState()) {
    fetchStocks();
  }

  final _repo = StocksRepository.instance;

  Future<void> fetchStocks({int page = 1, String? search}) async {
    final querySearch = search ?? state.searchText;
    state = state.copyWith(isLoading: true, searchText: querySearch, error: null);

    final res = await _repo.getStocks(page: page, searchText: querySearch);
    if (res != null) {
      state = state.copyWith(
        isLoading: false,
        list: res.data,
        meta: res.meta,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load stock records from API',
      );
    }
  }

  Future<bool> createStock(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.createStock(data);
    fetchStocks();
    return success;
  }

  Future<bool> updateStock(int id, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.updateStock(id, data);
    fetchStocks();
    return success;
  }

  Future<bool> deleteStock(int id) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.deleteStock(id);
    fetchStocks();
    return success;
  }
}

final stocksProvider = StateNotifierProvider<StocksNotifier, StocksState>((ref) {
  return StocksNotifier();
});
