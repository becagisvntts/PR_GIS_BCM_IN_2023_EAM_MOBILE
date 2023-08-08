import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list_meta.dart';

class DataList {
  late List<Map<String, dynamic>> data;
  late DataListMeta meta;

  DataList({List<Map<String, dynamic>>? data, DataListMeta? meta}) {
    this.data = data ?? [];
    this.meta = meta ?? DataListMeta();
  }

  DataList.fromJson(Map<String, dynamic> json) {
    data = json.containsKey("data")
        ? (json["data"] as List).map((e) => e as Map<String, dynamic>).toList()
        : [];
    meta = json.containsKey("meta")
        ? DataListMeta.fromJson(json["meta"])
        : DataListMeta();
  }
}
