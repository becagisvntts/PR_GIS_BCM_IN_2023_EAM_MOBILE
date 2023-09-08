import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/file_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/notify_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/fields/field_generator.dart';

class BMFileField extends StatefulWidget {
  final String name;
  final dynamic value;
  final String label;
  final String dmsCategory;
  final String fileName;
  final bool required;
  final bool enabled;
  const BMFileField(
      {super.key,
      required this.name,
      this.value,
      required this.label,
      required this.dmsCategory,
      required this.fileName,
      required this.required,
      required this.enabled});

  @override
  State<StatefulWidget> createState() => BMFileFieldState();
}

class BMFileFieldState extends State<BMFileField> {
  final fileIdFieldKey = GlobalKey<FormBuilderFieldState>();
  final fileNameFieldKey = GlobalKey<FormBuilderFieldState>();
  bool _uploadingFile = false;

  late dynamic uploadedFileId;
  late String uploadedFileName;

  @override
  void initState() {
    uploadedFileId = widget.value;
    uploadedFileName = widget.fileName;

    super.initState();
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: widget.dmsCategory == "Photo" ? FileType.media : FileType.any);

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

  void handleUploadFile(String localPath, String fileName) async {
    dynamic response = await FileHelper.uploadFile(localPath);
    if (response == false) {
      NotifyService.showErrorMessage("Không thể upload file");
    } else {
      uploadedFileId = response["_id"];
      uploadedFileName = response["name"];
      fileNameFieldKey.currentState?.didChange(uploadedFileName);
      fileIdFieldKey.currentState?.setValue(uploadedFileId);
      setState(() {});
    }
  }

  void removeFile() async {
    if (uploadedFileId != null && uploadedFileId != "") {
      bool success = await FileHelper.deleteFile(uploadedFileId);
      if (success) {
        uploadedFileId = null;
        uploadedFileName = "";
        fileNameFieldKey.currentState?.didChange(uploadedFileName);
        fileIdFieldKey.currentState?.setValue(uploadedFileId);
        setState(() {});
      } else {
        NotifyService.showErrorMessage("Không thể xóa file");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FormBuilderTextField(
          key: fileNameFieldKey,
          decoration: FormInputDecoration(placeholder: widget.label).copyWith(
              suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                if (uploadedFileId != null && uploadedFileId != "")
                  IconButton(
                      onPressed: removeFile,
                      icon: const Icon(Icons.close_rounded,
                          color: ThemeConfig.colorDanger)),
                _uploadingFile
                    ? PaddingWrapper(
                        child: const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator()),
                        right: 16)
                    : IconButton(
                        onPressed: pickFile,
                        icon: const Icon(Icons.upload_rounded))
              ])),
          name: "${widget.name}_file_name",
          initialValue: uploadedFileName,
          readOnly: true,
          validator: (val) {
            if (widget.required && (val == null || val.trim().isEmpty)) {
              return LocalizationService.translate
                  .msg_field_required(widget.label);
            }
            return null;
          }),
      FieldGenerator.hiddenField(
          key: fileIdFieldKey, name: widget.name, value: uploadedFileId)
    ]);
  }
}
