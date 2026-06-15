import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/modules/login_register/controllers/login_register_controller.dart';
import 'package:new_evmoto_user/app/modules/login_register/views/login_register_view.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import '../../../../helpers/test_typography_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginRegisterView', () {
    late LoginRegisterController controller;

    void registerDependencies() {
      Get.put<ThemeColorServices>(ThemeColorServices());

      final languageServices = LanguageServices();
      languageServices.language.value = Language(
        loginTitle: 'Login to Evmoto',
        loginDescription: 'Enter your mobile number to continue',
        mobilePhone: 'Mobile Phone',
        loginButton: 'Continue',
        mustStartWith8: 'Phone number must start with 8',
        min8DigitMobilePhone: 'Minimum 8 digits',
        max15DigitMobilePhone: 'Maximum 15 digits',
        tncPrivacyConfirmation1: 'By continuing, you agree to our',
        tncPrivacyConfirmation2: 'and',
        termAndCondition: 'Terms & Conditions',
        privacyPolicy: 'Privacy Policy',
      );
      Get.put<LanguageServices>(languageServices);

      registerTestTypographyServices();
    }

    Future<void> pumpLoginRegisterView(
      WidgetTester tester, {
      List<GetPage<dynamic>>? getPages,
    }) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginRegisterView(),
          getPages: getPages ?? const [],
        ),
      );
      await tester.pumpAndSettle();
    }

    setUp(() {
      registerDependencies();
      controller = LoginRegisterController();
      Get.put<LoginRegisterController>(controller);
    });

    tearDown(() {
      controller.onClose();
      controller.mobileNumberTextEditingController.dispose();
      Get.reset();
    });

    testWidgets('renders login screen content', (WidgetTester tester) async {
      await pumpLoginRegisterView(tester);

      expect(find.text('Login to Evmoto'), findsOneWidget);
      expect(find.text('Enter your mobile number to continue'), findsOneWidget);
      expect(find.text('Mobile Phone'), findsOneWidget);
      expect(find.text('+62'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('keeps submit button disabled when phone number is empty', (
      WidgetTester tester,
    ) async {
      await pumpLoginRegisterView(tester);

      final submitButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Continue'),
      );

      expect(submitButton.onPressed, isNull);
      expect(controller.isFormValid.value, isFalse);
    });

    testWidgets('enables submit button when phone number is valid', (
      WidgetTester tester,
    ) async {
      await pumpLoginRegisterView(tester);

      await tester.enterText(find.byType(TextFormField), '8123456789');
      await tester.pump();

      final submitButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Continue'),
      );

      expect(submitButton.onPressed, isNotNull);
      expect(controller.isFormValid.value, isTrue);
    });

    testWidgets('shows validation error when phone number does not start with 8', (
      WidgetTester tester,
    ) async {
      await pumpLoginRegisterView(tester);

      await tester.enterText(find.byType(TextFormField), '7123456789');
      await tester.pump();

      expect(find.text('Phone number must start with 8'), findsOneWidget);
      expect(controller.isFormValid.value, isFalse);
    });

    testWidgets('shows validation error when phone number has fewer than 8 digits', (
      WidgetTester tester,
    ) async {
      await pumpLoginRegisterView(tester);

      await tester.enterText(find.byType(TextFormField), '8123456');
      await tester.pump();

      expect(find.text('Minimum 8 digits'), findsOneWidget);
      expect(controller.isFormValid.value, isFalse);
    });

    testWidgets(
      'navigates to OTP verification page when submit is tapped with valid phone',
      (WidgetTester tester) async {
        Map<String, dynamic>? capturedArguments;

        await pumpLoginRegisterView(
          tester,
          getPages: [
            GetPage(
              name: Routes.LOGIN_REGISTER_VERIFICATION_OTP,
              page: () {
                capturedArguments = Get.arguments as Map<String, dynamic>?;
                return const Scaffold(body: Text('OTP Page'));
              },
            ),
          ],
        );

        await tester.enterText(find.byType(TextFormField), '8123 4567 89');
        await tester.pump();

        await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
        await tester.pumpAndSettle();

        expect(find.text('OTP Page'), findsOneWidget);
        expect(Get.currentRoute, Routes.LOGIN_REGISTER_VERIFICATION_OTP);
        expect(capturedArguments?['mobile_phone'], '628123456789');
      },
    );
  });
}
