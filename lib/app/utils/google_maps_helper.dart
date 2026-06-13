import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:turf/nearest_point_on_line.dart';
import 'package:turf/turf.dart' as turf;
import 'package:turf/helpers.dart';

LatLngBounds latLngBoundsFromPoints(
  List<LatLng> points, {
  double minSpanMeters = 300,
}) {
  var minLat = points.first.latitude;
  var maxLat = points.first.latitude;
  var minLng = points.first.longitude;
  var maxLng = points.first.longitude;

  for (final point in points) {
    minLat = math.min(minLat, point.latitude);
    maxLat = math.max(maxLat, point.latitude);
    minLng = math.min(minLng, point.longitude);
    maxLng = math.max(maxLng, point.longitude);
  }

  final latSpanMeters = Geolocator.distanceBetween(
    minLat,
    minLng,
    maxLat,
    minLng,
  );
  final lngSpanMeters = Geolocator.distanceBetween(
    minLat,
    minLng,
    minLat,
    maxLng,
  );
  final maxSpanMeters = math.max(latSpanMeters, lngSpanMeters);

  if (maxSpanMeters < minSpanMeters) {
    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;
    final latDelta = (minSpanMeters / 111320) / 2;
    final lngDelta =
        latDelta / math.cos(centerLat * math.pi / 180).abs().clamp(0.01, 1.0);

    minLat = centerLat - latDelta;
    maxLat = centerLat + latDelta;
    minLng = centerLng - lngDelta;
    maxLng = centerLng + lngDelta;
  }

  return LatLngBounds(
    southwest: LatLng(minLat, minLng),
    northeast: LatLng(maxLat, maxLng),
  );
}

double zoomLevelForSpanMeters(double distanceMeters) {
  if (distanceMeters <= 50) return 16;
  if (distanceMeters <= 200) return 15;
  if (distanceMeters <= 500) return 14;
  if (distanceMeters <= 1000) return 13;
  if (distanceMeters <= 3000) return 12;
  if (distanceMeters <= 10000) return 11;
  return 10;
}

double zoomLevelForRouteLookAhead(double lookAheadMeters) {
  if (lookAheadMeters <= 150) return 17.5;
  if (lookAheadMeters <= 300) return 17;
  if (lookAheadMeters <= 450) return 16.5;
  if (lookAheadMeters <= 600) return 16;
  if (lookAheadMeters <= 900) return 15.5;
  return 15;
}

double getRouteLookAheadMeters(
  LatLng driver,
  List<LatLng> route, {
  double maxLookAheadMeters = 1200,
  double minLookAheadMeters = 400,
}) {
  if (route.isEmpty) return minLookAheadMeters;

  final closest = getClosestPointIndex(driver, route);
  final startIndex = closest['index'] as int;

  var cumulative = Geolocator.distanceBetween(
    driver.latitude,
    driver.longitude,
    route[startIndex].latitude,
    route[startIndex].longitude,
  );

  for (var i = startIndex + 1; i < route.length; i++) {
    cumulative += Geolocator.distanceBetween(
      route[i - 1].latitude,
      route[i - 1].longitude,
      route[i].latitude,
      route[i].longitude,
    );
    if (cumulative >= maxLookAheadMeters) {
      return maxLookAheadMeters;
    }
  }

  return cumulative.clamp(minLookAheadMeters, maxLookAheadMeters);
}

double? bearingAlongRoute(
  LatLng driver,
  List<LatLng> route, {
  double bearingLookAheadMeters = 80,
}) {
  if (route.length < 2) return null;

  final closest = getClosestPointIndex(driver, route);
  final startIndex = closest['index'] as int;
  var traveled = 0.0;

  for (var i = startIndex + 1; i < route.length; i++) {
    traveled += Geolocator.distanceBetween(
      route[i - 1].latitude,
      route[i - 1].longitude,
      route[i].latitude,
      route[i].longitude,
    );
    if (traveled >= bearingLookAheadMeters) {
      return Geolocator.bearingBetween(
        driver.latitude,
        driver.longitude,
        route[i].latitude,
        route[i].longitude,
      );
    }
  }

  final destination = route.last;
  return Geolocator.bearingBetween(
    driver.latitude,
    driver.longitude,
    destination.latitude,
    destination.longitude,
  );
}

Future<void> animateMapToDriverWithRoute(
  GoogleMapController controller, {
  required LatLng driver,
  required List<LatLng> routePoints,
  double maxLookAheadMeters = 500,
  double minLookAheadMeters = 200,
  double defaultZoom = 17,
}) async {
  final lookAheadMeters = routePoints.isEmpty
      ? minLookAheadMeters
      : getRouteLookAheadMeters(
          driver,
          routePoints,
          maxLookAheadMeters: maxLookAheadMeters,
          minLookAheadMeters: minLookAheadMeters,
        );

  final zoom = routePoints.isEmpty
      ? defaultZoom
      : zoomLevelForRouteLookAhead(lookAheadMeters);
  final bearing = bearingAlongRoute(driver, routePoints);

  await controller.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(
        target: driver,
        zoom: zoom,
        bearing: bearing ?? 0,
      ),
    ),
  );
}

Future<void> animateMapToFitPoints(
  GoogleMapController controller,
  List<LatLng> points, {
  double edgePadding = 48,
  double minSpanMeters = 300,
}) async {
  if (points.isEmpty) return;

  final bounds = latLngBoundsFromPoints(
    points,
    minSpanMeters: minSpanMeters,
  );

  try {
    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, edgePadding),
    );
  } catch (_) {
    final center = LatLng(
      (bounds.southwest.latitude + bounds.northeast.latitude) / 2,
      (bounds.southwest.longitude + bounds.northeast.longitude) / 2,
    );
    final spanMeters = Geolocator.distanceBetween(
      bounds.southwest.latitude,
      bounds.southwest.longitude,
      bounds.northeast.latitude,
      bounds.northeast.longitude,
    );

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: center,
          zoom: zoomLevelForSpanMeters(spanMeters),
        ),
      ),
    );
  }
}

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
  if (routePoints.length < 2) {
    return 0.0;
  }

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

LatLngBounds getBoundsFromLatLngList(List<LatLng> list) {
  assert(list.isNotEmpty);
  double? x0, x1, y0, y1;
  for (LatLng latLng in list) {
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
  return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
}
