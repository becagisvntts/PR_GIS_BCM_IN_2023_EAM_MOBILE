import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';

class TextAttribute extends ClassAttribute {
  @override
  void initProperties() {
    type = AttributeService.typeText;
  }

  @override
  ClassAttribute copyWith(Map<String, dynamic> attributeConfig) {
    TextAttribute clone = TextAttribute();
    return copyConfigToInstance(clone, attributeConfig);
  }
}
