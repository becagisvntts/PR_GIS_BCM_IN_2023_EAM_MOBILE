import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/http_service.dart';

class FileHelper {
  static String? downloadedFolderPath;

  static Future<String> getDownloadedFolderPath() async {
    Directory? downloadsDirectory;
    if (Platform.isAndroid) {
      downloadsDirectory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      downloadsDirectory = await getDownloadsDirectory();
    }

    downloadedFolderPath = downloadsDirectory!.path;
    return downloadedFolderPath!;
  }

  static Future<String> getApplicationPath() async {
    Directory? directory;
    directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<String?> saveDataToFile(String data, String fileName,
      {String? folderPath}) async {
    try {
      if (folderPath == null) {
        Directory directory = await getApplicationDocumentsDirectory();
        folderPath = directory.path;
      }

      String fullFilePath = "$folderPath/$fileName";

      bool fileExists = await File(fullFilePath).exists();
      if (!fileExists) {
        File newFile = await File(fullFilePath).create(recursive: true);
        await newFile.writeAsString(data);
      } else {
        File existingFile = File(fullFilePath);
        await existingFile.writeAsString(data);
      }
      return fullFilePath;
    } catch (ex) {
      print("Can not save to file: $ex");
      return null;
    }
  }

  static Future<String?> saveBytesToFile(List<int> fileBytes, String fileName,
      {String? folderPath}) async {
    try {
      if (folderPath == null) {
        Directory directory = await getApplicationDocumentsDirectory();
        folderPath = directory.path;
      }

      String fullFilePath = "$folderPath/$fileName";

      bool fileExists = await File(fullFilePath).exists();
      if (!fileExists) {
        File newFile = await File(fullFilePath).create(recursive: true);
        await newFile.writeAsBytes(fileBytes);
      } else {
        File existingFile = File(fullFilePath);
        await existingFile.writeAsBytes(fileBytes);
      }
      return fullFilePath;
    } catch (ex) {
      print("Can not save to file: $ex");
      return null;
    }
  }

  static Future<dynamic> uploadFile(String localPath) async {
    var response = await HttpService.uploadFileWithAuth(
        endpoint: '${HttpService.apiUrl}uploads/_TEMP', filePath: localPath);
    if (response.statusCode == 200) {
      var resStr = await response.stream.bytesToString();
      var resArr = jsonDecode(resStr);

      /// {contentType: "image/png", name: "icon.png", size: 23068, _id: "6rjh33307qnp5g6965th7msm6rmu78np6tn17gni6d307a"}
      return resArr["data"];
    } else {
      return false;
    }
  }

  static Future<bool> deleteFile(String fileId) async {
    var response = await HttpService.deleteWithAuth(
        endpoint: '${HttpService.apiUrl}uploads/_TEMP/$fileId');

    return response.statusCode == 200;
  }
}
