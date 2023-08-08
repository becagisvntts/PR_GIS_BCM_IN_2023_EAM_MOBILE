import 'dart:async';

import 'package:pr_gis_bcm_in_2023_eam_mobile/core/store/core_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/eam_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/middlewares/eam_middleware.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/app_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/reducers/app_reducer.dart';
import 'package:redux/redux.dart';

class StateManager {
  static final StateManager _instance = StateManager._();
  StateManager._();

  static StateManager get instance => _instance;

  late Store<AppState> store;
  late List<Middleware<AppState>> middlewares;

  Future<void> initStore() async {
    middlewares = [...eamMiddlewares()];
    store = Store<AppState>(appReducer,
        initialState: AppState.empty(), middleware: middlewares);
  }
}

extension StoreExtension on Store {
  Future<void> dispatchFuture(dynamic action) {
    final completer = Completer<void>();
    dispatch(action);
    onChange.listen((state) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });
    return completer.future;
  }
}

class StateHelper {
  static Store<AppState> get store => StateManager.instance.store;
  static AppState get state => StateManager.instance.store.state;
  static CoreState get coreState => StateManager.instance.store.state.coreState;
  static EamState get eamState => StateManager.instance.store.state.eamState;
}
