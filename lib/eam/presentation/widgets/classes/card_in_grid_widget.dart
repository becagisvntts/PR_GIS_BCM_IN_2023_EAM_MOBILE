import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/screens/classes/card_detail_screen.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/domain_card_detail_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class CardInGridWidget extends StatefulWidget {
  final DataList? classAttributes;
  final Map<String, dynamic> card;
  final int index;
  final bool isDomainCard;
  final Function? onCardModified;
  const CardInGridWidget(
      {super.key,
      required this.card,
      required this.index,
      this.classAttributes,
      this.isDomainCard = false,
      this.onCardModified});

  @override
  State<StatefulWidget> createState() => CardInGridWidgetState();
}

class CardInGridWidgetState extends State<CardInGridWidget> {
  late bool isShowFull = false;
  late int attributeDisplayedOnShortModeCounter = 3;

  late List<Map<String, dynamic>> attributesShowInGrid;

  @override
  void initState() {
    attributesShowInGrid = getClassAttributesShowInGrid();
    super.initState();
  }

  List<Map<String, dynamic>> getClassAttributesShowInGrid() {
    List<Map<String, dynamic>> attributesShowInGrid = [];
    DataList sourceAttributes = widget.classAttributes ??
        StateHelper.eamState.classState.classAttributes;

    for (Map<String, dynamic> attribute in sourceAttributes.data) {
      if (attribute[ClassConfig.attributeShowInGridByKey]) {
        attributesShowInGrid.add(attribute);
      }
    }

    return attributesShowInGrid;
  }

  Widget getAttributeText(Map<String, dynamic> attributeConfig) {
    ClassAttribute attribute =
        AttributeService.getCopyClassAttributeByAttributeConfig(
            attributeConfig);
    attribute.syncDataFromCard(widget.card);

    return Text.rich(TextSpan(//apply style to all
        children: [
      TextSpan(
          text: "${attribute.description}: ",
          style: const TextStyle(color: Colors.black54)),
      TextSpan(text: attribute.getValueAsString())
    ]));
  }

  void navigateToCardDetailScreen(Map<String, dynamic> card) async {
    if (widget.isDomainCard) {
      showCustomBottomSheet(
          title: card[ClassConfig.cardTitleByKey],
          child: DomainCardDetailWidget(card: card));
    } else {
      var result = await NavigationHelper.push(CardDetailScreen(card: card));
      if (result == ClassConfig.popRouteOnModifySuccess) {
        widget.onCardModified?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        child: InkWell(
            borderRadius: BorderRadius.circular(12),
            child: PaddingWrapper(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///Card attribute detail
                      for (int i = 0;
                          i <
                              (isShowFull
                                  ? attributesShowInGrid.length
                                  : min(attributesShowInGrid.length,
                                      attributeDisplayedOnShortModeCounter));
                          i++)
                        if (attributesShowInGrid[i]
                            [ClassConfig.attributeShowInGridByKey])
                          getAttributeText(attributesShowInGrid[i]),

                      ///Display control && order number
                      PaddingWrapper(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                attributesShowInGrid.length >
                                        attributeDisplayedOnShortModeCounter
                                    ? InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () => setState(() {
                                              isShowFull = !isShowFull;
                                            }),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: ThemeConfig
                                                    .appColorLighting),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 0),
                                            child: Icon(
                                                isShowFull
                                                    ? Icons
                                                        .keyboard_arrow_up_rounded
                                                    : Icons
                                                        .keyboard_arrow_down_rounded,
                                                color: ThemeConfig.appColor)))
                                    : Container(),
                                Text("#${(widget.index + 1)}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: ThemeConfig.colorBlackSecondary))
                              ]),
                          top: 8)
                    ]),
                all: 16),
            onTap: () => navigateToCardDetailScreen(widget.card)));
  }
}
