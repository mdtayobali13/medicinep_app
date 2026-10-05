import 'package:medicine_system/constant/app_api_url.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/models/role_permission_model.dart';
import 'package:medicine_system/models/user_model.dart';
import 'package:medicine_system/services/api/api_services.dart';
import 'package:medicine_system/utils/app_log.dart';

class AdminUsersRepository {
  AdminUsersRepository._privateConstructor();
  static final AdminUsersRepository _instance = AdminUsersRepository._privateConstructor();
  static AdminUsersRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  // Users
  Future<PaginatedResponse<UserModel>?> getUsers({int page = 1, int perPage = 10, String searchText = ''}) async {
    try {
      final response = await _apiServices.getServices(
        _api.users,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (searchText.isNotEmpty) 'searchText': searchText,
        },
      );
      if (response != null) {
        return PaginatedResponse.fromJson(response, UserModel.fromJson);
      }
    } catch (e) {
      errorLog('getUsers error', e);
    }
    return null;
  }

  Future<bool> createUser(Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.postServices(url: _api.users, body: data);
      return response != null;
    } catch (e) {
      errorLog('createUser error', e);
      return false;
    }
  }

  Future<bool> updateUser(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.putServices(url: '${_api.users}/$id', body: data);
      return response != null;
    } catch (e) {
      errorLog('updateUser error', e);
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: '${_api.users}/$id');
      return response != null;
    } catch (e) {
      errorLog('deleteUser error', e);
      return false;
    }
  }

  // Roles
  Future<List<RoleModel>> getRoles() async {
    List<RoleModel> list = [];
    try {
      final response = await _apiServices.getServices(_api.roles);
      if (response != null && response['data'] is List) {
        list = (response['data'] as List).map((e) => RoleModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      errorLog('getRoles error', e);
    }
    return list;
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

  // Permissions
  Future<List<PermissionModel>> getPermissions() async {
    List<PermissionModel> list = [];
    try {
      final response = await _apiServices.getServices(_api.permissions);
      if (response != null && response['data'] is List) {
        list = (response['data'] as List).map((e) => PermissionModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      errorLog('getPermissions error', e);
    }
    return list;
  }
}
