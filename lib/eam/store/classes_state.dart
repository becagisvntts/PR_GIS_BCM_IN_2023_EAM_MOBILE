import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/request_payload.dart';

class ClassesState {
  late DataList list;
  late Map<String, dynamic> activeClass;
  late DataList classCards;
  late DataList classAttributes;
  late bool loading;
  late bool loadingClassDetail;
  late RequestPayload requestPayload;

  ClassesState(
      {DataList? list,
      this.activeClass = const {},
      DataList? classCards,
      DataList? classAttributes,
      this.loading = false,
      this.loadingClassDetail = false,
      RequestPayload? requestPayload}) {
    this.list = list ?? DataList();
    this.classCards = classCards ?? DataList();
    this.classAttributes = classAttributes ?? DataList();
    this.requestPayload = requestPayload ?? RequestPayload();
  }

  ClassesState copyWith(
      {DataList? list,
      Map<String, dynamic>? activeClass,
      DataList? classCards,
      DataList? classAttributes,
      bool? loading,
      bool? loadingClassDetail,
      RequestPayload? requestPayload}) {
    return ClassesState(
        list: list ?? this.list,
        activeClass: activeClass ?? this.activeClass,
        classCards: classCards ?? this.classCards,
        classAttributes: classAttributes ?? this.classAttributes,
        loading: loading ?? this.loading,
        loadingClassDetail: loadingClassDetail ?? this.loadingClassDetail,
        requestPayload: requestPayload ?? this.requestPayload);
  }
}
