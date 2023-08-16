import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/tree_node.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/actions/menu_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class ButtonTreeNode extends StatefulWidget {
  final TreeNode node;
  final TreeController treeController;
  const ButtonTreeNode(
      {super.key, required this.node, required this.treeController});

  @override
  State<StatefulWidget> createState() => ButtonTreeNodeState();
}

class ButtonTreeNodeState extends State<ButtonTreeNode> {
  late String? activeClassType;
  late bool isFolder = false;

  @override
  void initState() {
    isFolder = widget.node.menuType == ClassConfig.menuTypeFolder;
    Map<String, dynamic> activeClass =
        StateHelper.eamState.classState.activeClass;
    activeClassType =
        activeClass.isNotEmpty ? ClassGetter.getType(activeClass) : "";
    super.initState();
  }

  void changeActiveClass(TreeNode node) {
    ClassService.findAndChangeActiveClass(node.objectTypeName ?? "");
    NavigationHelper.pop();
  }

  bool isOrContainActiveClass(TreeNode node) {
    if (node.objectTypeName == activeClassType) {
      return true;
    }
    for (TreeNode node in node.children) {
      if (isOrContainActiveClass(node)) return true;
    }
    return false;
  }

  void toggleExpandNode() {
    widget.treeController.toggleExpansion(widget.node);
    StateHelper.store.dispatch(UpdateExpandedNodeIds(
        nodeId: widget.node.id,
        expanded: widget.treeController.getExpansionState(widget.node)));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () =>
            isFolder ? toggleExpandNode() : changeActiveClass(widget.node),
        child: Container(
            decoration: BoxDecoration(
                color: isOrContainActiveClass(widget.node)
                    ? ThemeConfig.colorOrangeLighting
                    : ThemeConfig.colorWhite),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Row(children: [
                    PaddingWrapper(
                        child: Icon(
                            isFolder
                                ? Icons.folder_copy_rounded
                                : Icons.class_rounded,
                            size: 16,
                            color: isFolder
                                ? ThemeConfig.appColor
                                : ThemeConfig.colorOrange),
                        right: 12),
                    Expanded(
                        child: Text(widget.node.objectDescription,
                            style: const TextStyle(
                                fontSize: 16,
                                color: ThemeConfig.colorBlackTitle)))
                  ])),
                  if (isFolder)
                    Text("${widget.node.children.length}",
                        style: const TextStyle(color: ThemeConfig.appColor))
                ])));
  }
}
