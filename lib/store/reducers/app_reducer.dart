import 'package:pr_gis_bcm_in_2023_eam_mobile/core/store/reducers/core_reducer.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/reducers/eam_reducer.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/app_state.dart';

AppState appReducer(AppState prevState, action) {
  return prevState.copyWith(
      coreState: coreReducer(prevState.coreState, action),
      eamState: eamReducer(prevState.eamState, action));
}
