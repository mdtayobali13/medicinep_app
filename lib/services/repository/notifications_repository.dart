import 'package:dio/dio.dart';
import 'package:medicine_system/constant/app_api_url.dart';
import 'package:medicine_system/services/api/api_services.dart';

class NotificationsRepository {
  Future<dynamic> fetchNotifications({int page = 1, int perPage = 10, String? search}) async {
    final queryParams = {
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final response = await ApiServices.instance.getServices(
      AppApiUrl.instance.notification,
      queryParameters: queryParams,
      options: Options(
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    return response;
  }
}
