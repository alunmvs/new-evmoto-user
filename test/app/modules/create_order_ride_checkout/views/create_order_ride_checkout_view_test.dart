import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_pricing_model.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/controllers/create_order_ride_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/controllers/create_order_ride_checkout_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/views/create_order_ride_checkout_view.dart';
import '../../../../helpers/fake_google_maps_flutter_platform.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  registerFakeGoogleMapsFlutterPlatform();

  group('CreateOrderRideCheckoutView', () {
    late CreateOrderRideCheckoutController controller;
    late CreateOrderRideController createOrderRideController;

    setUp(() {
      registerCoreTestServices();
      registerFakeLocationServices();
      registerMinimalHomeController();
      registerTestCreateOrderRideFlowControllers();

      createOrderRideController = Get.find<CreateOrderRideController>();
      controller = Get.find<CreateOrderRideCheckoutController>();
      controller.isFetch.value = false;
      controller.originAddressName.value = 'Pickup';
      controller.destinationAddressName.value = 'Dropoff';
      controller.selectedOrderRidePricing.value = OrderRidePricing(
        name: 'Standard',
        amount: 20000,
      );
    });

    tearDown(() {
      createOrderRideController.originTextEditingController.dispose();
      createOrderRideController.destinationTextEditingController.dispose();
      createOrderRideController.focusNodeOrigin.dispose();
      createOrderRideController.focusNodeDestination.dispose();
      createOrderRideController.onClose();
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders checkout screen scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: CreateOrderRideCheckoutView()),
      );
      await tester.pump();

      expect(find.byType(CreateOrderRideCheckoutView), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
