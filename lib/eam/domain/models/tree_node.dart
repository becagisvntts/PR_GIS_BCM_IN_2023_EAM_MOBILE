import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class TreeNode {
  late String id;
  late String menuType;
  late String objectDescription;
  late String objectDescriptionTranslation;
  late List<TreeNode> children;
  late int index;
  String? objectTypeName;

  TreeNode(
      {required this.id,
      required this.menuType,
      required this.objectDescription,
      required this.objectDescriptionTranslation,
      this.children = const [],
      this.objectTypeName});

  TreeNode.fromJson(Map<String, dynamic> json) {
    List<String> validatedType = StateHelper.eamState.menuState.validatedType;

    id = json["_id"];
    menuType = json["menuType"];
    objectDescription = json["objectDescription"];
    objectDescriptionTranslation = json["_objectDescription_translation"];
    children = (json["children"] as List)
        .map((e) => TreeNode.fromJson(e as Map<String, dynamic>))
        .toList();
    children = children
        .where((element) => validatedType.contains(element.menuType))
        .toList();
    if (json.containsKey("objectTypeName")) {
      objectTypeName = json["objectTypeName"];
    }
  }
}
