import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attribute_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/card_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/screens/classes/card_detail_screen.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/card/card_content.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/relation_card_detail_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class CardInGridWidget extends StatefulWidget {
  final DataList? classAttributes;
  final Map<String, dynamic> card;
  final int index;
  final bool isRelationCard;
  final bool isShowRelationSubType;
  final Function? onCardModified;
  const CardInGridWidget(
      {super.key,
      required this.card,
      required this.index,
      this.classAttributes,
      this.isRelationCard = false,
      this.isShowRelationSubType = false,
      this.onCardModified});

  @override
  State<StatefulWidget> createState() => CardInGridWidgetState();
}

class CardInGridWidgetState extends State<CardInGridWidget> {
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
      if (AttributeGetter.getShowInGrid(attribute)) {
        attributesShowInGrid.add(attribute);
      }
    }

    return attributesShowInGrid;
  }

  Widget formattedAttributeText(String label, String value) {
    return Text.rich(TextSpan(//apply style to all
        children: [
      TextSpan(text: "$label: ", style: const TextStyle(color: Colors.black54)),
      TextSpan(text: value)
    ]));
  }

  void navigateToCardDetailScreen() async {
    if (widget.isRelationCard) {
      showCustomBottomSheet(
          title: CardGetter.getDescription(widget.card),
          child: RelationCardDetailWidget(relationCard: widget.card));
    } else {
      var result =
          await NavigationHelper.push(CardDetailScreen(card: widget.card));
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
            onTap: navigateToCardDetailScreen,
            child: PaddingWrapper(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///Subtype of relation
                      if (widget.isShowRelationSubType)
                        formattedAttributeText(
                            LocalizationService
                                .translate.card_relation_sub_type,
                            CardGetter.getClassTypeName(widget.card)),

                      CardContent(
                          displayedAttributes: attributesShowInGrid,
                          card: widget.card,
                          displayedAttributeOnShortModeCounter:
                              ClassConfig.displayedAttributeOnShortModeCounter -
                                  (widget.isShowRelationSubType ? 1 : 0),
                          indexInList: widget.index),
                    ]),
                all: 16)));
  }
}
