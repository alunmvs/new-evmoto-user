import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:turf/nearest_point_on_line.dart';
import 'package:turf/turf.dart' as turf;
import 'package:turf/helpers.dart';

Map<String, dynamic> getClosestPointIndex(
  LatLng driverPos,
  List<LatLng> points,
) {
  double minDistance = double.infinity;
  int index = 0;

  for (int i = 0; i < points.length; i++) {
    double distance = Geolocator.distanceBetween(
      driverPos.latitude,
      driverPos.longitude,
      points[i].latitude,
      points[i].longitude,
    );
    if (distance < minDistance) {
      minDistance = distance;
      index = i;
    }
  }

  return {'index': index, 'min_distance': minDistance};
}

double getDistanceFromRoute(LatLng driver, List<LatLng> routePoints) {
  var lineString = turf.LineString(
    coordinates: [
      for (var p in routePoints) turf.Position(p.longitude, p.latitude),
    ],
  );

  var point = turf.Point(
    coordinates: turf.Position(driver.longitude, driver.latitude),
  );

  var nearest = nearestPointOnLine(lineString, point);
  var distance = turf.distance(point, nearest.geometry!, Unit.meters);

  return distance.toDouble();
}
