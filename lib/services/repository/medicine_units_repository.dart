import 'package:medicine_system/constant/app_api_url.dart';
import 'package:medicine_system/models/medicine_unit_model.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/services/api/api_services.dart';
import 'package:medicine_system/utils/app_log.dart';

class MedicineUnitsRepository {
  MedicineUnitsRepository._privateConstructor();
  static final MedicineUnitsRepository _instance = MedicineUnitsRepository._privateConstructor();
  static MedicineUnitsRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<PaginatedResponse<MedicineUnitModel>?> getMedicineUnits({int page = 1, int perPage = 10, String searchText = ''}) async {
    try {
      final response = await _apiServices.getServices(
        _api.medicineUnits,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (searchText.isNotEmpty) 'searchText': searchText,
        },
      );
      if (response != null) {
        return PaginatedResponse.fromJson(response, MedicineUnitModel.fromJson);
      }
    } catch (e) {
      errorLog('getMedicineUnits error', e);
    }
    return null;
  }

  Future<List<MedicineUnitModel>> getAllMedicineUnits() async {
    List<MedicineUnitModel> list = [];
    try {
      final response = await _apiServices.getServices(_api.getAllMedicineUnits);
      if (response != null && response['data'] is List) {
        list = (response['data'] as List).map((e) => MedicineUnitModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      errorLog('getAllMedicineUnits error', e);
    }
    return list;
  }

  Future<bool> createMedicineUnit(Map<String, dynamic> data) async {
    try {
      final body = Map<String, dynamic>.from(data);
      body['index'] ??= (DateTime.now().millisecondsSinceEpoch % 10000);
      body['status'] ??= 1;
      final response = await _apiServices.postServices(url: _api.medicineUnits, body: body);
      return response != null;
    } catch (e) {
      errorLog('createMedicineUnit error', e);
      return false;
    }
  }

  Future<bool> updateMedicineUnit(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.putServices(url: '${_api.medicineUnits}/$id', body: data);
      return response != null;
    } catch (e) {
      errorLog('updateMedicineUnit error', e);
      return false;
    }
  }

  Future<bool> deleteMedicineUnit(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: '${_api.medicineUnits}/$id');
      return response != null;
    } catch (e) {
      errorLog('deleteMedicineUnit error', e);
      return false;
    }
  }
}
