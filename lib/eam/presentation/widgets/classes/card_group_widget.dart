import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/card/card_content.dart';

class CardGroupWidget extends StatefulWidget {
  final Map<String, dynamic> groupConfig;
  final List<Map<String, dynamic>> attributesByGroup;
  final Map<String, dynamic> card;
  const CardGroupWidget(
      {super.key,
      required this.card,
      required this.groupConfig,
      required this.attributesByGroup});

  @override
  State<StatefulWidget> createState() => CardGroupWidgetState();
}

class CardGroupWidgetState extends State<CardGroupWidget> {
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
            childrenPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            shape: const Border(
                bottom: BorderSide(
                    width: 1, color: ThemeConfig.appColorSecondaryLighting)),
            children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                      elevation: 3,
                      child: PaddingWrapper(
                          child: CardContent(
                              displayedAttributes: widget.attributesByGroup,
                              card: widget.card,
                              isShowInList: false),
                          all: 16)),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 12))
              ])
        : Container();
  }
}
