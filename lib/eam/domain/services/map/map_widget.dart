import 'package:flutter/cupertino.dart';
import 'package:maplibre_gl/mapbox_gl.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/map/locate_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/map/map_controller.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/map/map_service.dart';

enum MapPosition {
  TopLeft,
  TopRight,
  BottomLeft,
  BottomRight,
  Center,
  BottomCenter
}

class MapWidget extends StatefulWidget {
  final String? styleString;
  final LatLng? initialPosition;
  final double? zoom;
  final Function? onMapCreated;
  final Function? onStyleLoadedCallback;
  final Function? onMapClick;
  final Function? onMapLongClick;

  const MapWidget(
      {super.key,
      this.styleString,
      this.initialPosition,
      this.zoom,
      this.onMapCreated,
      this.onStyleLoadedCallback,
      this.onMapClick,
      this.onMapLongClick});

  @override
  State<StatefulWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  bool loading = true;
  late MapContainer mapContainer;
  List<Widget> centerWidgets = [];
  List<Widget> topRightWidgets = [];
  List<Widget> topLeftWidgets = [];
  List<Widget> bottomRightWidgets = [];
  List<Widget> bottomLeftWidgets = [];
  List<Widget> bottomCenterWidgets = [];
  List<Widget> widgets = [];

  void onMapCreated(MaplibreMapController mapController) {
    mapContainer = MapContainer(controller: mapController);
    widget.onMapCreated?.call(mapContainer);
    addWidgetOverlayMap(
        MapPosition.TopRight, LocateWidget(mapContainer: mapContainer));
  }

  void addWidgetOverlayMap(MapPosition position, Widget widget) {
    setState(() {
      if (position == MapPosition.TopLeft) {
        topLeftWidgets.add(widget);
      } else if (position == MapPosition.TopRight) {
        topRightWidgets.add(widget);
      } else if (position == MapPosition.BottomLeft) {
        bottomLeftWidgets.add(widget);
      } else if (position == MapPosition.BottomRight) {
        bottomRightWidgets.add(widget);
      } else if (position == MapPosition.Center) {
        centerWidgets.add(widget);
      } else if (position == MapPosition.BottomCenter) {
        bottomCenterWidgets.add(widget);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: MaplibreMap(
                styleString: widget.styleString ?? MapService.defaultMapStyle,
                initialCameraPosition: CameraPosition(
                    target: widget.initialPosition ?? MapService.defaultLatLng,
                    zoom: widget.zoom ?? MapService.defaultZoom),
                trackCameraPosition: true,
                rotateGesturesEnabled: false,
                minMaxZoomPreference: const MinMaxZoomPreference(1, 24),
                onMapCreated: (controller) {
                  print("===========");
                  onMapCreated(controller);
                },
                onStyleLoadedCallback: () async =>
                    widget.onStyleLoadedCallback?.call(),
                onMapClick: (point, latLng) =>
                    widget.onMapClick?.call(point, latLng),
                onMapLongClick: (point, latLng) =>
                    widget.onMapLongClick?.call(point, latLng),
                annotationOrder: const [
              AnnotationType.fill,
              AnnotationType.line,
              AnnotationType.circle,
              AnnotationType.symbol
            ])),
        Align(
          alignment: AlignmentDirectional.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: centerWidgets,
          ),
        ),
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (Widget widget in topLeftWidgets)
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                        child: widget)
                ],
              )),
        ),
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: bottomRightWidgets,
              )),
        ),
        Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: bottomLeftWidgets,
              )),
        ),
        Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: bottomCenterWidgets)),
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (Widget widget in topRightWidgets)
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                        child: widget)
                ],
              )),
        )
      ],
    );
  }
}
