import 'package:pr_gis_bcm_in_2023_eam_mobile/core/store/actions/app_info_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/store/actions/user_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/store/core_state.dart';

CoreState coreReducer(CoreState prevState, action) {
  switch (action.runtimeType) {
    case UpdateUserDataAction:
      return prevState.copyWith(user: action.user);
    case UpdateAppInfoAction:
      return prevState.copyWith(appInfo: action.appInfo);
    default:
      return prevState;
  }
}
