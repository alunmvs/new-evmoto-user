import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/ride_call_sendbird/controllers/ride_call_sendbird_controller.dart';
import 'package:new_evmoto_user/app/modules/ride_call_sendbird/views/ride_call_sendbird_view.dart';
import '../../../../helpers/test_dependencies.dart';

class TestRideCallSendbirdController extends RideCallSendbirdController {
  @override
  Future<void> onInit() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RideCallSendbirdView', () {
    late RideCallSendbirdController controller;

    setUp(() {
      registerCoreTestServices(
        language: Language(call: 'Call'),
      );
      registerSendbirdTestServices();
      controller = TestRideCallSendbirdController();
      controller.isFetch.value = false;
      controller.isCriticalError.value = false;
      controller.driverName.value = 'Andi Driver';
      controller.driverAvatarUrl.value = '';
      Get.put<RideCallSendbirdController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('renders call screen scaffold and key text when isFetch is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: RideCallSendbirdView()),
      );
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Call'), findsOneWidget);
      expect(find.text('Andi Driver'), findsOneWidget);
    });
  });
}
