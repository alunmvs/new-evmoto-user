import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login_register/bindings/login_register_binding.dart';
import '../modules/login_register/views/login_register_view.dart';
import '../modules/login_register_verification_otp/bindings/login_register_verification_otp_binding.dart';
import '../modules/login_register_verification_otp/views/login_register_verification_otp_view.dart';
import '../modules/onboarding_introduction/bindings/onboarding_introduction_binding.dart';
import '../modules/onboarding_introduction/views/onboarding_introduction_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.ONBOARDING_INTRODUCTION,
      page: () => const OnboardingIntroductionView(),
      binding: OnboardingIntroductionBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.LOGIN_REGISTER,
      page: () => const LoginRegisterView(),
      binding: LoginRegisterBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.LOGIN_REGISTER_VERIFICATION_OTP,
      page: () => const LoginRegisterVerificationOtpView(),
      binding: LoginRegisterVerificationOtpBinding(),
    ),
  ];
}
