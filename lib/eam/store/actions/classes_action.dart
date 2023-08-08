import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';

class FetchClassesAction {}

class FetchClassesSuccessAction {
  DataList list;
  FetchClassesSuccessAction({required this.list});
}

class UpdateActiveClass {
  Map<String, dynamic> activeClass;
  UpdateActiveClass({required this.activeClass});
}

class FetchClassDetailSuccessAction {
  DataList attributes;
  DataList cards;
  FetchClassDetailSuccessAction(
      {required this.attributes, required this.cards});
}

class FetchClassAttributesSuccessAction {
  DataList list;
  FetchClassAttributesSuccessAction({required this.list});
}

class FetchClassCardsSuccessAction {
  DataList list;
  FetchClassCardsSuccessAction({required this.list});
}
