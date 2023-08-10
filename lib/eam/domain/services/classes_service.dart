import 'dart:convert';

import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/http_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/request_payload.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/classes_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/actions/classes_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/classes_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class ClassesService {
  static const classesApi = '${HttpService.apiUrl}classes/';

  static Future<void> fetchClassesData() async {
    StateHelper.store.dispatch(FetchClassesAction());
  }

  static Future<DataList> fetchClasses() async {
    var response =
        await HttpService.getWithAuth(endpoint: "$classesApi?detailed=true");
    if (response.statusCode == 200) {
      dynamic resArr = jsonDecode(utf8.decode(response.bodyBytes));
      return DataList.fromJson(resArr);
    } else {
      return DataList();
    }
  }

  static Future<DataList> fetchClassAttributes(String className) async {
    var response = await HttpService.getWithAuth(
        endpoint: "$classesApi$className/attributes");
    if (response.statusCode == 200) {
      dynamic resArr = jsonDecode(utf8.decode(response.bodyBytes));
      return DataList.fromJson(resArr);
    } else {
      return DataList();
    }
  }

  static Future<DataList> fetchClassCardsByPage(int page) async {
    RequestPayload requestPayload =
        StateHelper.eamState.classesState.requestPayload.copyWith(page: page);
    StateHelper.store
        .dispatch(UpdateRequestPayloadAction(requestPayload: requestPayload));
    return await fetchClassCards();
  }

  static Future<DataList> fetchClassCards(
      {String? className, RequestPayload? requestPayload}) async {
    className = className ??
        StateHelper
            .eamState.classesState.activeClass[ClassesConfig.classNameByKey];
    requestPayload =
        requestPayload ?? StateHelper.eamState.classesState.requestPayload;

    var response = await HttpService.getWithAuth(
        endpoint: "$classesApi$className/cards?${requestPayload.toPath()}");

    if (response.statusCode == 200) {
      dynamic resArr = jsonDecode(utf8.decode(response.bodyBytes));
      DataList classCards = DataList.fromJson(resArr);
      updateClassCardsToStore(classCards);
      return classCards;
    } else {
      return DataList();
    }
  }

  static void updateClassCardsToStore(DataList list) {
    DataList newList;
    ClassesState classesState = StateHelper.eamState.classesState;

    ///First load -> replace list
    if (classesState.requestPayload.page == 1) {
      newList = list;
    }

    ///Load more -> append to list
    else {
      newList = classesState.classCards;
      newList.data.addAll(list.data);
    }

    StateHelper.store.dispatch(FetchClassCardsSuccessAction(list: newList));
  }

  static void findAndChangeActiveClass(String className) async {
    DataList classes = StateHelper.eamState.classesState.list;
    for (int i = 0; i < classes.meta.total; i++) {
      if (classes.data[i][ClassesConfig.classNameByKey] == className) {
        StateHelper.store
            .dispatch(UpdateActiveClass(activeClass: classes.data[i]));
        break;
      }
    }
  }
}
