import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/notify_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static const String langVi = "vi";
  static const String langEn = "en";
  static const List<String> langCodes = [langVi, langEn];

  static String getCurrentLang() {
    if (getCurrentLangCode() == langVi) {
      return translate.cm_lang_vi;
    }
    return translate.cm_lang_en;
  }

  static String getCurrentLangCode() {
    return Localizations.localeOf(NavigationHelper.navigatorKey.currentContext!)
        .languageCode;
  }

  static bool isCurrentLangCode(String langCode) {
    return langCode == getCurrentLangCode();
  }

  static void changeLang(String langCode) {
    if (langCodes.contains(langCode)) {
      EAMApp.of(NavigationHelper.navigatorKey.currentContext!)!
          .setLocale(Locale(langCode));
      saveSettingLang(langCode);
    } else {
      NotifyService.showErrorMessage(translate.cm_do_not_support_lang);
    }
  }

  static void saveSettingLang(String langCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("displayLang", langCode);
  }

  static Future<String> getSavedSettingLang() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString("displayLang");
    if (langCode == null) {
      String localName = Platform.localeName;
      String deviceLang = localName.split("_").first;
      String lc = !langCodes.contains(deviceLang) ? langEn : langVi;
      return lc;
    }
    return langCode;
  }

  static AppLocalizations get translate =>
      AppLocalizations.of(NavigationHelper.navigatorKey.currentContext!)!;
}
