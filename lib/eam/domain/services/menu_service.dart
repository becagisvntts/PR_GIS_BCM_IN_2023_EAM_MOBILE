import 'dart:convert';

import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/http_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/actions/classes_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class MenuService {
  static const menuApi = '${HttpService.apiUrl}sessions/current/menu/';

  static Future<void> fetchMenuData() async {
    StateHelper.store.dispatch(FetchClassesAction());
  }

  static Future<Map<String, dynamic>> fetchMenu() async {
    var response = await HttpService.getWithAuth(endpoint: menuApi);
    if (response.statusCode == 200) {
      dynamic resArr = jsonDecode(utf8.decode(response.bodyBytes));
      return resArr["data"];
    } else {
      return {};
    }
  }
}
