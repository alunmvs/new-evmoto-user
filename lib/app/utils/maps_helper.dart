import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import 'package:new_evmoto_user/app/utils/google_maps_helper.dart';

import '../services/language_services.dart';

Future<double> getEstimatedDistanceInKm({
  required double originLat,
  required double originLon,
  required double destinationLat,
  required double destinationLon,
}) async {
  var openMapsRepository = OpenMapsRepository();

  var openMapDirection = await openMapsRepository.getDirection(
    originLatitude: originLat.toString(),
    originLongitude: originLon.toString(),
    destinationLatitude: destinationLat.toString(),
    destinationLongitude: destinationLon.toString(),
  );

  var polylineCoordinates = openMapDirection
      .routes!
      .first
      .geometry!
      .coordinates!
      .map((p) => LatLng(p[1], p[0]))
      .toList();

  return calculateTotalDistance(polylineCoordinates);
}

Future<double> getEstimatedTimeInMinutes({
  required double originLat,
  required double originLon,
  required double destinationLat,
  required double destinationLon,
  required double estimatedSpeedInKmh,
}) async {
  var openMapsRepository = OpenMapsRepository();

  var openMapDirection = await openMapsRepository.getDirection(
    originLatitude: originLat.toString(),
    originLongitude: originLon.toString(),
    destinationLatitude: destinationLat.toString(),
    destinationLongitude: destinationLon.toString(),
  );

  var polylineCoordinates = openMapDirection
      .routes!
      .first
      .geometry!
      .coordinates!
      .map((p) => LatLng(p[1], p[0]))
      .toList();

  var estimatedDistanceInKm = calculateTotalDistance(polylineCoordinates);

  return (estimatedDistanceInKm / estimatedSpeedInKmh) * 60;
}

String getEstimatedTimeInMinutesInText({
  required double estimatedTimeInMinutes,
}) {
  var languageServices = Get.find<LanguageServices>();

  int jam = estimatedTimeInMinutes ~/ 60;
  int menit = (estimatedTimeInMinutes % 60).round();

  if (jam > 0) {
    return '$jam ${languageServices.language.value.hour} $menit ${languageServices.language.value.minute}';
  } else {
    return '$menit ${languageServices.language.value.minute}';
  }
}
