import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';

class FileAttribute extends ClassAttribute {
  String dmsCategory = "";
  String dmsModel = "";

  @override
  void initProperties() {
    type = AttributeService.typeFile;
  }

  @override
  FileAttribute copyWith(Map<String, dynamic> attributeConfig) {
    FileAttribute clone =
        copyConfigToInstance(FileAttribute(), attributeConfig) as FileAttribute;
    return clone
      ..dmsModel = attributeConfig.containsKey("dmsModel")
          ? attributeConfig["dmsModel"]
          : dmsModel
      ..dmsCategory = attributeConfig.containsKey("dmsCategory")
          ? attributeConfig["dmsCategory"]
          : dmsCategory;
  }

  @override
  Widget getFormField() {
    return FormBuilderTextField(
        name: name,
        initialValue: getValueAsString(),
        readOnly: false,
        decoration: FormInputDecoration(placeholder: description)
            .copyWith(suffixIcon: const Icon(Icons.upload_rounded)));
  }
}
