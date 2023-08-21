import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:maplibre_gl/mapbox_gl.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/config/theme_config.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/localization_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/domain/services/navigation_helper.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/core/presentation/widgets/common_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/card_getter.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/map/map_controller.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/map/map_service.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/domain/services/map/map_widget.dart';
import 'package:pr_gis_bcm_in_2023_eam_mobile/eam/presentation/screens/classes/card_detail_screen.dart';
import 'package:turf/turf.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<StatefulWidget> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final mapKey = GlobalKey<MapWidgetState>();
  late MapContainer mapContainer;
  bool styleLoaded = false;
  late bool isCreateHighlightLayer = false;
  final String highlightSourceId = "highlight_source_id";
  final String highlightLayerId = "highlight_layer_id";
  List<Map<String, dynamic>> highlightFeatures = [];
  List<Map<String, dynamic>> listingFeatures = [];

  void onMapCreated(MapContainer mapContainer) {
    this.mapContainer = mapContainer;
  }

  void onMapClick(math.Point<double> point, LatLng latLng) async {
    showCardDetail(point);
  }

  void showCardDetail(math.Point<double> point) async {
    Rect rect = Rect.fromCenter(
        center: Offset(point.x, point.y), width: 30, height: 30);
    List<dynamic>? features = await mapContainer.controller
        .queryRenderedFeaturesInRect(rect, [], null);
    print(features?.length);
    if (features?.isNotEmpty ?? false) {
      highlightFeatures = [];

      for (Map<String, dynamic> feature in features!) {
        Map<String, dynamic> featureProperties =
            feature["properties"] as Map<String, dynamic>;

        ///If feature properties contains key IdClass -> this is eam feature
        if (featureProperties.containsKey("IdClass")) {
          highlightFeatures.add(feature);
          bool shouldAddToListCard = true;
          for (Map<String, dynamic> feature in listingFeatures) {
            if (CardGetter.getID(feature["properties"]) ==
                CardGetter.getID(featureProperties)) {
              shouldAddToListCard = false;
              break;
            }
          }
          if (shouldAddToListCard) listingFeatures.add(feature);
        }
      }
      createOrUpdateHighlightLayer(highlightFeatures);
      setState(() {});
    }
  }

  void createOrUpdateHighlightLayer(List<Map<String, dynamic>> features) {
    if (!isCreateHighlightLayer) {
      ///Create
      mapContainer.controller.addGeoJsonSource(highlightSourceId,
          {"type": "FeatureCollection", "features": features});
      MapService.addHighlightLayer(
          mapContainer, highlightSourceId, highlightLayerId);
      isCreateHighlightLayer = true;
    } else {
      ///Update
      mapContainer.controller.setGeoJsonSource(highlightSourceId,
          {"type": "FeatureCollection", "features": features});
    }
  }

  void onStyleLoadedCallback() async {
    styleLoaded = true;
  }

  void fitBounds(Map<String, dynamic>? geoJSON) {
    if (geoJSON != null) {
      BBox bounds = bbox(GeoJSONObject.fromJson(geoJSON));
      MapService.fitBoundsMap(
          mapContainer, MapService.convertBBoxToLatLngBounds(bounds.toList()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text(LocalizationService.translate.eam_map)),
        body: Stack(children: [
          Positioned.fill(
              child: MapWidget(
                  key: mapKey,
                  onMapCreated: (controller) => onMapCreated(controller),
                  onStyleLoadedCallback: onStyleLoadedCallback,
                  onMapClick: onMapClick)),
          if (listingFeatures.isNotEmpty)
            Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Container(
                    color: ThemeConfig.colorWhite,
                    width: double.infinity,
                    height: math.min(listingFeatures.length * 100 + 150, 300),
                    child: Column(children: [
                      Container(
                          color: ThemeConfig.appColorSecondary,
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    LocalizationService
                                        .translate.map_object_list,
                                    style: const TextStyle(
                                        color: ThemeConfig.colorWhite,
                                        fontSize: ThemeConfig.fontSize,
                                        fontWeight: FontWeight.bold)),
                                IconButton(
                                    onPressed: () {
                                      highlightFeatures = [];
                                      listingFeatures = [];
                                      createOrUpdateHighlightLayer([]);
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.close_rounded,
                                        color: ThemeConfig.colorWhite))
                              ])),
                      const Divider(height: 1),
                      Expanded(
                          child: PaddingWrapper(
                              child: ListView(shrinkWrap: true, children: [
                                for (int i = 0; i < listingFeatures.length; i++)
                                  Row(children: [
                                    Expanded(
                                        child: Text(
                                            "${i + 1}. ${CardGetter.getDescription(listingFeatures[i]["properties"])}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize:
                                                    ThemeConfig.fontSize))),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              fitBounds(listingFeatures[i]),
                                          icon: IconBuffer(Icons.location_on,
                                              iconColor:
                                                  ThemeConfig.appColorSecondary,
                                              iconSize: 16),
                                        ),
                                        IconButton(
                                            onPressed: () =>
                                                NavigationHelper.push(
                                                    CardDetailScreen(
                                                        card: listingFeatures[i]
                                                            ["properties"])),
                                            icon: IconBuffer(
                                                Icons.arrow_right_alt_rounded,
                                                iconColor: ThemeConfig
                                                    .appColorSecondary,
                                                iconSize: 16))
                                      ],
                                    )
                                  ])
                              ]),
                              all: 16))
                    ])))
        ]));
  }
}
