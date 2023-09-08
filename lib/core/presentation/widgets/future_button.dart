import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/http_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';

class FutureButton extends StatefulWidget {
  final String btnName;
  final Function onPressed;
  final Color color;
  final double? width;
  final double? height;
  final IconData? iconData;
  const FutureButton(
      {super.key,
      required this.btnName,
      required this.onPressed,
      this.color = ThemeConfig.appColorSecondary,
      this.height,
      this.width,
      this.iconData});

  @override
  State<StatefulWidget> createState() => _FutureButtonState();
}

class _FutureButtonState extends State<FutureButton> {
  @override
  Widget build(BuildContext context) {
    return BaseButton(widget.btnName, onPressed: () async {
      try {
        HttpService.disabledInteractionOnRequesting();
        await widget.onPressed();
      } catch (e) {
        rethrow;
      } finally {
        HttpService.closeOverlayLayerBlocking();
      }
    },
        color: widget.color,
        height: widget.height,
        width: widget.width,
        iconData: widget.iconData);
  }
}
