import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/date_time_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/file_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/http_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/notify_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BMFileViewer extends StatefulWidget {
  final String name;
  final dynamic value;
  final String label;
  final String dmsCategory;
  final String fileName;
  final String classType;
  final int cardId;
  const BMFileViewer(
      {super.key,
      required this.name,
      this.value,
      required this.label,
      required this.dmsCategory,
      required this.fileName,
      required this.classType,
      required this.cardId});

  @override
  State<StatefulWidget> createState() => BMFileViewerState();
}

class BMFileViewerState extends State<BMFileViewer> {
  Widget fileErrorBuilder() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.error_outline, color: ThemeConfig.colorDanger, size: 32),
      Text("${LocalizationService.translate.cm_error}!!!",
          style: const TextStyle(color: ThemeConfig.colorDanger))
    ]);
  }

  Widget loadingFile(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }
    return const CircularProgressIndicator();
  }

  Widget fileViewer(Map<String, String> requestHeaders) {
    var encodeFileName = Uri.encodeComponent(widget.fileName);
    String fileUrl =
        "${HttpService.apiUrl}classes/${widget.classType}/cards/${widget.cardId}/attachments/${widget.value}/$encodeFileName";

    if (widget.dmsCategory == "Photo") {
      return Image.network(fileUrl,
          fit: BoxFit.contain,
          headers: requestHeaders,
          loadingBuilder: loadingFile,
          errorBuilder: (context, url, error) => fileErrorBuilder());
    } else {
      WebViewController webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(ThemeConfig.colorWhite)
        ..loadRequest(Uri.parse(fileUrl), headers: requestHeaders);
      return WebViewWidget(controller: webViewController);
    }
  }

  void downloadFile(Map<String, String> requestHeaders) async {
    var encodeFileName = Uri.encodeComponent(widget.fileName);
    String fileUrl =
        "${HttpService.apiUrl}classes/${widget.classType}/cards/${widget.cardId}/attachments/${widget.value}/$encodeFileName";

    bool? savingStatus;
    if (widget.dmsCategory == "Photo") {
      savingStatus =
          await GallerySaver.saveImage(fileUrl, headers: requestHeaders);
    } else {
      String folderPath = await FileHelper.getDownloadedFolderPath();
      try {
        var response = await Dio().download(fileUrl,
            "$folderPath/${DateTimeHelper.getCurrentMillisecondTime()}-${widget.fileName}",
            options: Options(headers: requestHeaders));
        savingStatus = response.statusCode == 200;
      } catch (e) {
        print(e);
        savingStatus = false;
      }
    }

    if (savingStatus! == true) {
      NotifyService.showSuccessMessage(LocalizationService.translate
          .msg_action_success(LocalizationService.translate.cm_download_file));
    } else {
      NotifyService.showErrorMessage(LocalizationService.translate
          .msg_action_fail(LocalizationService.translate.cm_download_file));
    }
  }

  void showPreviewAttachment() async {
    Map<String, String> requestHeaders =
        await HttpService.getAuthorizationHeader();
    showDialog(
        context: NavigationHelper.navigatorKey.currentContext!,
        builder: (BuildContext context) => Dialog.fullscreen(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  PaddingWrapper(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () => NavigationHelper.pop(),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.arrow_back_ios,
                                          size: 20),
                                      Text(
                                          LocalizationService
                                              .translate.cm_close,
                                          style: const TextStyle(
                                              color: ThemeConfig.appColor))
                                    ])),
                            TextButton(
                                onPressed: () => downloadFile(requestHeaders),
                                child: Text(LocalizationService
                                    .translate.cm_download_file))
                          ]),
                      all: 8),
                  Expanded(child: Center(child: fileViewer(requestHeaders)))
                ])));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: showPreviewAttachment,
        child: const Row(children: [
          Text("Attachment",
              style: TextStyle(color: ThemeConfig.appColorSecondary)),
          Icon(Icons.attach_file_rounded,
              size: 16, color: ThemeConfig.appColorSecondary)
        ]));
  }
}
