import 'package:dio/dio.dart';
import 'package:info_cash/core/api/api_endpoints.dart';
import 'package:info_cash/core/api/app_http.dart';
import 'package:info_cash/core/responses/detalization_defectura_response.dart';
import 'package:intl/intl.dart';

class DetalizationDeFecturaServices {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }

  Future<List<DetalizationDefecturaResponse>> getDetalizationDefectura(
      String uID, DateTime dateN, DateTime dateK) async {
    try {
      String formattedDateN = _formatDate(dateN);
      String formattedDateK = _formatDate(dateK);

      Response res = await _http.get(
        ApiEndpoint.getDetalizationDefectura,
        params: {"UIDS": uID, "dateN": formattedDateN, "dateK": formattedDateK},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (res.data is List) {
          List<DetalizationDefecturaResponse> orderInfoList = (res.data as List)
              .map((item) => DetalizationDefecturaResponse.fromJson(item))
              .toList();
          return orderInfoList;
        } else {
          // Если данные не представлены списком, но мы ожидаем список, то обернем их в список
          DetalizationDefecturaResponse response =
              DetalizationDefecturaResponse.fromJson(res.data);
          return [response];
        }
      }
    } catch (e) {
      rethrow;
    }
    // Возвращаем пустой список в случае ошибки или пустого ответа
    return [];
  }
}
