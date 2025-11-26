import 'package:get/get.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/activity/bindings/activity_binding.dart';
import '../modules/activity/views/activity_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/introduction_delivery_service/bindings/introduction_delivery_service_binding.dart';
import '../modules/introduction_delivery_service/views/introduction_delivery_service_view.dart';
import '../modules/introduction_food_service/bindings/introduction_food_service_binding.dart';
import '../modules/introduction_food_service/views/introduction_food_service_view.dart';
import '../modules/introduction_package_service/bindings/introduction_package_service_binding.dart';
import '../modules/introduction_package_service/views/introduction_package_service_view.dart';
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
      bindings: [HomeBinding(), AccountBinding(), ActivityBinding()],
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
    GetPage(
      name: _Paths.INTRODUCTION_DELIVERY_SERVICE,
      page: () => const IntroductionDeliveryServiceView(),
      binding: IntroductionDeliveryServiceBinding(),
    ),
    GetPage(
      name: _Paths.INTRODUCTION_PACKAGE_SERVICE,
      page: () => const IntroductionPackageServiceView(),
      binding: IntroductionPackageServiceBinding(),
    ),
    GetPage(
      name: _Paths.INTRODUCTION_FOOD_SERVICE,
      page: () => const IntroductionFoodServiceView(),
      binding: IntroductionFoodServiceBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVITY,
      page: () => const ActivityView(),
      binding: ActivityBinding(),
    ),
  ];
}
