import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/menu_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/actions/menu_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/app_state.dart';
import 'package:redux/redux.dart';

class MenuMiddleware implements MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, NextDispatcher next) {
    if (action is FetchMenuAction) {
      fetchMenu(store, action, next);
    } else {
      next(action);
    }
  }

  void fetchMenu(Store<AppState> store, action, NextDispatcher next) async {
    /// next action to start loading
    next(action);

    /// await loaded classes and dispatch new action to update state
    Map<String, dynamic> menu = await MenuService.fetchMenu();
    store.dispatch(FetchMenuSuccessAction(menu: menu));
  }
}
