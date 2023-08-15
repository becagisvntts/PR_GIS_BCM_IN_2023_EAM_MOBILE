import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/class_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/app_state.dart';
import 'package:redux/redux.dart';

class ActiveClassProps {
  final Map<String, dynamic> activeClass;
  final DataList cards;
  final DataList attributes;
  final bool loading;

  ActiveClassProps(
      {required this.activeClass,
      required this.cards,
      required this.attributes,
      required this.loading});

  static ActiveClassProps mapStateToProps(Store<AppState> store) {
    ClassState classesState = store.state.eamState.classState;
    return ActiveClassProps(
        activeClass: classesState.activeClass,
        cards: classesState.classCards,
        attributes: classesState.classAttributes,
        loading: classesState.loadingAttributes);
  }
}
