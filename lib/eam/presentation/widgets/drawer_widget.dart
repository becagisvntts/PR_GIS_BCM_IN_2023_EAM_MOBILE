import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/models/app_info.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/auth_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/tree_node.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/btn_tree_node.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<StatefulWidget> createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget> {
  AppInfo appInfo = StateHelper.coreState.appInfo;
  Map<String, dynamic> menu = StateHelper.eamState.menuState.menu;
  List<String> validatedType = StateHelper.eamState.menuState.validatedType;
  late TreeController<TreeNode> treeController;

  @override
  void initState() {
    super.initState();
    List<TreeNode> menuNodes =
        (menu["children"] as List).map((e) => TreeNode.fromJson(e)).toList();
    menuNodes = menuNodes
        .where((element) => validatedType.contains(element.menuType))
        .toList();
    treeController = TreeController<TreeNode>(
        roots: menuNodes, childrenProvider: (TreeNode node) => node.children);
  }

  @override
  void dispose() {
    treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: 350,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: Column(children: [
                Container(
                    height: 150,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      ThemeConfig.appColor.withAlpha(230),
                      ThemeConfig.appColor.withAlpha(150)
                    ], begin: Alignment.bottomRight, end: Alignment.topLeft)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/icon.png',
                            width: 75,
                          ),
                          PaddingWrapper(
                              child: Text(StateHelper.coreState.user.username,
                                  style: const TextStyle(
                                      color: ThemeConfig.colorWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              left: 16)
                        ])),
                Expanded(
                    child: AnimatedTreeView<TreeNode>(
                  shrinkWrap: true,
                  treeController: treeController,
                  nodeBuilder:
                      (BuildContext context, TreeEntry<TreeNode> entry) {
                    return TreeIndentation(
                        entry: entry,
                        child: ButtonTreeNode(
                            node: entry.node, treeController: treeController));
                  },
                ))
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Divider(),
                ButtonDrawer(LocalizationService.translate.user_logout,
                    () => AuthService.logout(),
                    color: ThemeConfig.colorDanger,
                    iconData: Icons.logout,
                    showIconRedirect: false),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text('© 2023 — VNTTS. All Rights Reserved.'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                      "Version: ${appInfo.version} (${appInfo.buildNumber})",
                      style: const TextStyle(
                          color: ThemeConfig.colorBlackSecondary)),
                )
              ])
            ]));
  }
}
