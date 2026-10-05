import 'package:flutter_riverpod/legacy.dart';
import 'package:medicine_system/models/dashboard_model.dart';
import 'package:medicine_system/services/repository/admin_users_repository.dart';
import 'package:medicine_system/services/repository/dashboard_repository.dart';
import 'package:medicine_system/services/repository/distributions_repository.dart';
import 'package:medicine_system/services/repository/patients_repository.dart';

class DashboardState {
  final bool isLoading;
  final DashboardModel? data;
  final String? error;

  DashboardState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  DashboardState copyWith({
    bool? isLoading,
    DashboardModel? data,
    String? error,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(DashboardState()) {
    fetchDashboard();
  }

  final _repo = DashboardRepository.instance;

  Future<void> fetchDashboard() async {
    state = state.copyWith(isLoading: true, error: null);
    var res = await _repo.getDashboardData();

    res ??= DashboardModel(
      systemUsers: 0,
      totalPatients: 0,
      totalMedicines: 0,
      medicineStock: 0,
      totalDistributions: 0,
      medicineRemaining: 0,
      medicineExpiration: 0,
      medicineDamaged: 0,
      lowStockAlerts: 0,
      recentDistributions: [],
    );

    int systemUsers = res.systemUsers;
    int totalPatients = res.totalPatients;
    int totalDistributions = res.totalDistributions;
    int medicineRemaining = res.medicineRemaining;

    // 1. Fallback for System Users if API returned 0
    if (systemUsers == 0) {
      try {
        final usersRes = await AdminUsersRepository.instance.getUsers(perPage: 1);
        if (usersRes != null && usersRes.meta != null && usersRes.meta!.total > 0) {
          systemUsers = usersRes.meta!.total;
        } else if (usersRes != null && usersRes.data.isNotEmpty) {
          systemUsers = usersRes.data.length;
        }
      } catch (_) {}
    }

    // 2. Fallback for Total Patients if API returned 0
    if (totalPatients == 0) {
      try {
        final patientsRes = await PatientsRepository.instance.getPatients(perPage: 1);
        if (patientsRes != null && patientsRes.meta != null && patientsRes.meta!.total > 0) {
          totalPatients = patientsRes.meta!.total;
        }
      } catch (_) {}
    }

    // 3. Fallback for Total Distributions if API returned 0
    if (totalDistributions == 0) {
      try {
        final distRes = await DistributionsRepository.instance.getDistributions(perPage: 100);
        if (distRes != null && distRes.data.isNotEmpty) {
          int sumQty = 0;
          for (var dist in distRes.data) {
            for (var item in dist.items) {
              sumQty += item.quantity;
            }
          }
          totalDistributions = sumQty > 0 ? sumQty : (distRes.meta?.total ?? distRes.data.length);
        }
      } catch (_) {}
    }

    // 4. Calculate Medicine Remaining if API returned 0 and Medicine Stock is available
    if (medicineRemaining == 0 && res.medicineStock > 0) {
      medicineRemaining = res.medicineStock - totalDistributions;
      if (medicineRemaining < 0) medicineRemaining = 0;
    }

    res = res.copyWith(
      systemUsers: systemUsers,
      totalPatients: totalPatients,
      totalDistributions: totalDistributions,
      medicineRemaining: medicineRemaining,
    );

    state = state.copyWith(isLoading: false, data: res);
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier();
});
