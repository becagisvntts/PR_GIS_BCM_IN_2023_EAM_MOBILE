import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/data_type_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/card_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/card_group_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/shimmers/card_group_shimmer.dart';

class RelationCardDetailWidget extends StatefulWidget {
  final Map<String, dynamic> relationCard;
  const RelationCardDetailWidget({super.key, required this.relationCard});

  @override
  State<StatefulWidget> createState() => RelationCardDetailWidgetState();
}

class RelationCardDetailWidgetState extends State<RelationCardDetailWidget> {
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
        ClassService.getClassConfigOfCard(widget.relationCard);
    attributeGroupsConfig = ClassGetter.getAttributeGroups(classConfig);

    ///Get full card detail and attributes
    Map<String, dynamic> cardDetail = await ClassService.fetchClassCardDetail(
        CardGetter.getClassTypeName(widget.relationCard),
        "${CardGetter.getID(widget.relationCard)}");
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
                      card: widget.relationCard,
                      groupConfig: groupConfig,
                      attributesByGroup:
                          getAttributesByGroups(groupConfig["name"]))
              ]));
  }
}
