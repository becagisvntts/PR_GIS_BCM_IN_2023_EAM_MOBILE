import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/data_type_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';

class ClassGetter {
  static String getID(Map<String, dynamic> classConfig) {
    return classConfig["_id"];
  }

  static String getType(Map<String, dynamic> classConfig) {
    return classConfig[ClassConfig.classTypeByKey];
  }

  static List<Map<String, dynamic>> getAttributeGroups(
      Map<String, dynamic> classConfig) {
    return DataTypeService.listToListMapStringDynamic(
        classConfig[ClassConfig.classAttributeGroupsByKey]);
  }

  static String getDescription(Map<String, dynamic> classConfig) {
    return classConfig[ClassConfig.classTitleByKey];
  }
}
