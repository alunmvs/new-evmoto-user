import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/data/models/user_info_model.dart';
import 'package:new_evmoto_user/app/modules/account/controllers/account_controller.dart';
import 'package:new_evmoto_user/app/modules/account/views/account_view.dart';
import '../../../../helpers/test_dependencies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AccountView', () {
    late AccountController controller;

    setUp(() {
      registerCoreTestServices(
        language: Language(
          settingLanguage: 'Language',
          customerService: 'Customer Service',
          termAndCondition: 'Terms & Conditions',
          privacyPolicy: 'Privacy Policy',
          checkForUpdates: 'Check for Updates',
          manageAccount: 'Manage Account',
          appVersion: 'App Version',
        ),
      );
      registerMinimalHomeController(
        userInfo: UserInfo(name: 'John Doe', phone: '628123456789'),
      );

      controller = TestAccountController(
        otpRepository: MockOtpRepository(),
        userRepository: MockUserRepository(),
        orderRideRepository: MockOrderRideRepository(),
      );
      controller.isFetch.value = false;
      controller.packageVersion.value = '1.2.10';
      Get.put<AccountController>(controller);
    });

    tearDown(() {
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders account screen content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(home: Scaffold(body: AccountView())),
      );
      await tester.pump();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('+628123456789'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Customer Service'), findsOneWidget);
      expect(find.text('Terms & Conditions'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Check for Updates'), findsOneWidget);
      expect(find.text('Manage Account'), findsOneWidget);
      expect(find.textContaining('App Version'), findsOneWidget);
    });
  });
}
