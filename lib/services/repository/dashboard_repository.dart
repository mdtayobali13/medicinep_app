import 'package:medicine_system/constant/app_api_url.dart';
import 'package:medicine_system/models/dashboard_model.dart';
import 'package:medicine_system/services/api/api_services.dart';
import 'package:medicine_system/utils/app_log.dart';

class DashboardRepository {
  DashboardRepository._privateConstructor();
  static final DashboardRepository _instance = DashboardRepository._privateConstructor();
  static DashboardRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<DashboardModel?> getDashboardData() async {
    try {
      final response = await _apiServices.getServices(_api.dashboard);
      appLog('Dashboard API Raw Response: $response');
      if (response != null && response is Map) {
        final dynamic rawData = response['data'] ?? response;
        if (rawData is Map) {
          final mapData = Map<String, dynamic>.from(rawData);
          return DashboardModel.fromJson(mapData);
        }
      }
    } catch (e) {
      errorLog('getDashboardData error', e);
    }
    return null;
  }
}
