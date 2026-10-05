import 'package:medicine_system/constant/app_api_url.dart';
import 'package:medicine_system/models/designation_model.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/services/api/api_services.dart';
import 'package:medicine_system/utils/app_log.dart';

class DesignationsRepository {
  DesignationsRepository._privateConstructor();
  static final DesignationsRepository _instance = DesignationsRepository._privateConstructor();
  static DesignationsRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<PaginatedResponse<DesignationModel>?> getDesignations({int page = 1, int perPage = 10, String searchText = ''}) async {
    try {
      final response = await _apiServices.getServices(
        _api.designations,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (searchText.isNotEmpty) 'searchText': searchText,
        },
      );
      if (response != null) {
        return PaginatedResponse.fromJson(response, DesignationModel.fromJson);
      }
    } catch (e) {
      errorLog('getDesignations error', e);
    }
    return null;
  }

  Future<List<DesignationModel>> getAllDesignations() async {
    List<DesignationModel> list = [];
    try {
      final response = await _apiServices.getServices(_api.getAllDesignations);
      if (response != null && response['data'] is List) {
        list = (response['data'] as List).map((e) => DesignationModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      errorLog('getAllDesignations error', e);
    }
    return list;
  }

  Future<bool> createDesignation(Map<String, dynamic> data) async {
    try {
      final body = Map<String, dynamic>.from(data);
      body['index'] ??= (DateTime.now().millisecondsSinceEpoch % 10000);
      body['status'] ??= 1;
      final response = await _apiServices.postServices(url: _api.designations, body: body);
      return response != null;
    } catch (e) {
      errorLog('createDesignation error', e);
      return false;
    }
  }

  Future<bool> updateDesignation(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.putServices(url: '${_api.designations}/$id', body: data);
      return response != null;
    } catch (e) {
      errorLog('updateDesignation error', e);
      return false;
    }
  }

  Future<bool> deleteDesignation(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: '${_api.designations}/$id');
      return response != null;
    } catch (e) {
      errorLog('deleteDesignation error', e);
      return false;
    }
  }
}
