import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';

/// Lightweight [TypographyServices] for unit/widget tests.
/// Avoids [google_fonts] network fetches that fail in the test environment.
class TestTypographyServices extends GetxService implements TypographyServices {
  @override
  final headingLargeBold = const TextStyle(fontSize: 32).obs;

  @override
  final headingMediumBold = const TextStyle(fontSize: 24).obs;

  @override
  final headingSmallBold = const TextStyle(fontSize: 20).obs;

  @override
  final bodyLargeBold = const TextStyle(fontSize: 16).obs;

  @override
  final bodyLargeRegular = const TextStyle(fontSize: 16).obs;

  @override
  final bodySmallRegular = const TextStyle(fontSize: 14).obs;

  @override
  final bodySmallBold = const TextStyle(fontSize: 14).obs;

  @override
  final captionLargeBold = const TextStyle(fontSize: 12).obs;

  @override
  final captionLargeRegular = const TextStyle(fontSize: 12).obs;

  @override
  final captionSmallBold = const TextStyle(fontSize: 10).obs;

  @override
  final captionSmallRegular = const TextStyle(fontSize: 10).obs;
}

void registerTestTypographyServices() {
  Get.put<TypographyServices>(TestTypographyServices());
}
