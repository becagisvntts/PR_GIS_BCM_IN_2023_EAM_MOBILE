import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/request_payload.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/actions/class_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/class_state.dart';

ClassState classReducer(ClassState prevState, action) {
  switch (action.runtimeType) {
    case FetchClassesAction:
      return prevState.copyWith(loading: true);

    case FetchClassesSuccessAction:
      return prevState.copyWith(list: action.list, loading: false);

    case UpdateActiveClass:
      return prevState.copyWith(
          activeClass: action.activeClass,
          classCards: DataList(),
          classAttributes: DataList(),
          classDomains: DataList(),
          domainsAttributes: [],
          loadingAttributes: true,
          requestPayload: RequestPayload());

    case FetchClassAttributesSuccessAction:
      return prevState.copyWith(
          classAttributes: action.list, loadingAttributes: false);

    case FetchClassCardsSuccessAction:
      return prevState.copyWith(classCards: action.list);

    case FetchClassDomainsSuccessAction:
      return prevState.copyWith(classDomains: action.list);

    case UpdateRequestPayloadAction:
      return prevState.copyWith(requestPayload: action.requestPayload);

    case FetchCardDetailSuccessAction:
      return prevState.copyWith(cardDetail: action.cardDetail);
    default:
      return prevState;
  }
}
