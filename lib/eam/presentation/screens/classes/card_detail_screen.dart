import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/data_type_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/notify_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/card_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/screens/classes/card_update_screen.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/card_group_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/domain_group_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/shimmers/card_group_shimmer.dart';

class CardDetailScreen extends StatefulWidget {
  final Map<String, dynamic> card;
  const CardDetailScreen({super.key, required this.card});

  @override
  State<StatefulWidget> createState() => CardDetailScreenState();
}

class CardDetailScreenState extends State<CardDetailScreen> {
  late List<Map<String, dynamic>> attributeGroupsConfig;
  late Map<String, dynamic> attributesByGroups;
  bool loadingConfig = true;
  late Map<String, dynamic> classConfig;
  late DataList classDomains;
  late List<DataList> domainsAttributes;
  late Map<String, dynamic> _card;
  late bool isCardModified = false;

  @override
  void initState() {
    _card = widget.card;
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    loadingConfig = true;

    await Future.wait(
        [fetchCardDetail(), fetchClassDomainsAndAttributesOfThem()]);

    loadingConfig = false;
    setState(() {});
  }

  Future<void> fetchCardDetail() async {
    ///Get groups config
    classConfig = ClassService.getClassConfigOfCard(_card);

    attributeGroupsConfig = ClassGetter.getAttributeGroups(classConfig);

    ///Get full card detail and attributes
    Map<String, dynamic> cardDetail = await ClassService.fetchClassCardDetail(
        CardGetter.getClassType(_card), "${CardGetter.getID(_card)}");

    List<Map<String, dynamic>> classAttributes =
        CardGetter.getAttributes(cardDetail);

    ///Update _card
    cardDetail.remove("_model");
    _card = cardDetail;

    attributesByGroups = {};
    for (Map<String, dynamic> attribute in classAttributes) {
      ///If conditions is pass -> display
      if (attribute["active"] &&
          !attribute["hidden"] &&
          attribute["group"] != null) {
        if (!attributesByGroups.containsKey(attribute["group"])) {
          attributesByGroups[attribute["group"]] = [];
        }

        attributesByGroups[attribute["group"]].add(attribute);
      }
    }
  }

  Future<void> fetchClassDomainsAndAttributesOfThem() async {
    classDomains =
        await ClassService.fetchClassDomains(CardGetter.getClassType(_card));

    ///Get attributes of domains
    domainsAttributes =
        await ClassService.fetchClassAttributesOfDomains(classDomains);
  }

  List<Map<String, dynamic>> getAttributesByGroups(String groupName) {
    if (attributesByGroups.containsKey(groupName)) {
      return DataTypeService.listToListMapStringDynamic(
          attributesByGroups[groupName]);
    }
    return [];
  }

  void navigateToCardUpdateScreen() async {
    var result = await NavigationHelper.push(CardUpdateScreen(card: _card));
    if (result == ClassConfig.popRouteOnModifySuccess) {
      loadingConfig = true;
      isCardModified = true;
      setState(() {});

      await fetchCardDetail();

      loadingConfig = false;
      setState(() {});
    }
  }

  void showConfirmDeleteDialog() {
    showCustomBottomActionSheet(
        title:
            "${LocalizationService.translate.cm_delete} ${CardGetter.getDescription(_card)}",
        message: LocalizationService.translate.card_delete_msg_confirm,
        actions: [
          CupertinoActionSheetAction(
              onPressed: () {
                deleteCard();
                NavigationHelper.pop();
              },
              child: Text(LocalizationService.translate.cm_delete,
                  style: const TextStyle(color: ThemeConfig.colorDanger)))
        ]);
  }

  void deleteCard() async {
    bool result = await ClassService.deleteCard(
        CardGetter.getClassType(_card), "${CardGetter.getID(_card)}");
    if (result) {
      NotifyService.showSuccessMessage(LocalizationService.translate
          .msg_action_success(LocalizationService.translate.cm_delete));
      NavigationHelper.pop(message: ClassConfig.popRouteOnModifySuccess);
    } else {
      NotifyService.showErrorMessage(LocalizationService.translate
          .msg_action_fail(LocalizationService.translate.cm_delete));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            leading: IconButton(
                onPressed: () => NavigationHelper.pop(
                    message: isCardModified
                        ? ClassConfig.popRouteOnModifySuccess
                        : null),
                icon: const Icon(Icons.arrow_back_rounded)),
            title: Text(CardGetter.getDescription(_card)),
            actions: [
              IconButton(
                  onPressed: navigateToCardUpdateScreen,
                  icon: const Icon(Icons.edit_rounded)),
              IconButton(
                  onPressed: showConfirmDeleteDialog,
                  icon: const Icon(Icons.delete_rounded))
            ]),
        body: PageContent(
            child: loadingConfig
                ? const CardGroupShimmer()
                : ListView(shrinkWrap: true, children: [
                    for (Map<String, dynamic> groupConfig
                        in attributeGroupsConfig)
                      CardGroupWidget(
                          card: _card,
                          groupConfig: groupConfig,
                          attributesByGroup:
                              getAttributesByGroups(groupConfig["name"])),
                    for (int i = 0; i < classDomains.data.length; i++)
                      DomainGroupWidget(
                          domainAttributes: domainsAttributes[i],
                          domainConfig: classDomains.data[i],
                          sourceCard: _card)
                  ])));
  }
}
