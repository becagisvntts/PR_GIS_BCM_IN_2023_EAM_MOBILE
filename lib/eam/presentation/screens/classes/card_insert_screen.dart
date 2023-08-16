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
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/screens/classes/card_detail_screen.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/card_modifying_group_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/shimmers/card_group_shimmer.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class CardInsertScreen extends StatefulWidget {
  const CardInsertScreen({super.key});

  @override
  State<StatefulWidget> createState() => CardInsertScreenState();
}

class CardInsertScreenState extends State<CardInsertScreen> {
  late List<Map<String, dynamic>> attributeGroupsConfig;
  late Map<String, dynamic> attributesByGroups;
  late Map<String, dynamic> classConfig;
  bool loadingConfig = true;
  late DataList classDomains;
  late List<DataList> domainsAttributes;
  final formInsertCardKey = GlobalKey<FormBuilderState>();

  @override
  initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    loadingConfig = true;

    await getFormStructureAndRelations();

    loadingConfig = false;
    setState(() {});
  }

  Future<void> getFormStructureAndRelations() async {
    ///Get groups config
    classConfig = StateHelper.eamState.classState.activeClass;
    attributeGroupsConfig = ClassGetter.getAttributeGroups(classConfig);

    DataList classAttributes = StateHelper.eamState.classState.classAttributes;
    attributesByGroups = {};
    for (Map<String, dynamic> attribute in classAttributes.data) {
      ///If conditions is pass -> display
      if (attribute["active"] &&
          attribute["group"] != null &&
          !attribute["hidden"]) {
        if (!attributesByGroups.containsKey(attribute["group"])) {
          attributesByGroups[attribute["group"]] = [];
        }

        attributesByGroups[attribute["group"]].add(attribute);
      }
    }
  }

  List<Map<String, dynamic>> getAttributesByGroups(String groupName) {
    if (attributesByGroups.containsKey(groupName)) {
      return DataTypeService.listToListMapStringDynamic(
          attributesByGroups[groupName]);
    }
    return [];
  }

  void insertCard({bool isViewDetail = false}) async {
    if (formInsertCardKey.currentState!.validate()) {
      formInsertCardKey.currentState!.save();

      Map<String, dynamic> formData = {
        ...formInsertCardKey.currentState!.value
      };

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

      var response = await ClassService.createNewCard(
          ClassGetter.getType(classConfig), formData);

      if (response == false) {
        NotifyService.showErrorMessage(LocalizationService.translate
            .msg_action_fail(LocalizationService.translate.cm_create));
      } else {
        if (isViewDetail) {
          NavigationHelper.push(CardDetailScreen(card: response));
        } else {
          NavigationHelper.pop(message: ClassConfig.popRouteOnModifySuccess);
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
                "${LocalizationService.translate.cm_create} ${ClassGetter.getType(classConfig)}")),
        body: PageContent(
            child: loadingConfig
                ? const CardGroupShimmer()
                : Column(children: [
                    Expanded(
                        child: FormBuilder(
                            key: formInsertCardKey,
                            child: ListView(shrinkWrap: true, children: [
                              for (Map<String, dynamic> groupConfig
                                  in attributeGroupsConfig)
                                CardModifyingGroupWidget(
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
                                      onPressed: () =>
                                          insertCard(isViewDetail: true),
                                      iconData: Icons.save_rounded),
                                  right: 4)),
                          Expanded(
                              child: PaddingWrapper(
                                  child: BaseButton(
                                      LocalizationService
                                          .translate.cm_save_and_close,
                                      onPressed: () =>
                                          insertCard(isViewDetail: false),
                                      iconData: Icons.save_rounded),
                                  left: 4))
                        ]),
                        top: 16)
                  ])));
  }
}
