import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/data/models/login_data_model.dart';
import 'package:new_evmoto_user/app/modules/login_register_verification_otp/controllers/login_register_verification_otp_controller.dart';
import 'package:new_evmoto_user/app/repositories/login_register_repository.dart';
import 'package:new_evmoto_user/app/repositories/otp_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/data/models/user_info_model.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import 'package:new_evmoto_user/app/services/user_services.dart';
import 'package:new_evmoto_user/main.dart';
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

  group('LoginRegisterVerificationOtpController Test', () {
    late LoginRegisterVerificationOtpController controller;
    late MockOtpRepository otpRepository;
    late MockLoginRegisterRepository loginRegisterRepository;
    late LanguageServices languageServices;
    late ThemeColorServices themeColorServices;
    late FakeLocationServices locationServices;
    late TestUserServices userServices;

    void registerDependencies() {
      themeColorServices = ThemeColorServices();
      Get.put<ThemeColorServices>(themeColorServices);

      languageServices = LanguageServices();
      languageServices.language.value = Language(
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

    LoginRegisterVerificationOtpController createController() {
      return LoginRegisterVerificationOtpController(
        otpRepository: otpRepository,
        loginRegisterRepository: loginRegisterRepository,
      );
    }

    setUp(() {
      registerDependencies();
      otpRepository = MockOtpRepository();
      loginRegisterRepository = MockLoginRegisterRepository();
      controller = createController();
    });

    tearDown(() {
      controller.otpProtectionTimer?.cancel();
      controller.onClose();
      Get.reset();
    });

    test(
      'should have empty initial state before onInit',
      () {
        expect(controller.isOTPInvalid.value, false);
        expect(controller.mobilePhone.value, '');
        expect(controller.otpCode.value, '');
        expect(controller.otpProtectionTimerSeconds.value, 0);
        expect(controller.isFetch.value, false);
      },
    );

    testWidgets(
      'should set mobilePhone from Get.arguments on onInit',
      (WidgetTester tester) async {
        Get.routing.args = {'mobile_phone': '628123456789'};

        when(
          () => otpRepository.requestOTP(
            language: any(named: 'language'),
            phone: any(named: 'phone'),
            type: any(named: 'type'),
          ),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: SizedBox())),
        );
        await controller.onInit();
        await tester.pump();
        await tester.pump();

        expect(controller.mobilePhone.value, '628123456789');
        expect(controller.isFetch.value, false);

        controller.otpProtectionTimer?.cancel();
      },
    );

    testWidgets(
      'should default mobilePhone to empty string when mobile_phone key is missing',
      (WidgetTester tester) async {
        Get.routing.args = {};

        when(
          () => otpRepository.requestOTP(
            language: any(named: 'language'),
            phone: any(named: 'phone'),
            type: any(named: 'type'),
          ),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: SizedBox())),
        );
        await controller.onInit();
        await tester.pump();
        await tester.pump();

        expect(controller.mobilePhone.value, '');

        controller.otpProtectionTimer?.cancel();
      },
    );

    testWidgets(
      'should call requestOTP with correct parameters and start protection timer',
      (WidgetTester tester) async {
        controller.mobilePhone.value = '628123456789';

        when(
          () => otpRepository.requestOTP(
            language: 2,
            phone: '628123456789',
            type: 2,
          ),
        ).thenAnswer((_) async {});

        await tester.pumpWidget(
          MaterialApp(
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            home: const Scaffold(body: SizedBox()),
          ),
        );

        await controller.requestOTP();
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
      },
    );

    testWidgets(
      'should handle DioException in requestOTP without throwing',
      (WidgetTester tester) async {
        controller.mobilePhone.value = '628123456789';

        when(
          () => otpRepository.requestOTP(
            language: any(named: 'language'),
            phone: any(named: 'phone'),
            type: any(named: 'type'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/otp'),
            error: 'Network error',
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            home: const Scaffold(body: SizedBox()),
          ),
        );

        await expectLater(controller.requestOTP(), completes);
      },
    );

    testWidgets(
      'should navigate to HOME after successful OTP submission',
      (WidgetTester tester) async {
        controller.mobilePhone.value = '628123456789';
        controller.otpCode.value = '123456';
        locationServices.fakeLatitude = -6.2;
        locationServices.fakeLongitude = 106.8;

        when(
          () => loginRegisterRepository.loginByOtp(
            phone: '628123456789',
            code: '123456',
            language: 2,
            lat: '-6.2',
            lng: '106.8',
          ),
        ).thenAnswer((_) async => LoginData(token: 'test-token'));

        await tester.pumpWidget(
          GetMaterialApp(
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => const Scaffold(body: SizedBox())),
              GetPage(
                name: Routes.HOME,
                page: () => const Scaffold(body: Text('Home')),
              ),
            ],
          ),
        );

        await controller.onSubmitOTP();
        await tester.pumpAndSettle();

        expect(Get.currentRoute, Routes.HOME);
        expect(userServices.getUserInfoCallCount, 1);
      },
    );

    testWidgets(
      'should not navigate to HOME when location is unavailable',
      (WidgetTester tester) async {
        controller.mobilePhone.value = '628123456789';
        controller.otpCode.value = '123456';
        locationServices.fakeLatitude = null;
        locationServices.fakeLongitude = null;

        await tester.pumpWidget(
          GetMaterialApp(
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => const Scaffold(body: SizedBox())),
              GetPage(
                name: Routes.HOME,
                page: () => const Scaffold(body: Text('Home')),
              ),
            ],
          ),
        );

        await controller.onSubmitOTP();
        await tester.pump();

        expect(Get.currentRoute, '/');
        verifyNever(
          () => loginRegisterRepository.loginByOtp(
            phone: any(named: 'phone'),
            code: any(named: 'code'),
            language: any(named: 'language'),
            lat: any(named: 'lat'),
            lng: any(named: 'lng'),
          ),
        );
      },
    );

    testWidgets(
      'should handle DioException in onSubmitOTP without throwing',
      (WidgetTester tester) async {
        controller.mobilePhone.value = '628123456789';
        controller.otpCode.value = '123456';
        locationServices.fakeLatitude = -6.2;
        locationServices.fakeLongitude = 106.8;

        when(
          () => loginRegisterRepository.loginByOtp(
            phone: any(named: 'phone'),
            code: any(named: 'code'),
            language: any(named: 'language'),
            lat: any(named: 'lat'),
            lng: any(named: 'lng'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/login'),
            error: 'Invalid OTP',
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            home: const Scaffold(body: SizedBox()),
          ),
        );

        await expectLater(controller.onSubmitOTP(), completes);
      },
    );

    test(
      'should clean up controller without error when onClose is called',
      () {
        expect(() => controller.onClose(), returnsNormally);
      },
    );
  });
}
