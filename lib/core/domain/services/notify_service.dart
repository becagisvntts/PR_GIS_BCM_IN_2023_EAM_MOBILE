import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';

class NotifyService {
  static FToast? _fToast;
  static void _initToast() {
    _fToast ??= FToast();
  }

  static void showSuccessMessage(String message) {
    showMessage(message, ThemeConfig.colorSuccess, Icons.check);
  }

  static void showErrorMessage(String message) {
    showMessage(message, ThemeConfig.colorDanger, Icons.error_outline_rounded);
  }

  static void showMessage(String message, Color color, IconData iconData) {
    _initToast();
    _fToast!.init(NavigationHelper.navigatorKey.currentContext!);

    _fToast!.showToast(
        child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: color,
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(iconData, color: Colors.white),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                  child: Text(message,
                      style: const TextStyle(color: Colors.white))),
            ])));
  }
}
