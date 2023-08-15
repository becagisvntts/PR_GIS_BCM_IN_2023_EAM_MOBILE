import 'package:flutter/src/widgets/framework.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/fields/field_generator.dart';

class TextAttribute extends ClassAttribute {
  bool multiline = false;
  int maxLength = 255;

  @override
  void initProperties() {
    type = AttributeService.typeText;
  }

  @override
  TextAttribute copyWith(Map<String, dynamic> attributeConfig) {
    TextAttribute clone =
        copyConfigToInstance(TextAttribute(), attributeConfig) as TextAttribute;
    return clone
      ..maxLength = attributeConfig.containsKey("maxLength")
          ? attributeConfig["maxLength"]
          : maxLength
      ..multiline = attributeConfig.containsKey("multiline")
          ? attributeConfig["multiline"]
          : multiline;
  }

  @override
  Widget getFormField() {
    bool enabled = (!super.immutable || value == null); //writable
    return FieldGenerator.generateTextField(
        name: name,
        label: description,
        required: mandatory,
        maxLength: maxLength,
        enabled: enabled,
        minLines: multiline ? 3 : 1,
        maxLines: multiline ? 3 : 1,
        value: value);
  }
}
