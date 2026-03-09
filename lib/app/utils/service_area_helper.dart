import 'dart:convert';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:point_in_polygon/point_in_polygon.dart';

bool isLatLngInsideServiceArea({
  required double latitude,
  required double longitude,
}) {
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  var evmotoServiceArea = jsonDecode(
    firebaseRemoteConfigServices.remoteConfig.getString('evmoto_service_area'),
  );

  var isInsideServiceArea = false;
  var point = Point(x: latitude, y: longitude);
  for (var features in evmotoServiceArea['features']) {
    var points = <Point>[];
    var coordinates = features['geometry']['coordinates'][0][0];
    for (var longLat in coordinates) {
      points.add(
        Point(
          x: double.parse(longLat[1].toString()),
          y: double.parse(longLat[0].toString()),
        ),
      );
    }

    var isPointInPolygon = Poly.isPointInPolygon(point, points);

    if (isPointInPolygon == true) {
      isInsideServiceArea = true;
    }
  }

  return isInsideServiceArea;
}
