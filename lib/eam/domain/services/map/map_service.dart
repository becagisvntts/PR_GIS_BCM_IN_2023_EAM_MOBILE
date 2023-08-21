import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/mapbox_gl.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/http_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/map/map_controller.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/map/map_widget.dart';
import 'package:turf/turf.dart' as turf;

enum DrawMode { Polygon, Line }

class MapService {
  static String stadiaMapApiKey = "d55541ee-efaf-406d-89ec-a2d96bb49eed";
  static Map<String, String> mapStyleString = {
    "Smooth": "https://tiles.stadiamaps.com/styles/alidade_smooth.json",
    "Smooth dark":
        "https://tiles.stadiamaps.com/styles/alidade_smooth_dark.json",
    "Satellite": "https://tiles.stadiamaps.com/styles/alidade_satellite.json",
    "Outdoor": "https://tiles.stadiamaps.com/styles/outdoors.json",
    "OSM Bright": "https://tiles.stadiamaps.com/styles/osm_bright.json"
  };

  static const String TypePoint = "Point";
  static const String TypePolygon = "Polygon";
  static const String TypeLine = "LineString";

  static final Map<String, String> MapTypeLabels = {
    TypePoint: LocalizationService.translate.map_point,
    TypePolygon: LocalizationService.translate.map_polygon,
    TypeLine: LocalizationService.translate.map_line,
  };

  static const Map<String, DrawMode> MapTypeDrawModes = {
    TypePolygon: DrawMode.Polygon,
    TypeLine: DrawMode.Line,
  };

  static const Map<String, dynamic> emptyGeoJSON = {
    "type": "FeatureCollection",
    "features": []
  };

  // static String defaultMapStyle =
  //     "${mapStyleString["Outdoor"]}?api_key=$stadiaMapApiKey";
  static String defaultMapStyle = 'assets/style/eam-default.json';
  static LatLng defaultLatLng = const LatLng(16.047079, 108.206230);
  static double defaultZoom = 5;

  static MapWidget createMap(
      {GlobalKey<MapWidgetState>? key,
      String? styleString,
      LatLng? initialPosition,
      double? zoom,
      Function? onMapCreated,
      Function? onStyleLoadedCallback,
      Function? onMapClick,
      Function? onMapLongClick}) {
    return MapWidget(
        key: key,
        styleString: styleString,
        initialPosition: initialPosition,
        zoom: zoom,
        onMapCreated: onMapCreated,
        onStyleLoadedCallback: onStyleLoadedCallback,
        onMapClick: onMapClick,
        onMapLongClick: onMapLongClick);
  }

  static CircleOptions getDefaultCircleOptions(LatLng latLng) {
    return CircleOptions(
        circleColor: "#2196f3",
        circleRadius: 8,
        circleStrokeColor: "#2196f3",
        circleStrokeWidth: 3,
        circleStrokeOpacity: 0.5,
        geometry: latLng);
  }

  static Future<void> addClusteredPointLayers(
      {required MapContainer mapContainer,
      required String sourceId,
      required String layerId,
      required CircleLayerProperties pointProperties,
      CircleLayerProperties? clusterProperties}) async {
    await mapContainer.controller.addCircleLayer(
        sourceId,
        layerId,
        const CircleLayerProperties(circleColor: [
          "step",
          ["get", "point_count"],
          "#51bbd6",
          100,
          "#f1f075",
          750,
          "#f28cb1"
        ], circleRadius: [
          "step",
          ["get", "point_count"],
          20,
          100,
          30,
          750,
          40
        ]),
        filter: ["has", "point_count"]);

    await mapContainer.controller.addSymbolLayer(
        sourceId,
        "cluster-count",
        const SymbolLayerProperties(
            // NOTE: I would expect to be able to do something like "{point_count_abbreviated}", but this breaks on Android
            textField: [Expressions.get, "point_count_abbreviated"],
            textFont: ["Open Sans Regular"]),
        filter: ["has", "point_count"]);

    await mapContainer.controller.addCircleLayer(
        sourceId,
        layerId,
        const CircleLayerProperties(
            circleColor: "#11b4da",
            circleRadius: 8,
            circleStrokeWidth: 1,
            circleStrokeColor: "#fff"),
        filter: [
          "!",
          ["has", "point_count"]
        ]);
  }

  ///--------BOUNDS---------
  static fitBoundsMap(MapContainer mapContainer, LatLngBounds? bounds) {
    if (bounds != null) {
      fitBounds(
          mapContainer: mapContainer,
          bounds: bounds,
          top: 20,
          left: 20,
          right: 20,
          bottom: 20);
    }
  }

  static Future<bool?> fitBounds({
    required MapContainer mapContainer,
    required LatLngBounds? bounds,
    double top = 50,
    double left = 50,
    double bottom = 50,
    double right = 50,
  }) async {
    if (bounds != null) {
      return await mapContainer.controller.animateCamera(
          CameraUpdate.newLatLngBounds(bounds,
              top: top, left: left, bottom: bottom, right: right));
    }
    return false;
  }

  static LatLngBounds convertBBoxToLatLngBounds(List<num> items) {
    return LatLngBounds(
        northeast: LatLng(items[3].toDouble(), items[2].toDouble()),
        southwest: LatLng(items[1].toDouble(), items[0].toDouble()));
  }

  static LatLngBounds? boundsFromLatLngList(List<LatLng> latLongs) {
    if (latLongs.isNotEmpty) {
      double? x0, x1, y0, y1;
      for (int i = 0; i < latLongs.length; i++) {
        LatLng latLng = latLongs[i];
        if (x0 == null) {
          x0 = x1 = latLng.latitude;
          y0 = y1 = latLng.longitude;
        } else {
          if (latLng.latitude > x1!) x1 = latLng.latitude;
          if (latLng.latitude < x0) x0 = latLng.latitude;
          if (latLng.longitude > y1!) y1 = latLng.longitude;
          if (latLng.longitude < y0!) y0 = latLng.longitude;
        }
      }
      return LatLngBounds(
          northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
    }
    return null;
  }

  ///--------BOUNDS---------

  ///--------FEATURES---------
  static Map<String, dynamic> buildFeature(
      List<LatLng> latLongs, String mapType) {
    if (mapType == MapService.TypePoint) {
      return buildPointFeature(latLongs[0].latitude, latLongs[0].longitude);
    } else if (mapType == MapService.TypePolygon) {
      return buildPolygonFeature(latLongs);
    }
    return buildLineStringFeature(latLongs);
  }

  static Map<String, dynamic> buildPolygonFeature(List<LatLng> latLongs) {
    List localList = [];
    for (LatLng latLng in latLongs) {
      localList.add([latLng.longitude, latLng.latitude]);
    }
    if (localList.first != localList.last) {
      localList.add(localList.first);
    }

    return {
      "type": "Feature",
      "geometry": {
        "type": "Polygon",
        "coordinates": [localList]
      }
    };
  }

  static Map<String, dynamic> buildLineStringFeature(List<LatLng> latLongs) {
    List localList = [];
    for (LatLng latLng in latLongs) {
      localList.add([latLng.longitude, latLng.latitude]);
    }

    return {
      "type": "Feature",
      "geometry": {"type": "LineString", "coordinates": localList}
    };
  }

  static Map<String, dynamic> buildPointFeature(double lat, double lng) {
    return {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [lng, lat]
      }
    };
  }

  static List<LatLng> getLatLngListFromFeature(Map<String, dynamic>? geoJSON) {
    try {
      if (geoJSON != null && geoJSON.isNotEmpty) {
        ///Avoid that method change source geoJSON
        Map<String, dynamic> localGeoJSON = {...geoJSON};

        String geometryType = localGeoJSON["geometry"]["type"];
        if (geometryType == "LineString") {
          return getLatLngListFromLinePoint(localGeoJSON);
        } else if (geometryType == "Polygon") {
          return getLatLngListFromPolygonJson(localGeoJSON);
        }
        return getLatLngListFromPointJson(localGeoJSON);
      }
      return [];
    } catch (ex) {
      return [];
    }
  }

  static List<LatLng> getLatLngListFromPolygonJson(
      Map<String, dynamic> geoJSON) {
    try {
      List coordinates = geoJSON["geometry"]["coordinates"][0];
      int lastIndex = coordinates.length - 1;
      if (coordinates[0].toString() == coordinates[lastIndex].toString()) {
        coordinates.removeAt(lastIndex);
      }

      List<LatLng> latLngList =
          coordinates.map((e) => LatLng(e[1], e[0])).toList();
      return latLngList;
    } catch (ex) {
      print("error: $ex");
      return [];
    }
  }

  static List<LatLng> getLatLngListFromLinePoint(Map<String, dynamic> geoJSON) {
    try {
      List coordinates = geoJSON["geometry"]["coordinates"];
      List<LatLng> latLngList =
          coordinates.map((e) => LatLng(e[1], e[0])).toList();
      return latLngList;
    } catch (ex) {
      print("error: $ex");
      return [];
    }
  }

  static List<LatLng> getLatLngListFromPointJson(Map<String, dynamic> geoJSON) {
    try {
      List coordinates = geoJSON["geometry"]["coordinates"];
      return [LatLng(coordinates[1], coordinates[0])];
    } catch (ex) {
      print("error: $ex");
      return [];
    }
  }

  ///--------FEATURES---------

  static Map<String, dynamic> buildGeoJSONPoints(List<LatLng> latLongs) {
    var features = [];
    for (LatLng latLng in latLongs) {
      features
          .add(MapService.buildPointFeature(latLng.latitude, latLng.longitude));
    }

    return {"type": "FeatureCollection", "features": features};
  }

  static Map<String, dynamic> buildGeoJSONLine(List<LatLng> latLongs) {
    return {
      "type": "FeatureCollection",
      "features": [MapService.buildLineStringFeature(latLongs)]
    };
  }

  static Map<String, dynamic> buildGeoJSONPolygon(List<LatLng> latLongs) {
    return {
      "type": "FeatureCollection",
      "features": [MapService.buildPolygonFeature(latLongs)]
    };
  }

  static void addRecordLayer(MapContainer mapContainer, String sourceId,
      String layerId, String mapType) {
    MapService.addPolygonLayer(mapContainer, sourceId, layerId,
        matchWithMainType: mapType == MapService.TypePolygon);
    MapService.addLineLayer(mapContainer, sourceId, layerId,
        matchWithMainType: mapType == MapService.TypeLine);
    MapService.addPointLayer(mapContainer, sourceId, layerId,
        matchWithMainType: mapType == MapService.TypePoint);
  }

  static void addHighlightLayer(
      MapContainer mapContainer, String sourceId, String layerId) {
    MapService.addPolygonLayer(mapContainer, sourceId, layerId,
        highlight: true);
    MapService.addLineLayer(mapContainer, sourceId, layerId, highlight: true);
    MapService.addPointLayer(mapContainer, sourceId, layerId, highlight: true);
  }

  static void addPointLayer(
      MapContainer mapContainer, String sourceId, String layerId,
      {bool matchWithMainType = true, bool highlight = false}) {
    final pointLayerId = '${layerId}_point';
    final color = highlight
        ? '#f44336'
        : matchWithMainType
            ? '#2196f3'
            : '#FF9F43';
    mapContainer.controller.addCircleLayer(
        sourceId,
        pointLayerId,
        CircleLayerProperties(
            circleColor: color,
            circleRadius: highlight ? 10 : 8,
            circleStrokeWidth: 2,
            circleStrokeColor: "#ffffff"),
        filter: [
          '==',
          ['geometry-type'],
          'Point'
        ]);
  }

  static void addLineLayer(
      MapContainer mapContainer, String sourceId, String layerId,
      {bool matchWithMainType = true, bool highlight = false}) {
    final lineLayerId = '${layerId}_line';
    final color = highlight
        ? '#f44336'
        : matchWithMainType
            ? '#2196f3'
            : '#FF9F43';
    mapContainer.controller.addLineLayer(
        sourceId,
        lineLayerId,
        LineLayerProperties(
            lineColor: color,
            lineWidth: 2,
            lineCap: 'round',
            lineJoin: 'round'),
        filter: [
          '==',
          ['geometry-type'],
          'LineString'
        ]);
  }

  static void addPolygonLayer(
      MapContainer mapContainer, String sourceId, String layerId,
      {bool matchWithMainType = true, bool highlight = false}) {
    final polygonLayerId = '${layerId}_polygon';
    final color = highlight
        ? '#f44336'
        : matchWithMainType
            ? '#2196f3'
            : '#FF9F43';
    mapContainer.controller.addFillLayer(
        sourceId,
        polygonLayerId,
        FillLayerProperties(
            fillColor: color,
            fillOpacity: highlight ? 1 : 0.5,
            fillOutlineColor: color),
        filter: [
          '==',
          ['geometry-type'],
          'Polygon'
        ]);
  }

  static Future<Position?> determineCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      return null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<LatLng?> getUserLocate() async {
    if (await HttpService.checkConnection()) {
      Position? userLocation = await determineCurrentPosition();
      if (userLocation != null) {
        return LatLng(userLocation.latitude, userLocation.longitude);
      }
    }
    return null;
  }

  static LatLng getCenter(Map<String, dynamic> json) {
    turf.GeoJSONObject geoJSONObject = turf.GeoJSONObject.fromJson(json);
    turf.Feature<turf.Point> point = turf.center(geoJSONObject);
    Map<String, dynamic> pointJson = point.toJson();
    return LatLng(pointJson['geometry']['coordinates'][1],
        pointJson['geometry']['coordinates'][0]);
  }
}
