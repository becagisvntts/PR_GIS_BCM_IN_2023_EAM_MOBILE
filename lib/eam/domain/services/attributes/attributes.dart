import 'package:flutter/material.dart';

abstract class ClassAttribute {
  String attrId = "_id";
  String type = "text";
  String name = "attribute";
  String description = "description";
  bool writable = true;
  bool mandatory = false;
  bool immutable = false;
  dynamic autoValue;
  dynamic value;

  ClassAttribute() {
    initProperties();
  }

  void initProperties();

  String getValueAsString() {
    return value != null ? "$value" : "";
  }

  Widget getValueAsWidget() {
    return Text.rich(TextSpan(//apply style to all
        children: [
      TextSpan(
          text: "$description: ",
          style: const TextStyle(color: Colors.black54)),
      TextSpan(text: getValueAsString())
    ]));
  }

  void syncDataFromCard(Map<String, dynamic> card) {
    if (card.containsKey(name)) {
      value = card[name];
    }
  }

  ClassAttribute copyWith(Map<String, dynamic> attributeConfig);
  ClassAttribute copyConfigToInstance(
      ClassAttribute clone, Map<String, dynamic> attributeConfig) {
    {
      clone
        ..attrId =
            attributeConfig.containsKey("_id") ? attributeConfig["_id"] : attrId
        ..name =
            attributeConfig.containsKey("name") ? attributeConfig["name"] : name
        ..description = attributeConfig.containsKey("description")
            ? attributeConfig["description"]
            : description
        ..value = attributeConfig.containsKey("defaultValue")
            ? attributeConfig["defaultValue"]
            : ""
        ..autoValue = attributeConfig.containsKey("autoValue")
            ? attributeConfig["autoValue"]
            : ""
        ..writable = attributeConfig.containsKey("writable")
            ? attributeConfig["writable"]
            : ""
        ..mandatory = attributeConfig.containsKey("mandatory")
            ? attributeConfig["mandatory"]
            : ""
        ..immutable = attributeConfig.containsKey("immutable")
            ? attributeConfig["immutable"]
            : "";
      return clone;
    }
  }

  Future<Map<String, dynamic>> formatBeforeSubmit(
      Map<String, dynamic> formData) async {
    if (formData[name] == "") formData[name] = null;
    return formData;
  }

  Widget getFormField();
}
