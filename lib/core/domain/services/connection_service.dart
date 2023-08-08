import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';

class ConnectionService {
  static Future<bool> checkConnection(context) async {
    Connectivity connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(LocalizationService.translate.cm_error),
          content: Text(LocalizationService.translate.msg_no_internet),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () => NavigationHelper.pop(),
              child: Text(LocalizationService.translate.cm_close),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                NavigationHelper.pop();
                await checkConnection(context);
              },
              child: Text(LocalizationService.translate.cm_try_again),
            ),
          ],
        ),
      );
    }
    return true;
  }

  static Future<bool> isOnline() async {
    Connectivity connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();
    return result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile;
  }
}
