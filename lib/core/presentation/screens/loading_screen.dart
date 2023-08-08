import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/models/app_info.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/screens/login_screen.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/store/actions/app_info_action.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<StatefulWidget> createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    preloadApplication();
  }

  void preloadApplication() async {
    await initApplicationLang();
    await checkAuthToken();
  }

  Future<void> checkAuthToken() async {
    // bool userLoggedIn = await AuthService.checkAuthToken();
    // if (userLoggedIn) {
    //   NavigationHelper.pushReplacement(const ClassesListScreen());
    // } else {
    //   NavigationHelper.pushReplacement(const LoginScreen());
    // }

    await Future.delayed(const Duration(seconds: 1));
    NavigationHelper.pushReplacement(const LoginScreen());
  }

  Future<void> initApplicationLang() async {
    String langCode = await LocalizationService.getSavedSettingLang();
    LocalizationService.changeLang(langCode);
  }

  Future<void> loadAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppInfo appInfo = AppInfo(
        appName: packageInfo.appName,
        buildNumber: packageInfo.buildNumber,
        version: packageInfo.version,
        packageName: packageInfo.packageName);

    StateHelper.store.dispatch(UpdateAppInfoAction(appInfo: appInfo));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
