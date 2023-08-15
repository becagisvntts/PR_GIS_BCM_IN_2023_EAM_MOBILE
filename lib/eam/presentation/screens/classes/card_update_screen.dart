import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/data_type_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/notify_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/attributes/attributes_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/card_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/screens/classes/class_grid_screen.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/card_modifying_group_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/shimmers/card_group_shimmer.dart';

class CardUpdateScreen extends StatefulWidget {
  final Map<String, dynamic> card;
  const CardUpdateScreen({super.key, required this.card});

  @override
  State<StatefulWidget> createState() => CardUpdateScreenState();
}

class CardUpdateScreenState extends State<CardUpdateScreen> {
  late List<Map<String, dynamic>> attributeGroupsConfig;
  late Map<String, dynamic> attributesByGroups;
  late Map<String, dynamic> classConfig;
  bool loadingConfig = true;
  late DataList classDomains;
  late List<DataList> domainsAttributes;
  late Map<String, dynamic> _card;

  final formUpdateCardKey = GlobalKey<FormBuilderState>();

  @override
  initState() {
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
    Map<String, dynamic> cardDetail =
        await ClassService.fetchClassCardDetail(_card);

    List<Map<String, dynamic>> classAttributes =
        DataTypeService.listToListMapStringDynamic(
            cardDetail["_model"]["attributes"]);

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

  void updateCard({bool isViewDetail = false}) async {
    if (formUpdateCardKey.currentState!.validate()) {
      formUpdateCardKey.currentState!.save();

      Map<String, dynamic> formData = {
        ...formUpdateCardKey.currentState!.value
      };
      print(formData);
      return;

      formData["_type"] = ClassGetter.getType(classConfig);
      formData["_tenant"] = "";
      formData["CalendarEntity"] = null;
      formData["ServiceStatus"] = null;

      for (Map<String, dynamic> groupConfig in attributeGroupsConfig) {
        List<Map<String, dynamic>> attributesByGroups =
            getAttributesByGroups(groupConfig["name"]);
        for (Map<String, dynamic> attributeConfig in attributesByGroups) {
          ClassAttribute attribute =
              AttributeService.getCopyClassAttributeByAttributeConfig(
                  attributeConfig);
          attribute.syncDataFromCard(formData);
          await attribute.formatBeforeSubmit(formData);
        }
      }

      var response = await ClassService.updateCard(
          ClassGetter.getType(classConfig), CardGetter.getID(_card), formData);

      if (response == false) {
        NotifyService.showErrorMessage(LocalizationService.translate
            .msg_action_fail(LocalizationService.translate.cm_update));
      } else {
        if (isViewDetail) {
          NavigationHelper.pop(message: ClassConfig.popRouteOnModifySuccess);
        } else {
          NavigationHelper.push(const ClassGridScreen());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: Text(
                "${LocalizationService.translate.cm_update} ${CardGetter.getTitle(_card)}")),
        body: PageContent(
            child: loadingConfig
                ? const CardGroupShimmer()
                : Column(children: [
                    Expanded(
                        child: FormBuilder(
                            key: formUpdateCardKey,
                            child: ListView(shrinkWrap: true, children: [
                              for (Map<String, dynamic> groupConfig
                                  in attributeGroupsConfig)
                                CardModifyingGroupWidget(
                                    card: _card,
                                    groupConfig: groupConfig,
                                    attributesByGroup: getAttributesByGroups(
                                        groupConfig["name"]))
                            ]))),
                    PaddingWrapper(
                        child: Row(children: [
                          Expanded(
                              child: PaddingWrapper(
                                  child: BaseButton(
                                      LocalizationService.translate.cm_save,
                                      () => updateCard(isViewDetail: true),
                                      iconData: Icons.save_rounded),
                                  right: 4)),
                          Expanded(
                              child: PaddingWrapper(
                                  child: BaseButton(
                                      LocalizationService
                                          .translate.cm_save_and_close,
                                      () => updateCard(isViewDetail: false),
                                      iconData: Icons.save_rounded),
                                  left: 4))
                        ]),
                        top: 16)
                  ])));
  }
}
