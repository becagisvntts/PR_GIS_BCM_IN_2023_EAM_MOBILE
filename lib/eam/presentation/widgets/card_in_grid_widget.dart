import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/classes_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class CardInGridWidget extends StatefulWidget {
  final Map<String, dynamic> cardData;
  const CardInGridWidget({super.key, required this.cardData});

  @override
  State<StatefulWidget> createState() => CardInGridWidgetState();
}

class CardInGridWidgetState extends State<CardInGridWidget> {
  late bool isShowFull = false;

  final DataList classAttributes =
      StateHelper.eamState.classesState.classAttributes;

  final Map<String, dynamic> activeClass =
      StateHelper.eamState.classesState.activeClass;

  Widget getAttributeText(Map<String, dynamic> attribute) {
    String attributeName = attribute[ClassesConfig.attributeNameByKey];
    dynamic attributeValue = "";
    if (widget.cardData.containsKey(attributeName)) {
      attributeValue = widget.cardData[attributeName] ?? "";
    }
    return Text.rich(TextSpan(//apply style to all
        children: [
      TextSpan(
          text: "${attribute[ClassesConfig.attributeTitleByKey]}: ",
          style: const TextStyle(color: Colors.black54)),
      TextSpan(text: "$attributeValue")
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        child: PaddingWrapper(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0;
                    i < (isShowFull ? classAttributes.data.length : 4);
                    i++)
                  if (classAttributes.data[i]
                      [ClassesConfig.attributeShowInGridByKey])
                    getAttributeText(classAttributes.data[i]),
                PaddingWrapper(
                    child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setState(() {
                              isShowFull = !isShowFull;
                            }),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: ThemeConfig.appColorLighting),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            child: Icon(
                                isShowFull
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: ThemeConfig.appColor))),
                    top: 8)
              ],
            ),
            all: 16));
  }
}
