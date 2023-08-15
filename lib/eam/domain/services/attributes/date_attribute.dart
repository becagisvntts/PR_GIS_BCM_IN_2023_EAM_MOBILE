import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/date_time_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/fields/bm_date_picker_field.dart';

class DateAttribute extends ClassAttribute {
  @override
  void initProperties() {
    type = AttributeService.typeDate;
  }

  @override
  String getValueAsString() {
    return value != null
        ? DateTimeHelper.formattedDateTime(
            str: value, format: DateTimeHelper.dateFormat)
        : "";
  }

  @override
  DateAttribute copyWith(Map<String, dynamic> attributeConfig) {
    DateAttribute clone = DateAttribute();
    return copyConfigToInstance(clone, attributeConfig) as DateAttribute;
  }

  @override
  Widget getFormField() {
    bool enabled = writable && (!super.immutable || value == null);
    return BMDatePickerField(
        name: name,
        enabled: enabled,
        value: value,
        label: description,
        required: mandatory);
  }

  @override
  Future<Map<String, dynamic>> formatBeforeSubmit(
      Map<String, dynamic> formData) async {
    if (formData[name] == null || formData[name] == "") {
      formData[name] = null;
    } else {
      formData[name] = DateTimeHelper.formattedDateTime(
          str: formData[name], format: DateTimeHelper.savingFormat);
    }
    return formData;
  }
}
