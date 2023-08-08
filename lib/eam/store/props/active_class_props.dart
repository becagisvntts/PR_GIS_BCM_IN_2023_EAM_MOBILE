import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/classes_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/app_state.dart';
import 'package:redux/redux.dart';

class ActiveClassProps {
  final Map<String, dynamic> activeClass;
  final DataList attributes;
  final DataList cards;
  final bool loading;

  ActiveClassProps(
      {required this.activeClass,
      required this.attributes,
      required this.cards,
      required this.loading});

  static ActiveClassProps mapStateToProps(Store<AppState> store) {
    ClassesState classesState = store.state.eamState.classesState;
    return ActiveClassProps(
        activeClass: classesState.activeClass,
        attributes: classesState.classAttributes,
        cards: classesState.classCards,
        loading: classesState.loadingClassDetail);
  }
}
