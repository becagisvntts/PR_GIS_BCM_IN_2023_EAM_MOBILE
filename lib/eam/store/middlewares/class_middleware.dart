import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/actions/class_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/app_state.dart';
import 'package:redux/redux.dart';

class ClassesMiddleware implements MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, NextDispatcher next) {
    if (action is FetchClassesAction) {
      fetchClasses(store, action, next);
    } else if (action is UpdateActiveClass) {
      fetchClassDetail(store, action, next);
    } else {
      next(action);
    }
  }

  void fetchClasses(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    DataList list = await ClassService.fetchClasses();
    store.dispatch(FetchClassesSuccessAction(list: list));
  }

  void fetchClassDetail(
      Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    DataList list =
        await ClassService.fetchClassAttributes(action.activeClass["_id"]);
    store.dispatch(FetchClassAttributesSuccessAction(list: list));
  }
}
