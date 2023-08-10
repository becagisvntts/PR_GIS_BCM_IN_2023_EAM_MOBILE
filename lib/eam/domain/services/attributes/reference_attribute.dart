import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';

class ReferenceAttribute extends ClassAttribute {
  String domain = "";

  @override
  void initProperties() {
    type = AttributeService.typeReference;
  }

  @override
  String getValueAsString() {
    return valueDescription != null
        ? "$valueDescription"
        : valueCode != null
            ? "$valueCode"
            : value != null
                ? "$value"
                : "";
  }

  @override
  void syncDataFromCard(Map<String, dynamic> card) {
    super.syncDataFromCard(card);
    if (card.containsKey("_${name}_code")) {
      valueCode = card["_${name}_code"];
    } else {
      valueCode = null;
    }
    if (card.containsKey("_${name}_description")) {
      valueDescription = card["_${name}_description"];
    } else {
      valueDescription = null;
    }
  }

  @override
  ClassAttribute copyWith(Map<String, dynamic> attributeConfig) {
    ReferenceAttribute clone = ReferenceAttribute();
    return copyConfigToInstance(clone, attributeConfig);
  }
}
