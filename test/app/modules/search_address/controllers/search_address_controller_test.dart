import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_place_model.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/search_address/controllers/search_address_controller.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import '../../../../helpers/test_dependencies.dart';

class MockGeocodingRepository extends Mock implements GeocodingRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SearchAddressController', () {
    late SearchAddressController controller;
    late MockGeocodingRepository geocodingRepository;

    setUp(() {
      registerCoreTestServices(language: Language(km: 'km'));
      registerFakeLocationServices(latitude: -6.1751, longitude: 106.8650);
      geocodingRepository = MockGeocodingRepository();
      controller = SearchAddressController(
        geocodingRepository: geocodingRepository,
      );
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state before onInit', () {
      expect(controller.addressType.value, 0);
      expect(controller.keyword.value, '');
      expect(controller.geocodingPlaceList, isEmpty);
      expect(controller.isEdit.value, false);
      expect(controller.isFetch.value, false);
      expect(controller.isFetchAddressSearch.value, false);
    });

    testWidgets('should set addressType from arguments on onInit', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {'address_type': 1};

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await controller.onInit();
      await tester.pump();

      expect(controller.addressType.value, 1);
      expect(controller.isEdit.value, false);
      expect(controller.isFetch.value, false);
    });

    testWidgets('should set isEdit true when address_type argument is missing', (
      WidgetTester tester,
    ) async {
      Get.routing.args = {};

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await controller.onInit();
      await tester.pump();

      expect(controller.isEdit.value, true);
    });

    test('should return formatted distance string in kilometers', () {
      final place = GeocodingPlace(
        customDistanceKm: 2.5,
        customDistanceM: 2500,
      );

      expect(controller.getDistanceString(geocodingPlace: place), '2.50 km');
    });

    test('should return formatted distance string in meters', () {
      final place = GeocodingPlace(
        customDistanceKm: 0.5,
        customDistanceM: 450,
      );

      expect(controller.getDistanceString(geocodingPlace: place), '450 m');
    });

    test('should clean up without error when onClose is called', () {
      controller.textEditingController = TextEditingController();
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
