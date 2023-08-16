import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/data_type_service.dart';

class ClassGetter {
  static const String typeByKey = "name";
  static const String idByKey = "_id";
  static const String attributeGroupsByKey = "attributeGroups";
  static const String descriptionByKey = "description";

  static String getID(Map<String, dynamic> classConfig) {
    return classConfig[idByKey];
  }

  static String getName(Map<String, dynamic> classConfig) {
    return classConfig["name"];
  }

  static String getType(Map<String, dynamic> classConfig) {
    return classConfig[typeByKey];
  }

  static List<Map<String, dynamic>> getAttributeGroups(
      Map<String, dynamic> classConfig) {
    return DataTypeService.listToListMapStringDynamic(
        classConfig[attributeGroupsByKey]);
  }

  static String getDescription(Map<String, dynamic> classConfig) {
    return classConfig[descriptionByKey];
  }
}
