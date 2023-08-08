import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/classes_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class ClassSortingWidget extends StatefulWidget {
  const ClassSortingWidget({super.key});

  @override
  State<StatefulWidget> createState() => ClassSortingWidgetState();
}

class ClassSortingWidgetState extends State<ClassSortingWidget> {
  late List<DropdownMenuItem> sortingAttributes = [];
  late Map<String, dynamic> sortingDirections = {
    "ASC": "Tăng dần",
    "DESC": "Giảm dần"
  };

  @override
  void initState() {
    super.initState();
    getSortingAttributes();
  }

  void getSortingAttributes() {
    // DataListMeta meta = StateHelper.eamState.classesState.classCards.meta;
    //
    // if(meta.sort == null) {
    //
    // }
    DataList classAttributes =
        StateHelper.eamState.classesState.classAttributes;
    for (int i = 0; i < classAttributes.data.length; i++) {
      Map<String, dynamic> attribute = classAttributes.data[i];
      if (attribute[ClassesConfig.attributeShowInGridByKey]) {
        sortingAttributes.add(DropdownMenuItem(
            value: attribute[ClassesConfig.attributeNameByKey],
            child: Text(attribute[ClassesConfig.attributeTitleByKey])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PaddingWrapper(
        child: Row(
          children: [
            Expanded(
                child: FormBuilderDropdown(
                    decoration: FormInputDecoration(),
                    items: sortingAttributes,
                    onChanged: (value) {},
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    menuMaxHeight: 300,
                    name: 'property')),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
            Expanded(
                child: FormBuilderDropdown(
                    decoration: FormInputDecoration(),
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
                    onChanged: (value) {},
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
