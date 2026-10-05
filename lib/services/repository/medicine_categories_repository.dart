import 'package:medicine_system/constant/app_api_url.dart';
import 'package:medicine_system/models/medicine_category_model.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/services/api/api_services.dart';
import 'package:medicine_system/utils/app_log.dart';

class MedicineCategoriesRepository {
  MedicineCategoriesRepository._privateConstructor();
  static final MedicineCategoriesRepository _instance = MedicineCategoriesRepository._privateConstructor();
  static MedicineCategoriesRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<PaginatedResponse<MedicineCategoryModel>?> getCategories({int page = 1, int perPage = 10, String searchText = ''}) async {
    try {
      final response = await _apiServices.getServices(
        _api.categories,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (searchText.isNotEmpty) 'searchText': searchText,
        },
      );
      if (response != null) {
        return PaginatedResponse.fromJson(response, MedicineCategoryModel.fromJson);
      }
    } catch (e) {
      errorLog('getCategories error', e);
    }
    return null;
  }

  Future<List<MedicineCategoryModel>> getAllCategories() async {
    List<MedicineCategoryModel> list = [];
    try {
      final response = await _apiServices.getServices(_api.getAllCategories);
      if (response != null && response['data'] is List) {
        list = (response['data'] as List).map((e) => MedicineCategoryModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      errorLog('getAllCategories error', e);
    }
    return list;
  }

  Future<bool> createCategory(Map<String, dynamic> data) async {
    try {
      final body = Map<String, dynamic>.from(data);
      body['index'] ??= (DateTime.now().millisecondsSinceEpoch % 10000);
      body['status'] ??= 1;
      final response = await _apiServices.postServices(url: _api.categories, body: body);
      return response != null;
    } catch (e) {
      errorLog('createCategory error', e);
      return false;
    }
  }

  Future<bool> updateCategory(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.putServices(url: '${_api.categories}/$id', body: data);
      return response != null;
    } catch (e) {
      errorLog('updateCategory error', e);
      return false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: '${_api.categories}/$id');
      return response != null;
    } catch (e) {
      errorLog('deleteCategory error', e);
      return false;
    }
  }
}
