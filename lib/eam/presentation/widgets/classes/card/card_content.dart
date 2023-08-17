import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';

class CardContent extends StatefulWidget {
  final List<Map<String, dynamic>> displayedAttributes;
  final Map<String, dynamic> card;
  final bool isShowInList;
  final bool isExpanded;
  final int displayedAttributeOnShortModeCounter;
  final int indexInList;
  const CardContent(
      {super.key,
      required this.displayedAttributes,
      required this.card,
      this.isShowInList = true,
      this.isExpanded = false,
      this.displayedAttributeOnShortModeCounter =
          ClassConfig.displayedAttributeOnShortModeCounter,
      this.indexInList = 0});

  @override
  State<StatefulWidget> createState() => CardContentState();
}

class CardContentState extends State<CardContent> {
  late bool isExpanded = false;

  @override
  void initState() {
    isExpanded = widget.isShowInList && widget.isExpanded;

    super.initState();
  }

  Widget getAttributeText(Map<String, dynamic> attributeConfig) {
    ClassAttribute attribute =
        AttributeService.getCopyClassAttributeByAttributeConfig(
            attributeConfig);
    attribute.syncDataFromCard(widget.card);

    return attribute.getValueAsWidget();

    return formattedAttributeText(
        attribute.description, attribute.getValueAsString());
  }

  Widget formattedAttributeText(String label, String value) {
    return Text.rich(TextSpan(//apply style to all
        children: [
      TextSpan(text: "$label: ", style: const TextStyle(color: Colors.black54)),
      TextSpan(text: value)
    ]));
  }

  int displayedAttributeCounter() {
    return (!widget.isShowInList || isExpanded)
        ? widget.displayedAttributes.length
        : min(widget.displayedAttributes.length,
            widget.displayedAttributeOnShortModeCounter);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (int i = 0; i < displayedAttributeCounter(); i++)
        getAttributeText(widget.displayedAttributes[i]),
      if (widget.isShowInList)
        PaddingWrapper(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.displayedAttributes.length >
                          widget.displayedAttributeOnShortModeCounter
                      ? InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => setState(() {
                                isExpanded = !isExpanded;
                              }),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: ThemeConfig.appColorLighting),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 0),
                              child: Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: ThemeConfig.appColor)))
                      : Container(),
                  Text("#${(widget.indexInList + 1)}",
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: ThemeConfig.colorBlackSecondary))
                ]),
            top: 8)
    ]);
  }
}
