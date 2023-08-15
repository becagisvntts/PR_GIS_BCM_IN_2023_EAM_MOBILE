import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';

class CardGetter {
  static String getID(Map<String, dynamic> card) {
    return "${card["_id"]}";
  }

  static String getClassType(Map<String, dynamic> card) {
    return card[ClassConfig.cardClassTypeByKey];
  }

  static String getTitle(Map<String, dynamic> card) {
    return card[ClassConfig.cardTitleByKey];
  }
}
