import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/classes_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/menu_state.dart';

class EamState {
  late ClassesState classesState;
  late MenuState menuState;

  factory EamState.initialState() => EamState.empty();

  EamState.empty() {
    classesState = ClassesState();
    menuState = MenuState();
  }

  EamState({ClassesState? classesState, MenuState? menuState}) {
    this.classesState = classesState ?? ClassesState();
    this.menuState = menuState ?? MenuState();
  }

  EamState copyWith({ClassesState? classesState, MenuState? menuState}) {
    return EamState(
        classesState: classesState ?? this.classesState,
        menuState: menuState ?? this.menuState);
  }
}
