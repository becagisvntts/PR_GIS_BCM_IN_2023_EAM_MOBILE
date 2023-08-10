import 'package:flutter/material.dart';

abstract class ClassAttribute {
  String attrId = "_id";
  String type = "text";
  String name = "attribute";
  String description = "description";
  dynamic value;
  dynamic valueCode;
  dynamic valueDescription;

  ClassAttribute() {
    initProperties();
  }

  void initProperties();

  String getValueAsString() {
    return value != null ? "$value" : "";
  }

  Widget getValueAsWidget() {
    return Text(getValueAsString());
  }

  void syncAttributeConfig(Map<String, dynamic> attributeConfig) {
    attrId = attributeConfig["_id"];
    name = attributeConfig["name"];
    description = attributeConfig["description"];
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
            : description;
      return clone;
    }
  }
}
