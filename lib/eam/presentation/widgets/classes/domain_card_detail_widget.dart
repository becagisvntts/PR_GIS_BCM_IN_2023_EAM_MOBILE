import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/data_type_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/card_group_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/shimmers/card_group_shimmer.dart';

class DomainCardDetailWidget extends StatefulWidget {
  final Map<String, dynamic> card;
  const DomainCardDetailWidget({super.key, required this.card});

  @override
  State<StatefulWidget> createState() => DomainCardDetailWidgetState();
}

class DomainCardDetailWidgetState extends State<DomainCardDetailWidget> {
  late List<Map<String, dynamic>> attributeGroupsConfig;
  late Map<String, dynamic> attributesByGroups;

  late List<Map<String, dynamic>> attributeGroups;
  late bool loadingConfig = false;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    loadingConfig = true;

    await fetchCardDetail();

    loadingConfig = false;
    setState(() {});
  }

  Future<void> fetchCardDetail() async {
    ///Get groups config
    Map<String, dynamic> classConfig =
        ClassService.getClassConfigOfCard(widget.card);
    attributeGroupsConfig = DataTypeService.listToListMapStringDynamic(
        classConfig[ClassConfig.classAttributeGroupsByKey]);

    ///Get full card detail and attributes
    Map<String, dynamic> cardDetail =
        await ClassService.fetchClassCardDetail(widget.card);
    attributesByGroups = {};
    for (Map<String, dynamic> attribute
        in DataTypeService.listToListMapStringDynamic(
            cardDetail["_model"]["attributes"])) {
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

  List<Map<String, dynamic>> getAttributesByGroups(String groupName) {
    if (attributesByGroups.containsKey(groupName)) {
      return DataTypeService.listToListMapStringDynamic(
          attributesByGroups[groupName]);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 400,
        child: loadingConfig
            ? const CardGroupShimmer()
            : ListView(shrinkWrap: true, children: [
                for (Map<String, dynamic> groupConfig in attributeGroupsConfig)
                  CardGroupWidget(
                      card: widget.card,
                      groupConfig: groupConfig,
                      attributesByGroup:
                          getAttributesByGroups(groupConfig["name"])),
              ]));
  }
}
