import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/request_payload.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/card_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/fields/field_generator.dart';

class BMReferenceField extends StatefulWidget {
  final String name;
  final dynamic value;
  final dynamic valueCode;
  final dynamic valueDescription;
  final dynamic valueDescriptionTranslation;
  final String targetClass;
  final String label;
  final bool enabled;
  final bool required;
  const BMReferenceField(
      {super.key,
      required this.name,
      required this.value,
      required this.targetClass,
      required this.label,
      required this.enabled,
      required this.required,
      this.valueCode,
      this.valueDescription,
      this.valueDescriptionTranslation});

  @override
  State<StatefulWidget> createState() => BMReferenceFieldState();
}

class BMReferenceFieldState extends State<BMReferenceField> {
  bool loadingReferenceCards = true;
  final referenceCodeFieldKey = GlobalKey<FormBuilderFieldState>();
  final referenceDescriptionFieldKey = GlobalKey<FormBuilderFieldState>();
  late DataList referenceCards;

  @override
  void initState() {
    fetchReferenceCards();
    super.initState();
  }

  Future<void> fetchReferenceCards() async {
    RequestPayload requestPayload =
        RequestPayload(limit: 500, attrs: ["Id", "Description", "Code"]);
    referenceCards = await ClassService.fetchClassCards(
        classType: widget.targetClass, requestPayload: requestPayload);
    loadingReferenceCards = false;
    setState(() {});
  }

  dynamic getReferenceCode(dynamic referenceId) {
    for (Map<String, dynamic> card in referenceCards.data) {
      if (CardGetter.getID(card) == referenceId) {
        return CardGetter.getCode(card);
      }
    }
    return "";
  }

  dynamic getReferenceDescription(dynamic referenceId) {
    for (Map<String, dynamic> card in referenceCards.data) {
      if (CardGetter.getID(card) == referenceId) {
        return CardGetter.getDescription(card);
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return loadingReferenceCards
        ? Container()
        : Column(children: [
            FieldGenerator.generateSelectField(
                name: widget.name,
                label: widget.label,
                value: widget.value,
                required: widget.required,
                enabled: widget.enabled,
                dropdownItems: referenceCards.data
                    .map((el) => DropdownMenuItem(
                        value: CardGetter.getID(el),
                        child: Text(CardGetter.getDescription(el))))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      referenceCodeFieldKey.currentState!
                          .setValue(getReferenceCode(value));
                      referenceDescriptionFieldKey.currentState!
                          .setValue(getReferenceDescription(value));
                    });
                  }
                }),
            FieldGenerator.hiddenField(
                key: referenceCodeFieldKey,
                name: "_${widget.name}_code",
                value: widget.valueCode),
            FieldGenerator.hiddenField(
                key: referenceDescriptionFieldKey,
                name: "_${widget.name}_description",
                value: widget.valueDescription)
          ]);
  }
}
