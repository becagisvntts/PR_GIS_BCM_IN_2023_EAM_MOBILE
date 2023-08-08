import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/app_config.dart';

class AppInfo {
  late String appName;
  late String version;
  late String buildNumber;
  late String packageName;

  AppInfo(
      {String? appName,
      String? version,
      String? buildNumber,
      String? packageName}) {
    this.appName = appName ?? AppConfig.appTitle;
    this.version = version ?? "1.0.0";
    this.buildNumber = buildNumber ?? "1";
    this.packageName = packageName ?? "";
  }
}
