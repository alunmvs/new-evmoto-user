import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/views/ride_order_detail_view.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import '../../../../helpers/fake_google_maps_flutter_platform.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  registerFakeGoogleMapsFlutterPlatform();

  group('RideOrderDetailView', () {
    late RideOrderDetailController controller;

    setUp(() {
      registerTestRideOrderDetailServices();
      Get.find<LanguageServices>().language.value = Language(
        orderId: 'Order ID',
        cancel: 'Cancel',
        chatDriver: 'Chat Driver',
      );
      controller = createTestRideOrderDetailController();
      controller.isFetch.value = false;
      controller.isCriticalError.value = false;
      controller.state.value = 1;
      controller.orderRideDetail.value = OrderRide(
        orderNum: 'ORD-LIVE-001',
        driverName: 'Andi Driver',
        licensePlate: 'B 5678 EF',
        state: 1,
      );
      Get.put<RideOrderDetailController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders ride order detail scaffold when isFetch is false', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const GetMaterialApp(home: RideOrderDetailView()),
      );
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
