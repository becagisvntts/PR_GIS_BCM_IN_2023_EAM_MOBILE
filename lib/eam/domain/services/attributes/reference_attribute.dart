import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/fields/bm_reference_field.dart';

class ReferenceAttribute extends ClassAttribute {
  String domain = "";
  String targetClass = "";
  DataList? referenceCards;
  dynamic valueCode;
  dynamic valueDescription;

  @override
  void initProperties() {
    type = AttributeService.typeReference;
  }

  @override
  String getValueAsString() {
    return valueDescription != null
        ? "$valueDescription"
        : valueCode != null
            ? "$valueCode"
            : value != null
                ? "$value"
                : "";
  }

  @override
  void syncDataFromCard(Map<String, dynamic> card) {
    super.syncDataFromCard(card);
    if (card.containsKey("_${name}_code")) {
      valueCode = card["_${name}_code"];
    } else {
      valueCode = null;
    }
    if (card.containsKey("_${name}_description")) {
      valueDescription = card["_${name}_description"];
    } else {
      valueDescription = null;
    }
  }

  @override
  ReferenceAttribute copyWith(Map<String, dynamic> attributeConfig) {
    ReferenceAttribute clone =
        copyConfigToInstance(ReferenceAttribute(), attributeConfig)
            as ReferenceAttribute;
    return clone
      ..valueCode = attributeConfig.containsKey("valueCode")
          ? attributeConfig["valueCode"]
          : valueCode
      ..valueDescription = attributeConfig.containsKey("valueDescription")
          ? attributeConfig["valueDescription"]
          : valueDescription
      ..domain = attributeConfig.containsKey("domain")
          ? attributeConfig["domain"]
          : domain
      ..targetClass = attributeConfig.containsKey("targetClass")
          ? attributeConfig["targetClass"]
          : targetClass;
  }

  @override
  Widget getFormField() {
    bool enabled = writable && (!super.immutable || value == null);
    return BMReferenceField(
      name: name,
      value: value,
      valueCode: valueCode,
      valueDescription: valueDescription,
      targetClass: targetClass,
      label: description,
      enabled: enabled,
      required: mandatory,
    );
  }
}
