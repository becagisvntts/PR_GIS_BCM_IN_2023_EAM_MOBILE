import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/menu_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/screens/classes/class_grid_screen.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/actions/class_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/actions/menu_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class PreloadEamScreen extends StatefulWidget {
  const PreloadEamScreen({super.key});

  @override
  State<StatefulWidget> createState() => PreloadEamScreenState();
}

class PreloadEamScreenState extends State<PreloadEamScreen> {
  @override
  initState() {
    super.initState();
    fetchMenu();
  }

  void fetchMenu() async {
    var values = await Future.wait(
        [MenuService.fetchMenu(), ClassService.fetchClasses()]);
    StateHelper.store.dispatch(
        FetchMenuSuccessAction(menu: values[0] as Map<String, dynamic>));
    StateHelper.store
        .dispatch(FetchClassesSuccessAction(list: values[1] as DataList));
    NavigationHelper.pushReplacement(const ClassGridScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
          const SizedBox(
              width: 40, height: 40, child: CircularProgressIndicator()),
          PaddingWrapper(
              child: Text(LocalizationService.translate.eam_loading_classes),
              top: 16)
        ])));
  }
}
