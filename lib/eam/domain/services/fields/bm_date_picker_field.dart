import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/date_time_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';

class BMDatePickerField extends StatefulWidget {
  final String name;
  final dynamic value;
  final bool enabled;
  final String label;
  final bool required;
  const BMDatePickerField(
      {super.key,
      required this.name,
      this.value,
      required this.enabled,
      required this.label,
      required this.required});

  @override
  State<StatefulWidget> createState() => BMDatePickerFieldState();
}

class BMDatePickerFieldState extends State<BMDatePickerField> {
  late DateTime? initialValue;
  DateTime? currentValue;
  final datePickerController = TextEditingController();

  @override
  void initState() {
    initialValue = widget.value != null
        ? DateTimeHelper.convertStringToDateTime(str: widget.value)
        : null;

    currentValue = initialValue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
        controller: datePickerController,
        name: widget.name,
        initialValue: initialValue,
        inputType: InputType.date,
        enabled: widget.enabled,
        locale: Locale(LocalizationService.getCurrentLangCode()),
        onChanged: (value) {
          setState(() {
            currentValue = value;
          });
        },
        format: DateFormat("dd-MM-yyyy"),
        decoration: FormInputDecoration(placeholder: widget.label).copyWith(
            suffixIcon: currentValue == null
                ? const Icon(Icons.calendar_month_rounded)
                : IconButton(
                    onPressed: () {
                      setState(() {
                        datePickerController.clear();
                        currentValue = null;
                      });
                    },
                    icon: const Icon(Icons.close_rounded))),
        validator: (val) {
          if (widget.required) {
            if (val == null) {
              return LocalizationService.translate
                  .msg_field_required(widget.label);
            } else if (DateTimeHelper.convertDateTimeToString(dateTime: val)
                .isEmpty) {
              return LocalizationService.translate
                  .msg_field_wrong_format(widget.label);
            }
          }
          return null;
        });
  }
}
