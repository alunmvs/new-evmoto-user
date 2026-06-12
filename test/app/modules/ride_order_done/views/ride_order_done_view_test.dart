import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/modules/ride_order_done/controllers/ride_order_done_controller.dart';
import 'package:new_evmoto_user/app/modules/ride_order_done/views/ride_order_done_view.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RideOrderDoneView', () {
    late RideOrderDoneController controller;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          orderCompleted: 'Order Completed',
          pleaseMakePaymentAccording: 'Please pay the driver',
          travelExpense: 'Travel expense',
          total: 'Total',
        ),
      );
      registerMinimalHomeController();

      controller = TestRideOrderDoneController(
        orderRideRepository: MockOrderRideRepository(),
      );
      controller.isFetch.value = false;
      controller.orderRideDetail.value = OrderRide(
        orderNum: 'ORD-12345',
        licensePlate: 'B 1234 CD',
        brand: 'Toyota',
        carColor: 'White',
        driverName: 'Driver Name',
        driverAvatar: 'https://example.com/driver.png',
        score: 4.8,
        payMoney: 50000,
        additionalCharge: 0,
      );
      Get.put<RideOrderDoneController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders ride order done screen content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const GetMaterialApp(home: RideOrderDoneView()));
      await tester.pump();

      expect(find.text('Order Completed'), findsOneWidget);
      expect(find.text('ORD-12345'), findsOneWidget);
    });
  });
}
