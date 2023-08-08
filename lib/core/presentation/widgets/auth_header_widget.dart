import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/app_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';

class AuthHeaderWidget extends StatelessWidget {
  final String pageTitle;

  const AuthHeaderWidget({super.key, required this.pageTitle});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FormControl(
          child: Image.asset(
        "assets/images/icon.png",
        width: 125,
      )),
      PaddingWrapper(
          child: Text(AppConfig.appTitle,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ThemeConfig.appColor)),
          bottom: 4),
      PaddingWrapper(
          child: Text(AppConfig.appSubTitle,
              style: const TextStyle(
                  fontSize: 16,
                  color: ThemeConfig.appColor,
                  fontWeight: FontWeight.w500)),
          bottom: 16),
      PaddingWrapper(
          child: Text(pageTitle,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ThemeConfig.appColor.withAlpha(200))),
          bottom: 40)
    ]);
  }
}
