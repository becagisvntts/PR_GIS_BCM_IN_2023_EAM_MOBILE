import 'package:flutter/cupertino.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/app_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';

class CardGroupShimmer extends StatelessWidget {
  const CardGroupShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PaddingWrapper(
            child: Shimmers(
                width: AppConfig.screenWidth * 0.4, height: 40, radius: 8),
            bottom: 16),
        PaddingWrapper(
            child: Shimmers(height: 120), bottom: 20, left: 20, right: 20),
        PaddingWrapper(
            child: Shimmers(
                width: AppConfig.screenWidth * 0.4, height: 40, radius: 8),
            bottom: 16),
        PaddingWrapper(
            child: Shimmers(height: 100), bottom: 12, left: 20, right: 20),
        PaddingWrapper(
            child: Shimmers(height: 100), bottom: 20, left: 20, right: 20),
        PaddingWrapper(
            child: Shimmers(
                width: AppConfig.screenWidth * 0.4, height: 40, radius: 8),
            bottom: 20),
        PaddingWrapper(
            child: Shimmers(
                width: AppConfig.screenWidth * 0.4, height: 40, radius: 8),
            bottom: 20),
      ]),
    );
  }
}
