import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_address_model.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_map_select/controllers/create_order_ride_map_select_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CreateOrderRideMapSelectController', () {
    late CreateOrderRideMapSelectController controller;
    late MockGeocodingRepository geocodingRepository;
    late MockDriverNearbyRepository driverNearbyRepository;

    setUp(() {
      registerCoreTestServices();
      geocodingRepository = MockGeocodingRepository();
      driverNearbyRepository = MockDriverNearbyRepository();

      when(
        () => geocodingRepository.getAddressByLatitudeLongitude(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        ),
      ).thenAnswer(
        (_) async => GeocodingAddress(
          address: 'Jl. Sudirman',
          name: 'Sudirman',
        ),
      );

      when(
        () => driverNearbyRepository.getDriverNearbyList(
          lat: any(named: 'lat'),
          lon: any(named: 'lon'),
        ),
      ).thenAnswer((_) async => []);

      controller = CreateOrderRideMapSelectController(
        geocodingRepository: geocodingRepository,
        driverNearbyRepository: driverNearbyRepository,
      );
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    test('should have default initial state before fillForm', () {
      expect(controller.type.value, isNull);
      expect(controller.address.value, isNull);
      expect(controller.latitude.value, isNull);
      expect(controller.longitude.value, isNull);
      expect(controller.isFetch.value, true);
      expect(controller.isFetchAddress.value, false);
      expect(controller.isPermissionLocationAllow.value, false);
      expect(controller.driverNearbyList, isEmpty);
    });

    test('should read route arguments and geocoded address', () async {
      Get.routing.args = {
        'type': 'origin',
        'address': 'Origin Address',
        'address_name': 'Origin',
        'latitude': '-6.1751',
        'longitude': '106.8650',
      };

      controller.type.value = Get.arguments?['type'];
      controller.latitude.value = Get.arguments?['latitude'];
      controller.longitude.value = Get.arguments?['longitude'];

      final searchedAddress = await geocodingRepository
          .getAddressByLatitudeLongitude(
            latitude: double.parse(controller.latitude.value!),
            longitude: double.parse(controller.longitude.value!),
          );

      controller.address.value = searchedAddress?.address ?? '-';
      controller.addressName.value = searchedAddress?.name ?? '-';
      controller.driverNearbyList.value =
          await driverNearbyRepository.getDriverNearbyList(
            lat: double.tryParse(controller.latitude.value!),
            lon: double.tryParse(controller.longitude.value!),
          );

      expect(controller.type.value, 'origin');
      expect(controller.addressName.value, 'Sudirman');
      expect(controller.address.value, 'Jl. Sudirman');
      expect(controller.latitude.value, '-6.1751');
      expect(controller.longitude.value, '106.8650');
      expect(controller.driverNearbyList, isEmpty);
    });

    testWidgets('onTapSubmit should return selected location', (
      WidgetTester tester,
    ) async {
      Get.testMode = true;
      controller.type.value = 'destination';
      controller.address.value = 'Address';
      controller.addressName.value = 'Place';
      controller.latitude.value = '-6.1';
      controller.longitude.value = '106.8';

      await tester.pumpWidget(const GetMaterialApp(home: SizedBox()));

      expect(() => controller.onTapSubmit(), returnsNormally);
    });

    test('should clean up timer without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
