import 'package:medicine_system/constant/app_api_url.dart';
import 'package:medicine_system/models/role_permission_model.dart';
import 'package:medicine_system/services/api/api_services.dart';
import 'package:medicine_system/utils/app_log.dart';

class RolesRepository {
  RolesRepository._privateConstructor();
  static final RolesRepository instance = RolesRepository._privateConstructor();

  final _apiServices = ApiServices.instance;
  final _api = AppApiUrl.instance;

  Future<List<RoleModel>?> getRoles() async {
    try {
      final response = await _apiServices.getServices(_api.roles);
      if (response != null && response['data'] != null) {
        final list = response['data'] as List;
        return list.map((e) => RoleModel.fromJson(e)).toList();
      }
    } catch (e) {
      errorLog('getRoles error', e);
    }
    return null;
  }

  Future<List<PermissionModel>?> getPermissions() async {
    try {
      final response = await _apiServices.getServices(_api.permissions);
      if (response != null && response['data'] != null) {
        final list = response['data'] as List;
        return list.map((e) => PermissionModel.fromJson(e)).toList();
      }
    } catch (e) {
      errorLog('getPermissions error', e);
    }
    return null;
  }

  Future<bool> createRole(Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.postServices(url: _api.roles, body: data);
      return response != null;
    } catch (e) {
      errorLog('createRole error', e);
      return false;
    }
  }

  Future<bool> updateRole(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.putServices(url: '${_api.roles}/$id', body: data);
      return response != null;
    } catch (e) {
      errorLog('updateRole error', e);
      return false;
    }
  }

  Future<bool> deleteRole(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: '${_api.roles}/$id');
      return response != null;
    } catch (e) {
      errorLog('deleteRole error', e);
      return false;
    }
  }
}
