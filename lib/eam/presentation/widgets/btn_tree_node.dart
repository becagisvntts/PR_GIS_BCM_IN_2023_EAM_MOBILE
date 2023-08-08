import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/tree_node.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/classes_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/classes_service.dart';

class ButtonTreeNode extends StatefulWidget {
  final TreeNode node;
  final TreeController treeController;
  const ButtonTreeNode(
      {super.key, required this.node, required this.treeController});

  @override
  State<StatefulWidget> createState() => ButtonTreeNodeState();
}

class ButtonTreeNodeState extends State<ButtonTreeNode> {
  late bool isFolder = false;

  @override
  void initState() {
    super.initState();
    isFolder = widget.node.menuType == ClassesConfig.menuTypeFolder;
  }

  void changeActiveClass(TreeNode node) {
    ClassesService.findAndChangeActiveClass(node.objectTypeName ?? "");
    NavigationHelper.pop();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => isFolder
            ? widget.treeController.toggleExpansion(widget.node)
            : changeActiveClass(widget.node),
        child: Padding(
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
                            color: ThemeConfig.appColor),
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
