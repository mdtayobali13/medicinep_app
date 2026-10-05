import 'package:medicine_system/constant/app_api_url.dart';
import 'package:medicine_system/models/medicine_model.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/services/api/api_services.dart';
import 'package:medicine_system/utils/app_log.dart';

class MedicinesRepository {
  MedicinesRepository._privateConstructor();
  static final MedicinesRepository _instance = MedicinesRepository._privateConstructor();
  static MedicinesRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<PaginatedResponse<MedicineModel>?> getMedicines({int page = 1, int perPage = 10, String searchText = ''}) async {
    try {
      final response = await _apiServices.getServices(
        _api.medicines,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (searchText.isNotEmpty) 'searchText': searchText,
        },
      );
      if (response != null) {
        return PaginatedResponse.fromJson(response, MedicineModel.fromJson);
      }
    } catch (e) {
      errorLog('getMedicines error', e);
    }
    return null;
  }

  Future<List<MedicineModel>> getActiveMedicines() async {
    List<MedicineModel> list = [];
    try {
      final response = await _apiServices.getServices(_api.getActiveMedicines);
      if (response != null && response['data'] is List) {
        list = (response['data'] as List).map((e) => MedicineModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      errorLog('getActiveMedicines error', e);
    }
    return list;
  }

  Future<bool> createMedicine(Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.postServices(url: _api.medicines, body: data);
      return response != null;
    } catch (e) {
      errorLog('createMedicine error', e);
      return false;
    }
  }

  Future<bool> updateMedicine(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.putServices(url: '${_api.medicines}/$id', body: data);
      return response != null;
    } catch (e) {
      errorLog('updateMedicine error', e);
      return false;
    }
  }

  Future<bool> deleteMedicine(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: '${_api.medicines}/$id');
      return response != null;
    } catch (e) {
      errorLog('deleteMedicine error', e);
      return false;
    }
  }
}
