import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/request_payload.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class DataListMeta {
  late int total;
  late int pageSize;
  late int page;
  late int totalPages;

  DataListMeta(
      {this.total = 0, this.pageSize = 0, this.page = 1, this.totalPages = 1});

  DataListMeta.fromJson(Map<String, dynamic> json) {
    total = json.containsKey("total") ? json["total"] : 0;
    RequestPayload requestPayload =
        StateHelper.eamState.classesState.requestPayload;
    page = requestPayload.page;
    pageSize = requestPayload.limit;
    totalPages = (total * 1.0 / pageSize).ceil();
  }
}
