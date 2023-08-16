import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/notify_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/request_payload.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/card_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/domain_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/class_searching_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/class_sorting_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/picking_domain_card_widget.dart';

class RelationPickingScreen extends StatefulWidget {
  final DataList domainAttributes;
  final Map<String, dynamic> domainConfig;
  final Map<String, dynamic> sourceCard;
  final List<Map<String, dynamic>> relationCards;

  const RelationPickingScreen(
      {super.key,
      required this.domainAttributes,
      required this.domainConfig,
      required this.sourceCard,
      required this.relationCards});

  @override
  State<StatefulWidget> createState() => RelationPickingScreenState();
}

class RelationPickingScreenState extends State<RelationPickingScreen> {
  late RequestPayload requestPayload;
  late bool isShowSearchingWidget = false;
  late bool isShowSortingWidget = false;
  late int totalCards = 0;
  late List<Map<String, dynamic>> selectedCards;
  final PagingController<int, Map<String, dynamic>> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    requestPayload = RequestPayload(
        forDomainName: DomainGetter.getName(widget.domainConfig),
        forDomainDirection:
            DomainGetter.getDirectionAsString(widget.domainConfig),
        forDomainOriginId: CardGetter.getID(widget.sourceCard),
        limit: 50);

    selectedCards = [];

    pagingController
        .addPageRequestListener((pageKey) => fetchDomainCards(pageKey));
    super.initState();
  }

  Future<void> fetchDomainCards(int pageKey) async {
    requestPayload = requestPayload.copyWith(page: pageKey);

    DataList list = await ClassService.fetchDomainCards(
        widget.domainConfig, widget.sourceCard, requestPayload);
    setState(() {
      totalCards = list.meta.total;
    });

    try {
      final isLastPage = list.data.length < requestPayload.limit;
      if (isLastPage) {
        pagingController.appendLastPage(list.data);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(list.data, nextPageKey);
      }
    } catch (e) {
      pagingController.error = e;
      print(e);
    }
  }

  void fetchClassCardsBySearching(String keyword) {
    requestPayload = requestPayload.copyWith(queryKeyword: keyword);
    pagingController.refresh();
  }

  void fetchClassCardsBySorting(
      String propertySorting, String directionSorting) {
    requestPayload = requestPayload.copyWith(
        propertySorting: propertySorting, directionSorting: directionSorting);
    pagingController.refresh();
  }

  void showSearchingWidget() {
    setState(() {
      isShowSearchingWidget = !isShowSearchingWidget;
      if (isShowSearchingWidget) isShowSortingWidget = false;
    });
  }

  void showSortingWidget() {
    setState(() {
      isShowSortingWidget = !isShowSortingWidget;
      if (isShowSortingWidget) isShowSearchingWidget = false;
    });
  }

  void onToggleSelectCard(Map<String, dynamic> card, bool value) {
    if (selectedCards.contains(card) && !value) {
      selectedCards.remove(card);
    } else if (!selectedCards.contains(card) && value) {
      selectedCards.add(card);
    }
    setState(() {});
  }

  void linkSourceCardWithSelectedCards() async {
    if (selectedCards.isNotEmpty) {
      List<Future<bool>> listEvent = [];
      for (Map<String, dynamic> destinationCard in selectedCards) {
        listEvent.add(ClassService.linkCardWithRelate(
            widget.domainConfig, widget.sourceCard, destinationCard));
      }

      await Future.wait(listEvent);

      NotifyService.showSuccessMessage("Thêm mối quan hệ thành công");
      NavigationHelper.pop(message: ClassConfig.popRouteOnModifySuccess);
    } else {
      NotifyService.showErrorMessage("Vui lòng chọn các mối quan hệ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: Text(
                "${CardGetter.getDescription(widget.sourceCard)}: ${DomainGetter.getRelatedDescription(widget.domainConfig)}")),
        body: PageContent(
            child: Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HeadingText(
                    LocalizationService.translate.eam_list_count(totalCards),
                    icon: Icons.numbers,
                    top: 0),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                      onPressed: showSortingWidget,
                      icon: IconBuffer(
                          iconColor: isShowSortingWidget
                              ? ThemeConfig.appColorSecondary
                              : ThemeConfig.appColor,
                          Icons.sort_rounded),
                      iconSize: 16),
                  IconButton(
                      onPressed: showSearchingWidget,
                      icon: IconBuffer(
                          iconColor: isShowSearchingWidget
                              ? ThemeConfig.appColorSecondary
                              : ThemeConfig.appColor,
                          Icons.search_rounded),
                      iconSize: 16)
                ])
              ]),
          if (isShowSearchingWidget)
            ClassSearchingWidget(
                onSearch: (keyword) => fetchClassCardsBySearching(keyword)),
          if (isShowSortingWidget)
            ClassSortingWidget(
              onSort: (propertySorting, directionSorting) =>
                  fetchClassCardsBySorting(propertySorting, directionSorting),
            ),
          Expanded(
              child: PagedListView<int, Map<String, dynamic>>(
                  pagingController: pagingController,
                  builderDelegate:
                      PagedChildBuilderDelegate<Map<String, dynamic>>(
                          itemBuilder: (context, item, index) {
                    return PickingDomainCardWidget(
                        domainConfig: widget.domainConfig,
                        classAttributes: widget.domainAttributes,
                        card: item,
                        index: index,
                        onToggleSelect: (value) =>
                            onToggleSelectCard(item, value),
                        relationCards: widget.relationCards);
                  }))),
          PaddingWrapper(
              child: Row(mainAxisSize: MainAxisSize.max, children: [
                Expanded(child: Text("${selectedCards.length} đã chọn")),
                BaseButton(LocalizationService.translate.cm_save,
                    onPressed: linkSourceCardWithSelectedCards,
                    width: 125,
                    iconData: Icons.save_rounded)
              ]),
              top: 12)
        ])));
  }
}
