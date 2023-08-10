import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';

class NumberAttribute extends ClassAttribute {
  @override
  void initProperties() {
    type = AttributeService.typeNumber;
  }

  @override
  ClassAttribute copyWith(Map<String, dynamic> attributeConfig) {
    NumberAttribute clone = NumberAttribute();
    return copyConfigToInstance(clone, attributeConfig);
  }
}
