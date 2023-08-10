import 'dart:convert';

import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/classes_config.dart';

class RequestPayload {
  late int page;
  late int start;
  late int limit;
  late String queryKeyword;
  late String propertySorting;
  late String directionSorting;
  // late Map<String, dynamic>? filter;
  // late List<Map<String, dynamic>> sort;

  RequestPayload(
      {this.page = 1,
      this.limit = 10,
      this.queryKeyword = "",
      this.propertySorting = ClassesConfig.defaultAttributeSortingByKey,
      this.directionSorting = ClassesConfig.defaultDirectionSorting}) {
    start = (page - 1) * limit;
  }

  RequestPayload copyWith(
      {int? page,
      int? limit,
      String? queryKeyword,
      String? propertySorting,
      String? directionSorting}) {
    return RequestPayload(
        page: page ?? this.page,
        limit: limit ?? this.limit,
        queryKeyword: queryKeyword ?? this.queryKeyword,
        propertySorting: propertySorting ?? this.propertySorting,
        directionSorting: directionSorting ?? this.directionSorting);
  }

  String toPath() {
    Map<String, dynamic> filter = {"query": queryKeyword};

    List<Map<String, dynamic>> sort = [
      {"property": propertySorting, "direction": directionSorting}
    ];

    String payloadToPath =
        "page=$page&start=$start&limit=$limit&filter=${jsonEncode(filter)}&sort=${jsonEncode(sort)}";

    return payloadToPath;
  }
}
