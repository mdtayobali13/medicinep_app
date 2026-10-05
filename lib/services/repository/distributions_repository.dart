import 'package:medicine_system/constant/app_api_url.dart';
import 'package:medicine_system/models/distribution_model.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/services/api/api_services.dart';
import 'package:medicine_system/utils/app_log.dart';

class DistributionsRepository {
  DistributionsRepository._privateConstructor();
  static final DistributionsRepository _instance = DistributionsRepository._privateConstructor();
  static DistributionsRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  // Central Distributions
  Future<PaginatedResponse<DistributionModel>?> getDistributions({int page = 1, int perPage = 10, String searchText = ''}) async {
    try {
      final response = await _apiServices.getServices(
        _api.distributions,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (searchText.isNotEmpty) 'searchText': searchText,
        },
      );
      if (response != null) {
        return PaginatedResponse.fromJson(response, DistributionModel.fromJson);
      }
    } catch (e) {
      errorLog('getDistributions error', e);
    }
    return null;
  }

  Future<bool> createDistribution(Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.postServices(url: _api.distributions, body: data);
      return response != null;
    } catch (e) {
      errorLog('createDistribution error', e);
      return false;
    }
  }

  Future<bool> deleteDistribution(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: '${_api.distributions}/$id');
      return response != null;
    } catch (e) {
      errorLog('deleteDistribution error', e);
      return false;
    }
  }

  // Local Distributions
  Future<PaginatedResponse<DistributionModel>?> getLocalDistributions({int page = 1, int perPage = 10, String searchText = ''}) async {
    try {
      final response = await _apiServices.getServices(
        _api.localDistributions,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (searchText.isNotEmpty) 'searchText': searchText,
        },
      );
      if (response != null) {
        return PaginatedResponse.fromJson(response, DistributionModel.fromJson);
      }
    } catch (e) {
      errorLog('getLocalDistributions error', e);
    }
    return null;
  }

  Future<bool> createLocalDistribution(Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.postServices(url: _api.localDistributions, body: data);
      return response != null;
    } catch (e) {
      errorLog('createLocalDistribution error', e);
      return false;
    }
  }

  Future<bool> deleteLocalDistribution(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: '${_api.localDistributions}/$id');
      return response != null;
    } catch (e) {
      errorLog('deleteLocalDistribution error', e);
      return false;
    }
  }
}
