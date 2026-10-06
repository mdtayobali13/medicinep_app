import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:medicine_system/routes/app_routes.dart';
import 'package:medicine_system/routes/app_routes_key.dart';
import 'package:medicine_system/services/api/api.dart';
import 'package:medicine_system/services/storage/storage_services.dart';
import 'package:medicine_system/utils/app_log.dart';
import 'package:medicine_system/utils/app_snack_bar.dart';

class ApiServices {
  ///////////////
  ApiServices._privateConstructor();
  static final ApiServices _instance = ApiServices._privateConstructor();
  static ApiServices get instance => _instance;
  //////////  object
  final api = AppApi();
  var storageServices = StorageServices.instance;
  final appRoutes = AppRoutes.instance;

  void _handleDioError(DioException e) {
    if (e.response != null) {
      if (e.response?.statusCode == 401) {
        storageServices.logout();
        appRoutes.pushReplacement(AppRoutesKey.instance.splash);
      }
      final data = e.response?.data;
      if (data is Map) {
        if (data['errors'] is Map && (data['errors'] as Map).isNotEmpty) {
          final List<String> allMessages = [];
          for (final value in (data['errors'] as Map).values) {
            if (value is List) {
              allMessages.addAll(value.map((e) => e.toString()));
            } else if (value != null) {
              allMessages.add(value.toString());
            }
          }
          if (allMessages.isNotEmpty) {
            AppSnackBar.instance.error(allMessages.join('\n'));
            return;
          }
        }
        if (data['message'] != null && data['message'].toString().isNotEmpty) {
          AppSnackBar.instance.error(data['message'].toString());
          return;
        }
      } else if (data is String && data.isNotEmpty && !data.contains('<html')) {
        AppSnackBar.instance.error(data);
      }
    } else {
      errorLog('api dio exception', e);
    }
  }

  dynamic _processResponse(dynamic data) {
    if (data == null) return null;
    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.startsWith('<') ||
          trimmed.contains('<html') ||
          trimmed.contains('<!doctype')) {
        errorLog('api_services', 'Server returned HTML instead of JSON');
        return null;
      }
    } else if (data is Map) {
      final isStatusFalse = data['status'] == false || data['status'] == 'false' || data['status'] == 0;
      final isSuccessFalse = data['success'] == false || data['success'] == 'false' || data['success'] == 0;
      if (isStatusFalse || isSuccessFalse) {
        final msg = data['message'] ?? data['error'] ?? 'API returned failure status';
        AppSnackBar.instance.error(msg.toString());
        return null;
      }
    }
    return data;
  }

  Future<dynamic> putServices({
    required String url,
    dynamic body,
    int statusCodeStart = 200,
    int statusCodeEnd = 299,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      final response = await api.sendRequest.put(
        url,
        data: body,
        queryParameters: query,
        options: options,
      );
      if (response.statusCode != null &&
          response.statusCode! >= statusCodeStart &&
          response.statusCode! <= statusCodeEnd) {
        return _processResponse(response.data) ?? true;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.instance.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      return null;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  Future<dynamic> postServices({
    required String url,
    dynamic body,
    int statusCodeStart = 200,
    int statusCodeEnd = 299,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      final dynamic response = await AppApi().sendRequest.post(
        url,
        data: body,
        options: options,
        queryParameters: query,
      );
      if (response.statusCode != null &&
          response.statusCode! >= statusCodeStart &&
          response.statusCode! <= statusCodeEnd) {
        return _processResponse(response.data) ?? true;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.instance.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      return null;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  Future<dynamic> getServices(
    String url, {
    int statusCode = 200,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Options? options,
  }) async {
    try {
      final response = await api.sendRequest.get(
        url,
        queryParameters: queryParameters,
        data: body,
        options: options,
      );
      if (response.statusCode == statusCode) {
        return _processResponse(response.data);
      } else {
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.instance.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      return null;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  Future<dynamic> patchServices({
    required String url,
    Object? body,
    int statusCodeStart = 200,
    int statusCodeEnd = 299,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      final response = await api.sendRequest.patch(
        url,
        data: body,
        queryParameters: query,
        options: options,
      );

      if (response.statusCode != null &&
          response.statusCode! >= statusCodeStart &&
          response.statusCode! <= statusCodeEnd) {
        return _processResponse(response.data) ?? true;
      } else {
        AppSnackBar.instance.error(
          "Unexpected response: ${response.statusCode} ${response.statusMessage}",
        );
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.instance.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      return null;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  Future<dynamic> deleteServices({
    required String url,
    Object? body,
    int statusCodeStart = 200,
    int statusCodeEnd = 299,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      final response = await api.sendRequest.delete(
        url,
        data: body,
        queryParameters: query,
        options: options,
      );

      if (response.statusCode != null &&
          response.statusCode! >= statusCodeStart &&
          response.statusCode! <= statusCodeEnd) {
        return _processResponse(response.data) ?? true;
      } else {
        AppSnackBar.instance.error(
          "Unexpected response: ${response.statusCode} ${response.statusMessage}",
        );
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.instance.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      return null;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }
}
