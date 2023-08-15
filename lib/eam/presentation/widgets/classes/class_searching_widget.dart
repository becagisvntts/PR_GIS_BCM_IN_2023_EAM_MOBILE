import 'package:flutter/cupertino.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class ClassSearchingWidget extends StatefulWidget {
  final Function onSearch;
  const ClassSearchingWidget({super.key, required this.onSearch});

  @override
  State<StatefulWidget> createState() => ClassSearchingWidgetState();
}

class ClassSearchingWidgetState extends State<ClassSearchingWidget> {
  TextEditingController searchController = TextEditingController(
      text: StateHelper.eamState.classState.requestPayload.queryKeyword);

  void searchCards(String keyword) {
    widget.onSearch(keyword);
  }

  @override
  Widget build(BuildContext context) {
    return PaddingWrapper(
        child: CupertinoSearchTextField(
            controller: searchController,
            onSubmitted: (keyword) => searchCards(keyword)),
        top: 12,
        bottom: 12);
  }
}
