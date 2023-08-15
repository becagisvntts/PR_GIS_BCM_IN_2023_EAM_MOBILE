import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/request_payload.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/screens/classes/domain_grid_screen.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/card_in_grid_widget.dart';

class DomainGridWidget extends StatefulWidget {
  final DataList domainAttributes;
  final Map<String, dynamic> domainConfig;
  final Map<String, dynamic> card;
  const DomainGridWidget(
      {super.key,
      required this.domainConfig,
      required this.card,
      required this.domainAttributes});

  @override
  State<StatefulWidget> createState() => DomainGridWidgetState();
}

class DomainGridWidgetState extends State<DomainGridWidget> {
  late bool isClosed;
  late bool loadingCards = true;
  late DataList domainCards = DataList();

  @override
  void initState() {
    isClosed =
        ClassService.getDomainDefaultClosedOnClassDetail(widget.domainConfig);
    fetchDomainCardsByPage();
    super.initState();
  }

  Future<void> fetchDomainCardsByPage() async {
    RequestPayload requestPayload = RequestPayload(page: 1, limit: 5);
    domainCards = await ClassService.fetchDomainCards(
        widget.domainConfig, widget.card,
        requestPayload: requestPayload);
    loadingCards = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: HeadingText(
            "${ClassService.getDomainTitleOnClassDetail(widget.domainConfig)}(${domainCards.meta.total})",
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
          for (int i = 0; i < domainCards.data.length; i++)
            CardInGridWidget(
                classAttributes: widget.domainAttributes,
                card: domainCards.data[i],
                index: i,
                isDomainCard: true),
          if (domainCards.data.length < domainCards.meta.total)
            PaddingWrapper(
                child: BaseButton(
                    "Xem đầy đủ",
                    () => NavigationHelper.push(DomainGridScreen(
                        domainConfig: widget.domainConfig,
                        card: widget.card,
                        domainAttributes: widget.domainAttributes)),
                    width: 150,
                    height: 36,
                    iconData: Icons.keyboard_arrow_right_rounded,
                    color: ThemeConfig.appColorSecondary),
                // : ,
                // child: const Text("Xem đầy đủ")),
                top: 12,
                bottom: 12),
          Padding(
              padding: EdgeInsets.fromLTRB(
                  0,
                  0,
                  0,
                  (domainCards.data.length < domainCards.meta.total ||
                          domainCards.meta.total == 0)
                      ? 0
                      : 12))
        ]);
  }
}
