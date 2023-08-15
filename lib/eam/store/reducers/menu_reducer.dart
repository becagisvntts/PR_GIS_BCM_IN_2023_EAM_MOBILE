import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/actions/menu_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/menu_state.dart';

MenuState menuReducer(MenuState prevState, action) {
  switch (action.runtimeType) {
    case FetchMenuAction:
      return prevState.copyWith(loading: true);
    case FetchMenuSuccessAction:
      return prevState.copyWith(menu: action.menu, loading: false);
    case UpdateExpandedNodeIds:
      List<String> expandedNodeIds = [...prevState.expandedNodeIds];
      if (action.expanded && !expandedNodeIds.contains(action.nodeId)) {
        expandedNodeIds.add(action.nodeId);
      } else if (!action.expanded && expandedNodeIds.contains(action.nodeId)) {
        expandedNodeIds.remove(action.nodeId);
      }
      return prevState.copyWith(expandedNodeIds: expandedNodeIds);
    default:
      return prevState;
  }
}
