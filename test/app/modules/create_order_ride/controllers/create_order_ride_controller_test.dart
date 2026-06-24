import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_address_model.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/controllers/create_order_ride_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CreateOrderRideController', () {
    late CreateOrderRideController controller;
    late MockGeocodingRepository geocodingRepository;
    late MockSavedAddressRepository savedAddressRepository;
    late MockOrderRideRepository orderRideRepository;

    setUp(() {
      registerCoreTestServices();
      registerFakeLocationServices(latitude: -6.1751, longitude: 106.8650);

      geocodingRepository = MockGeocodingRepository();
      savedAddressRepository = MockSavedAddressRepository();
      orderRideRepository = MockOrderRideRepository();

      when(() => savedAddressRepository.getSavedAddressList())
          .thenAnswer((_) async => []);

      when(
        () => orderRideRepository.getHistoryOrderList(
          language: any(named: 'language'),
          pageNum: any(named: 'pageNum'),
          size: any(named: 'size'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => []);

      when(
        () => geocodingRepository.searchGeocodingPlacesByQuery(
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => []);

      controller = CreateOrderRideController(
        geocodingRepository: geocodingRepository,
        savedAddressRepository: savedAddressRepository,
        orderRideRepository: orderRideRepository,
      );
    });

    tearDown(() {
      controller.originTextEditingController.dispose();
      controller.destinationTextEditingController.dispose();
      controller.focusNodeOrigin.dispose();
      controller.focusNodeDestination.dispose();
      controller.onClose();
      Get.reset();
    });

    test('should have empty location fields before onInit', () {
      expect(controller.originLatitude.value, '');
      expect(controller.originLongitude.value, '');
      expect(controller.destinationLatitude.value, '');
      expect(controller.destinationLongitude.value, '');
      expect(controller.isFetch.value, false);
      expect(controller.isOriginHasPrimaryFocus.value, false);
      expect(controller.isDestinationHasPrimaryFocus.value, false);
    });

    testWidgets('should load saved addresses and history on onInit', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await controller.onInit();
      await tester.pump();

      expect(controller.isFetch.value, false);
      expect(controller.savedAddressList, isEmpty);
      expect(controller.historyOrderList, isEmpty);
    });

    test('should fill origin address from geocoding API using route coordinates',
        () async {
      when(
        () => geocodingRepository.getAddressByLatitudeLongitude(
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        ),
      ).thenAnswer(
        (_) async => GeocodingAddress(
          address: 'Origin Address',
          name: 'Origin Place',
        ),
      );

      Get.routing.args = {
        'is_origin_auto_select': true,
        'origin_latitude': '-6.1',
        'origin_longitude': '106.8',
      };

      await controller.fillForm();

      expect(controller.originAddressName.value, 'Origin Place');
      expect(controller.originAddress.value, 'Origin Address');
      expect(controller.originLatitude.value, '-6.1');
      expect(controller.destinationAddressName.value, '');
      verify(
        () => geocodingRepository.getAddressByLatitudeLongitude(
          latitude: -6.1,
          longitude: 106.8,
        ),
      ).called(1);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
