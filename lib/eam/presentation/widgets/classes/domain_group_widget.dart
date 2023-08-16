import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/request_payload.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/domain_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/screens/classes/relation_cards_grid_screen.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/screens/classes/relation_picking_screen.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/card_in_grid_widget.dart';

class DomainGroupWidget extends StatefulWidget {
  final DataList domainAttributes;
  final Map<String, dynamic> domainConfig;
  final Map<String, dynamic> sourceCard;
  final bool isModifyingMode;
  const DomainGroupWidget(
      {super.key,
      required this.domainConfig,
      required this.sourceCard,
      required this.domainAttributes,
      this.isModifyingMode = false});

  @override
  State<StatefulWidget> createState() => DomainGroupWidgetState();
}

class DomainGroupWidgetState extends State<DomainGroupWidget> {
  late bool isClosed;
  late bool loadingCards = true;
  late DataList relationCards = DataList();
  late bool isDomainHaveMultipleDestinationType = false;

  @override
  void initState() {
    isClosed = DomainGetter.getCollapseState(widget.domainConfig);
    fetchRelationCardsByPage();
    checkDomainHaveMultipleDestinationType();
    super.initState();
  }

  Future<void> fetchRelationCardsByPage() async {
    RequestPayload requestPayload = RequestPayload(page: 1, limit: 5);
    relationCards = await ClassService.fetchRelationCards(
        widget.domainConfig, widget.sourceCard,
        requestPayload: requestPayload);
    loadingCards = false;

    setState(() {});
  }

  void checkDomainHaveMultipleDestinationType() {
    isDomainHaveMultipleDestinationType =
        DomainGetter.haveMultipleDestinationTypes(widget.domainConfig);
  }

  void navigateToRelationPickingScreen() async {
    var result = await NavigationHelper.push(RelationPickingScreen(
        domainAttributes: widget.domainAttributes,
        domainConfig: widget.domainConfig,
        sourceCard: widget.sourceCard,
        relationCards: relationCards.data));
    if (result == ClassConfig.popRouteOnModifySuccess) {
      fetchRelationCardsByPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: HeadingText(
            "${DomainGetter.getRelatedDescription(widget.domainConfig)}(${relationCards.meta.total})",
            icon: Icons.insert_link_rounded,
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
        childrenPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        shape: const Border(
            bottom: BorderSide(
                width: 1, color: ThemeConfig.appColorSecondaryLighting)),
        children: [
          if (widget.isModifyingMode)
            OutlineButton(LocalizationService.translate.card_add_relate,
                width: 200,
                height: 36,
                iconData: Icons.add_rounded,
                onPressed: navigateToRelationPickingScreen),
          for (int i = 0; i < relationCards.data.length; i++)
            CardInGridWidget(
                classAttributes: widget.domainAttributes,
                card: relationCards.data[i],
                index: i,
                isRelationCard: true,
                isShowRelationSubType: isDomainHaveMultipleDestinationType),

          ///Relations is empty
          if (relationCards.data.isEmpty)
            PaddingWrapper(
                child: Text(LocalizationService.translate.card_relation_empty),
                top: 12,
                bottom: 12),

          ///Has many relations (>5) -> show button negative to full list screen
          if (relationCards.data.length < relationCards.meta.total)
            PaddingWrapper(
                child: BaseButton(LocalizationService.translate.cm_view_all,
                    onPressed: () => NavigationHelper.push(
                        RelationCardsGridScreen(
                            domainConfig: widget.domainConfig,
                            sourceCard: widget.sourceCard,
                            domainAttributes: widget.domainAttributes)),
                    width: 150,
                    height: 36,
                    iconData: Icons.keyboard_arrow_right_rounded,
                    color: ThemeConfig.appColorSecondary),
                top: 12,
                bottom: 12)
        ]);
  }
}
