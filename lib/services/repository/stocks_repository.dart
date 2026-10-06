import 'package:medicine_system/constant/app_api_url.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/models/stock_model.dart';
import 'package:medicine_system/models/stock_report_model.dart';
import 'package:medicine_system/services/api/api_services.dart';
import 'package:medicine_system/utils/app_log.dart';

class StocksRepository {
  StocksRepository._privateConstructor();
  static final StocksRepository _instance = StocksRepository._privateConstructor();
  static StocksRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  Future<PaginatedResponse<StockModel>?> getStocks({int page = 1, int perPage = 10, String searchText = ''}) async {
    try {
      final response = await _apiServices.getServices(
        _api.stocks,
        queryParameters: {
          'page': page,
          'per_page': perPage,
          if (searchText.isNotEmpty) 'searchText': searchText,
        },
      );
      if (response != null) {
        return PaginatedResponse.fromJson(response, StockModel.fromJson);
      }
    } catch (e) {
      errorLog('getStocks error', e);
    }
    return null;
  }

  Future<PaginatedResponse<StockReportModel>?> getStockReports({int page = 1, int perPage = 10, String searchText = '', String? startDate, String? endDate}) async {
    try {
      final response = await _apiServices.postServices(
        url: _api.stockReports,
        body: {
          'page': page,
          'per_page': perPage,
          if (searchText.isNotEmpty) 'searchText': searchText,
          if (startDate != null && startDate.isNotEmpty) 'start_date': startDate,
          if (endDate != null && endDate.isNotEmpty) 'end_date': endDate,
        },
      );
      if (response != null) {
        return PaginatedResponse.fromJson(response, StockReportModel.fromJson);
      }
    } catch (e) {
      errorLog('getStockReports error', e);
    }
    return null;
  }

  Future<bool> createStock(Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.postServices(url: _api.stocks, body: data);
      return response != null;
    } catch (e) {
      errorLog('createStock error', e);
      return false;
    }
  }

  Future<bool> updateStock(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.putServices(url: '${_api.stocks}/$id', body: data);
      return response != null;
    } catch (e) {
      errorLog('updateStock error', e);
      return false;
    }
  }

  Future<bool> deleteStock(int id) async {
    try {
      final response = await _apiServices.deleteServices(url: '${_api.stocks}/$id');
      return response != null;
    } catch (e) {
      errorLog('deleteStock error', e);
      return false;
    }
  }
}
