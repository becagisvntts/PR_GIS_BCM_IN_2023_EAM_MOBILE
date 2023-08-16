import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attribute_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/card_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/domain_getter.dart';

class PickingDomainCardWidget extends StatefulWidget {
  final Map<String, dynamic> domainConfig;
  final DataList classAttributes;
  final Map<String, dynamic> card;

  ///Destination card
  final List<Map<String, dynamic>> relationCards;

  ///Relation cards with source card
  final int index;
  final Function onToggleSelect;
  const PickingDomainCardWidget(
      {super.key,
      required this.card,
      required this.index,
      required this.classAttributes,
      required this.onToggleSelect,
      required this.domainConfig,
      required this.relationCards});

  @override
  State<StatefulWidget> createState() => PickingDomainCardWidgetState();
}

class PickingDomainCardWidgetState extends State<PickingDomainCardWidget> {
  late bool selected = false;
  late bool isShowFull = false;
  late bool isDisableSelected;
  late int attributeDisplayedOnShortModeCounter = 3;
  late bool isDomainHaveMultipleDestinationType = false;

  late List<Map<String, dynamic>> attributesShowInGrid;

  @override
  void initState() {
    attributesShowInGrid = getClassAttributesShowInGrid();
    checkConditionToDisableSelected();
    checkDomainHaveMultipleDestinationType();
    super.initState();
  }

  void checkConditionToDisableSelected() {
    ///If is inverse: 1 sourceCard can belong to N relationCards
    ///Loop all attributes of card
    ///-> find attribute is reference and domain equal with current domain
    ///-> find attribute name
    ///-> check card data with this attribute: not null -> disabled
    for (Map<String, dynamic> attribute in widget.classAttributes.data) {
      if (AttributeGetter.getType(attribute) ==
              AttributeService.typeReference &&
          AttributeGetter.getDomain(attribute) ==
              DomainGetter.getName(widget.domainConfig)) {
        String attributeName = AttributeGetter.getName(attribute);
        if (widget.card.containsKey(attributeName)) {
          isDisableSelected = widget.card[attributeName] != null;
        } else {
          isDisableSelected = false;
        }
      }
    }

    ///If is direct: 1 sourceCard can contains N relationCards
    ///If relationCard is exist -> disableSelected
    for (Map<String, dynamic> relationCard in widget.relationCards) {
      if (CardGetter.getID(relationCard) == CardGetter.getID(widget.card)) {
        isDisableSelected = true;
        return;
      }
    }
  }

  void checkDomainHaveMultipleDestinationType() {
    isDomainHaveMultipleDestinationType =
        DomainGetter.haveMultipleDestinationTypes(widget.domainConfig);
  }

  List<Map<String, dynamic>> getClassAttributesShowInGrid() {
    List<Map<String, dynamic>> attributesShowInGrid = [];

    for (Map<String, dynamic> attribute in widget.classAttributes.data) {
      if (AttributeGetter.getShowInGrid(attribute)) {
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

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        child: PaddingWrapper(
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              PaddingWrapper(
                  child: SizedBox(
                      width: 18,
                      height: 18,
                      child: Checkbox(
                          value: selected,
                          onChanged: isDisableSelected
                              ? null
                              : (value) {
                                  selected = value!;
                                  widget.onToggleSelect(value);
                                  setState(() {});
                                })),
                  right: 16),
              Expanded(
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
                      if (AttributeGetter.getShowInGrid(
                          attributesShowInGrid[i]))
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
                                              color:
                                                  ThemeConfig.appColorLighting),
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
                  ]))
            ]),
            all: 16));
  }
}
