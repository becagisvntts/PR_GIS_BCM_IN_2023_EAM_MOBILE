import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/models/app_info.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/models/user.dart';

class CoreState {
  late User user;
  late AppInfo appInfo;

  CoreState({User? user, AppInfo? appInfo}) {
    this.user = user ?? User();
    this.appInfo = appInfo ?? AppInfo();
  }

  CoreState copyWith({User? user, AppInfo? appInfo}) {
    return CoreState(user: user ?? this.user, appInfo: appInfo ?? this.appInfo);
  }
}
