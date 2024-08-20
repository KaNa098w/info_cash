import 'package:dio/dio.dart';
import 'package:info_cash/core/api/api_endpoints.dart';
import 'package:info_cash/core/api/app_http.dart';
import 'package:info_cash/core/responses/all_info_response.dart';
import 'package:intl/intl.dart';

class AllInfoServices {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }

  Future<List<GetOrderInfoAll>> getOrderInfoAll(
      String uID, DateTime dateN, DateTime dateK) async {
    try {
      String formattedDateN = _formatDate(dateN);
      String formattedDateK = _formatDate(dateK);

      Response res = await _http.get(
        ApiEndpoint.getOrderInfoAll,
        params: {"UIDS": uID, "dateN": formattedDateN, "dateK": formattedDateK},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (res.data is List) {
          List<GetOrderInfoAll> orderInfoList = (res.data as List)
              .map((item) => GetOrderInfoAll.fromJson(item))
              .toList();
          return orderInfoList;
        } else {
          return [GetOrderInfoAll.fromJson(res.data)];
        }
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }
}
