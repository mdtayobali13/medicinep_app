import 'package:medicine_system/constant/app_api_url.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/models/police_unit_model.dart';
import 'package:medicine_system/services/api/api_services.dart';
import 'package:medicine_system/utils/app_log.dart';

class PoliceUnitsRepository {
  PoliceUnitsRepository._privateConstructor();
  static final PoliceUnitsRepository _instance = PoliceUnitsRepository._privateConstructor();
  static PoliceUnitsRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<PaginatedResponse<PoliceUnitModel>?> getPoliceUnits({int page = 1, int perPage = 10, String searchText = ''}) async {
    try {
      final response = await _apiServices.getServices(
        _api.policeUnits,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (searchText.isNotEmpty) 'searchText': searchText,
        },
      );
      if (response != null) {
        return PaginatedResponse.fromJson(response, PoliceUnitModel.fromJson);
      }
    } catch (e) {
      errorLog('getPoliceUnits error', e);
    }
    return null;
  }

  Future<List<PoliceUnitModel>> getAllPoliceUnits() async {
    List<PoliceUnitModel> list = [];
    try {
      final response = await _apiServices.getServices(_api.getAllPoliceUnits);
      if (response != null && response['data'] is List) {
        list = (response['data'] as List).map((e) => PoliceUnitModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      errorLog('getAllPoliceUnits error', e);
    }
    return list;
  }

  Future<bool> createPoliceUnit(Map<String, dynamic> data) async {
    try {
      final body = Map<String, dynamic>.from(data);
      body['index'] ??= (DateTime.now().millisecondsSinceEpoch % 10000);
      body['status'] ??= 1;
      final response = await _apiServices.postServices(url: _api.policeUnits, body: body);
      return response != null;
    } catch (e) {
      errorLog('createPoliceUnit error', e);
      return false;
    }
  }

  Future<bool> updatePoliceUnit(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.putServices(url: '${_api.policeUnits}/$id', body: data);
      return response != null;
    } catch (e) {
      errorLog('updatePoliceUnit error', e);
      return false;
    }
  }

  Future<bool> deletePoliceUnit(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: '${_api.policeUnits}/$id');
      return response != null;
    } catch (e) {
      errorLog('deletePoliceUnit error', e);
      return false;
    }
  }
}
