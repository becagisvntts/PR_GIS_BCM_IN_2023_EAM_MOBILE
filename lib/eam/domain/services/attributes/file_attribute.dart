import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/fields/bm_file_field.dart';

class FileAttribute extends ClassAttribute {
  String dmsCategory = "";
  String dmsModel = "";
  String fileName = "";
  int fileId = -1;

  @override
  void initProperties() {
    type = AttributeService.typeFile;
  }

  @override
  FileAttribute copyWith(Map<String, dynamic> attributeConfig) {
    FileAttribute clone =
        copyConfigToInstance(FileAttribute(), attributeConfig) as FileAttribute;
    String _dmsCategory = attributeConfig.containsKey("dmsCategory")
        ? attributeConfig["dmsCategory"]
        : dmsCategory;
    return clone
      ..dmsModel = attributeConfig.containsKey("dmsModel")
          ? attributeConfig["dmsModel"]
          : dmsModel
      ..dmsCategory = _dmsCategory
      ..fileName = attributeConfig.containsKey("_${_dmsCategory}_FileName")
          ? attributeConfig["_${_dmsCategory}_FileName"]
          : fileName
      ..fileId = attributeConfig.containsKey("_${_dmsCategory}_card")
          ? attributeConfig["_${_dmsCategory}_card"]
          : fileId;
  }

  @override
  Widget getFormField() {
    return BMFileField(
        name: name, description: '', dmsCategory: '', fileName: '', fileId: 0);
  }
}
