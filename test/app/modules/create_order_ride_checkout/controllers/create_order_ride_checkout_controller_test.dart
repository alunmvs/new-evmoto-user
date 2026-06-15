import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_pricing_model.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/controllers/create_order_ride_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/controllers/create_order_ride_checkout_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CreateOrderRideCheckoutController', () {
    late CreateOrderRideCheckoutController controller;
    late CreateOrderRideController createOrderRideController;

    setUp(() {
      registerCoreTestServices();
      registerFakeLocationServices();
      registerMinimalHomeController();
      registerTestCreateOrderRideFlowControllers();

      createOrderRideController = Get.find<CreateOrderRideController>();
      controller = Get.find<CreateOrderRideCheckoutController>();
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

    test('should have default initial state before onInit', () {
      expect(controller.payType.value, 3);
      expect(controller.orderRidePricingList, isEmpty);
      expect(controller.isFetch.value, false);
      expect(controller.isAdvanceOrderEnable.value, false);
      expect(controller.selectedCoupon.value.id, isNull);
    });

    testWidgets('should fill addresses from route arguments on onInit', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      Get.routing.args = {
        'origin_address_name': 'Pickup',
        'origin_address': 'Pickup Address',
        'origin_latitude': '-6.1',
        'origin_longitude': '106.8',
        'destination_address_name': 'Dropoff',
        'destination_address': 'Dropoff Address',
        'destination_latitude': '-6.2',
        'destination_longitude': '106.9',
      };
      controller.fillForm();
      await controller.generateMinMaxDateTimeAdvanceOrder();
      await controller.generateDateRecommendationList();
      controller.timeRecommendationList.value =
          await controller.generateTimeRecommendationList(
        selectedDate: controller.selectedDate.value!,
      );
      controller.selectedTime.value = controller.timeRecommendationList.first;
      await tester.pump();

      expect(controller.originAddressName.value, 'Pickup');
      expect(controller.destinationAddressName.value, 'Dropoff');
      expect(controller.originLatitude.value, '-6.1');
      expect(controller.destinationLatitude.value, '-6.2');
      expect(controller.selectedDate.value, isNotNull);
      expect(controller.selectedTime.value, isNotNull);
    });

    test('selectedOrderRidePricing can be set from create order ride flow', () {
      controller.selectedOrderRidePricing.value = OrderRidePricing(
        id: 1,
        priceNo: 'PRICE-1',
        amount: 25000,
      );

      expect(controller.selectedOrderRidePricing.value.priceNo, 'PRICE-1');
      expect(controller.selectedOrderRidePricing.value.amount, 25000);
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
