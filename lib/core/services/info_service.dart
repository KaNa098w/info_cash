import 'package:dio/dio.dart';
import 'package:info_cash/core/api/api_endpoints.dart';
import 'package:info_cash/core/api/app_http.dart';
import 'package:info_cash/core/responses/info_sklad.dart';
import 'package:intl/intl.dart';

class InfoService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }

  Future<GetOrderInfo?> getOrderInfo(
      String uID, DateTime dateN, DateTime dateK) async {
    try {
      String formattedDateN = _formatDate(dateN);
      String formattedDateK = _formatDate(dateK);

      Response res = await _http.get(
        ApiEndpoint.getOrderInfo,
        params: {"UIDS": uID, "dateN": formattedDateN, "dateK": formattedDateK},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (res.data is List) {
          List<GetOrderInfo> orderInfoList = (res.data as List)
              .map((item) => GetOrderInfo.fromJson(item))
              .toList();
          return orderInfoList.isNotEmpty ? orderInfoList.first : null;
        } else {
          GetOrderInfo response = GetOrderInfo.fromJson(res.data);
          return response;
        }
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
