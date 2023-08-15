import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/date_time_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/string_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';

class FieldGenerator {
  static FormBuilderTextField generateTextField(
      {required String name,
      required String label,
      String? value,
      bool required = false,
      bool enabled = true,
      int minLines = 1,
      int maxLines = 1,
      String subType = "text",
      int? maxLength}) {
    return FormBuilderTextField(
        key: ValueKey("$name-$value"),
        decoration: FormInputDecoration(placeholder: label),
        name: name,
        initialValue: value ?? "",
        keyboardType: TextInputType.text,
        enabled: enabled,
        minLines: minLines,
        maxLines: max(minLines, maxLines),
        textInputAction: TextInputAction.next,
        onTapOutside: (event) =>
            FocusScope.of(NavigationHelper.navigatorKey.currentContext!)
                .unfocus(),
        validator: (val) {
          if (required && (val == null || val.trim().isEmpty)) {
            return LocalizationService.translate.msg_field_required(label);
          }

          if (maxLength != null && val != null && val.length > maxLength) {
            return LocalizationService.translate
                .msg_field_max_length(label, maxLength);
          }
          return null;
        });
  }

  static FormBuilderTextField generateNumberField(
      {required String name,
      required String label,
      String? value,
      bool required = false,
      bool enabled = true,
      int? minValue,
      int? maxValue}) {
    return FormBuilderTextField(
      key: ValueKey("$name-$value"),
      decoration: FormInputDecoration(placeholder: label),
      name: name,
      initialValue: value ?? "",
      keyboardType: TextInputType.number,
      enabled: enabled,
      textInputAction: TextInputAction.next,
      onTapOutside: (event) =>
          FocusScope.of(NavigationHelper.navigatorKey.currentContext!)
              .unfocus(),
      validator: (val) {
        if (required && (val == null || val.trim().isEmpty)) {
          return LocalizationService.translate.msg_field_required(label);
        }

        if ((val != null && val.trim().isNotEmpty) &&
            StringHelper.toDouble(input: val) == null) {
          return LocalizationService.translate.msg_field_wrong_format(label);
        }

        if (maxValue != null && double.parse(val!) > maxValue) {
          return LocalizationService.translate
              .msg_field_max_value(label, maxValue);
        } else if (minValue != null && double.parse(val!) < minValue) {
          return LocalizationService.translate
              .msg_field_min_value(label, minValue);
        }
        return null;
      },
    );
  }

  static FormBuilderDropdown generateSelectField(
      {required String name,
      required String label,
      dynamic value,
      bool required = false,
      bool enabled = true,
      List<DropdownMenuItem> dropdownItems = const [],
      Function? onChanged}) {
    return FormBuilderDropdown(
      key: ValueKey("$name-$value"),
      decoration: FormInputDecoration(placeholder: label),
      initialValue: value ?? "",
      name: name,
      enabled: enabled,
      items: dropdownItems,
      onChanged: (value) => onChanged?.call(value),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(8),
      menuMaxHeight: 300,
      validator: (val) {
        if (required && (val == null || val.trim().isEmpty)) {
          return LocalizationService.translate.msg_field_required(label);
        }
        return null;
      },
    );
  }

  static FormBuilderCheckbox generateCheckboxField(
      {required String name,
      required String label,
      bool value = false,
      bool enabled = true,
      Function? onChanged}) {
    return FormBuilderCheckbox(
        key: ValueKey("$name-$value"),
        decoration: const InputDecoration(
            border: InputBorder.none, contentPadding: EdgeInsets.all(0)),
        name: name,
        enabled: enabled,
        initialValue: value,
        title: Text(label, style: const TextStyle(fontSize: 16)),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.all(0),
        // side: BorderSide(color: ThemeConfig.appColor, width: 2),
        onChanged: (value) => onChanged?.call(value));
  }

  static FormBuilderCheckboxGroup generateCheckboxGroupField(
      {required String name,
      required String label,
      List<dynamic>? value,
      bool required = false,
      bool enabled = true,
      List<Map<String, dynamic>> options = const []}) {
    List<FormBuilderFieldOption> checkboxGroupItems = [];
    for (Map<String, dynamic> option in options) {
      checkboxGroupItems.add(FormBuilderFieldOption(
          value: option['name'],
          child: Text(option['label'], style: const TextStyle(fontSize: 16))));
    }
    return FormBuilderCheckboxGroup(
        key: ValueKey("$name-$value"),
        decoration: const InputDecoration(
            border: InputBorder.none, contentPadding: EdgeInsets.all(0)),
        name: name,
        initialValue: value,
        enabled: enabled,
        orientation: OptionsOrientation.vertical,
        options: checkboxGroupItems,
        activeColor: ThemeConfig.appColor);
  }

  static FormBuilderRadioGroup generateRadioGroupField(
      {required String name,
      required String label,
      dynamic value,
      bool required = false,
      bool enabled = true,
      List<Map<String, dynamic>> options = const []}) {
    List<FormBuilderFieldOption> radioGroupOptions = [];
    for (Map<String, dynamic> option in options) {
      radioGroupOptions.add(FormBuilderFieldOption(
          value: option['name'],
          child: Text(option['label'], style: const TextStyle(fontSize: 16))));
    }
    return FormBuilderRadioGroup(
      key: ValueKey("$name-$value"),
      decoration: const InputDecoration(
          border: InputBorder.none, contentPadding: EdgeInsets.all(0)),
      name: name,
      initialValue: value,
      enabled: enabled,
      orientation: OptionsOrientation.vertical,
      options: radioGroupOptions,
    );
  }

  static FormBuilderDateTimePicker generateDateTimeField({
    required String name,
    required String label,
    DateTime? value,
    bool required = false,
    bool enabled = true,
  }) {
    return FormBuilderDateTimePicker(
      key: ValueKey("$name-$value"),
      name: name,
      decoration: FormInputDecoration(placeholder: label),
      inputType: InputType.date,
      enabled: enabled,
      format: DateFormat("dd-MM-yyyy"),
      initialValue: value,
      validator: (val) {
        if (required) {
          if (val == null) {
            return LocalizationService.translate.msg_field_required(label);
          } else if (DateTimeHelper.convertDateTimeToString(dateTime: val)
              .isEmpty) {
            return LocalizationService.translate.msg_field_wrong_format(label);
          }
        }
        return null;
      },
    );
  }

  static FormBuilderField hiddenField(
      {Key? key, required String name, dynamic value}) {
    return FormBuilderField(
        key: key,
        builder: (FormFieldState<dynamic> field) {
          return Container();
        },
        initialValue: value,
        name: name);
  }
}
