import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/app_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/screens/loading_screen.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/store/state_manager.dart';

void main() {
  runApp(const EAMApp());
}

class EAMApp extends StatefulWidget {
  const EAMApp({super.key});

  @override
  State<StatefulWidget> createState() => EAMAppState();
  static EAMAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<EAMAppState>();
}

class EAMAppState extends State<EAMApp> {
  Locale locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      this.locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    StateManager.instance.initStore();
  }

  ThemeData _buildTheme() {
    var baseTheme = ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: ThemeConfig.appColor,
            primary: ThemeConfig.appColor,
            secondary: ThemeConfig.colorGreen,
            surface: ThemeConfig.colorWhite,
            surfaceVariant: ThemeConfig.colorWhite,
            surfaceTint: ThemeConfig.colorWhite,
            inverseSurface: ThemeConfig.colorWhite,
            background: ThemeConfig.backgroundColor),
        canvasColor: Colors.transparent,
        // colorSchemeSeed: ThemeConfig.appColor,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: ThemeConfig.appColorSecondary,
            foregroundColor: ThemeConfig.colorWhite),
        unselectedWidgetColor: ThemeConfig.appColor,
        // buttonTheme: ButtonThemeData(buttonColor: ThemeConfig.appColor),
        appBarTheme: AppBarTheme(
            backgroundColor: ThemeConfig.appColor,
            iconTheme: const IconThemeData(color: ThemeConfig.colorWhite),
            titleTextStyle: GoogleFonts.poppins(
                color: ThemeConfig.colorWhite,
                fontSize: ThemeConfig.fontSizeAppbar)));

    return baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: StateManager.instance.store,
        child: MaterialApp(
            builder: FToastBuilder(),
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigationHelper.navigatorKey,
            title: AppConfig.appTitle,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('vi'), // Vietnam
            ],
            locale: locale,
            home: const LoadingScreen(),
            theme: _buildTheme()));
  }
}
