import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/fields/field_generator.dart';

class NumberAttribute extends ClassAttribute {
  @override
  void initProperties() {
    type = AttributeService.typeNumber;
  }

  @override
  NumberAttribute copyWith(Map<String, dynamic> attributeConfig) {
    NumberAttribute clone = NumberAttribute();
    return copyConfigToInstance(clone, attributeConfig) as NumberAttribute;
  }

  @override
  Widget getFormField() {
    bool enabled = writable && (!super.immutable || value == null);
    return FieldGenerator.generateNumberField(
        name: name,
        label: description,
        required: mandatory,
        enabled: enabled,
        value: getValueAsString());
  }
}
