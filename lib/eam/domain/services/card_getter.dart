import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/data_type_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class CardGetter {
  static const String classTypeByKey = "_type";
  static const String idByKey = "_id";
  static const String descriptionByKey = "Description";
  static const String codeByKey = "Code";

  static int getID(Map<String, dynamic> card) {
    if (card.containsKey("_id")) return card["_id"];
    if (card.containsKey("Id")) return card["Id"] as int;
    return 0;
  }

  static String getClassType(Map<String, dynamic> card) {
    if (card.containsKey("_type")) return card["_type"];
    if (card.containsKey("IdClass")) {
      String idClass = card["IdClass"];
      if (idClass.startsWith("public.")) {
        List<String> arr = idClass.split(".");
        return arr.last.replaceAll("\"", "");
      }
      return idClass;
    }
    return "";
  }

  static String getDescription(Map<String, dynamic> card) {
    return card[descriptionByKey];
  }

  static String getCode(Map<String, dynamic> card) {
    return card[codeByKey];
  }

  ///Use only at detail card screen
  static List<Map<String, dynamic>> getAttributes(Map<String, dynamic> card) {
    return DataTypeService.listToListMapStringDynamic(
        card["_model"]["attributes"]);
  }

  static String getClassTypeName(Map<String, dynamic> card) {
    String cardClassType = getClassType(card);
    DataList classes = StateHelper.eamState.classState.list;
    for (Map<String, dynamic> cls in classes.data) {
      if (ClassGetter.getID(cls) == cardClassType) {
        return ClassGetter.getDescription(cls);
      }
    }
    return cardClassType;
  }
}
