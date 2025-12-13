import 'dart:math';

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

double calculateTotalDistance(List<LatLng> polylineList) {
  double totalDistance = 0.0;

  for (int i = 0; i < polylineList.length - 1; i++) {
    totalDistance += _calculateDistance(
      polylineList[i].latitude,
      polylineList[i].longitude,
      polylineList[i + 1].latitude,
      polylineList[i + 1].longitude,
    );
  }

  return totalDistance;
}

double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371;

  double dLat = _degToRad(lat2 - lat1);
  double dLon = _degToRad(lon2 - lon1);

  double a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_degToRad(lat1)) *
          cos(_degToRad(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}

double _degToRad(double degree) {
  return degree * (pi / 180);
}
