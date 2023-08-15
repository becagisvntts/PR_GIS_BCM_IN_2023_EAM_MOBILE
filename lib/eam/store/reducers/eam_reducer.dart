import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/eam_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/reducers/class_reducer.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/reducers/menu_reducer.dart';

EamState eamReducer(EamState prevState, action) {
  return prevState.copyWith(
      classState: classReducer(prevState.classState, action),
      menuState: menuReducer(prevState.menuState, action));
}
