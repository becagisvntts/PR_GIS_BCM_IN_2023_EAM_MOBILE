import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/fields/bm_lookup_field.dart';

class LookupAttribute extends ClassAttribute {
  String lookupType = "";
  String textColor = "#333333";
  dynamic valueCode;
  dynamic valueDescription;
  dynamic valueDescriptionTranslation;
  @override
  void initProperties() {
    type = AttributeService.typeLookup;
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
    }
    if (card.containsKey("_${name}_description")) {
      valueDescription = card["_${name}_description"];
    }
  }

  @override
  LookupAttribute copyWith(Map<String, dynamic> attributeConfig) {
    LookupAttribute clone =
        copyConfigToInstance(LookupAttribute(), attributeConfig)
            as LookupAttribute;
    return clone
      ..lookupType = attributeConfig.containsKey("lookupType")
          ? attributeConfig["lookupType"]
          : lookupType
      ..valueCode = attributeConfig.containsKey("valueCode")
          ? attributeConfig["valueCode"]
          : valueCode
      ..valueDescription = attributeConfig.containsKey("valueDescription")
          ? attributeConfig["valueDescription"]
          : valueDescription
      ..valueDescriptionTranslation =
          attributeConfig.containsKey("valueDescriptionTranslation")
              ? attributeConfig["valueDescriptionTranslation"]
              : valueDescriptionTranslation;
  }

  @override
  Widget getFormField() {
    bool enabled = writable && (!super.immutable || value == null);
    return BMLookupField(
        name: name,
        value: value,
        valueCode: valueCode,
        valueDescription: valueDescription,
        valueDescriptionTranslation: valueDescriptionTranslation,
        lookupType: lookupType,
        label: description,
        enabled: enabled,
        required: mandatory);
  }
}
