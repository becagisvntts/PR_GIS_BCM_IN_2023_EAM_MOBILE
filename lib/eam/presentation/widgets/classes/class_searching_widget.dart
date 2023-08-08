import 'package:flutter/cupertino.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/classes_service.dart';

class ClassSearchingWidget extends StatefulWidget {
  const ClassSearchingWidget({super.key});

  @override
  State<StatefulWidget> createState() => ClassSearchingWidgetState();
}

class ClassSearchingWidgetState extends State<ClassSearchingWidget> {
  void searchCards(String keyword) {
    ClassesService.searchCardsByKeyword(keyword);
  }

  @override
  Widget build(BuildContext context) {
    return PaddingWrapper(
        child: CupertinoSearchTextField(
            onSubmitted: (keyword) => searchCards(keyword)),
        top: 12,
        bottom: 12);
  }
}
