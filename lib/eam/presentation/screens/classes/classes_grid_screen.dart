import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/classes_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/classes_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/card_in_grid_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/class_searching_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/class_sorting_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/drawer_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/props/active_class_props.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/app_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class ClassesGridScreen extends StatefulWidget {
  const ClassesGridScreen({super.key});

  @override
  State<StatefulWidget> createState() => ClassesGridScreenState();
}

class ClassesGridScreenState extends State<ClassesGridScreen> {
  final Map<String, dynamic> activeClass =
      StateHelper.eamState.classesState.activeClass;

  late bool isShowSearchingWidget = false;
  late bool isShowSortingWidget = false;

  void showSearchingWidget() {
    setState(() {
      isShowSearchingWidget = !isShowSearchingWidget;
      if (isShowSearchingWidget) isShowSortingWidget = false;
    });
  }

  void showSortingWidget() {
    setState(() {
      isShowSortingWidget = !isShowSortingWidget;
      if (isShowSortingWidget) isShowSearchingWidget = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: StoreConnector<AppState, String>(
                converter: (store) => store.state.eamState.classesState
                    .activeClass[ClassesConfig.classTitleByKey],
                builder: (context, props) {
                  return Text(props);
                })),
        body: PageContent(
            child: StoreProvider(
                store: StateHelper.store,
                child: StoreConnector<AppState, ActiveClassProps>(
                  converter: (store) => ActiveClassProps.mapStateToProps(store),
                  distinct: true,
                  onInit: (store) => ClassesService.findAndChangeActiveClass(
                      ClassesConfig.firstLoadClassName),
                  builder: (context, props) {
                    if (props.loading) {
                      return Shimmers();
                    } else {
                      return Column(
                        children: [
                          Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  HeadingText(
                                      LocalizationService.translate
                                          .eam_list_count(
                                              props.cards.meta.total),
                                      icon: Icons.numbers,
                                      top: 0),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: showSortingWidget,
                                            icon: IconBuffer(
                                                iconColor: isShowSortingWidget
                                                    ? ThemeConfig.colorSuccess
                                                    : ThemeConfig.appColor,
                                                Icons.sort_by_alpha_rounded),
                                            iconSize: 16),
                                        IconButton(
                                            onPressed: showSearchingWidget,
                                            icon: IconBuffer(
                                                iconColor: isShowSearchingWidget
                                                    ? ThemeConfig.colorSuccess
                                                    : ThemeConfig.appColor,
                                                Icons.search_rounded),
                                            iconSize: 16)
                                      ])
                                ]),
                            if (isShowSearchingWidget)
                              const ClassSearchingWidget(),
                            if (isShowSortingWidget) const ClassSortingWidget()
                          ]),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: props.cards.meta.total,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CardInGridWidget(
                                        cardData: props.cards.data[index]);
                                  }))
                        ],
                      );
                    }
                  },
                ))),
        drawer: const DrawerWidget());
  }
}
