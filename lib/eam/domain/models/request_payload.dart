import 'dart:convert';

import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';

class RequestPayload {
  late int page;
  late int start;
  late int limit;
  late String queryKeyword;
  late String propertySorting;
  late String directionSorting;
  late List<String> attrs;
  late String forDomainName;
  late String forDomainDirection;
  late int forDomainOriginId;

  RequestPayload(
      {this.page = 1,
      this.limit = 10,
      this.queryKeyword = "",
      this.propertySorting = ClassConfig.defaultAttributeSortingByKey,
      this.directionSorting = ClassConfig.defaultDirectionSorting,
      this.attrs = const [],
      this.forDomainName = "",
      this.forDomainDirection = "",
      this.forDomainOriginId = -1}) {
    start = (page - 1) * limit;
  }

  RequestPayload copyWith(
      {int? page,
      int? limit,
      String? queryKeyword,
      String? propertySorting,
      String? directionSorting,
      List<String>? attrs,
      String? forDomainName,
      String? forDomainDirection,
      int? forDomainOriginId}) {
    return RequestPayload(
        page: page ?? this.page,
        limit: limit ?? this.limit,
        queryKeyword: queryKeyword ?? this.queryKeyword,
        propertySorting: propertySorting ?? this.propertySorting,
        directionSorting: directionSorting ?? this.directionSorting,
        attrs: attrs ?? this.attrs,
        forDomainName: forDomainName ?? this.forDomainName,
        forDomainDirection: forDomainDirection ?? this.forDomainDirection,
        forDomainOriginId: forDomainOriginId ?? this.forDomainOriginId);
  }

  String toPath({Map<String, dynamic> additionalFilter = const {}}) {
    Map<String, dynamic> filter = {"query": queryKeyword};
    filter = {...filter, ...additionalFilter};

    List<Map<String, dynamic>> sort = [
      {"property": propertySorting, "direction": directionSorting}
    ];

    String payloadToPath =
        "page=$page&start=$start&limit=$limit&filter=${jsonEncode(filter)}&sort=${jsonEncode(sort)}";
    if (attrs.isNotEmpty) {
      payloadToPath += "&attrs=${attrs.join(',')}";
    }

    if (forDomainName != "") {
      payloadToPath += "&forDomain_name=$forDomainName";
    }

    if (forDomainDirection != "") {
      payloadToPath += "&forDomain_direction=$forDomainDirection";
    }

    if (forDomainOriginId > 0) {
      payloadToPath += "&forDomain_originId=$forDomainOriginId";
    }

    return payloadToPath;
  }
}
