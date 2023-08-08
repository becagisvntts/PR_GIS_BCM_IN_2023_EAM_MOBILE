import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/eam_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/reducers/classes_reducer.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/reducers/menu_reducer.dart';

EamState eamReducer(EamState prevState, action) {
  return prevState.copyWith(
      classesState: classesReducer(prevState.classesState, action),
      menuState: menuReducer(prevState.menuState, action));
}
