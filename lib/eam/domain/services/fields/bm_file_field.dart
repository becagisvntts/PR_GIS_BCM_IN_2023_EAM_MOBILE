import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/file_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/notify_service.dart';

class BMFileField extends StatefulWidget {
  final String name;
  final dynamic value;
  final String description;
  final String dmsCategory;
  final String fileName;
  final int fileId;
  const BMFileField(
      {super.key,
      required this.name,
      this.value,
      required this.description,
      required this.dmsCategory,
      required this.fileName,
      required this.fileId});

  @override
  State<StatefulWidget> createState() => BMFileFieldState();
}

class BMFileFieldState extends State<BMFileField> {
  final valueFieldKey = GlobalKey<FormBuilderFieldState>();
  List<dynamic> selectedFiles = [];
  List<dynamic> failedMessages = [];
  bool _uploadingFile = false;
  Map<String, dynamic>? uploadedFileData;

  @override
  void initState() {
    selectedFiles = widget.value as List<dynamic>;
    super.initState();
  }

  void pickFile() async {
    PermissionStatus permissionStatus = await Permission.storage.request();
    if (permissionStatus == PermissionStatus.granted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _uploadingFile = true;
        });
        if (result.files.single.path != null) {
          handleUploadFile(result.files.single.path!, result.files.single.name);
        } else {
          NotifyService.showErrorMessage("Không thể đọc file");
        }
        setState(() {
          _uploadingFile = false;
        });
      }
    }
  }

  void handleUploadFile(String localPath, String fileName) async {
    dynamic res = await FileHelper.uploadFile(localPath);
    if (res == false) {
      NotifyService.showErrorMessage("Không thể upload file");
    } else {
      uploadedFileData = res as Map<String, dynamic>;
      setState(() {});
    }
  }

  void removeFile() async {
    if (uploadedFileData != null) {
      bool success = await FileHelper.deleteFile(uploadedFileData?["_id"]);
      if (success) {
        uploadedFileData = null;
        setState(() {});
      } else {
        NotifyService.showErrorMessage("Không thể xóa file");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(widget.description,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
        _uploadingFile
            ? const CircularProgressIndicator()
            : TextButton(
                onPressed: pickFile,
                child: Text(LocalizationService.translate.cm_browse_file))
      ]),
      FormBuilderField(
          key: valueFieldKey,
          name: widget.name,
          initialValue: uploadedFileData?["_id"],
          builder: (FormFieldState<dynamic> field) {
            return SizedBox(
                width: double.infinity,
                child: InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                      border: InputBorder.none,
                      errorText: field.errorText,
                    ),
                    child: Row(children: [
                      Text(uploadedFileData?["name"]),
                      IconButton(
                          onPressed: removeFile,
                          icon: const Icon(Icons.close_rounded,
                              color: ThemeConfig.colorDanger))
                    ])));
          })
    ]);
  }
}
