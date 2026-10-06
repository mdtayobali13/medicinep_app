import 'package:flutter_riverpod/legacy.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/models/stock_report_model.dart';
import 'package:medicine_system/services/repository/stocks_repository.dart';

class StockReportsState {
  final bool isLoading;
  final List<StockReportModel> list;
  final String searchText;
  final String? startDate;
  final String? endDate;
  final PaginationMeta? meta;
  final String? error;

  StockReportsState({
    this.isLoading = false,
    this.list = const [],
    this.searchText = '',
    this.startDate,
    this.endDate,
    this.meta,
    this.error,
  });

  StockReportsState copyWith({
    bool? isLoading,
    List<StockReportModel>? list,
    String? searchText,
    String? startDate,
    String? endDate,
    PaginationMeta? meta,
    String? error,
  }) {
    return StockReportsState(
      isLoading: isLoading ?? this.isLoading,
      list: list ?? this.list,
      searchText: searchText ?? this.searchText,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      meta: meta ?? this.meta,
      error: error,
    );
  }
}

class StockReportsNotifier extends StateNotifier<StockReportsState> {
  StockReportsNotifier() : super(StockReportsState()) {
    fetchReports();
  }

  final _repo = StocksRepository.instance;

  Future<void> fetchReports({
    int page = 1,
    String? search,
    String? startDate,
    String? endDate,
  }) async {
    final querySearch = search ?? state.searchText;
    final queryStart = startDate ?? state.startDate;
    final queryEnd = endDate ?? state.endDate;

    state = state.copyWith(
      isLoading: true,
      searchText: querySearch,
      startDate: queryStart,
      endDate: queryEnd,
      error: null,
    );

    final res = await _repo.getStockReports(
      page: page,
      searchText: querySearch,
      startDate: queryStart,
      endDate: queryEnd,
    );

    if (res != null) {
      state = state.copyWith(
        isLoading: false,
        list: res.data,
        meta: res.meta,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load stock reports from API',
      );
    }
  }
}

final stockReportsProvider = StateNotifierProvider<StockReportsNotifier, StockReportsState>((ref) {
  return StockReportsNotifier();
});
