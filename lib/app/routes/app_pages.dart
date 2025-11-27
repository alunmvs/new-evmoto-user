import 'package:get/get.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/activity/bindings/activity_binding.dart';
import '../modules/activity/views/activity_view.dart';
import '../modules/activity_detail/bindings/activity_detail_binding.dart';
import '../modules/activity_detail/views/activity_detail_view.dart';
import '../modules/add_edit_address/bindings/add_edit_address_binding.dart';
import '../modules/add_edit_address/views/add_edit_address_view.dart';
import '../modules/history_balance/bindings/history_balance_binding.dart';
import '../modules/history_balance/views/history_balance_view.dart';
import '../modules/history_balance_detail/bindings/history_balance_detail_binding.dart';
import '../modules/history_balance_detail/views/history_balance_detail_view.dart';
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
import '../modules/promotion/bindings/promotion_binding.dart';
import '../modules/promotion/views/promotion_view.dart';
import '../modules/ride/bindings/ride_binding.dart';
import '../modules/ride/views/ride_view.dart';
import '../modules/search_address/bindings/search_address_binding.dart';
import '../modules/search_address/views/search_address_view.dart';
import '../modules/select_promo/bindings/select_promo_binding.dart';
import '../modules/select_promo/views/select_promo_view.dart';
import '../modules/setting_language/bindings/setting_language_binding.dart';
import '../modules/setting_language/views/setting_language_view.dart';
import '../modules/setting_payment/bindings/setting_payment_binding.dart';
import '../modules/setting_payment/views/setting_payment_view.dart';
import '../modules/setting_saved_location/bindings/setting_saved_location_binding.dart';
import '../modules/setting_saved_location/views/setting_saved_location_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/voucher_detail/bindings/voucher_detail_binding.dart';
import '../modules/voucher_detail/views/voucher_detail_view.dart';

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
    GetPage(
      name: _Paths.ACTIVITY_DETAIL,
      page: () => const ActivityDetailView(),
      binding: ActivityDetailBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY_BALANCE,
      page: () => const HistoryBalanceView(),
      binding: HistoryBalanceBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY_BALANCE_DETAIL,
      page: () => const HistoryBalanceDetailView(),
      binding: HistoryBalanceDetailBinding(),
    ),
    GetPage(
      name: _Paths.PROMOTION,
      page: () => const PromotionView(),
      binding: PromotionBinding(),
    ),
    GetPage(
      name: _Paths.VOUCHER_DETAIL,
      page: () => const VoucherDetailView(),
      binding: VoucherDetailBinding(),
    ),
    GetPage(
      name: _Paths.ADD_EDIT_ADDRESS,
      page: () => const AddEditAddressView(),
      binding: AddEditAddressBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_ADDRESS,
      page: () => const SearchAddressView(),
      binding: SearchAddressBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_LANGUAGE,
      page: () => const SettingLanguageView(),
      binding: SettingLanguageBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_PAYMENT,
      page: () => const SettingPaymentView(),
      binding: SettingPaymentBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_SAVED_LOCATION,
      page: () => const SettingSavedLocationView(),
      binding: SettingSavedLocationBinding(),
    ),
    GetPage(
      name: _Paths.RIDE,
      page: () => const RideView(),
      binding: RideBinding(),
    ),
    GetPage(
      name: _Paths.SELECT_PROMO,
      page: () => const SelectPromoView(),
      binding: SelectPromoBinding(),
    ),
  ];
}
