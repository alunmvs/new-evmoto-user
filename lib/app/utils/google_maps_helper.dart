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

const double kDriverMapFarDistanceMeters = 3000.0;
const double kDriverMapNearDistanceMeters = 80.0;

double zoomLevelForSpanMeters(double distanceMeters) {
  if (distanceMeters <= 50) return 16;
  if (distanceMeters <= 200) return 15;
  if (distanceMeters <= 500) return 14;
  if (distanceMeters <= 1000) return 13;
  if (distanceMeters <= 3000) return 12;
  if (distanceMeters <= 10000) return 11;
  return 10;
}

/// Minimum map span used when fitting driver + destination.
/// Closer points use a tighter span so the camera auto-zooms in.
double minSpanMetersForDriverDestinationDistance(
  double distanceMeters, {
  double nearDistanceMeters = kDriverMapNearDistanceMeters,
  double farDistanceMeters = kDriverMapFarDistanceMeters,
}) {
  return distanceMeters.clamp(nearDistanceMeters, farDistanceMeters);
}

/// Fits the map to show both [driver] and [destination].
/// Zoom adjusts automatically as the driver approaches the destination.
Future<void> animateMapToDriverAndDestination(
  GoogleMapController controller, {
  required LatLng driver,
  required LatLng destination,
  double edgePadding = 48,
  double nearDistanceMeters = kDriverMapNearDistanceMeters,
  double farDistanceMeters = kDriverMapFarDistanceMeters,
}) async {
  final distanceMeters = Geolocator.distanceBetween(
    driver.latitude,
    driver.longitude,
    destination.latitude,
    destination.longitude,
  );

  await animateMapToFitPoints(
    controller,
    [driver, destination],
    edgePadding: edgePadding,
    minSpanMeters: minSpanMetersForDriverDestinationDistance(
      distanceMeters,
      nearDistanceMeters: nearDistanceMeters,
      farDistanceMeters: farDistanceMeters,
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
