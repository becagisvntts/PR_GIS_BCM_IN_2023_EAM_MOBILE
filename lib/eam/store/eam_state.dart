import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/class_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/menu_state.dart';

class EamState {
  late ClassState classState;
  late MenuState menuState;

  factory EamState.initialState() => EamState.empty();

  EamState.empty() {
    classState = ClassState();
    menuState = MenuState();
  }

  EamState({ClassState? classState, MenuState? menuState}) {
    this.classState = classState ?? ClassState();
    this.menuState = menuState ?? MenuState();
  }

  EamState copyWith({ClassState? classState, MenuState? menuState}) {
    return EamState(
        classState: classState ?? this.classState,
        menuState: menuState ?? this.menuState);
  }
}
