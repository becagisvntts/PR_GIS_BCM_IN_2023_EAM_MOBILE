import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:shimmer/shimmer.dart';

Widget PaddingWrapper(
    {required Widget child,
    double top = 0,
    double left = 0,
    double bottom = 0,
    double right = 0,
    double? all}) {
  return Padding(
      padding: EdgeInsets.fromLTRB(
          all ?? left, all ?? top, all ?? right, all ?? bottom),
      child: child);
}

Widget FormControl({required Widget child}) {
  return PaddingWrapper(child: child, bottom: 16);
}

Widget PageContent({required Widget child}) {
  return PaddingWrapper(child: child, bottom: 24, left: 16, right: 16, top: 24);
}

Widget HeadingText(String title,
    {double fontSize = 16,
    IconData? icon,
    double top = 4,
    double bottom = 8,
    Color color = ThemeConfig.colorBlackSecondary}) {
  return Padding(
      padding: EdgeInsets.fromLTRB(0, top, 0, bottom),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: Icon(icon, color: color, size: (fontSize + 2))),
            Flexible(
                child: Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: fontSize,
                        color: color)))
          ]));
}

Widget ButtonDrawer(String title, Function onPressed,
    {Color color = ThemeConfig.colorBlackTitle,
    required IconData iconData,
    double iconSize = 16,
    bool showIconRedirect = true}) {
  return InkWell(
      onTap: () => onPressed(),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                child: Row(children: [
              PaddingWrapper(
                  child: Icon(iconData, size: iconSize, color: color),
                  right: 12),
              Expanded(
                  child: Text(title,
                      style: TextStyle(fontSize: iconSize, color: color)))
            ])),
            if (showIconRedirect)
              Icon(Icons.arrow_forward_ios, color: color, size: iconSize)
          ])));
}

Widget ActionButton(String title, Function onPressed,
    {Color color = ThemeConfig.colorBlackTitle,
    required IconData iconData,
    double iconSize = 16,
    String? subText,
    bool showIconRedirect = true}) {
  return Card(
      elevation: 3,
      child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onPressed(),
          child: PaddingWrapper(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      PaddingWrapper(
                          child: Icon(iconData, color: color, size: iconSize),
                          right: 16),
                      Text(title,
                          style: TextStyle(fontSize: iconSize, color: color))
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      if (subText != null) Text(subText),
                      if (showIconRedirect)
                        PaddingWrapper(
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: color,
                              size: 18,
                            ),
                            left: 2)
                    ])
                  ]),
              all: 12)));
}

Widget ActionButton2(String title, Function onPressed,
    {Color color = ThemeConfig.colorBlackTitle,
    required IconData iconData,
    double iconSize = 16,
    bool showIcon = true,
    BorderRadius? borderRadius}) {
  return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onPressed(),
      child: PaddingWrapper(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              PaddingWrapper(
                  child: Icon(iconData, color: color, size: iconSize),
                  right: 16),
              Text(title, style: TextStyle(fontSize: iconSize, color: color))
            ]),
            if (showIcon) Icon(Icons.arrow_forward_ios, color: color, size: 16)
          ]),
          all: 12));
}

InputDecoration FormInputDecoration({String? placeholder}) {
  return InputDecoration(
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          )),
      filled: true,
      fillColor: ThemeConfig.appColorLighting,
      labelText: placeholder ?? "",
      labelStyle: const TextStyle(color: ThemeConfig.appColor),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12));
}

///LOADING
Widget LoadingSpinner() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 12, offset: Offset(2, 4))
              ],
              color: Colors.white,
            ),
            child: const CupertinoActivityIndicator(),
          ),
          const Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Text("Loading")))
        ],
      )
    ],
  );
}

///BUTTONS
FilledButton BaseButton(String btnName,
    {required Function onPressed,
    Color color = ThemeConfig.appColorSecondary,
    double? width,
    double? height,
    IconData? iconData}) {
  return FilledButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
          elevation: 3,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: Size(width ?? double.infinity, height ?? 45),
          maximumSize: Size(width ?? double.infinity, height ?? 45)),
      child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(btnName.toUpperCase()),
            if (iconData != null)
              PaddingWrapper(
                  child: Icon(iconData, color: Colors.white, size: 20), left: 4)
          ])));
}

OutlinedButton OutlineButton(String btnName,
    {Color color = ThemeConfig.appColorSecondary,
    required Function onPressed,
    double? width,
    double? height,
    IconData? iconData}) {
  return OutlinedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
          elevation: 3,
          foregroundColor: color,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: color, width: 1, style: BorderStyle.solid),
          minimumSize: Size(width ?? double.infinity, height ?? 45),
          maximumSize: Size(width ?? double.infinity, height ?? 45)),
      child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(btnName.toUpperCase(), style: TextStyle(color: color)),
            if (iconData != null)
              PaddingWrapper(
                  child: Icon(iconData, color: color, size: 20), left: 4)
          ])));
}

FilledButton ButtonDisabled(String btnName,
    {Color? color, double? width, double? height, IconData? iconData}) {
  return FilledButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
          elevation: 3,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          backgroundColor: color?.withAlpha(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: Size(width ?? double.infinity, height ?? 45)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(btnName.toUpperCase(), textAlign: TextAlign.center),
        if (iconData != null)
          PaddingWrapper(
              child: Icon(iconData, color: Colors.white, size: 20), left: 4)
      ]));
}

FilledButton ButtonLoading({Color? color, double? width, double? height}) {
  return FilledButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
          elevation: 3,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: Size(width ?? double.infinity, height ?? 45)),
      child: const CupertinoActivityIndicator(color: Colors.white));
}

FilledButton ButtonPrimary(String btnName, Function onPressed,
    {IconData? iconData, double? width, double? height}) {
  return BaseButton(btnName,
      onPressed: onPressed,
      color: ThemeConfig.colorPrimary,
      iconData: iconData,
      width: width,
      height: height);
}

FilledButton ButtonSuccess(String btnName, Function onPressed,
    {IconData? iconData, double? width, double? height}) {
  return BaseButton(btnName,
      onPressed: onPressed,
      color: ThemeConfig.colorSuccess,
      iconData: iconData,
      width: width,
      height: height);
}

FilledButton ButtonTeal(String btnName, Function onPressed,
    {IconData? iconData, double? width, double? height}) {
  return BaseButton(btnName,
      onPressed: onPressed,
      color: Colors.teal,
      iconData: iconData,
      width: width,
      height: height);
}

FilledButton ButtonDanger(String btnName, Function onPressed,
    {IconData? iconData, double? width, double? height}) {
  return BaseButton(btnName,
      onPressed: onPressed,
      color: ThemeConfig.colorDanger,
      iconData: iconData,
      width: width,
      height: height);
}

FilledButton ButtonWarning(String btnName, Function onPressed,
    {IconData? iconData, double? width, double? height}) {
  return BaseButton(btnName,
      onPressed: onPressed,
      color: Colors.orangeAccent,
      iconData: iconData,
      width: width,
      height: height);
}

Widget IconBuffer(IconData iconData,
    {Color iconColor = ThemeConfig.appColor,
    double? iconSize,
    double bufferRadius = 8,
    double padding = 8}) {
  return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(bufferRadius),
          color: iconColor?.withAlpha(80)),
      padding: EdgeInsets.all(padding),
      child: Icon(iconData, color: iconColor, size: iconSize));
}

Widget Shimmers(
    {double width = double.infinity, double height = 100, double radius = 12}) {
  return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.black26)),
      ));
}

void showCustomBottomSheet(
    {required String title,
    List<Widget> actions = const [],
    required Widget child}) {
  showModalBottomSheet(
      context: NavigationHelper.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
              PaddingWrapper(
                  child: Row(
                      mainAxisAlignment: actions.isEmpty
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ThemeConfig.appColor),
                        ),
                        Row(children: [
                          for (Widget action in actions) action,
                        ])
                      ]),
                  top: 12,
                  left: 16,
                  right: 16),
              const Divider(),
              PaddingWrapper(child: child, bottom: 20, left: 16, right: 16)
            ]));
      });
}

Future<void> showAlertDialog(
    {required String title,
    required String messageAlert,
    required Function onConfirm}) {
  return showDialog<String>(
    context: NavigationHelper.navigatorKey.currentContext!,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(messageAlert),
      actions: [
        TextButton(
            onPressed: () => NavigationHelper.pop(),
            child: Text(
              LocalizationService.translate.cm_cancel,
              style: const TextStyle(color: Colors.black87),
            )),
        TextButton(
            onPressed: () {
              onConfirm.call();
              NavigationHelper.pop();
            },
            child: Text(LocalizationService.translate.cm_confirm,
                style: const TextStyle(color: ThemeConfig.colorDanger))),
      ],
    ),
  );
}

void showCustomDialog(
    {required String title,
    List<Widget> actions = const [],
    required Widget child}) {
  showDialog(
      context: NavigationHelper.navigatorKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
          title: Container(
            color: ThemeConfig.appColor,
            child: Text(title),
          ),
          content: child));
}

void showCustomBottomActionSheet(
    {required List<CupertinoActionSheetAction> actions,
    String? title,
    String? message,
    bool styledAction = false}) {
  showCupertinoModalPopup(
      context: NavigationHelper.navigatorKey.currentContext!,
      builder: (BuildContext context) => CupertinoActionSheet(
          actionScrollController: ScrollController(),
          title: title != null ? Text(title) : null,
          message: message != null ? Text(message) : null,
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(LocalizationService.translate.cm_cancel,
                style: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w500)),
          ),
          actions: actions));
}

Widget DividerWithText(String text, Color color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
          child: Divider(color: color, indent: 0, thickness: 0.5, height: 0)),
      PaddingWrapper(
          child: Text(text,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          left: 8,
          right: 8),
      Expanded(
          child: Divider(color: color, indent: 0, thickness: 0.5, height: 0))
    ],
  );
}

Widget MapIconButton(Widget icon, Function onPressed) {
  return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6)),
          boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 4)]),
      child: IconButton(onPressed: () => onPressed(), icon: icon));
}
