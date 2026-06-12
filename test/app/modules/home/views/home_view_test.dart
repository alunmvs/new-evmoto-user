import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/account/controllers/account_controller.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/modules/home/views/home_view.dart';
import 'package:new_evmoto_user/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/repositories/otp_repository.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import '../../../../helpers/fake_google_maps_flutter_platform.dart';
import '../../../../helpers/test_dependencies.dart';

const _homeViewTestSize = Size(1080, 1920);

class MockAdvanceBookingRepository extends Mock
    implements AdvanceBookingRepository {}

class MockOtpRepository extends Mock implements OtpRepository {}

class TestActivityController extends ActivityController {
  TestActivityController({
    required super.orderRideRepository,
    required super.advancedBookingRepository,
  });

  @override
  Future<void> onInit() async {
    tabController = TabController(length: 2, vsync: this);
    isFetch.value = false;
  }
}

class TestAccountController extends AccountController {
  TestAccountController({
    required super.otpRepository,
    required super.userRepository,
    required super.orderRideRepository,
  });

  @override
  Future<void> onInit() async {}
}

void main() {
  registerFakeGoogleMapsFlutterPlatform();

  group('HomeView', () {
    late HomeController homeController;
    late ActivityController activityController;
    late AccountController accountController;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          home: 'Home',
          activity: 'Activity',
          account: 'Account',
          homeRideReadyToGoHint: 'Where are you going today?',
          nearestDriverNotAvailable: 'No drivers nearby',
        ),
      );
      registerTestUserServices();
      registerFakeLocationServices();
      registerHomeInfrastructureServices();

      homeController = createTestHomeController();
      homeController.isFetch.value = false;
      homeController.driverNearbyList.clear();
      Get.put<HomeController>(homeController);

      activityController = TestActivityController(
        orderRideRepository: MockOrderRideRepository(),
        advancedBookingRepository: MockAdvanceBookingRepository(),
      );
      Get.put<ActivityController>(activityController);

      accountController = TestAccountController(
        otpRepository: MockOtpRepository(),
        userRepository: MockUserRepository(),
        orderRideRepository: MockOrderRideRepository(),
      );
      Get.put<AccountController>(accountController);
    });

    tearDown(() {
      homeController.onClose();
      activityController.onClose();
      accountController.onClose();
      Get.reset();
    });

    testWidgets('renders home screen scaffold and key text when isFetch is false', (
      WidgetTester tester,
    ) async {
      final binding = tester.view;
      binding.physicalSize = _homeViewTestSize;
      binding.devicePixelRatio = 1.0;
      addTearDown(binding.resetPhysicalSize);

      await tester.pumpWidget(const GetMaterialApp(home: HomeView()));
      await tester.pump();

      expect(find.byType(Scaffold), findsWidgets);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Activity'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
    });
  });
}
