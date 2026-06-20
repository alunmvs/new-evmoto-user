import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_evmoto_user/app/data/models/language_model.dart';
import 'package:new_evmoto_user/app/data/models/user_info_model.dart';
import 'package:new_evmoto_user/app/modules/account/controllers/account_controller.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/controllers/create_order_ride_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/controllers/create_order_ride_checkout_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_promo/controllers/create_order_ride_promo_controller.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/modules/add_edit_address/controllers/add_edit_address_controller.dart';
import 'package:new_evmoto_user/app/modules/ride_order_cancel/controllers/ride_order_cancel_controller.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import 'package:new_evmoto_user/app/modules/ride_order_done/controllers/ride_order_done_controller.dart';
import 'package:new_evmoto_user/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_user/app/repositories/advertisement_repository.dart';
import 'package:new_evmoto_user/app/repositories/coupon_repository.dart';
import 'package:new_evmoto_user/app/repositories/driver_nearby_repository.dart';
import 'package:new_evmoto_user/app/repositories/geocoding_repository.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/repositories/otp_repository.dart';
import 'package:new_evmoto_user/app/repositories/saved_address_repository.dart';
import 'package:new_evmoto_user/app/repositories/upload_image_repository.dart';
import 'package:new_evmoto_user/app/repositories/user_repository.dart';
import 'package:new_evmoto_user/app/repositories/versioning_server_repository.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/utils/geocoding_cache_options.dart';
import 'package:new_evmoto_user/app/services/firebase_push_notification_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/app/services/sendbird_chat_services.dart';
import 'package:new_evmoto_user/app/services/sendbird_services.dart';
import 'package:new_evmoto_user/app/services/socket_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_typography_services.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockOrderRideRepository extends Mock implements OrderRideRepository {}

class MockCouponRepository extends Mock implements CouponRepository {}

class MockSavedAddressRepository extends Mock implements SavedAddressRepository {}

class MockGeocodingRepository extends Mock implements GeocodingRepository {}

class MockAdvertisementRepository extends Mock implements AdvertisementRepository {}

class MockVersioningServerRepository extends Mock
    implements VersioningServerRepository {}

class MockDriverNearbyRepository extends Mock implements DriverNearbyRepository {}

class MockOtpRepository extends Mock implements OtpRepository {}

class MockAdvanceBookingRepository extends Mock
    implements AdvanceBookingRepository {}

class MockUploadImageRepository extends Mock implements UploadImageRepository {}

class MockOpenMapsRepository extends Mock implements OpenMapsRepository {}

/// Registers [ThemeColorServices], [LanguageServices], and test typography.
void registerCoreTestServices({
  Language? language,
  String languageCode = 'ID',
  int languageCodeSystem = 2,
}) {
  Get.put<ThemeColorServices>(ThemeColorServices());

  final languageServices = LanguageServices();
  languageServices.language.value = language ?? Language();
  languageServices.languageCode.value = languageCode;
  languageServices.languageCodeSystem.value = languageCodeSystem;
  Get.put<LanguageServices>(languageServices);

  registerTestTypographyServices();
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

class FakeLocationServices extends LocationServices {
  double? fakeLatitude;
  double? fakeLongitude;

  @override
  Future<void> requestLocation({bool? isSkipGeocodingAddress}) async {
    currentLatitude.value = fakeLatitude;
    currentLongitude.value = fakeLongitude;
  }

  @override
  Future<void> requestLocationSplashScreen() async {
    currentLatitude.value = fakeLatitude ?? -6.1751;
    currentLongitude.value = fakeLongitude ?? 106.8650;
  }
}

void registerTestUserServices({UserInfo? userInfo}) {
  final userServices = TestUserServices();
  if (userInfo != null) {
    userServices.userInfo.value = userInfo;
  }
  Get.put<UserServices>(userServices);
}

void registerFakeLocationServices({
  double? latitude,
  double? longitude,
}) {
  final locationServices = FakeLocationServices();
  locationServices.fakeLatitude = latitude;
  locationServices.fakeLongitude = longitude;
  Get.put<LocationServices>(locationServices);
}

/// Registers a minimal [HomeController] without calling [HomeController.onInit].
void registerMinimalHomeController({
  UserRepository? userRepository,
  OrderRideRepository? orderRideRepository,
  CouponRepository? couponRepository,
  SavedAddressRepository? savedAddressRepository,
  GeocodingRepository? geocodingRepository,
  AdvertisementRepository? advertisementRepository,
  VersioningServerRepository? versioningServerRepository,
  DriverNearbyRepository? driverNearbyRepository,
  UserInfo? userInfo,
}) {
  registerCoreTestServices();
  registerTestUserServices(userInfo: userInfo);
  registerFakeLocationServices();
  registerHomeInfrastructureServices();
  Get.put<HomeController>(
    createTestHomeController(
      userRepository: userRepository,
      orderRideRepository: orderRideRepository,
      couponRepository: couponRepository,
      savedAddressRepository: savedAddressRepository,
      geocodingRepository: geocodingRepository,
      advertisementRepository: advertisementRepository,
      versioningServerRepository: versioningServerRepository,
      driverNearbyRepository: driverNearbyRepository,
    ),
  );
}

class FakeSendbirdChatServices extends SendbirdChatServices {
  FakeSendbirdChatServices() {
    isSuccessInitialize.value = true;
  }

  @override
  Future<void> initialize() async {
    isSuccessInitialize.value = true;
  }
}

class FakeSendbirdServices extends SendbirdServices {
  FakeSendbirdServices() {
    isSuccessInitialize.value = true;
  }

  @override
  Future<void> initialize() async {
    isSuccessInitialize.value = true;
  }
}

class TestApiServices extends ApiServices {
  TestApiServices() {
    cacheStore = MemCacheStore();
    geocodingReverseCacheOptions = GeocodingCacheOptions.reverseGeocoding(
      cacheStore,
    );
    geocodingPlacesCacheOptions = GeocodingCacheOptions.placesSearch(cacheStore);
  }

  @override
  Future<void> onInit() async {}

  @override
  Future<void> manualOnInit() async {}
}

class TestSocketServices extends SocketServices {
  @override
  Future<void> onInit() async {}
}

class TestFirebaseRemoteConfigServices extends FirebaseRemoteConfigServices {
  @override
  Future<void> onInit() async {}
}

class TestFirebasePushNotificationServices
    extends FirebasePushNotificationServices {
  @override
  Future<void> onInit() async {}
}

class TestHomeController extends HomeController {
  TestHomeController({
    required super.userRepository,
    required super.orderRideRepository,
    required super.couponRepository,
    required super.savedAddressRepository,
    required super.geocodingRepository,
    required super.advertisementRepository,
    required super.versioningServerRepository,
    required super.driverNearbyRepository,
  });

  @override
  Future<void> onInit() async {}
}

Future<void> ensureFirebaseForTests() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'fake-api-key',
        appId: 'fake-app-id',
        messagingSenderId: 'fake-sender-id',
        projectId: 'fake-project-id',
      ),
    );
  }
}

void registerSendbirdTestServices() {
  if (!Get.isRegistered<SendbirdChatServices>()) {
    Get.put<SendbirdChatServices>(FakeSendbirdChatServices());
  }
  if (!Get.isRegistered<SendbirdServices>()) {
    Get.put<SendbirdServices>(FakeSendbirdServices());
  }
}

void registerHomeInfrastructureServices() {
  SharedPreferences.setMockInitialValues({});
  if (!Get.isRegistered<ApiServices>()) {
    Get.put<ApiServices>(TestApiServices());
  }
  if (!Get.isRegistered<FirebaseRemoteConfigServices>()) {
    Get.put<FirebaseRemoteConfigServices>(TestFirebaseRemoteConfigServices());
  }
  if (!Get.isRegistered<FirebasePushNotificationServices>()) {
    Get.put<FirebasePushNotificationServices>(
      TestFirebasePushNotificationServices(),
    );
  }
  if (!Get.isRegistered<SocketServices>()) {
    Get.put<SocketServices>(TestSocketServices());
  }
  registerSendbirdTestServices();
}

TestHomeController createTestHomeController({
  UserRepository? userRepository,
  OrderRideRepository? orderRideRepository,
  CouponRepository? couponRepository,
  SavedAddressRepository? savedAddressRepository,
  GeocodingRepository? geocodingRepository,
  AdvertisementRepository? advertisementRepository,
  VersioningServerRepository? versioningServerRepository,
  DriverNearbyRepository? driverNearbyRepository,
}) {
  return TestHomeController(
    userRepository: userRepository ?? MockUserRepository(),
    orderRideRepository: orderRideRepository ?? MockOrderRideRepository(),
    couponRepository: couponRepository ?? MockCouponRepository(),
    savedAddressRepository:
        savedAddressRepository ?? MockSavedAddressRepository(),
    geocodingRepository: geocodingRepository ?? MockGeocodingRepository(),
    advertisementRepository:
        advertisementRepository ?? MockAdvertisementRepository(),
    versioningServerRepository:
        versioningServerRepository ?? MockVersioningServerRepository(),
    driverNearbyRepository:
        driverNearbyRepository ?? MockDriverNearbyRepository(),
  );
}

void registerTestHomeController({
  HomeController? homeController,
  UserInfo? userInfo,
}) {
  registerCoreTestServices();
  registerTestUserServices(userInfo: userInfo);
  registerFakeLocationServices();
  registerHomeInfrastructureServices();
  Get.put<HomeController>(
    homeController ?? createTestHomeController(),
  );
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

class TestActivityController extends ActivityController {
  TestActivityController({
    required super.orderRideRepository,
    required super.advancedBookingRepository,
  });

  @override
  Future<void> onInit() async {}
}

class TestCreateOrderRideController extends CreateOrderRideController {
  TestCreateOrderRideController({
    required super.geocodingRepository,
    required super.savedAddressRepository,
    required super.orderRideRepository,
  });

  @override
  Future<void> onInit() async {}
}

class TestCreateOrderRidePromoController extends CreateOrderRidePromoController {
  TestCreateOrderRidePromoController({required super.couponRepository});

  @override
  Future<void> onInit() async {}
}

class TestRideOrderDoneController extends RideOrderDoneController {
  TestRideOrderDoneController({required super.orderRideRepository});

  @override
  Future<void> onInit() async {}
}

class TestAddEditAddressController extends AddEditAddressController {
  TestAddEditAddressController({required super.savedAddressRepository});

  @override
  Future<void> onInit() async {}
}

class TestRideOrderCancelController extends RideOrderCancelController {
  TestRideOrderCancelController({required super.orderRideRepository});

  @override
  Future<void> onInit() async {}
}

class TestRideOrderDetailController extends RideOrderDetailController {
  TestRideOrderDetailController({
    required super.orderRideRepository,
    required super.openMapsRepository,
    required super.driverNearbyRepository,
    required super.advanceBookingRepository,
  });

  @override
  Future<void> onInit() async {}
}

TestRideOrderDetailController createTestRideOrderDetailController({
  OrderRideRepository? orderRideRepository,
  OpenMapsRepository? openMapsRepository,
  DriverNearbyRepository? driverNearbyRepository,
  AdvanceBookingRepository? advanceBookingRepository,
}) {
  return TestRideOrderDetailController(
    orderRideRepository: orderRideRepository ?? MockOrderRideRepository(),
    openMapsRepository: openMapsRepository ?? MockOpenMapsRepository(),
    driverNearbyRepository:
        driverNearbyRepository ?? MockDriverNearbyRepository(),
    advanceBookingRepository:
        advanceBookingRepository ?? MockAdvanceBookingRepository(),
  );
}

void registerTestRideOrderDetailServices() {
  registerCoreTestServices();
  registerTestUserServices();
  registerHomeInfrastructureServices();
}

class TestCreateOrderRideCheckoutController
    extends CreateOrderRideCheckoutController {
  TestCreateOrderRideCheckoutController({
    required super.orderRideRepository,
    required super.geocodingRepository,
    required super.openMapsRepository,
    required super.couponRepository,
    required super.driverNearbyRepository,
    required super.advanceBookingRepository,
  });

  @override
  Future<void> onInit() async {}
}

TestCreateOrderRideCheckoutController createTestCreateOrderRideCheckoutController({
  OrderRideRepository? orderRideRepository,
  GeocodingRepository? geocodingRepository,
  OpenMapsRepository? openMapsRepository,
  CouponRepository? couponRepository,
  DriverNearbyRepository? driverNearbyRepository,
  AdvanceBookingRepository? advanceBookingRepository,
}) {
  return TestCreateOrderRideCheckoutController(
    orderRideRepository: orderRideRepository ?? MockOrderRideRepository(),
    geocodingRepository: geocodingRepository ?? MockGeocodingRepository(),
    openMapsRepository: openMapsRepository ?? MockOpenMapsRepository(),
    couponRepository: couponRepository ?? MockCouponRepository(),
    driverNearbyRepository:
        driverNearbyRepository ?? MockDriverNearbyRepository(),
    advanceBookingRepository:
        advanceBookingRepository ?? MockAdvanceBookingRepository(),
  );
}

void registerTestCreateOrderRideFlowControllers({
  CreateOrderRideController? createOrderRideController,
  CreateOrderRideCheckoutController? checkoutController,
}) {
  if (!Get.isRegistered<CreateOrderRideController>()) {
    Get.put<CreateOrderRideController>(
      createOrderRideController ??
          TestCreateOrderRideController(
            geocodingRepository: MockGeocodingRepository(),
            savedAddressRepository: MockSavedAddressRepository(),
            orderRideRepository: MockOrderRideRepository(),
          ),
    );
  }

  if (!Get.isRegistered<CreateOrderRideCheckoutController>()) {
    Get.put<CreateOrderRideCheckoutController>(
      checkoutController ?? createTestCreateOrderRideCheckoutController(),
    );
  }
}

