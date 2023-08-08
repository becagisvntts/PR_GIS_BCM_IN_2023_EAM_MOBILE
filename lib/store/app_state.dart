import 'package:pr_gis_bcm_in_2023_eam_mobile/core/store/core_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/eam_state.dart';

class AppState {
  late CoreState coreState;
  late EamState eamState;

  factory AppState.initialState() => AppState.empty();

  AppState.empty() {
    coreState = CoreState();
    eamState = EamState();
  }

  AppState({required this.coreState, required this.eamState});

  AppState copyWith({CoreState? coreState, EamState? eamState}) {
    return AppState(
        coreState: coreState ?? this.coreState,
        eamState: eamState ?? this.eamState);
  }
}
