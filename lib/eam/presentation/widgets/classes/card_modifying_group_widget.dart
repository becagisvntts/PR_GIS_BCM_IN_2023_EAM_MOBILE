import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/app_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_service.dart';

class CardModifyingGroupWidget extends StatefulWidget {
  final Map<String, dynamic> groupConfig;
  final List<Map<String, dynamic>> attributesByGroup;
  final Map<String, dynamic>? card;
  const CardModifyingGroupWidget(
      {super.key,
      this.card,
      required this.groupConfig,
      required this.attributesByGroup});

  @override
  State<StatefulWidget> createState() => CardModifyingGroupWidgetState();
}

class CardModifyingGroupWidgetState extends State<CardModifyingGroupWidget> {
  late bool isClosed;

  @override
  void initState() {
    isClosed = widget.groupConfig["defaultDisplayMode"] == "closed";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.attributesByGroup.isNotEmpty
        ? ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: HeadingText("${widget.groupConfig["description"]}",
                icon: Icons.label_important_outline_rounded,
                color: isClosed
                    ? ThemeConfig.colorBlackTitle
                    : ThemeConfig.appColorSecondary,
                top: 0),
            trailing: Icon(
              isClosed
                  ? Icons.keyboard_arrow_down_rounded
                  : Icons.keyboard_arrow_up_rounded,
            ),
            initiallyExpanded: !isClosed,
            onExpansionChanged: (bool expanded) {
              setState(() {
                isClosed = !expanded;
              });
            },
            childrenPadding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
            shape: const Border(
                bottom: BorderSide(
                    width: 1, color: ThemeConfig.appColorSecondaryLighting)),
            children: [
                SizedBox(
                    width: AppConfig.screenWidth,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (Map<String, dynamic> attributeConfig
                              in widget.attributesByGroup)
                            ClassService.getAttributeFormField(attributeConfig,
                                card: widget.card)
                        ]))
              ])
        : Container();
  }
}
