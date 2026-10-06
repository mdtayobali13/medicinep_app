import 'package:flutter_riverpod/legacy.dart';
import 'package:medicine_system/models/role_permission_model.dart';
import 'package:medicine_system/services/repository/roles_repository.dart';

class RolesState {
  final bool isLoading;
  final List<RoleModel> roles;
  final List<PermissionModel> permissions;
  final String? error;

  RolesState({
    this.isLoading = false,
    this.roles = const [],
    this.permissions = const [],
    this.error,
  });

  RolesState copyWith({
    bool? isLoading,
    List<RoleModel>? roles,
    List<PermissionModel>? permissions,
    String? error,
  }) {
    return RolesState(
      isLoading: isLoading ?? this.isLoading,
      roles: roles ?? this.roles,
      permissions: permissions ?? this.permissions,
      error: error,
    );
  }
}

class RolesNotifier extends StateNotifier<RolesState> {
  RolesNotifier() : super(RolesState()) {
    fetchRoles();
    fetchPermissions();
  }

  final _repo = RolesRepository.instance;

  Future<void> fetchRoles() async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await _repo.getRoles();
    if (res != null) {
      state = state.copyWith(isLoading: false, roles: res);
    } else {
      state = state.copyWith(isLoading: false, error: 'Failed to load roles');
    }
  }

  Future<void> fetchPermissions() async {
    final res = await _repo.getPermissions();
    if (res != null) {
      state = state.copyWith(permissions: res);
    }
  }

  Future<bool> createRole(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.createRole(data);
    fetchRoles();
    return success;
  }

  Future<bool> updateRole(int id, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.updateRole(id, data);
    fetchRoles();
    return success;
  }

  Future<bool> deleteRole(int id) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.deleteRole(id);
    fetchRoles();
    return success;
  }
}

final rolesProvider = StateNotifierProvider<RolesNotifier, RolesState>((ref) {
  return RolesNotifier();
});
