import 'package:medicine_system/constant/app_api_url.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/models/patient_model.dart';
import 'package:medicine_system/services/api/api_services.dart';
import 'package:medicine_system/utils/app_log.dart';

class PatientsRepository {
  PatientsRepository._privateConstructor();
  static final PatientsRepository _instance = PatientsRepository._privateConstructor();
  static PatientsRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<PaginatedResponse<PatientModel>?> getPatients({int page = 1, int perPage = 10, String searchText = ''}) async {
    try {
      final response = await _apiServices.getServices(
        _api.patients,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (searchText.isNotEmpty) 'searchText': searchText,
        },
      );
      if (response != null) {
        return PaginatedResponse.fromJson(response, PatientModel.fromJson);
      }
    } catch (e) {
      errorLog('getPatients error', e);
    }
    return null;
  }

  Future<List<PatientModel>> getRegularPatients() async {
    List<PatientModel> list = [];
    try {
      final response = await _apiServices.getServices(_api.getRegularPatients);
      if (response != null && response['data'] is List) {
        list = (response['data'] as List).map((e) => PatientModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      errorLog('getRegularPatients error', e);
    }
    return list;
  }

  Future<PatientModel?> getPatientWithMedicines(int id) async {
    try {
      final response = await _apiServices.getServices(_api.patientWithMedicines(id));
      if (response != null && response['data'] is Map<String, dynamic>) {
        return PatientModel.fromJson(response['data']);
      }
    } catch (e) {
      errorLog('getPatientWithMedicines error', e);
    }
    return null;
  }

  Future<bool> createPatient(Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.postServices(url: _api.patients, body: data);
      return response != null;
    } catch (e) {
      errorLog('createPatient error', e);
      return false;
    }
  }

  Future<bool> updatePatient(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.putServices(url: '${_api.patients}/$id', body: data);
      return response != null;
    } catch (e) {
      errorLog('updatePatient error', e);
      return false;
    }
  }

  Future<bool> deletePatient(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: '${_api.patients}/$id');
      return response != null;
    } catch (e) {
      errorLog('deletePatient error', e);
      return false;
    }
  }

  // Spouses & Children
  Future<bool> createSpouse(Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.postServices(url: _api.spouses, body: data);
      return response != null;
    } catch (e) {
      errorLog('createSpouse error', e);
      return false;
    }
  }

  Future<bool> updateSpouse(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.putServices(url: '${_api.spouses}/$id', body: data);
      return response != null;
    } catch (e) {
      errorLog('updateSpouse error', e);
      return false;
    }
  }

  Future<bool> deleteSpouse(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: '${_api.spouses}/$id');
      return response != null;
    } catch (e) {
      errorLog('deleteSpouse error', e);
      return false;
    }
  }

  Future<bool> createChild(Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.postServices(url: _api.childrens, body: data);
      return response != null;
    } catch (e) {
      errorLog('createChild error', e);
      return false;
    }
  }

  Future<bool> updateChild(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.putServices(url: '${_api.childrens}/$id', body: data);
      return response != null;
    } catch (e) {
      errorLog('updateChild error', e);
      return false;
    }
  }

  Future<bool> deleteChild(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: '${_api.childrens}/$id');
      return response != null;
    } catch (e) {
      errorLog('deleteChild error', e);
      return false;
    }
  }
}
