import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/class_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/menu_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/app_state.dart';
import 'package:redux/redux.dart';

class MenuProps {
  final DataList classes;
  final Map<String, dynamic> menu;
  final bool loadingMenu;
  final bool loadingClasses;

  MenuProps(
      {required this.classes,
      required this.menu,
      required this.loadingMenu,
      required this.loadingClasses});

  static MenuProps mapStateToProps(Store<AppState> store) {
    ClassState classesState = store.state.eamState.classState;
    MenuState menuState = store.state.eamState.menuState;
    return MenuProps(
        classes: classesState.list,
        menu: menuState.menu,
        loadingClasses: classesState.loading,
        loadingMenu: menuState.loading);
  }
}
