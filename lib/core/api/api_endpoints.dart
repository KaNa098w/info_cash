class ApiEndpoint {
  static const baseUrl = 'http://okrauza.podzone.net:9998/';

  static const api = '${baseUrl}ut_base/hs/OnlineOrder';

  static const getOrganizations = '$api/getspcatalogs';
  static const getOrderInfo = '$api/getorderinfo';
  static const getDefecturalist = '$api/defecturalist';
  static const getOrderInfoAll = '$api/getorderinfoall';
  static const getDetalizationDefectura = '$api/detalizationsdefecture';

  static const List<String> urlsWithoutAuthorization = [];
}
