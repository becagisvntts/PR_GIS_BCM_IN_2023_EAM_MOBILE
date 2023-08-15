import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class ClassSortingWidget extends StatefulWidget {
  final Function onSort;
  const ClassSortingWidget({super.key, required this.onSort});

  @override
  State<StatefulWidget> createState() => ClassSortingWidgetState();
}

class ClassSortingWidgetState extends State<ClassSortingWidget> {
  late List<DropdownMenuItem> sortingAttributes = [];
  late Map<String, dynamic> sortingDirections = {
    "ASC": "Tăng dần",
    "DESC": "Giảm dần"
  };

  late String propertySelected =
      StateHelper.eamState.classState.requestPayload.propertySorting;
  late String directionSelected =
      StateHelper.eamState.classState.requestPayload.directionSorting;

  @override
  void initState() {
    super.initState();
    getSortingAttributes();
  }

  void getSortingAttributes() {
    DataList classAttributes = StateHelper.eamState.classState.classAttributes;
    for (int i = 0; i < classAttributes.data.length; i++) {
      Map<String, dynamic> attribute = classAttributes.data[i];
      if (attribute[ClassConfig.attributeShowInGridByKey] &&
          attribute[ClassConfig.attributeSortingEnableByKey]) {
        sortingAttributes.add(DropdownMenuItem(
            value: attribute[ClassConfig.attributeNameByKey],
            child: Text(attribute[ClassConfig.attributeTitleByKey])));
      }
    }
  }

  void sortCards(String propertySorting, String directionSorting) {
    widget.onSort(propertySorting, directionSorting);
  }

  @override
  Widget build(BuildContext context) {
    return PaddingWrapper(
        child: Row(
          children: [
            Expanded(
                child: FormBuilderDropdown(
                    decoration: FormInputDecoration(),
                    initialValue: propertySelected,
                    items: sortingAttributes,
                    onChanged: (value) {
                      propertySelected = value;
                    },
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    menuMaxHeight: 300,
                    name: 'property')),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
            Expanded(
                child: FormBuilderDropdown(
                    decoration: FormInputDecoration(),
                    initialValue: directionSelected,
                    items: const [
                      DropdownMenuItem(
                        value: "ASC",
                        child: Text("Tăng dần"),
                      ),
                      DropdownMenuItem(
                        value: "DESC",
                        child: Text("Giảm dần"),
                      )
                    ],
                    onChanged: (value) {
                      directionSelected = value!;
                      sortCards(propertySelected, directionSelected);
                    },
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    menuMaxHeight: 300,
                    name: 'direction'))
          ],
        ),
        top: 12,
        bottom: 12);
  }
}
