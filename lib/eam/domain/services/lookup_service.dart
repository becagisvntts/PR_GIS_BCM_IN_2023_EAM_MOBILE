import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/date_time_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/http_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';

class LookupService {
  static const lookupApi = '${HttpService.apiUrl}lookup_types/';

  static Future<DataList> fetchLookupTypes(String lookupType) async {
    String lookupTypeHex = "HEX${hex.encode(lookupType.codeUnits)}";
    String api =
        "$lookupApi$lookupTypeHex/values/?_dc=${DateTimeHelper.getCurrentMillisecondTime()}";
    var response = await HttpService.getWithAuth(endpoint: api);
    if (response.statusCode == 200) {
      dynamic resArr = jsonDecode(utf8.decode(response.bodyBytes));
      return DataList.fromJson(resArr);
    } else {
      return DataList();
    }
  }
}
