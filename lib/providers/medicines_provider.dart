import 'package:flutter_riverpod/legacy.dart';
import 'package:medicine_system/models/medicine_model.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/services/repository/medicines_repository.dart';

class MedicinesState {
  final bool isLoading;
  final List<MedicineModel> list;
  final String searchText;
  final PaginationMeta? meta;
  final String? error;

  MedicinesState({
    this.isLoading = false,
    this.list = const [],
    this.searchText = '',
    this.meta,
    this.error,
  });

  MedicinesState copyWith({
    bool? isLoading,
    List<MedicineModel>? list,
    String? searchText,
    PaginationMeta? meta,
    String? error,
  }) {
    return MedicinesState(
      isLoading: isLoading ?? this.isLoading,
      list: list ?? this.list,
      searchText: searchText ?? this.searchText,
      meta: meta ?? this.meta,
      error: error,
    );
  }
}

class MedicinesNotifier extends StateNotifier<MedicinesState> {
  MedicinesNotifier() : super(MedicinesState()) {
    fetchMedicines();
  }

  final _repo = MedicinesRepository.instance;

  Future<void> fetchMedicines({int page = 1, String? search}) async {
    final querySearch = search ?? state.searchText;
    state = state.copyWith(isLoading: true, searchText: querySearch, error: null);

    final res = await _repo.getMedicines(page: page, searchText: querySearch);
    if (res != null) {
      state = state.copyWith(
        isLoading: false,
        list: res.data,
        meta: res.meta,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load medicines from API',
      );
    }
  }

  Future<bool> createMedicine(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.createMedicine(data);
    fetchMedicines();
    return success;
  }

  Future<bool> updateMedicine(int id, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.updateMedicine(id, data);
    fetchMedicines();
    return success;
  }

  Future<bool> deleteMedicine(int id) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.deleteMedicine(id);
    fetchMedicines();
    return success;
  }
}

final medicinesProvider = StateNotifierProvider<MedicinesNotifier, MedicinesState>((ref) {
  return MedicinesNotifier();
});
