import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/date_attribute.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/lookup_attribute.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/number_attribute.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/reference_attribute.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/text_attribute.dart';

class AttributeService {
  static const String typeReference = "reference";
  static const String typeText = "text|string";
  static const String typeNumber = "integer|long|double";
  static const String typeDate = "date";
  static const String typeLookup = "lookup";
  static const String typeEntryType = "entryType";

  static List<ClassAttribute> listClassAttributes = [
    ReferenceAttribute(),
    NumberAttribute(),
    TextAttribute(),
    DateAttribute(),
    LookupAttribute()
  ];

  static ClassAttribute getCopyClassAttributeByAttributeConfig(
      Map<String, dynamic> attributeConfig) {
    for (ClassAttribute fieldBuilder in listClassAttributes) {
      if (fieldBuilder.type.split('|').contains(attributeConfig['type'])) {
        return fieldBuilder.copyWith(attributeConfig);
      }
    }
    return TextAttribute().copyWith(attributeConfig);
  }
}
