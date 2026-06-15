import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_pricing_model.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/controllers/create_order_ride_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/controllers/create_order_ride_checkout_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_promo/controllers/create_order_ride_promo_controller.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CreateOrderRidePromoController', () {
    late CreateOrderRidePromoController controller;
    late CreateOrderRideCheckoutController checkoutController;
    late MockCouponRepository couponRepository;

    setUp(() {
      registerCoreTestServices();
      registerFakeLocationServices();
      registerMinimalHomeController();
      registerTestCreateOrderRideFlowControllers();

      checkoutController = Get.find<CreateOrderRideCheckoutController>();
      checkoutController.selectedOrderRidePricing.value = OrderRidePricing(
        priceNo: 'PRICE-1',
        amount: 30000,
      );

      controller = CreateOrderRidePromoController(
        couponRepository: couponRepository = MockCouponRepository(),
      );
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

    test('should have default initial state before onInit', () {
      expect(controller.selectedCouponId.value, isNull);
      expect(controller.couponList, isEmpty);
      expect(controller.isFetch.value, false);
      expect(controller.isSeeMoreCouponList.value, true);
      expect(controller.pageNum.value, 1);
    });

    testWidgets('should load coupon list on onInit', (WidgetTester tester) async {
      when(
        () => couponRepository.getCouponList(
          language: any(named: 'language'),
          pageNum: any(named: 'pageNum'),
          size: any(named: 'size'),
          state: any(named: 'state'),
          priceNo: any(named: 'priceNo'),
          amount: any(named: 'amount'),
        ),
      ).thenAnswer(
        (_) async => [Coupon(id: 1, name: 'Promo 10%', state: 1)],
      );

      Get.routing.args = {'selected_coupon': Coupon(id: 1)};

      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await controller.onInit();
      await tester.pump();

      expect(controller.isFetch.value, false);
      expect(controller.couponList.length, 1);
      expect(controller.selectedCouponId.value, 1);
      expect(controller.couponList.first.name, 'Promo 10%');
    });

    test('should clean up without error when onClose is called', () {
      expect(() => controller.onClose(), returnsNormally);
    });
  });
}
