import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/data/models/login_data_model.dart';
import 'package:new_evmoto_user/app/data/models/user_info_model.dart';
import 'package:new_evmoto_user/app/modules/login_register_verification_otp/controllers/login_register_verification_otp_controller.dart';
import 'package:new_evmoto_user/app/modules/login_register_verification_otp/views/login_register_verification_otp_view.dart';
import 'package:new_evmoto_user/app/repositories/login_register_repository.dart';
import 'package:new_evmoto_user/app/repositories/otp_repository.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/user_services.dart';
import 'package:new_evmoto_user/main.dart';
import 'package:pinput/pinput.dart';
import '../../../../helpers/test_typography_services.dart';

class MockOtpRepository extends Mock implements OtpRepository {}

class MockLoginRegisterRepository extends Mock
    implements LoginRegisterRepository {}

class FakeLocationServices extends LocationServices {
  double? fakeLatitude;
  double? fakeLongitude;

  @override
  Future<void> requestLocation({bool? isSkipGeocodingAddress}) async {
    currentLatitude.value = fakeLatitude;
    currentLongitude.value = fakeLongitude;
  }
}

class TestUserServices extends GetxService implements UserServices {
  int getUserInfoCallCount = 0;

  @override
  final userInfo = UserInfo().obs;

  @override
  final isLoadingRefreshHome = false.obs;

  @override
  UserRepository get userRepository => throw UnimplementedError();

  @override
  LanguageServices get languageServices => Get.find<LanguageServices>();

  @override
  Future<void> getUserInfo() async {
    getUserInfoCallCount++;
  }

  @override
  Future<void> manualOnInit() async {}

  @override
  void clearUserInfo() {
    userInfo.value = UserInfo();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginRegisterVerificationOtpView', () {
    late LoginRegisterVerificationOtpController controller;
    late MockOtpRepository otpRepository;
    late MockLoginRegisterRepository loginRegisterRepository;
    late FakeLocationServices locationServices;
    late TestUserServices userServices;

    void registerDependencies() {
      Get.put<ThemeColorServices>(ThemeColorServices());

      final languageServices = LanguageServices();
      languageServices.language.value = Language(
        verificationOtpTitle: 'Verify OTP',
        verificationOtpDescription: 'Enter the code sent to',
        verificationOtpNotReceive: 'Did not receive the code?',
        verificationOtpResend: 'Resend',
        verificationOtpNotMatch: 'OTP does not match',
        snackbarOtpSuccess: 'OTP sent successfully',
      );
      languageServices.languageCodeSystem.value = 2;
      Get.put<LanguageServices>(languageServices);

      registerTestTypographyServices();

      locationServices = FakeLocationServices();
      Get.put<LocationServices>(locationServices);

      userServices = TestUserServices();
      Get.put<UserServices>(userServices);

      FlutterSecureStorage.setMockInitialValues({});
    }

    void mockRequestOtp() {
      when(
        () => otpRepository.requestOTP(
          language: any(named: 'language'),
          phone: any(named: 'phone'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async {});
    }

    void registerController({
      Map<String, dynamic> arguments = const {'mobile_phone': '628123456789'},
    }) {
      mockRequestOtp();
      Get.routing.args = arguments;
      controller = LoginRegisterVerificationOtpController(
        otpRepository: otpRepository,
        loginRegisterRepository: loginRegisterRepository,
      );
      Get.put<LoginRegisterVerificationOtpController>(controller);
    }

    Finder richTextContaining(String text) {
      return find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains(text),
      );
    }

    Future<void> pumpOtpView(
      WidgetTester tester, {
      List<GetPage<dynamic>>? getPages,
      void Function(LoginRegisterVerificationOtpController controller)?
      configureController,
    }) async {
      await tester.pumpWidget(
        GetMaterialApp(
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          home: const LoginRegisterVerificationOtpView(),
          getPages: getPages ?? const [],
        ),
      );

      await tester.pump();
      await tester.pump();
      controller.otpProtectionTimer?.cancel();

      configureController?.call(controller);
      await tester.pump();
    }

    setUp(() {
      registerDependencies();
      otpRepository = MockOtpRepository();
      loginRegisterRepository = MockLoginRegisterRepository();
      registerController();
    });

    tearDown(() {
      controller.otpProtectionTimer?.cancel();
      controller.onClose();
      Get.reset();
    });

    testWidgets('renders OTP verification screen content', (
      WidgetTester tester,
    ) async {
      await pumpOtpView(
        tester,
        configureController: (controller) {
          controller.otpProtectionTimerSeconds.value = 0;
        },
      );

      expect(find.text('Verify OTP'), findsOneWidget);
      expect(richTextContaining('Enter the code sent to'), findsOneWidget);
      expect(richTextContaining('+628123456789'), findsOneWidget);
      expect(find.byType(Pinput), findsOneWidget);
      expect(richTextContaining('Did not receive the code?'), findsOneWidget);
      expect(richTextContaining('Resend'), findsOneWidget);
    });

    testWidgets('shows loading indicator when isFetch is true', (
      WidgetTester tester,
    ) async {
      await pumpOtpView(
        tester,
        configureController: (controller) {
          controller.isFetch.value = true;
        },
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Pinput), findsNothing);
      expect(find.byType(BottomAppBar), findsNothing);
    });

    testWidgets('shows invalid OTP error when isOTPInvalid is true', (
      WidgetTester tester,
    ) async {
      await pumpOtpView(
        tester,
        configureController: (controller) {
          controller.isOTPInvalid.value = true;
          controller.otpProtectionTimerSeconds.value = 0;
        },
      );

      expect(find.text('OTP does not match'), findsOneWidget);
    });

    testWidgets('shows resend link when protection timer is zero', (
      WidgetTester tester,
    ) async {
      await pumpOtpView(
        tester,
        configureController: (controller) {
          controller.otpProtectionTimerSeconds.value = 0;
        },
      );

      expect(richTextContaining('Resend'), findsOneWidget);
      expect(richTextContaining('(0)'), findsNothing);
    });

    testWidgets('shows countdown when protection timer is active', (
      WidgetTester tester,
    ) async {
      await pumpOtpView(
        tester,
        configureController: (controller) {
          controller.otpProtectionTimerSeconds.value = 45;
        },
      );

      expect(richTextContaining('(45)'), findsOneWidget);
      expect(richTextContaining('Resend'), findsNothing);
    });

    testWidgets('calls requestOTP when resend is tapped', (
      WidgetTester tester,
    ) async {
      await pumpOtpView(
        tester,
        configureController: (controller) {
          controller.otpProtectionTimerSeconds.value = 0;
        },
      );

      clearInteractions(otpRepository);
      mockRequestOtp();

      final bottomRichText = tester.widget<RichText>(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains('Did not receive the code?'),
        ),
      );
      final bottomTextSpan = bottomRichText.text as TextSpan;
      final resendSpan = bottomTextSpan.children!.singleWhere(
        (span) => span is TextSpan && span.text == 'Resend',
      ) as TextSpan;
      (resendSpan.recognizer as TapGestureRecognizer).onTap!();
      await tester.pump();

      verify(
        () => otpRepository.requestOTP(
          language: 2,
          phone: '628123456789',
          type: 2,
        ),
      ).called(1);
      expect(controller.otpProtectionTimerSeconds.value, 60);

      controller.otpProtectionTimer?.cancel();
    });

    testWidgets('submits OTP and navigates to HOME when PIN is completed', (
      WidgetTester tester,
    ) async {
      locationServices.fakeLatitude = -6.2;
      locationServices.fakeLongitude = 106.8;

      when(
        () => loginRegisterRepository.loginByOtp(
          phone: '628123456789',
          code: '1234',
          language: 2,
          lat: '-6.2',
          lng: '106.8',
        ),
      ).thenAnswer((_) async => LoginData(token: 'test-token'));

      await pumpOtpView(
        tester,
        getPages: [
          GetPage(
            name: Routes.HOME,
            page: () => const Scaffold(body: Text('Home')),
          ),
        ],
        configureController: (controller) {
          controller.otpProtectionTimerSeconds.value = 0;
        },
      );

      await tester.enterText(find.byType(Pinput), '1234');
      await tester.pump();
      await tester.pump();

      expect(controller.otpCode.value, '1234');
      expect(Get.currentRoute, Routes.HOME);
      expect(userServices.getUserInfoCallCount, 1);
    });
  });
}
