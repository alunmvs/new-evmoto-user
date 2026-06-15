import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/ride_order_cancel/controllers/ride_order_cancel_controller.dart';
import 'package:new_evmoto_user/app/modules/ride_order_cancel/views/ride_order_cancel_view.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../../helpers/test_dependencies.dart';

class MockOrderRideRepository extends Mock implements OrderRideRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RideOrderCancelView', () {
    late RideOrderCancelController controller;
    late MockOrderRideRepository orderRideRepository;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          cancelOrder: 'Cancel Order',
          cancelOrderConfirmationTitle: 'Why are you cancelling?',
          cancelOrderConfirmationDescription: 'Additional notes',
          cancel: 'Cancel',
        ),
      );
      orderRideRepository = MockOrderRideRepository();
      controller = TestRideOrderCancelController(
        orderRideRepository: orderRideRepository,
      );
      controller.isFetch.value = false;
      Get.put<RideOrderCancelController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders cancel order screen content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: RideOrderCancelView()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cancel Order'), findsOneWidget);
      expect(find.text('Why are you cancelling?'), findsOneWidget);
      expect(find.byType(ReactiveForm), findsOneWidget);
    });
  });
}
