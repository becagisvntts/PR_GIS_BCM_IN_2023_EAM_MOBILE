import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/date_time_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';

class DateAttribute extends ClassAttribute {
  @override
  void initProperties() {
    type = AttributeService.typeDate;
  }

  @override
  String getValueAsString() {
    return value != null
        ? DateTimeHelper.formattedDateTime(
            str: value, format: DateTimeHelper.dateFormat)
        : "";
  }

  @override
  ClassAttribute copyWith(Map<String, dynamic> attributeConfig) {
    DateAttribute clone = DateAttribute();
    return copyConfigToInstance(clone, attributeConfig);
  }
}
