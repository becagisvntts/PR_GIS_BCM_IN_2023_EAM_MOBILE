import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/date_time_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/string_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';

class FieldGenerator {
  static FormBuilderTextField generateTextField(
      {required String name,
      required String label,
      String? initialValue,
      bool required = false,
      bool readOnly = false,
      String subType = "text",
      int? maxLength}) {
    return FormBuilderTextField(
      key: ValueKey("$name-$initialValue"),
      decoration: FormInputDecoration(placeholder: label),
      name: name,
      initialValue: initialValue ?? "",
      keyboardType: TextInputType.text,
      readOnly: readOnly,
      textInputAction: TextInputAction.next,
      validator: (val) {
        if (required && (val == null || val.trim().isEmpty)) {
          return LocalizationService.translate.msg_field_required(label);
        }

        if (maxLength != null && val != null && val.length > maxLength) {
          return LocalizationService.translate
              .msg_field_max_length(label, maxLength);
        }
        return null;
      },
    );
  }

  static FormBuilderTextField generateNumberField(
      {required String name,
      required String label,
      String? initialValue,
      bool required = false,
      bool readOnly = false,
      int? minValue,
      int? maxValue}) {
    return FormBuilderTextField(
      key: ValueKey("$name-$initialValue"),
      decoration: FormInputDecoration(placeholder: label),
      name: name,
      initialValue: initialValue ?? "",
      keyboardType: TextInputType.number,
      readOnly: readOnly,
      textInputAction: TextInputAction.next,
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
      String? initialValue,
      bool required = false,
      bool readOnly = false,
      Map<String, String> options = const <String, String>{},
      Function? onChanged}) {
    List<DropdownMenuItem> dropdownItems = [];
    options.forEach((key, value) {
      dropdownItems.add(DropdownMenuItem(value: key, child: Text(value)));
    });
    return FormBuilderDropdown(
      key: ValueKey("$name-$initialValue"),
      decoration: FormInputDecoration(placeholder: label),
      initialValue: initialValue ?? "",
      name: name,
      isExpanded: !readOnly,
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

  static FormBuilderDropdown generateDropdownField(
      {required String name,
      required String label,
      dynamic initialValue,
      bool required = false,
      bool readOnly = false,
      List<Map<String, dynamic>> options = const [],
      Function? onChanged}) {
    List<DropdownMenuItem> dropdownItems = [];
    for (Map<String, dynamic> option in options) {
      dropdownItems.add(DropdownMenuItem(
          value: option['name'].toString(), child: Text(option['label'])));
    }

    return FormBuilderDropdown(
      key: ValueKey("$name-$initialValue"),
      decoration: FormInputDecoration(placeholder: label),
      initialValue: initialValue,
      name: name,
      isExpanded: !readOnly,
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
      bool initialValue = false,
      bool readOnly = false,
      Function? onChanged}) {
    return FormBuilderCheckbox(
        key: ValueKey("$name-$initialValue"),
        decoration: const InputDecoration(
            border: InputBorder.none, contentPadding: EdgeInsets.all(0)),
        name: name,
        enabled: !readOnly,
        initialValue: initialValue,
        title: Text(label, style: const TextStyle(fontSize: 16)),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.all(0),
        // side: BorderSide(color: ThemeConfig.appColor, width: 2),
        onChanged: (value) => onChanged?.call(value));
  }

  static FormBuilderCheckboxGroup generateCheckboxGroupField(
      {required String name,
      required String label,
      List<dynamic>? initialValue,
      bool required = false,
      bool readOnly = false,
      List<Map<String, dynamic>> options = const []}) {
    List<FormBuilderFieldOption> checkboxGroupItems = [];
    for (Map<String, dynamic> option in options) {
      checkboxGroupItems.add(FormBuilderFieldOption(
          value: option['name'],
          child: Text(option['label'], style: const TextStyle(fontSize: 16))));
    }
    return FormBuilderCheckboxGroup(
        key: ValueKey("$name-$initialValue"),
        decoration: const InputDecoration(
            border: InputBorder.none, contentPadding: EdgeInsets.all(0)),
        name: name,
        initialValue: initialValue,
        enabled: !readOnly,
        orientation: OptionsOrientation.vertical,
        options: checkboxGroupItems,
        activeColor: ThemeConfig.appColor);
  }

  static FormBuilderRadioGroup generateRadioGroupField(
      {required String name,
      required String label,
      dynamic initialValue,
      bool required = false,
      bool readOnly = false,
      List<Map<String, dynamic>> options = const []}) {
    List<FormBuilderFieldOption> radioGroupOptions = [];
    for (Map<String, dynamic> option in options) {
      radioGroupOptions.add(FormBuilderFieldOption(
          value: option['name'],
          child: Text(option['label'], style: const TextStyle(fontSize: 16))));
    }
    return FormBuilderRadioGroup(
      key: ValueKey("$name-$initialValue"),
      decoration: const InputDecoration(
          border: InputBorder.none, contentPadding: EdgeInsets.all(0)),
      name: name,
      initialValue: initialValue,
      enabled: !readOnly,
      orientation: OptionsOrientation.vertical,
      options: radioGroupOptions,
    );
  }

  static FormBuilderDateTimePicker generateDateTimeField({
    required String name,
    required String label,
    DateTime? initialValue,
    bool required = false,
    bool readOnly = false,
  }) {
    return FormBuilderDateTimePicker(
      key: ValueKey("$name-$initialValue"),
      name: name,
      decoration: FormInputDecoration(placeholder: label),
      inputType: InputType.date,
      enabled: !readOnly,
      format: DateFormat("dd-MM-yyyy"),
      initialValue: initialValue,
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
}
