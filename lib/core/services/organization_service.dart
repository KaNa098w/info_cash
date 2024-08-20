import 'package:dio/dio.dart';
import 'package:info_cash/core/api/api_endpoints.dart';
import 'package:info_cash/core/api/app_http.dart';
import 'package:info_cash/core/responses/organization_response.dart';

class OrganizationServices {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
    headers: {},
  );

  Future<List<OrganizationResponse>> getOrganizations(
      String organizations) async {
    try {
      organizations = 'warehouse';
      Response res = await _http.get(
        ApiEndpoint.getOrganizations,
        params: {"type": organizations},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        List<dynamic> data = res.data;
        return data.map((json) => OrganizationResponse.fromJson(json)).toList();
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }
}
