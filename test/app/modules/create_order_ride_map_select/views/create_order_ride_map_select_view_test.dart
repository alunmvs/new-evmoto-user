import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_map_select/controllers/create_order_ride_map_select_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_map_select/views/create_order_ride_map_select_view.dart';
import '../../../../helpers/fake_google_maps_flutter_platform.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  registerFakeGoogleMapsFlutterPlatform();

  group('CreateOrderRideMapSelectView', () {
    late CreateOrderRideMapSelectController controller;

    setUp(() {
      registerCoreTestServices();
      controller = CreateOrderRideMapSelectController(
        geocodingRepository: MockGeocodingRepository(),
        driverNearbyRepository: MockDriverNearbyRepository(),
      );
      controller.isFetch.value = true;
      controller.type.value = 'origin';
      Get.put<CreateOrderRideMapSelectController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders map select loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: CreateOrderRideMapSelectView()),
      );
      await tester.pump();

      expect(find.byType(CreateOrderRideMapSelectView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
