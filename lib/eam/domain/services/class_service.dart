import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/http_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list_meta.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/request_payload.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/card_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/actions/class_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/class_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class ClassService {
  static const classApi = '${HttpService.apiUrl}classes/';

  static Future<void> fetchClassesData() async {
    StateHelper.store.dispatch(FetchClassesAction());
  }

  static Future<DataList> fetchClasses() async {
    var response =
        await HttpService.getWithAuth(endpoint: "$classApi?detailed=true");
    if (response.statusCode == 200) {
      dynamic resArr = jsonDecode(utf8.decode(response.bodyBytes));
      return DataList.fromJson(resArr);
    } else {
      return DataList();
    }
  }

  static Future<DataList> fetchClassAttributes(String className) async {
    var response = await HttpService.getWithAuth(
        endpoint: "$classApi$className/attributes");
    if (response.statusCode == 200) {
      dynamic resArr = jsonDecode(utf8.decode(response.bodyBytes));
      return DataList.fromJson(resArr);
    } else {
      return DataList();
    }
  }

  static Future<DataList> fetchClassDomains(String className) async {
    DataList classDomains = StateHelper.eamState.classState.classDomains;
    Map<String, dynamic> activeClass =
        StateHelper.eamState.classState.activeClass;
    if (className != activeClass[ClassConfig.classTypeByKey] ||
        classDomains.data.isEmpty) {
      String api = "$classApi$className/domains?detailed=true";
      var response = await HttpService.getWithAuth(endpoint: api);

      if (response.statusCode == 200) {
        dynamic resArr = jsonDecode(utf8.decode(response.bodyBytes));
        classDomains = DataList.fromJson(resArr);

        ///Filter displayed domains and get attributes of them
        List<Map<String, dynamic>> displayedDomains = [];
        for (Map<String, dynamic> domain in classDomains.data) {
          if (ClassService.isShowDomainOnClassDetail(domain, className)) {
            displayedDomains.add(domain);
          }
        }

        ///Save displayed domains to store
        classDomains = DataList(
            data: displayedDomains,
            meta: DataListMeta(total: displayedDomains.length));

        // StateHelper.store
        //     .dispatch(FetchClassDomainsSuccessAction(list: classDomains));

        return classDomains;
      }
      return DataList();
    }
    return classDomains;
  }

  static Future<List<DataList>> fetchClassAttributesOfDomains(
      DataList domains) async {
    List<DataList> domainsAttributes =
        StateHelper.eamState.classState.domainsAttributes;
    if (domainsAttributes.isEmpty) {
      List<Future<DataList>> requestList = [];
      for (Map<String, dynamic> domain in domains.data) {
        requestList.add(ClassService.fetchClassAttributes(
            ClassService.getDomainTargetNameOnClassDetail(domain)));
      }

      domainsAttributes = await Future.wait(requestList);
      // StateHelper.store.dispatch(
      //     FetchClassAttributesOfDomainsSuccessAction(list: domainsAttributes));
    }
    return domainsAttributes;
  }

  static Future<DataList> fetchClassCardsByPage(int page) async {
    RequestPayload requestPayload =
        StateHelper.eamState.classState.requestPayload.copyWith(page: page);
    StateHelper.store
        .dispatch(UpdateRequestPayloadAction(requestPayload: requestPayload));
    DataList classCards = await fetchClassCards();
    updateClassCardsToStore(classCards);
    return classCards;
  }

  static Future<Map<String, dynamic>> fetchClassCardDetail(
      Map<String, dynamic> card) async {
    String cardClassType = card[ClassConfig.cardClassTypeByKey];
    String cardId = CardGetter.getID(card);
    String api =
        "$classApi$cardClassType/cards/$cardId?includeModel=true&includeWidgets=true&includeStats=true";
    var response = await HttpService.getWithAuth(endpoint: api);

    if (response.statusCode == 200) {
      /// {...attributes, _model: attributes: []}
      dynamic resArr = jsonDecode(utf8.decode(response.bodyBytes));
      return resArr["data"];
    }

    return {
      ...card,
      "_model": {"attributes": []}
    };
  }

  static Future<DataList> fetchDomainCards(
      Map<String, dynamic> domainConfig, Map<String, dynamic> card,
      {RequestPayload? requestPayload}) async {
    Map<String, dynamic> additionalFilter = {
      "relation": [
        {
          "domain": domainConfig["_id"],
          "source": domainConfig["source"],
          "destination": domainConfig["destination"],
          "direction": getDomainDirectionOnClassDetail(domainConfig),
          "type": "oneof",
          "cards": [
            {
              "className": card[ClassConfig.cardClassTypeByKey],
              "id": CardGetter.getID(card)
            }
          ]
        }
      ]
    };

    String payloadStr = "include_tasklist=true";
    if (requestPayload != null) {
      payloadStr +=
          "&${requestPayload.toPath(additionalFilter: additionalFilter)}";
    } else {
      payloadStr += "&filter=${jsonEncode(additionalFilter)}";
    }

    String api =
        "$classApi${getDomainTargetNameOnClassDetail(domainConfig)}/cards?$payloadStr}";
    var response = await HttpService.getWithAuth(endpoint: api);

    if (response.statusCode == 200) {
      dynamic resArr = jsonDecode(utf8.decode(response.bodyBytes));
      DataList classCards = DataList.fromJson(resArr);
      updateClassCardsToStore(classCards);
      return classCards;
    }

    return DataList();
  }

  static Future<DataList> fetchClassCards(
      {String? className, RequestPayload? requestPayload}) async {
    className = className ??
        StateHelper.eamState.classState.activeClass[ClassConfig.classTypeByKey];
    requestPayload =
        requestPayload ?? StateHelper.eamState.classState.requestPayload;

    var response = await HttpService.getWithAuth(
        endpoint: "$classApi$className/cards?${requestPayload.toPath()}");

    if (response.statusCode == 200) {
      dynamic resArr = jsonDecode(utf8.decode(response.bodyBytes));
      DataList classCards = DataList.fromJson(resArr);
      return classCards;
    } else {
      return DataList();
    }
  }

  static void updateClassCardsToStore(DataList list) {
    DataList newList;
    ClassState classesState = StateHelper.eamState.classState;

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
    DataList classes = StateHelper.eamState.classState.list;
    for (int i = 0; i < classes.meta.total; i++) {
      if (classes.data[i][ClassConfig.classTypeByKey] == className) {
        StateHelper.store
            .dispatch(UpdateActiveClass(activeClass: classes.data[i]));
        break;
      }
    }
  }

  static bool isShowDomainOnClassDetail(
      Map<String, dynamic> domainConfig, String className) {
    return (domainConfig["sourceInline"] &&
            ["1:N", "1:1", "N:N"].contains(domainConfig["cardinality"]) &&
            domainConfig["sources"].contains(className) ||
        domainConfig["destinationInline"] &&
            ["N:1", "1:1", "N:N"].contains(domainConfig["cardinality"]) &&
            domainConfig["destinations"].contains(className));
  }

  static String getDomainTitleOnClassDetail(Map<String, dynamic> domainConfig) {
    return domainConfig["sourceInline"]
        ? domainConfig["descriptionDirect"]
        : domainConfig["descriptionInverse"];
  }

  static String getDomainTargetNameOnClassDetail(
      Map<String, dynamic> domainConfig) {
    return domainConfig["sourceInline"]
        ? domainConfig["destination"]
        : domainConfig["source"];
  }

  static bool getDomainDefaultClosedOnClassDetail(
      Map<String, dynamic> domainConfig) {
    return domainConfig["sourceInline"]
        ? domainConfig["sourceDefaultClosed"]
        : domainConfig["destinationDefaultClosed"];
  }

  static String getDomainDirectionOnClassDetail(
      Map<String, dynamic> domainConfig) {
    return domainConfig["sourceInline"] ? "_2" : "_1";
  }

  static Map<String, dynamic> getClassConfigOfCard(Map<String, dynamic>? card) {
    Map<String, dynamic> activeClass =
        StateHelper.eamState.classState.activeClass;
    if (card == null) return activeClass;

    if (card[ClassConfig.cardClassTypeByKey] !=
        activeClass[ClassConfig.classTypeByKey]) {
      DataList classes = StateHelper.eamState.classState.list;
      for (int i = 0; i < classes.data.length; i++) {
        if (card[ClassConfig.cardClassTypeByKey] ==
            classes.data[i][ClassConfig.classTypeByKey]) {
          return classes.data[i];
        }
      }
    }

    return activeClass;
  }

  static Widget getAttributeText(
      Map<String, dynamic> attributeConfig, Map<String, dynamic> card) {
    ClassAttribute attribute =
        AttributeService.getCopyClassAttributeByAttributeConfig(
            attributeConfig);
    attribute.syncDataFromCard(card);

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("${attribute.description}: ",
          style: const TextStyle(color: Colors.black54)),
      Expanded(child: attribute.getValueAsWidget())
    ]);
  }

  static Widget getAttributeFormField(Map<String, dynamic> attributeConfig,
      {Map<String, dynamic>? card}) {
    ClassAttribute attribute =
        AttributeService.getCopyClassAttributeByAttributeConfig(
            attributeConfig);
    if (card != null) attribute.syncDataFromCard(card);

    return FormControl(child: attribute.getFormField());
  }

  static Future<dynamic> createNewCard(
      String className, Map<String, dynamic> formData) async {
    String api = "$classApi$className/cards";
    var response =
        await HttpService.postWithAuth(endpoint: api, body: formData);

    if (response.statusCode == 200) {
      var resArr = jsonDecode(utf8.decode(response.bodyBytes));
      return resArr["data"];
    } else {
      return false;
    }
  }

  static Future<dynamic> updateCard(
      String className, String cardId, Map<String, dynamic> formData) async {
    String api = "$classApi$className/cards/$cardId";
    var response = await HttpService.putWithAuth(endpoint: api, body: formData);

    if (response.statusCode == 200) {
      var resArr = jsonDecode(utf8.decode(response.bodyBytes));
      return resArr["data"];
    } else {
      return false;
    }
  }

  static Future<bool> deleteCard(String className, String cardId) async {
    String api = "$classApi$className/cards/$cardId";
    var response = await HttpService.deleteWithAuth(endpoint: api);

    return response.statusCode == 200;
  }
}
