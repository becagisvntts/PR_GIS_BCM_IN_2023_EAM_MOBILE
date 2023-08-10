import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';

class AppConfig {
  static String appTitle = "BecaMaint";
  static String appSubTitle = "Quản lý, vận hành, bảo trì tài sản";
  static double screenWidth =
      MediaQuery.of(NavigationHelper.navigatorKey.currentContext!).size.width;
  static double screenHeight =
      MediaQuery.of(NavigationHelper.navigatorKey.currentContext!).size.height;
}
