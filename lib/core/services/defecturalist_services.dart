import 'package:dio/dio.dart';
import 'package:info_cash/core/api/api_endpoints.dart';
import 'package:info_cash/core/api/app_http.dart';
import 'package:info_cash/core/responses/defectura_response.dart';
import 'package:intl/intl.dart';

class DefecturalistServices {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }

  Future<List<DefecturaResponse>> getDefectura(
      DateTime dateN, DateTime dateK) async {
    try {
      String formattedDateN = _formatDate(dateN);
      String formattedDateK = _formatDate(dateK);

      Response res = await _http.get(
        ApiEndpoint.getDefecturalist,
        params: {"dateN": formattedDateN, "dateK": formattedDateK},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (res.data is List) {
          return (res.data as List)
              .map((item) => DefecturaResponse.fromJson(item))
              .toList();
        } else {
          return [DefecturaResponse.fromJson(res.data)];
        }
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }
}
