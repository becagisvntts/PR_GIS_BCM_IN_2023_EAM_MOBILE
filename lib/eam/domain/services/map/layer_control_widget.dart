import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/map/map_controller.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/map/map_service.dart';

class LayerControlWidget extends StatefulWidget {
  final MapContainer mapContainer;
  final String styleActive;
  final Function onChangeStyle;
  const LayerControlWidget(
      {super.key,
      required this.mapContainer,
      required this.onChangeStyle,
      required this.styleActive});

  @override
  State<StatefulWidget> createState() => LayerControlWidgetState();
}

class LayerControlWidgetState extends State<LayerControlWidget> {
  late String _styleActive;
  @override
  void initState() {
    super.initState();
    _styleActive = widget.styleActive;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 3)]),
      child: IconButton(
        onPressed: showLayerOptions,
        icon: const Icon(Icons.layers_rounded,
            size: 20, color: ThemeConfig.appColor),
      ),
    );
  }

  void showLayerOptions() {
    showCustomBottomActionSheet(
        title: LocalizationService.translate.map_select_base_layers,
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction:
                _styleActive.startsWith(MapService.mapStyleString['Smooth']!),
            onPressed: () {
              Navigator.pop(context);
              ;
            },
            child:
                const Text('Smooth', style: TextStyle(color: Colors.black87)),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: _styleActive
                .startsWith(MapService.mapStyleString['Satellite']!),
            onPressed: () {
              Navigator.pop(context);
              changeMapStyle(MapService.mapStyleString['Satellite']!);
            },
            child: const Text('Satellite',
                style: TextStyle(color: Colors.black87)),
          ),
          CupertinoActionSheetAction(
            isDefaultAction:
                _styleActive.startsWith(MapService.mapStyleString['Outdoor']!),
            onPressed: () {
              Navigator.pop(context);
              changeMapStyle(MapService.mapStyleString['Outdoor']!);
            },
            child:
                const Text('Outdoor', style: TextStyle(color: Colors.black87)),
          )
        ]);
  }

  void changeMapStyle(String style) {
    String fullStyleUrl = '$style?api_key=${MapService.stadiaMapApiKey}';
    setState(() {
      _styleActive = fullStyleUrl;
    });
    widget.onChangeStyle(fullStyleUrl);
  }
}
