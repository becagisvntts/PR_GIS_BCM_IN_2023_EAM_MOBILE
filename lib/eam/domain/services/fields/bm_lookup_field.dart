import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/fields/field_generator.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/lookup_service.dart';

class BMLookupField extends StatefulWidget {
  final String name;
  final dynamic value;
  final dynamic valueCode;
  final dynamic valueDescription;
  final dynamic valueDescriptionTranslation;
  final String lookupType;
  final String label;
  final bool enabled;
  final bool required;
  const BMLookupField(
      {super.key,
      required this.name,
      required this.value,
      required this.lookupType,
      required this.label,
      required this.enabled,
      required this.required,
      this.valueCode,
      this.valueDescription,
      this.valueDescriptionTranslation});

  @override
  State<StatefulWidget> createState() => BMLookupFieldState();
}

class BMLookupFieldState extends State<BMLookupField> {
  bool loadingLookupCards = true;
  final lookupCodeFieldKey = GlobalKey<FormBuilderFieldState>();
  final lookupDescriptionFieldKey = GlobalKey<FormBuilderFieldState>();
  final referenceDescriptionTranslationFieldKey =
      GlobalKey<FormBuilderFieldState>();
  late DataList lookupTypes;

  @override
  void initState() {
    fetchLookupTypes();
    super.initState();
  }

  Future<void> fetchLookupTypes() async {
    lookupTypes = await LookupService.fetchLookupTypes(widget.lookupType);
    loadingLookupCards = false;
    setState(() {});
  }

  dynamic getReferenceCode(dynamic referenceId) {
    for (Map<String, dynamic> card in lookupTypes.data) {
      if (card["_id"] == referenceId) return card["code"];
    }
    return "";
  }

  dynamic getReferenceDescription(dynamic referenceId) {
    for (Map<String, dynamic> card in lookupTypes.data) {
      if (card["_id"] == referenceId) return card["description"];
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return loadingLookupCards
        ? Container()
        : Column(children: [
            FieldGenerator.generateSelectField(
                name: widget.name,
                label: widget.label,
                value: widget.value,
                required: widget.required,
                enabled: widget.enabled,
                dropdownItems: lookupTypes.data
                    .map((el) => DropdownMenuItem(
                        value: el["_id"], child: Text(el["description"])))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      lookupCodeFieldKey.currentState!
                          .setValue(getReferenceCode(value));
                      lookupDescriptionFieldKey.currentState!
                          .setValue(getReferenceDescription(value));
                      referenceDescriptionTranslationFieldKey.currentState!
                          .setValue(getReferenceDescription(value));
                    });
                  }
                }),
            FieldGenerator.hiddenField(
                key: lookupCodeFieldKey,
                name: "_${widget.name}_code",
                value: widget.valueCode),
            FieldGenerator.hiddenField(
                key: lookupDescriptionFieldKey,
                name: "_${widget.name}_description",
                value: widget.valueDescription),
            FieldGenerator.hiddenField(
                key: referenceDescriptionTranslationFieldKey,
                name: "_${widget.name}_description_translation",
                value: widget.valueDescriptionTranslation)
          ]);
  }
}
