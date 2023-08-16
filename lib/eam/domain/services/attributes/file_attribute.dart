import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/fields/bm_file_field.dart';

class FileAttribute extends ClassAttribute {
  String dmsCategory = "";
  String dmsModel = "";
  String fileName = "";

  @override
  void initProperties() {
    type = AttributeService.typeFile;
  }

  @override
  String getValueAsString() {
    return fileName;
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
  void syncDataFromCard(Map<String, dynamic> card) {
    super.syncDataFromCard(card);
    if (card.containsKey("_${dmsCategory}_FileName")) {
      fileName = card["_${dmsCategory}_FileName"];
    }
  }

  @override
  Widget getFormField() {
    bool enabled = writable && (!super.immutable || value == null);
    return BMFileField(
        name: name,
        value: value,
        label: description,
        dmsCategory: dmsCategory,
        fileName: fileName,
        enabled: enabled,
        required: mandatory);
  }
}
