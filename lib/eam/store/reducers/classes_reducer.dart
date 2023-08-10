import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/request_payload.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/actions/classes_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/classes_state.dart';

ClassesState classesReducer(ClassesState prevState, action) {
  switch (action.runtimeType) {
    case FetchClassesAction:
      return prevState.copyWith(loading: true);
    case FetchClassesSuccessAction:
      return prevState.copyWith(list: action.list, loading: false);
    case UpdateActiveClass:
      return prevState.copyWith(
          activeClass: action.activeClass,
          loadingClassDetail: true,
          requestPayload: RequestPayload());
    case FetchClassAttributesSuccessAction:
      return prevState.copyWith(
          classAttributes: action.list, loadingClassDetail: false);
    case FetchClassCardsSuccessAction:
      return prevState.copyWith(classCards: action.list);

    case UpdateRequestPayloadAction:
      return prevState.copyWith(requestPayload: action.requestPayload);
    default:
      return prevState;
  }
}
