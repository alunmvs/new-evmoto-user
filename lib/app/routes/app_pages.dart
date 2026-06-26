import 'package:get/get.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/account_payment_method/bindings/account_payment_method_binding.dart';
import '../modules/account_payment_method/views/account_payment_method_view.dart';
import '../modules/account_payment_method_gopay_detail/bindings/account_payment_method_gopay_detail_binding.dart';
import '../modules/account_payment_method_gopay_detail/views/account_payment_method_gopay_detail_view.dart';
import '../modules/activity/bindings/activity_binding.dart';
import '../modules/activity/views/activity_view.dart';
import '../modules/activity_detail/bindings/activity_detail_binding.dart';
import '../modules/activity_detail/views/activity_detail_view.dart';
import '../modules/add_account_payment_method/bindings/add_account_payment_method_binding.dart';
import '../modules/add_account_payment_method/views/add_account_payment_method_view.dart';
import '../modules/add_edit_address/bindings/add_edit_address_binding.dart';
import '../modules/add_edit_address/views/add_edit_address_view.dart';
import '../modules/add_edit_address_other/bindings/add_edit_address_other_binding.dart';
import '../modules/add_edit_address_other/views/add_edit_address_other_view.dart';
import '../modules/add_edit_user_information/bindings/add_edit_user_information_binding.dart';
import '../modules/add_edit_user_information/views/add_edit_user_information_view.dart';
import '../modules/advanced_booking_detail/bindings/advanced_booking_detail_binding.dart';
import '../modules/advanced_booking_detail/views/advanced_booking_detail_view.dart';
import '../modules/advanced_booking_searching_driver/bindings/advanced_booking_searching_driver_binding.dart';
import '../modules/advanced_booking_searching_driver/views/advanced_booking_searching_driver_view.dart';
import '../modules/chat_detail/bindings/chat_detail_binding.dart';
import '../modules/chat_detail/views/chat_detail_view.dart';
import '../modules/chat_list/bindings/chat_list_binding.dart';
import '../modules/chat_list/views/chat_list_view.dart';
import '../modules/create_order_ride/bindings/create_order_ride_binding.dart';
import '../modules/create_order_ride/views/create_order_ride_view.dart';
import '../modules/create_order_ride_checkout/bindings/create_order_ride_checkout_binding.dart';
import '../modules/create_order_ride_checkout/views/create_order_ride_checkout_view.dart';
import '../modules/create_order_ride_map_select/bindings/create_order_ride_map_select_binding.dart';
import '../modules/create_order_ride_map_select/views/create_order_ride_map_select_view.dart';
import '../modules/create_order_ride_promo/bindings/create_order_ride_promo_binding.dart';
import '../modules/create_order_ride_promo/views/create_order_ride_promo_view.dart';
import '../modules/gopay_activation_webview/bindings/gopay_activation_webview_binding.dart';
import '../modules/gopay_activation_webview/views/gopay_activation_webview_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login_register/bindings/login_register_binding.dart';
import '../modules/login_register/views/login_register_view.dart';
import '../modules/login_register_verification_otp/bindings/login_register_verification_otp_binding.dart';
import '../modules/login_register_verification_otp/views/login_register_verification_otp_view.dart';
import '../modules/onboarding_registration_form/bindings/onboarding_registration_form_binding.dart';
import '../modules/onboarding_registration_form/views/onboarding_registration_form_view.dart';
import '../modules/photo_viewer/bindings/photo_viewer_binding.dart';
import '../modules/photo_viewer/views/photo_viewer_view.dart';
import '../modules/privacy_policy/bindings/privacy_policy_binding.dart';
import '../modules/privacy_policy/views/privacy_policy_view.dart';
import '../modules/ride_call_sendbird/bindings/ride_call_sendbird_binding.dart';
import '../modules/ride_call_sendbird/views/ride_call_sendbird_view.dart';
import '../modules/ride_chat_sendbird/bindings/ride_chat_sendbird_binding.dart';
import '../modules/ride_chat_sendbird/views/ride_chat_sendbird_view.dart';
import '../modules/ride_checkout_select_payment_method/bindings/ride_checkout_select_payment_method_binding.dart';
import '../modules/ride_checkout_select_payment_method/views/ride_checkout_select_payment_method_view.dart';
import '../modules/ride_order_cancel/bindings/ride_order_cancel_binding.dart';
import '../modules/ride_order_cancel/views/ride_order_cancel_view.dart';
import '../modules/ride_order_detail/bindings/ride_order_detail_binding.dart';
import '../modules/ride_order_detail/views/ride_order_detail_view.dart';
import '../modules/ride_order_done/bindings/ride_order_done_binding.dart';
import '../modules/ride_order_done/views/ride_order_done_view.dart';
import '../modules/search_address/bindings/search_address_binding.dart';
import '../modules/search_address/views/search_address_view.dart';
import '../modules/sendbird_chat_detail/bindings/sendbird_chat_detail_binding.dart';
import '../modules/sendbird_chat_detail/views/sendbird_chat_detail_view.dart';
import '../modules/sendbird_chat_list/bindings/sendbird_chat_list_binding.dart';
import '../modules/sendbird_chat_list/views/sendbird_chat_list_view.dart';
import '../modules/setting_language/bindings/setting_language_binding.dart';
import '../modules/setting_language/views/setting_language_view.dart';
import '../modules/setting_saved_location/bindings/setting_saved_location_binding.dart';
import '../modules/setting_saved_location/views/setting_saved_location_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/terms_and_conditions/bindings/terms_and_conditions_binding.dart';
import '../modules/terms_and_conditions/views/terms_and_conditions_view.dart';
import '../modules/voucher_list/bindings/voucher_list_binding.dart';
import '../modules/voucher_list/views/voucher_list_view.dart';

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
      name: _Paths.ADD_EDIT_ADDRESS,
      page: () => const AddEditAddressView(),
      binding: AddEditAddressBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_ADDRESS,
      page: () => SearchAddressView(),
      binding: SearchAddressBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_LANGUAGE,
      page: () => const SettingLanguageView(),
      binding: SettingLanguageBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_SAVED_LOCATION,
      page: () => const SettingSavedLocationView(),
      binding: SettingSavedLocationBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: _Paths.TERMS_AND_CONDITIONS,
      page: () => const TermsAndConditionsView(),
      binding: TermsAndConditionsBinding(),
    ),
    GetPage(
      name: _Paths.RIDE_ORDER_DETAIL,
      page: () => const RideOrderDetailView(),
      binding: RideOrderDetailBinding(),
    ),
    GetPage(
      name: _Paths.RIDE_ORDER_DONE,
      page: () => const RideOrderDoneView(),
      binding: RideOrderDoneBinding(),
    ),
    GetPage(
      name: _Paths.RIDE_ORDER_CANCEL,
      page: () => const RideOrderCancelView(),
      binding: RideOrderCancelBinding(),
    ),
    GetPage(
      name: _Paths.PHOTO_VIEWER,
      page: () => const PhotoViewerView(),
      binding: PhotoViewerBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_REGISTRATION_FORM,
      page: () => const OnboardingRegistrationFormView(),
      binding: OnboardingRegistrationFormBinding(),
    ),
    GetPage(
      name: _Paths.ADD_EDIT_USER_INFORMATION,
      page: () => const AddEditUserInformationView(),
      binding: AddEditUserInformationBinding(),
    ),
    GetPage(
      name: _Paths.RIDE_CALL_SENDBIRD,
      page: () => const RideCallSendbirdView(),
      binding: RideCallSendbirdBinding(),
    ),
    GetPage(
      name: _Paths.RIDE_CHAT_SENDBIRD,
      page: () => const RideChatSendbirdView(),
      binding: RideChatSendbirdBinding(),
    ),
    GetPage(
      name: _Paths.SENDBIRD_CHAT_LIST,
      page: () => const SendbirdChatListView(),
      binding: SendbirdChatListBinding(),
    ),
    GetPage(
      name: _Paths.SENDBIRD_CHAT_DETAIL,
      page: () => const SendbirdChatDetailView(),
      binding: SendbirdChatDetailBinding(),
    ),
    GetPage(
      name: _Paths.VOUCHER_LIST,
      page: () => const VoucherListView(),
      binding: VoucherListBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_ORDER_RIDE,
      page: () => const CreateOrderRideView(),
      binding: CreateOrderRideBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_ORDER_RIDE_CHECKOUT,
      page: () => const CreateOrderRideCheckoutView(),
      binding: CreateOrderRideCheckoutBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_ORDER_RIDE_PROMO,
      page: () => const CreateOrderRidePromoView(),
      binding: CreateOrderRidePromoBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_ORDER_RIDE_MAP_SELECT,
      page: () => const CreateOrderRideMapSelectView(),
      binding: CreateOrderRideMapSelectBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_LIST,
      page: () => const ChatListView(),
      binding: ChatListBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_DETAIL,
      page: () => const ChatDetailView(),
      binding: ChatDetailBinding(),
    ),
    GetPage(
      name: _Paths.ADVANCED_BOOKING_DETAIL,
      page: () => const AdvancedBookingDetailView(),
      binding: AdvancedBookingDetailBinding(),
    ),
    GetPage(
      name: _Paths.ADVANCED_BOOKING_SEARCHING_DRIVER,
      page: () => const AdvancedBookingSearchingDriverView(),
      binding: AdvancedBookingSearchingDriverBinding(),
    ),
    GetPage(
      name: _Paths.ADD_EDIT_ADDRESS_OTHER,
      page: () => const AddEditAddressOtherView(),
      binding: AddEditAddressOtherBinding(),
    ),
    GetPage(
      name: _Paths.RIDE_CHECKOUT_SELECT_PAYMENT_METHOD,
      page: () => const RideCheckoutSelectPaymentMethodView(),
      binding: RideCheckoutSelectPaymentMethodBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_PAYMENT_METHOD,
      page: () => const AccountPaymentMethodView(),
      binding: AccountPaymentMethodBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ACCOUNT_PAYMENT_METHOD,
      page: () => const AddAccountPaymentMethodView(),
      binding: AddAccountPaymentMethodBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_PAYMENT_METHOD_GOPAY_DETAIL,
      page: () => const AccountPaymentMethodGopayDetailView(),
      binding: AccountPaymentMethodGopayDetailBinding(),
    ),
    GetPage(
      name: _Paths.GOPAY_ACTIVATION_WEBVIEW,
      page: () => const GopayActivationWebviewView(),
      binding: GopayActivationWebviewBinding(),
    ),
  ];
}
