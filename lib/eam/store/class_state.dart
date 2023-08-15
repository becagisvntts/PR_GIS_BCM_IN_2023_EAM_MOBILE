import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/request_payload.dart';

class ClassState {
  late DataList list;
  late Map<String, dynamic> activeClass;
  late DataList classCards;
  late DataList classAttributes;
  late DataList classDomains;
  late List<DataList> domainsAttributes;
  late Map<String, dynamic> cardDetail;
  late bool loading;
  late bool loadingDomains;
  late bool loadingAttributes;
  late RequestPayload requestPayload;

  ClassState(
      {DataList? list,
      this.activeClass = const {},
      DataList? classCards,
      DataList? classAttributes,
      DataList? classDomains,
      this.domainsAttributes = const [],
      this.cardDetail = const {},
      this.loading = false,
      this.loadingDomains = false,
      this.loadingAttributes = false,
      RequestPayload? requestPayload}) {
    this.list = list ?? DataList();
    this.classCards = classCards ?? DataList();
    this.classAttributes = classAttributes ?? DataList();
    this.classDomains = classDomains ?? DataList();
    this.requestPayload = requestPayload ?? RequestPayload();
  }

  ClassState copyWith(
      {DataList? list,
      Map<String, dynamic>? activeClass,
      DataList? classCards,
      DataList? classAttributes,
      DataList? classDomains,
      List<DataList>? domainsAttributes,
      Map<String, dynamic>? cardDetail,
      bool? loading,
      bool? loadingDomains,
      bool? loadingAttributes,
      RequestPayload? requestPayload}) {
    return ClassState(
        list: list ?? this.list,
        activeClass: activeClass ?? this.activeClass,
        classCards: classCards ?? this.classCards,
        classAttributes: classAttributes ?? this.classAttributes,
        classDomains: classDomains ?? this.classDomains,
        domainsAttributes: domainsAttributes ?? this.domainsAttributes,
        cardDetail: cardDetail ?? this.cardDetail,
        loading: loading ?? this.loading,
        loadingDomains: loadingDomains ?? this.loadingDomains,
        loadingAttributes: loadingAttributes ?? this.loadingAttributes,
        requestPayload: requestPayload ?? this.requestPayload);
  }
}
