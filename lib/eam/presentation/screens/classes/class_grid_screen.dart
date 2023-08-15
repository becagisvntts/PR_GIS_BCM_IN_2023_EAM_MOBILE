import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/data_list.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/models/request_payload.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/class_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/screens/classes/card_insert_screen.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/card_in_grid_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/class_searching_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/class_sorting_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/classes/shimmers/class_grid_shimmer.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/widgets/drawer_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/actions/class_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/store/props/active_class_props.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/app_state.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class ClassGridScreen extends StatefulWidget {
  const ClassGridScreen({super.key});

  @override
  State<StatefulWidget> createState() => ClassGridScreenState();
}

class ClassGridScreenState extends State<ClassGridScreen> {
  late Map<String, dynamic> activeClass;

  late bool isShowSearchingWidget = false;
  late bool isShowSortingWidget = false;

  final PagingController<int, Map<String, dynamic>> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    activeClass = StateHelper.eamState.classState.activeClass;
    pagingController
        .addPageRequestListener((pageKey) => fetchClassCards(pageKey));
    super.initState();
  }

  Future<void> fetchClassCards(int pageKey) async {
    DataList list = await ClassService.fetchClassCardsByPage(pageKey);

    try {
      RequestPayload requestPayload =
          StateHelper.eamState.classState.requestPayload;
      final isLastPage = list.data.length < requestPayload.limit;
      if (isLastPage) {
        pagingController.appendLastPage(list.data);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(list.data, nextPageKey);
      }
    } catch (e) {
      pagingController.error = e;
      print(e);
    }
  }

  void fetchClassCardsBySearching(String keyword) {
    RequestPayload requestPayload = StateHelper
        .eamState.classState.requestPayload
        .copyWith(queryKeyword: keyword);
    StateHelper.store
        .dispatch(UpdateRequestPayloadAction(requestPayload: requestPayload));
    pagingController.refresh();
  }

  void fetchClassCardsBySorting(
      String propertySorting, String directionSorting) {
    RequestPayload requestPayload =
        StateHelper.eamState.classState.requestPayload.copyWith(
            propertySorting: propertySorting,
            directionSorting: directionSorting);
    StateHelper.store
        .dispatch(UpdateRequestPayloadAction(requestPayload: requestPayload));
    pagingController.refresh();
  }

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

  void navigateToCardInsertScreen() async {
    var result = await NavigationHelper.push(const CardInsertScreen());
    if (result == ClassConfig.popRouteOnModifySuccess) {
      RequestPayload requestPayload = RequestPayload();
      StateHelper.store
          .dispatch(UpdateRequestPayloadAction(requestPayload: requestPayload));
      pagingController.refresh();
    }
  }

  void refreshListAndScrollToCard() {
    pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: StoreConnector<AppState, String>(
                converter: (store) => store.state.eamState.classState
                    .activeClass[ClassConfig.classTitleByKey],
                builder: (context, props) {
                  return Text(props);
                })),
        body: PageContent(
            child: StoreProvider(
                store: StateHelper.store,
                child: StoreConnector<AppState, ActiveClassProps>(
                    converter: (store) =>
                        ActiveClassProps.mapStateToProps(store),
                    distinct: true,
                    onInit: (store) => ClassService.findAndChangeActiveClass(
                        ClassConfig.firstLoadClassName),
                    builder: (context, props) {
                      if (props.loading) {
                        return const ClassesGridShimmer();
                      } else {
                        if (activeClass != props.activeClass) {
                          pagingController.refresh();
                        }
                        activeClass = props.activeClass;
                        return RefreshIndicator(
                            backgroundColor: ThemeConfig.colorWhite,
                            onRefresh: () async {
                              pagingController.refresh();
                            },
                            child: Column(children: [
                              Column(children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      HeadingText(
                                          LocalizationService.translate
                                              .eam_list_count(
                                                  props.cards.meta.total),
                                          icon: Icons.numbers,
                                          top: 0),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                onPressed: showSortingWidget,
                                                icon: IconBuffer(
                                                    iconColor: isShowSortingWidget
                                                        ? ThemeConfig
                                                            .appColorSecondary
                                                        : ThemeConfig.appColor,
                                                    Icons.sort_rounded),
                                                iconSize: 16),
                                            IconButton(
                                                onPressed: showSearchingWidget,
                                                icon: IconBuffer(
                                                    iconColor:
                                                        isShowSearchingWidget
                                                            ? ThemeConfig
                                                                .appColorSecondary
                                                            : ThemeConfig
                                                                .appColor,
                                                    Icons.search_rounded),
                                                iconSize: 16)
                                          ])
                                    ]),
                                if (isShowSearchingWidget)
                                  ClassSearchingWidget(
                                      onSearch: (keyword) =>
                                          fetchClassCardsBySearching(keyword)),
                                if (isShowSortingWidget)
                                  ClassSortingWidget(
                                    onSort: (propertySorting,
                                            directionSorting) =>
                                        fetchClassCardsBySorting(
                                            propertySorting, directionSorting),
                                  )
                              ]),
                              Expanded(
                                  child:
                                      PagedListView<int, Map<String, dynamic>>(
                                          pagingController: pagingController,
                                          builderDelegate:
                                              PagedChildBuilderDelegate<
                                                      Map<String, dynamic>>(
                                                  itemBuilder:
                                                      (context, item, index) {
                                            return CardInGridWidget(
                                                card: item,
                                                index: index,
                                                onCardModified:
                                                    refreshListAndScrollToCard);
                                          })))
                            ]));
                      }
                    }))),
        floatingActionButton: FloatingActionButton(
            onPressed: navigateToCardInsertScreen,
            mini: true,
            child: const Icon(Icons.add_rounded)),
        drawer: const DrawerWidget());
  }
}
