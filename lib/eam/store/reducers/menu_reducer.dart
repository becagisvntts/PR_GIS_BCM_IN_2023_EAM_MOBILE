import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/actions/menu_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/menu_state.dart';

MenuState menuReducer(MenuState prevState, action) {
  switch (action.runtimeType) {
    case FetchMenuAction:
      return prevState.copyWith(loading: true);
    case FetchMenuSuccessAction:
      return prevState.copyWith(menu: action.menu, loading: false);
    default:
      return prevState;
  }
}
