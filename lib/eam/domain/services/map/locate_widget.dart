import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/mapbox_gl.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/map/map_controller.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/map/map_service.dart';

enum LocateState { UnLocate, Loading, Located }

class LocateWidget extends StatefulWidget {
  final MapContainer mapContainer;
  const LocateWidget({super.key, required this.mapContainer});

  @override
  State<StatefulWidget> createState() => LocateWidgetState();
}

class LocateWidgetState extends State<LocateWidget> {
  LocateState _locateState = LocateState.UnLocate;
  Circle? _circleMaker;
  @override
  Widget build(BuildContext context) {
    return MapIconButton(getIconBaseOnState(), fireEventBaseOnState);
  }

  Widget getIconBaseOnState() {
    if (_locateState == LocateState.UnLocate) {
      return const Icon(Icons.my_location, color: Colors.black45, size: 20);
    } else if (_locateState == LocateState.Loading) {
      return const CupertinoActivityIndicator();
    }
    return const Icon(Icons.my_location, color: Colors.blueAccent, size: 20);
  }

  void fireEventBaseOnState() {
    if (_locateState == LocateState.UnLocate) {
      setState(() {
        _locateState = LocateState.Loading;
      });
      getUserLocateAndInitMarker();
    } else if (_locateState == LocateState.Located) {
      setState(() {
        _locateState = LocateState.UnLocate;
      });
      removeCircleMarkerFromMap();
    }
  }

  void getUserLocateAndInitMarker() async {
    LatLng? userLocate = await MapService.getUserLocate();
    if (userLocate == null) {
      setState(() {
        _locateState = LocateState.UnLocate;
      });
    } else {
      setState(() {
        _locateState = LocateState.Located;
      });
      addCircleMarkerToMap(userLocate);
      widget.mapContainer.controller
          .moveCamera(CameraUpdate.newLatLngZoom(userLocate, 18));
    }
  }

  void addCircleMarkerToMap(LatLng latLng) async {
    _circleMaker = await widget.mapContainer.controller.addCircle(CircleOptions(
        circleColor: "#0693e3",
        circleRadius: 8,
        circleStrokeColor: "#8ed1fc",
        circleStrokeOpacity: 0.5,
        circleStrokeWidth: 30,
        geometry: latLng));
  }

  void removeCircleMarkerFromMap() async {
    if (_circleMaker != null) {
      await widget.mapContainer.controller.removeCircle(_circleMaker!);
      _circleMaker = null;
    }
  }
}
