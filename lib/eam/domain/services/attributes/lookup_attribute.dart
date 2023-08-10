import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';

class LookupAttribute extends ClassAttribute {
  @override
  void initProperties() {
    type = AttributeService.typeLookup;
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
    }
    if (card.containsKey("_${name}_description")) {
      valueDescription = card["_${name}_description"];
    }
  }

  @override
  ClassAttribute copyWith(Map<String, dynamic> attributeConfig) {
    LookupAttribute clone = LookupAttribute();
    return copyConfigToInstance(clone, attributeConfig);
  }
}
