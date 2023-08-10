import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/request_payload.dart';

class FetchClassesAction {}

class FetchClassesSuccessAction {
  DataList list;
  FetchClassesSuccessAction({required this.list});
}

class UpdateActiveClass {
  Map<String, dynamic> activeClass;
  UpdateActiveClass({required this.activeClass});
}

class FetchClassAttributesSuccessAction {
  DataList list;
  FetchClassAttributesSuccessAction({required this.list});
}

class FetchClassCardsAction {}

class FetchClassCardsSuccessAction {
  DataList list;
  FetchClassCardsSuccessAction({required this.list});
}

class UpdateRequestPayloadAction {
  RequestPayload requestPayload;
  UpdateRequestPayloadAction({required this.requestPayload});
}
