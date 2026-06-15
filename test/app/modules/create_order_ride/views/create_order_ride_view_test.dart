import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/controllers/create_order_ride_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/views/create_order_ride_view.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CreateOrderRideView', () {
    late CreateOrderRideController controller;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          back: 'Back',
          selectViaMap: 'Select via Map',
          enterPickupLocation: 'Enter pickup location',
          enterDestinationLocation: 'Enter destination',
        ),
      );
      registerFakeLocationServices();

      controller = CreateOrderRideController(
        geocodingRepository: MockGeocodingRepository(),
        savedAddressRepository: MockSavedAddressRepository(),
        orderRideRepository: MockOrderRideRepository(),
      );
      controller.isFetch.value = false;
      Get.put<CreateOrderRideController>(controller);
    });

    tearDown(() {
      controller.originTextEditingController.dispose();
      controller.destinationTextEditingController.dispose();
      controller.focusNodeOrigin.dispose();
      controller.focusNodeDestination.dispose();
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders create order ride screen content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const GetMaterialApp(home: CreateOrderRideView()));
      await tester.pumpAndSettle();

      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Select via Map'), findsOneWidget);
      expect(find.text('Enter pickup location'), findsOneWidget);
      expect(find.text('Enter destination'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    });
  });
}
