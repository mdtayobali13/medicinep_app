import 'package:flutter_riverpod/legacy.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/models/patient_model.dart';
import 'package:medicine_system/services/repository/patients_repository.dart';

class PatientsState {
  final bool isLoading;
  final List<PatientModel> list;
  final String searchText;
  final int perPage;
  final PaginationMeta? meta;
  final String? error;

  PatientsState({
    this.isLoading = false,
    this.list = const [],
    this.searchText = '',
    this.perPage = 10,
    this.meta,
    this.error,
  });

  PatientsState copyWith({
    bool? isLoading,
    List<PatientModel>? list,
    String? searchText,
    int? perPage,
    PaginationMeta? meta,
    String? error,
  }) {
    return PatientsState(
      isLoading: isLoading ?? this.isLoading,
      list: list ?? this.list,
      searchText: searchText ?? this.searchText,
      perPage: perPage ?? this.perPage,
      meta: meta ?? this.meta,
      error: error,
    );
  }
}

class PatientsNotifier extends StateNotifier<PatientsState> {
  PatientsNotifier() : super(PatientsState()) {
    fetchPatients();
  }

  final _repo = PatientsRepository.instance;

  Future<void> fetchPatients({int page = 1, int? perPage, String? search}) async {
    final querySearch = search ?? state.searchText;
    final queryPerPage = perPage ?? state.perPage;
    state = state.copyWith(isLoading: true, searchText: querySearch, perPage: queryPerPage, error: null);

    final res = await _repo.getPatients(page: page, perPage: queryPerPage, searchText: querySearch);
    if (res != null) {
      state = state.copyWith(
        isLoading: false,
        list: res.data,
        meta: res.meta,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load patients from API',
      );
    }
  }

  Future<bool> createPatient(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.createPatient(data);
    fetchPatients();
    return success;
  }

  Future<bool> updatePatient(int id, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.updatePatient(id, data);
    fetchPatients();
    return success;
  }

  Future<bool> deletePatient(int id) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.deletePatient(id);
    fetchPatients();
    return success;
  }
}

final patientsProvider = StateNotifierProvider<PatientsNotifier, PatientsState>((ref) {
  return PatientsNotifier();
});
