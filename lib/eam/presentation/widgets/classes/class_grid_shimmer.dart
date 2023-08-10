import 'package:flutter/cupertino.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/app_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';

class ClassesGridShimmer extends StatelessWidget {
  const ClassesGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        PaddingWrapper(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmers(
                      width: AppConfig.screenWidth * 0.4,
                      height: 40,
                      radius: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PaddingWrapper(
                          child: Shimmers(width: 40, height: 40, radius: 8),
                          right: 12),
                      Shimmers(width: 40, height: 40, radius: 8)
                    ],
                  )
                ]),
            bottom: 16),
        PaddingWrapper(child: Shimmers(height: 120), bottom: 12),
        PaddingWrapper(child: Shimmers(height: 120), bottom: 12),
        PaddingWrapper(child: Shimmers(height: 120), bottom: 12),
        PaddingWrapper(child: Shimmers(height: 120), bottom: 12),
        PaddingWrapper(child: Shimmers(height: 120), bottom: 12),
        PaddingWrapper(child: Shimmers(height: 120), bottom: 12)
      ]),
    );
  }
}
