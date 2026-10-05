import 'package:medicine_system/constant/app_api_url.dart';
import 'package:medicine_system/models/address_lookup_model.dart';
import 'package:medicine_system/services/api/api_services.dart';
import 'package:medicine_system/utils/app_log.dart';

class AddressLookupRepository {
  AddressLookupRepository._privateConstructor();
  static final AddressLookupRepository _instance = AddressLookupRepository._privateConstructor();
  static AddressLookupRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<List<LocationItemModel>> getDivisions() async {
    List<LocationItemModel> list = [];
    try {
      final response = await _apiServices.getServices(_api.divisions);
      if (response != null && response['data'] is List) {
        list = (response['data'] as List).map((e) => LocationItemModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      errorLog('getDivisions error', e);
    }
    return list;
  }

  Future<List<LocationItemModel>> getDistricts(int divisionId) async {
    List<LocationItemModel> list = [];
    try {
      final response = await _apiServices.getServices(_api.districts(divisionId));
      if (response != null && response['data'] is List) {
        list = (response['data'] as List).map((e) => LocationItemModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      errorLog('getDistricts error', e);
    }
    return list;
  }

  Future<List<LocationItemModel>> getUpazilas(int districtId) async {
    List<LocationItemModel> list = [];
    try {
      final response = await _apiServices.getServices(_api.upazilas(districtId));
      if (response != null && response['data'] is List) {
        list = (response['data'] as List).map((e) => LocationItemModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      errorLog('getUpazilas error', e);
    }
    return list;
  }

  Future<List<LocationItemModel>> getUnions(int upazilaId) async {
    List<LocationItemModel> list = [];
    try {
      final response = await _apiServices.getServices(_api.unions(upazilaId));
      if (response != null && response['data'] is List) {
        list = (response['data'] as List).map((e) => LocationItemModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      errorLog('getUnions error', e);
    }
    return list;
  }
}
