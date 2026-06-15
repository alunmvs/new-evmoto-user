import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_pricing_model.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/controllers/create_order_ride_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/controllers/create_order_ride_checkout_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_promo/controllers/create_order_ride_promo_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_promo/views/create_order_ride_promo_view.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CreateOrderRidePromoView', () {
    late CreateOrderRidePromoController controller;
    late CreateOrderRideCheckoutController checkoutController;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          promo: 'Promo',
          promotionAvailable: 'Promotion available',
          validUntil: 'Valid until',
        ),
      );
      registerFakeLocationServices();
      registerMinimalHomeController();
      registerTestCreateOrderRideFlowControllers();

      checkoutController = Get.find<CreateOrderRideCheckoutController>();
      checkoutController.selectedOrderRidePricing.value = OrderRidePricing(
        priceNo: 'PRICE-1',
        amount: 30000,
      );

      controller = TestCreateOrderRidePromoController(
        couponRepository: MockCouponRepository(),
      );
      Get.put<CreateOrderRidePromoController>(controller);
      controller.isFetch.value = false;
      controller.couponList.value = [
        Coupon(
          id: 1,
          name: 'Promo 10%',
          state: 1,
          money: 10000,
          time: '31 Dec 2026',
        ),
      ];
    });

    tearDown(() {
      controller.onClose();
      checkoutController.onClose();
      final createOrderRideController = Get.find<CreateOrderRideController>();
      createOrderRideController.originTextEditingController.dispose();
      createOrderRideController.destinationTextEditingController.dispose();
      createOrderRideController.focusNodeOrigin.dispose();
      createOrderRideController.focusNodeDestination.dispose();
      createOrderRideController.onClose();
      Get.reset();
    });

    testWidgets('renders promo screen content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: CreateOrderRidePromoView()),
      );
      await tester.pump();

      expect(find.text('Promo'), findsOneWidget);
      expect(find.textContaining('Rp'), findsWidgets);
      expect(find.byType(CreateOrderRidePromoView), findsOneWidget);
    });
  });
}
