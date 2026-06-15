# Evmoto User App — Project Overview

> Generated from codebase analysis of `new_evmoto_user` (v1.2.8+51).  
> Evidence-based; assumptions are marked explicitly.

---

## 1. Project Summary

**Evmoto** (`new_evmoto_user`) is a **Flutter mobile application for electric motorcycle ride-hailing and booking** in Indonesia. Users can book on-demand rides, schedule advanced bookings, track drivers in real time, chat/call drivers, manage saved addresses, apply vouchers, and manage their account.

| Aspect | Detail |
|--------|--------|
| **What it does** | On-demand EV ride booking, advanced (scheduled) booking, live order tracking, driver communication, vouchers/promos, account & settings |
| **Business purpose** | Consumer-facing ride-hailing app for Evmoto's electric motorcycle fleet |
| **Target users** | End customers (passengers) in Indonesia who need short-distance transport via electric motorcycles |
| **Evidence** | `pubspec.yaml` description: *"Electric vehicle booking app for everyday needs."*; package name `com.evmoto.user.app`; OTP login with `+62` phone prefix; Indonesian locale (`id_ID`) initialized in `main.dart` |

**Assumption:** Primary market is Indonesia based on phone format (`62` prefix in login), Bahasa Indonesia geocoding default, and WhatsApp CS number in Firebase Remote Config defaults.

---

## 2. Business Features

### Authentication & Onboarding

| | |
|---|---|
| **Purpose** | Phone OTP login, first-run registration, profile completion |
| **Screens** | `SplashScreenView`, `LoginRegisterView`, `LoginRegisterVerificationOtpView`, `OnboardingRegistrationFormView`, `AddEditUserInformationView` |
| **Modules** | `splash_screen`, `login_register`, `login_register_verification_otp`, `onboarding_registration_form`, `add_edit_user_information` |

### Home & Map

| | |
|---|---|
| **Purpose** | Main hub with Google Maps, nearby drivers, active orders, advertisements, bottom navigation |
| **Screens** | `HomeView` (map tab, activity tab, account tab via `IndexedStack`) |
| **Modules** | `home` (also hosts `AccountView` and `ActivityView` as tabs) |

### Ride Booking (On-Demand)

| | |
|---|---|
| **Purpose** | Create ride orders: pick origin/destination, map selection, checkout, promo, payment method |
| **Screens** | `CreateOrderRideView`, `CreateOrderRideMapSelectView`, `CreateOrderRideCheckoutView`, `CreateOrderRidePromoView`, `RideCheckoutSelectPaymentMethodView`, `SearchAddressView`, `AddEditAddressView`, `AddEditAddressOtherView` |
| **Modules** | `create_order_ride`, `create_order_ride_map_select`, `create_order_ride_checkout`, `create_order_ride_promo`, `ride_checkout_select_payment_method`, `search_address`, `add_edit_address`, `add_edit_address_other` |

### Live Ride Tracking

| | |
|---|---|
| **Purpose** | Real-time order status, driver position, chat/call during ride |
| **Screens** | `RideOrderDetailView`, `RideOrderDoneView`, `RideOrderCancelView` |
| **Modules** | `ride_order_detail`, `ride_order_done`, `ride_order_cancel` |

### Advanced Booking (Scheduled)

| | |
|---|---|
| **Purpose** | Schedule rides in advance, search for driver, view booking details |
| **Screens** | `AdvancedBookingSearchingDriverView`, `AdvancedBookingDetailView` |
| **Modules** | `advanced_booking_searching_driver`, `advanced_booking_detail` |

### Activity & Order History

| | |
|---|---|
| **Purpose** | View past and in-progress orders; rate/review completed rides |
| **Screens** | `ActivityView`, `ActivityDetailView` |
| **Modules** | `activity`, `activity_detail` |

### Vouchers & Promotions

| | |
|---|---|
| **Purpose** | Browse and apply discount vouchers/coupons |
| **Screens** | `VoucherListView` |
| **Modules** | `voucher_list` |

### Account & Settings

| | |
|---|---|
| **Purpose** | Profile, language, saved locations, legal docs, logout, account deletion |
| **Screens** | `AccountView`, `SettingLanguageView`, `SettingSavedLocationView`, `PrivacyPolicyView`, `TermsAndConditionsView` |
| **Modules** | `account`, `setting_language`, `setting_saved_location`, `privacy_policy`, `terms_and_conditions` |

### Payment Methods *(in progress)*

| | |
|---|---|
| **Purpose** | Manage payment methods (GoPay binding, cash); checkout payment selection |
| **Screens** | `AccountPaymentMethodView`, `AddAccountPaymentMethodView`, `AccountPaymentMethodGopayDetailView`, `RideCheckoutSelectPaymentMethodView` |
| **Modules** | `account_payment_method`, `add_account_payment_method`, `account_payment_method_gopay_detail`, `ride_checkout_select_payment_method` |
| **Note** | `AccountPaymentMethodController` is a stub; UI/dialog assets exist but API integration appears incomplete |

### Chat & Communication

| | |
|---|---|
| **Purpose** | In-app order chat (Firestore), Sendbird chat/call for driver communication |
| **Screens** | `ChatListView`, `ChatDetailView`, `SendbirdChatListView`, `SendbirdChatDetailView`, `RideChatSendbirdView`, `RideCallSendbirdView` |
| **Modules** | `chat_list`, `chat_detail`, `sendbird_chat_list`, `sendbird_chat_detail`, `ride_chat_sendbird`, `ride_call_sendbird` |

### Utilities

| | |
|---|---|
| **Purpose** | Photo viewing, address search |
| **Screens** | `PhotoViewerView`, `SearchAddressView` |
| **Modules** | `photo_viewer`, `search_address` |

---

## 3. Technical Stack

| Technology | Version (from `pubspec.yaml`) | Usage |
|------------|-------------------------------|-------|
| **Flutter / Dart** | SDK `^3.9.2` | UI framework |
| **GetX** | `^4.7.3` | State management, routing, DI |
| **Dio** | `^5.9.2` | HTTP client |
| **dio_curl_logger** | `^1.3.0` | Request logging (dev) |
| **flutter_secure_storage** | `^10.0.0` | Token & device ID storage |
| **shared_preferences** | `^2.5.5` | Language, flags, controller registration |
| **google_maps_flutter** | `^2.17.0` | Maps |
| **geolocator** | `^14.0.2` | Location services |
| **firebase_core** | `^4.7.0` | Firebase bootstrap |
| **firebase_remote_config** | `^6.4.0` | Remote strings (i18n, Sendbird app ID, CS WhatsApp) |
| **firebase_crashlytics** | `^5.2.0` | Crash reporting |
| **firebase_messaging** | `^16.2.0` | Push notifications |
| **firebase_storage** | `^13.3.0` | Image uploads *(via repositories)* |
| **cloud_firestore** | `^6.1.1` | Order chat messages & participants |
| **sendbird_chat_sdk** | `^4.10.0` | Chat SDK |
| **flutter_callkit_incoming** | `^3.0.0` | VoIP incoming calls |
| **reactive_forms** | `^18.2.2` | Form validation (onboarding, addresses, cancel reasons) |
| **google_fonts** | `^8.0.2` | Nunito Sans typography |
| **flutter_svg** | `^2.2.4` | SVG icons |
| **app_links** | `^7.0.0` | Deep linking (`evmoto://`) |
| **intl** | `^0.20.2` | Date/number formatting |
| **cached_network_image** | `^3.4.1` | Remote images |
| **image_picker** | `^1.2.1` | Chat attachments |
| **permission_handler** | `^12.0.1` | Runtime permissions |
| **internet_connection_checker** | `^3.0.1` | Connectivity |
| **native_flutter_proxy** | `^0.3.1` | System proxy support (dev) |
| **get_cli** | `^1.9.1` (dev) | Module/route scaffolding |

**Not used:** Hive, GetStorage — no references found in codebase.

---

## 4. Architecture Overview

### Pattern: GetX Feature Modules

The project follows **GetX module-based architecture** generated/scaffolded with `get_cli`. Each feature lives under `lib/app/modules/<feature>/` with:

```
bindings/     → Dependency injection (Get.lazyPut)
controllers/  → Business logic, reactive state (.obs)
views/        → UI (GetView<Controller> + Obx)
```

### Layer Responsibilities

| Layer | Location | Responsibility |
|-------|----------|----------------|
| **Views** | `lib/app/modules/*/views/` | UI rendering; extend `GetView<T>`; wrap reactive sections in `Obx` |
| **Controllers** | `lib/app/modules/*/controllers/` | State, user actions, orchestration; inject repositories via constructor |
| **Bindings** | `lib/app/modules/*/bindings/` | Register controllers and inject repository instances |
| **Repositories** | `lib/app/repositories/` | API calls via `ApiServices.dio`; read token from secure storage |
| **Services** | `lib/app/services/` | App-wide singletons (`GetxService`); registered in `main.dart` |
| **Models** | `lib/app/data/models/` | JSON-serializable data classes |
| **Widgets** | `lib/app/widgets/` | Shared dialogs, loaders, map markers |
| **Utils** | `lib/app/utils/` | Helpers (snackbar, maps, socket, logout) |

### Example: Home Module

`HomeBinding` registers `HomeController` with 7 repository dependencies via `Get.lazyPut`. `HomeView` extends `GetView<HomeController>` and uses `Obx` for bottom-nav index and map panel. The HOME route also binds `AccountBinding` and `ActivityBinding` so all three tab controllers are available from a single shell route.

### Real-Time Layer

- **WebSocket** (`SocketServices`): Raw TCP socket on port `8888` for driver position, order events
- **Firebase Cloud Messaging**: Push notifications, Sendbird call payloads
- **Cloud Firestore**: Order-scoped chat rooms and messages
- **Sendbird**: Voice/video calls via native method channel + SDK

---

## 5. Application Flow

```
main()
  ├── WidgetsFlutterBinding.ensureInitialized()
  ├── Proxy setup (native_flutter_proxy)
  ├── initializeDateFormatting('id_ID')
  ├── Firebase.initializeApp() + Crashlytics hooks
  ├── Get.put() global services (permanent: true)
  │     ThemeColorServices, TypographyServices, LanguageServices,
  │     ApiServices, FirebaseRemoteConfigServices,
  │     FirebasePushNotificationServices, SocketServices,
  │     SendbirdServices, SendbirdChatServices,
  │     LocationServices, DeepLinkServices, UserServices
  ├── FirebaseRemoteConfigServices.manualOnInit()
  ├── LanguageServices.manualOnInit()
  └── runApp(GetMaterialApp)
        initialRoute: /splash-screen
        getPages: AppPages.routes

SplashScreenController.onInit()
  ├── checkIfAppFirstRun() → clear secure storage on first launch
  ├── getSplashScreenQueryImage()
  ├── Reset controller registration flags (SharedPreferences)
  ├── Read token from FlutterSecureStorage
  ├── No token → delay 2s → LOGIN_REGISTER
  └── Has token → load user info + location → delay 2s → HOME

HOME (shell)
  ├── IndexedStack: Map tab | Activity tab | Account tab
  ├── HomeController.onInit() → socket, FCM, Sendbird, active orders, map
  └── routingCallback on HOME → refresh home + activity data
```

---

## 6. Folder Structure

```
lib/
├── main.dart                    # App entry, service registration, GetMaterialApp
├── environment.dart             # baseUrl, socketUrl, env flag (manual switch)
└── app/
    ├── data/models/             # 28 domain models (orders, user, coupons, etc.)
    ├── modules/                 # 37 feature modules (GetX)
    │   └── <feature>/
    │       ├── bindings/
    │       ├── controllers/
    │       └── views/           # Often split into *_sub_view.dart files
    ├── repositories/            # 16 API repository classes
    ├── routes/
    │   ├── app_pages.dart       # GetPage definitions
    │   └── app_routes.dart      # Route name constants (get_cli generated)
    ├── services/                # 12 global GetxService singletons
    ├── utils/                   # 8 helper files
    └── widgets/                 # Shared UI (dialogs, loaders, map widgets)

assets/
├── images/                      # PNG/SVG illustrations, promos, payment UI
├── icons/                       # SVG/PNG icons
├── logos/                       # App logo, social logos
└── jsons/                       # Declared in pubspec; directory may be empty

android/                         # Gradle, Firebase, Sendbird Calls native dep
ios/                             # Info.plist, VoIP/push background modes, deep link scheme
```

---

## 7. Module Overview

All 37 modules under `lib/app/modules/`:

| Module | Purpose | Main Screen(s) | Main Controller |
|--------|---------|----------------|-----------------|
| `splash_screen` | Auth gate, splash image | `SplashScreenView` | `SplashScreenController` |
| `login_register` | Phone number entry | `LoginRegisterView` | `LoginRegisterController` |
| `login_register_verification_otp` | OTP verify & login | `LoginRegisterVerificationOtpView` | `LoginRegisterVerificationOtpController` |
| `onboarding_registration_form` | New user name registration | `OnboardingRegistrationFormView` | `OnboardingRegistrationFormController` |
| `home` | Main shell: map, nav, ads | `HomeView` | `HomeController` |
| `activity` | Order history list | `ActivityView` | `ActivityController` |
| `activity_detail` | Order detail, rating | `ActivityDetailView` | `ActivityDetailController` |
| `account` | Profile, settings menu, logout | `AccountView` | `AccountController` |
| `create_order_ride` | Origin/destination selection | `CreateOrderRideView` | `CreateOrderRideController` |
| `create_order_ride_map_select` | Map pin selection | `CreateOrderRideMapSelectView` | `CreateOrderRideMapSelectController` |
| `create_order_ride_checkout` | Price breakdown, confirm order | `CreateOrderRideCheckoutView` | `CreateOrderRideCheckoutController` |
| `create_order_ride_promo` | Promo/voucher selection at checkout | `CreateOrderRidePromoView` | `CreateOrderRidePromoController` |
| `ride_checkout_select_payment_method` | Payment method at checkout | `RideCheckoutSelectPaymentMethodView` | `RideCheckoutSelectPaymentMethodController` |
| `ride_order_detail` | Live ride tracking | `RideOrderDetailView` | `RideOrderDetailController` |
| `ride_order_done` | Post-ride summary | `RideOrderDoneView` | `RideOrderDoneController` |
| `ride_order_cancel` | Cancel ride with reason | `RideOrderCancelView` | `RideOrderCancelController` |
| `advanced_booking_searching_driver` | Scheduled ride driver search | `AdvancedBookingSearchingDriverView` | `AdvancedBookingSearchingDriverController` |
| `advanced_booking_detail` | Scheduled booking detail | `AdvancedBookingDetailView` | `AdvancedBookingDetailController` |
| `search_address` | Address autocomplete search | `SearchAddressView` | `SearchAddressController` |
| `add_edit_address` | Save/edit address | `AddEditAddressView` | `AddEditAddressController` |
| `add_edit_address_other` | Custom address label/form | `AddEditAddressOtherView` | `AddEditAddressOtherController` |
| `setting_saved_location` | Manage saved addresses | `SettingSavedLocationView` | `SettingSavedLocationController` |
| `setting_language` | Language picker (ID/EN/ZH) | `SettingLanguageView` | `SettingLanguageController` |
| `add_edit_user_information` | Edit profile fields | `AddEditUserInformationView` | `AddEditUserInformationController` |
| `voucher_list` | Available/used vouchers | `VoucherListView` | `VoucherListController` |
| `account_payment_method` | Payment methods list | `AccountPaymentMethodView` | `AccountPaymentMethodController` |
| `add_account_payment_method` | Add payment method | `AddAccountPaymentMethodView` | `AddAccountPaymentMethodController` |
| `account_payment_method_gopay_detail` | GoPay bind/unbind | `AccountPaymentMethodGopayDetailView` | `AccountPaymentMethodGopayDetailController` |
| `chat_list` | Firestore order chat list | `ChatListView` | `ChatListController` |
| `chat_detail` | Firestore order chat thread | `ChatDetailView` | `ChatDetailController` |
| `sendbird_chat_list` | Sendbird chat list | `SendbirdChatListView` | `SendbirdChatListController` |
| `sendbird_chat_detail` | Sendbird chat thread | `SendbirdChatDetailView` | `SendbirdChatDetailController` |
| `ride_chat_sendbird` | In-ride Sendbird chat | `RideChatSendbirdView` | `RideChatSendbirdController` |
| `ride_call_sendbird` | In-ride Sendbird call UI | `RideCallSendbirdView` | `RideCallSendbirdController` |
| `privacy_policy` | Privacy policy (remote HTML) | `PrivacyPolicyView` | `PrivacyPolicyController` |
| `terms_and_conditions` | T&C (remote HTML) | `TermsAndConditionsView` | `TermsAndConditionsController` |
| `photo_viewer` | Full-screen image viewer | `PhotoViewerView` | `PhotoViewerController` |

---

## 8. Routing Overview

### Strategy

- **GetX named routes** via `GetMaterialApp(getPages: AppPages.routes)`
- Route constants in `Routes` / `_Paths` (`app_routes.dart`, get_cli generated)
- Navigation: `Get.toNamed()`, `Get.offAllNamed()`, `Get.offAndToNamed()`
- Arguments passed via `Get.arguments` map

### Registration

- **Initial route:** `/splash-screen` (`AppPages.INITIAL`)
- **37 `GetPage` entries** in `lib/app/routes/app_pages.dart`
- **Special case:** `HOME` binds three controllers: `HomeBinding`, `AccountBinding`, `ActivityBinding`

### Examples

```dart
// Navigate to OTP with phone argument
Get.toNamed(Routes.LOGIN_REGISTER_VERIFICATION_OTP, arguments: {"mobile_phone": "62..."});

// Post-login reset stack
Get.offAllNamed(Routes.HOME);

// Deep link (evmoto://host?params)
Get.toNamed(uri.host, arguments: uri.queryParameters);
```

### Global Routing Callback

`main.dart` `routingCallback`: when navigating to `HOME`, refreshes `HomeController` and `ActivityController` if previously registered (tracked via SharedPreferences flags).

---

## 9. State Management Overview

### Primary Pattern: GetX Reactive

- Controllers extend `GetxController`
- State exposed via `.obs` reactive variables (`RxBool`, `RxList`, `Rx<T>`, etc.)
- UI uses `Obx(() => ...)` to rebuild on observable changes
- Views extend `GetView<Controller>` for typed `controller` access

### Usage Statistics

| Pattern | Count | Notes |
|---------|-------|-------|
| `Obx(` | ~90+ files | Dominant reactive pattern |
| `GetView<` | ~100+ sub-views | Standard view base class |
| `GetBuilder` | 0 | Not used |
| `StatefulWidget` / `setState` | 0 | Fully GetX-driven UI |

### Common Controller State Flags

- `isFetch` — loading state
- `isCriticalError` — error state (used with `GlobalBodyHandler`)
- Feature-specific lists: `activeOrderList`, `savedAddressList`, `driverNearbyList`, etc.

### Cross-Controller Access

Controllers frequently use `Get.find<SomeService>()` or `Get.find<OtherController>()` for shared services and tab-shell coordination (e.g., `ChatDetailController` finds `HomeController`).

---

## 10. Dependency Injection Overview

### Global Services (`main.dart`)

All registered with `Get.put(..., permanent: true)` at startup:

`ThemeColorServices`, `TypographyServices`, `LanguageServices`, `ApiServices`, `FirebaseRemoteConfigServices`, `FirebasePushNotificationServices`, `SocketServices`, `SendbirdServices`, `SendbirdChatServices`, `LocationServices`, `DeepLinkServices`, `UserServices`

### Feature Controllers (Bindings)

- `Get.lazyPut<Controller>(() => Controller(...))` in each module's `*Binding`
- Repositories instantiated inline in bindings (not registered in GetX): `UserRepository()`, `OrderRideRepository()`, etc.

### Repository Pattern

Repositories are **plain Dart classes** (not `GetxService`). They resolve `ApiServices` via `Get.find<ApiServices>()` internally.

### HOME Route Multi-Binding

```dart
GetPage(
  name: _Paths.HOME,
  page: () => const HomeView(),
  bindings: [HomeBinding(), AccountBinding(), ActivityBinding()],
),
```

`HomeBinding` itself also registers `AccountController` and `ActivityController` — potential duplicate registration when HOME uses multiple bindings.

---

## 11. Data Layer Overview

### Remote Data Sources

| Source | Access | Data |
|--------|--------|------|
| **REST API** (`baseUrl`) | Dio via repositories | User, orders, coupons, geocoding, OTP, agreements, notifications |
| **WebSocket** (`socketUrl:8888`) | `SocketServices` | Driver position, order lifecycle events |
| **Cloud Firestore** | Direct SDK in controllers | `evmoto_order_chat_participants`, `evmoto_order_chat_messages` |
| **Firebase Remote Config** | `FirebaseRemoteConfigServices` | i18n JSON strings, Sendbird app ID, CS WhatsApp |
| **Firebase Storage** | `UploadImageRepository` | Chat image attachments |
| **Sendbird** | Native channel + SDK | Voice/video calls, Sendbird chat |

### Local Data Sources

| Store | Keys / Usage |
|-------|--------------|
| **FlutterSecureStorage** | `token`, `device_id`; cleared on first run and logout |
| **SharedPreferences** | `language_code`, `first_run`, `home_controller_registered`, `activity_controller_registered` |

### Storage Strategy

- **Sensitive:** Token and device ID in secure storage
- **Preferences:** Language and UI/controller lifecycle flags in SharedPreferences
- **No local DB:** No Hive/SQLite; all order data fetched from API on demand
- **Logout:** `clearDataLogout()` in `common_helper.dart` clears token, prefs, socket, FCM subscription

---

## 12. API Integration Overview

### API Client

- **Dio** singleton on `ApiServices.dio`
- **Base URL:** Configured in `lib/environment.dart` (currently dev: `http://8.215.203.97:8500`)
- **Timeouts:** connect/send 10s, receive 15s

### Request Headers (Interceptor)

Every request automatically includes:

| Header | Value |
|--------|-------|
| `version` | App package version |
| `deviceid` | UUID from secure storage |
| `timestamp` | Epoch ms |
| `from` | `android` / `ios` |
| `role` | `user` |
| `nonce` | MD5 of timestamp |

Authenticated endpoints add `Authorization: Bearer <token>` in repository layer.

### Response Handling

- Business `code` field checked per repository (expect `200`)
- API `code == 600` → forced logout via interceptor (`clearDataLogout()` + redirect to login)
- Errors localized via `LanguageServices` strings
- Errors logged to Firebase Crashlytics

### API Endpoint Examples

| Endpoint | Repository |
|----------|--------------|
| `/account/base/user/captchaLogin` | `LoginRegisterRepository` |
| `/user/api/user/queryUserInfo` | `UserRepository` |
| `/pushSingle/api/netty/queryOrderServer` | `OrderRideRepository` |
| `/cancelOrder/api/cancel/driverCancelChoice` | `OrderRideRepository` |

**Assumption:** Backend is a custom Java/Netty microservice architecture based on URL paths (`pushSingle`, `netty`).

---

## 13. Local Storage Overview

### FlutterSecureStorage

```dart
// Written on OTP login
await storage.write(key: "token", value: loginData.token);

// Read in repositories
var token = await storage.read(key: 'token');

// Device ID (auto-generated UUID, persisted)
await storage.write(key: "device_id", value: deviceId);
```

### SharedPreferences

```dart
// Language persistence
await prefs.setString('language_code', languageCode);

// Controller lifecycle (for safe logout/refresh)
await prefs.setBool('home_controller_registered', true);

// First-run wipe
if (prefs.getBool('first_run') ?? true) { storage.deleteAll(); }
```

### Not Used

- Hive, GetStorage, SQLite — not present in dependencies or code

---

## 14. Authentication Overview

### Login Flow

1. User enters mobile number (`LoginRegisterController`) → navigates to OTP screen
2. OTP requested via `OtpRepository.requestOTP(type: 2)`
3. User submits OTP → `LoginRegisterRepository.loginByOtp()` with phone, code, lat/lng
4. Token stored in `FlutterSecureStorage` key `token`
5. `UserServices.getUserInfo()` called
6. `Get.offAllNamed(Routes.HOME)`

### Token Storage

- **Key:** `token` in `FlutterSecureStorage`
- **Usage:** Bearer token on authenticated API calls

### Session Management

- Splash screen checks token presence
- API response `code == 600` triggers automatic logout
- Socket events can also trigger `clearDataLogout()`
- `UserServices.userInfo` holds in-memory user profile

### Logout Flow

`logout()` / `clearDataLogout()` in `common_helper.dart`:

1. Wait for in-flight controller operations
2. Unsubscribe FCM
3. Delete token from secure storage
4. Close WebSocket
5. Clear SharedPreferences
6. Clear `UserServices.userInfo`
7. Navigate to `LOGIN_REGISTER`

### Onboarding

**Assumption:** New users with incomplete profiles are directed to `OnboardingRegistrationFormView` based on `UserInfo` fields (verified in home/account flows; exact redirect logic is in `HomeController`).

---

## 15. Theme & UI Overview

### Theme Strategy

- Minimal `ThemeData` in `main.dart` (text selection colors from `ThemeColorServices.primaryBlue`)
- **No Material 3 theme file** — colors and typography accessed via services

### Design System

| Service | Content |
|---------|---------|
| `ThemeColorServices` | Primary blue `#0060C6`, semantic colors (red/green/blue/yellow), neutral greys/slates |
| `TypographyServices` | Nunito Sans via `google_fonts` — heading/body/caption scale |

### Shared Widgets

| Widget | Purpose |
|--------|---------|
| `GlobalBodyHandler` | Loading spinner / critical error / body with `onInit` callback |
| `LoaderElevatedButtonWidget` | Button with loading state |
| `LoadingDialog` | Modal loading overlay |
| `DriverNearbyPositionWidget` | Custom map marker for nearby drivers |
| `AccessLocationRequiredWidget` | Location permission prompt |
| Dialogs | Driver cancel, advanced booking cancel/expired, GoPay payment dialogs |
| `DashedLine` | Visual connector for origin/destination UI |

### Responsive Strategy

- Fixed design ratio references (e.g., `375/812`, `375/369`) for layout calculations
- `MediaQuery` for screen dimensions
- `SafeArea` wrapper in `main.dart` builder
- `SlidingUpPanel` on home map for bottom sheet UX
- No dedicated responsive framework (e.g., ScreenUtil)

### Sub-View Decomposition

Large screens split into `*_sub_view.dart` files (e.g., `home_view/home_map_sub_view.dart`, `ride_order_detail_view/ride_order_*_panel_sub_view.dart`) — consistent pattern across modules.

---

## 16. Assets Overview

### Declared in `pubspec.yaml`

```
assets/images/
assets/icons/
assets/logos/
assets/jsons/
```

### Images (`assets/images/`)

- Onboarding illustrations (`img_onboarding_2.svg`, intro service SVGs)
- OTP illustration (`img_otp.svg`)
- Payment method UI (`img_payment_method_gopay_*.png`)
- Order checkout dialogs (`img_order_free_cancellation_fee.png`, etc.)
- Empty states (`img_latest_activity_not_found.svg`)

### Icons (`assets/icons/`)

~60 SVG/PNG icons: navigation (home, activity, account), map pins, payment (cash, GoPay, wallet), chat/call, flags (ID/EN), status indicators

### Logos (`assets/logos/`)

- `logo.png` (launcher icon source)
- `logo_google.svg`, `logo_facebook.svg`

### Fonts

- **No bundled fonts** — uses `google_fonts` package (Nunito Sans loaded at runtime)

### Localization Resources

- **Not using ARB/flutter_localizations**
- Strings loaded from **Firebase Remote Config** JSON keys: `user_lang_id`, `user_lang_en`, `user_lang_zh_cn`
- Parsed into `Language` model (`language_model.dart`)

---

## 17. Environment Configuration

### Current Setup

`lib/environment.dart` — **manual comment/uncomment** to switch environments:

| Environment | `baseUrl` | `env` | Status |
|-------------|-----------|-------|--------|
| Production | `https://api.evmotoid.com` | `prod` | Commented out |
| Development v2 | `http://8.215.203.97:8500` | `dev` | **Active** |
| Development v1 | `http://api-dev.evmotoapp.com:8500` | `dev` | Commented out |

### Environment Flag Usage

- `env == "dev"` → shows "Dev" banner + WebSocket ping overlay in `main.dart`
- No Flutter flavors or `--dart-define` build variants found

### External Config

| Config | Source |
|--------|--------|
| Google Maps API key | `local.properties` → `MAPS_API_KEY` (Android), Xcode `MAPS_API_KEY` (iOS) |
| Firebase | `google-services.json` / `GoogleService-Info.plist` |
| Signing | `key.properties` (Android release) |

**Assumption:** Production builds require manually editing `environment.dart` before release — no CI flavor automation detected.

---

## 18. Third-Party Services

| Service | Integration | Usage |
|---------|-------------|-------|
| **Firebase Core** | `main.dart` | App initialization |
| **Firebase Crashlytics** | `main.dart`, `ApiServices` | Fatal error reporting |
| **Firebase Remote Config** | `FirebaseRemoteConfigServices` | i18n strings, Sendbird app ID, CS WhatsApp number |
| **Firebase Cloud Messaging** | `FirebasePushNotificationServices` | Push notifications, Sendbird call wake |
| **Firebase Storage** | `UploadImageRepository` | Chat image uploads |
| **Cloud Firestore** | Chat controllers | Order chat persistence |
| **Google Maps** | `google_maps_flutter` | Home map, ride tracking, map select |
| **Sendbird Calls** | Native SDK + method channel | Driver voice/video calls |
| **Sendbird Chat SDK** | `SendbirdChatServices` | In-app messaging |
| **Geolocator** | `LocationServices` | GPS positioning |
| **CallKit** | `flutter_callkit_incoming` | iOS/Android incoming call UI |
| **App Links** | `DeepLinkServices` | `evmoto://` deep links |

---

## 19. Build & Deployment Overview

### Android (`android/app/build.gradle.kts`)

| Setting | Value |
|---------|-------|
| Application ID | `com.evmoto.user.app` |
| minSdk | Flutter default (21 via launcher icons config) |
| targetSdk | 35 |
| compileSdk | Flutter default |
| JVM | 17 |
| Release | Minify enabled, ProGuard rules |
| Plugins | Google Services, Firebase Crashlytics |
| Native deps | `sendbird-calls:1.12.3`, desugaring for notifications |

### iOS (`ios/Runner/Info.plist`)

| Setting | Value |
|---------|-------|
| Display name | Evmoto |
| Background modes | `remote-notification`, `voip` |
| URL scheme | `evmoto` |
| Permissions | Camera, microphone, photo library, location (always + when in use), VoIP |

### Flavors / Variants

- **No product flavors** configured
- Environment switching via `environment.dart` source edit
- Dev banner shown when `env == "dev"`

### Versioning

- `pubspec.yaml`: `1.2.8+51`
- Server-side version check via `VersioningServerRepository` (force-update flow in `HomeController`)

---

## 20. Development Standards Summary

Inferred conventions from the codebase:

1. **Get CLI module structure** — each feature has `bindings/`, `controllers/`, `views/`
2. **GetView + Obx** — views extend `GetView<T>`, reactive UI via `Obx` (no `GetBuilder`, no `StatefulWidget`)
3. **Repository per domain** — API logic in `lib/app/repositories/`, not in controllers
4. **Constructor injection in bindings** — repositories passed to controller constructors
5. **Global services in `main.dart`** — cross-cutting concerns as permanent `GetxService`
6. **Sub-view decomposition** — complex screens split into `*_sub_view.dart` files
7. **Shared loading/error pattern** — `isFetch`, `isCriticalError`, `GlobalBodyHandler`
8. **Service-based design tokens** — `ThemeColorServices` + `TypographyServices` instead of `Theme.of(context)`
9. **Remote i18n** — strings from Firebase Remote Config, not local ARB files
10. **Snackbar helper** — centralized `SnackbarHelper` for user feedback

---

## 21. Current Architectural Inconsistencies

| Finding | Details |
|---------|---------|
| **Duplicate controller registration on HOME** | `HomeBinding` registers `AccountController` + `ActivityController`; HOME route also includes `AccountBinding` + `ActivityBinding` separately |
| **Repositories not in DI container** | Repositories instantiated with `new` in bindings; some controllers also call `Get.find` on other controllers directly |
| **Dual chat systems** | Firestore chat (`chat_list`/`chat_detail`) AND Sendbird chat (`sendbird_chat_*`, `ride_chat_sendbird`) coexist |
| **Environment switching** | Manual file edit vs. build flavors/`--dart-define` |
| **Payment methods incomplete** | UI modules and dialog assets exist; `AccountPaymentMethodController` is a stub without repository calls |
| **Large controllers** | `HomeController` (~1600+ lines), `RideOrderDetailController` (~2200+ lines) — high complexity |
| **Controller registration flags** | SharedPreferences booleans (`home_controller_registered`) used to coordinate lifecycle — fragile pattern |
| **Sendbird user ID prefix mismatch** | `environment.dart` defines `prefixSendbirdUser` but `SendbirdServices` hardcodes `"user_${id}"` |
| **Logout cleanup incomplete** | `clearDataLogout()` has commented-out Sendbird logout calls |
| **Build artifacts in source** | `ride_order_done/controllers/build/ios/` — Xcode build cache committed under module folder |
| **Mixed API payload formats** | Some endpoints use `FormData`, others JSON — inconsistent but per-endpoint |
| **reactive_forms limited use** | Only used in ~8 files; most forms use manual `FormState` validation |

---

## 22. Project Health Assessment

### Strengths

- **Consistent GetX module scaffolding** across 37 features
- **Clear separation** of repositories, services, and controllers
- **Comprehensive ride lifecycle** — booking, tracking, cancellation, rating, advanced booking
- **Real-time infrastructure** — WebSocket + FCM + Firestore for live updates
- **Shared UI primitives** — `GlobalBodyHandler`, typography/color services, snackbar helper
- **Crash reporting** integrated on API errors and Flutter errors
- **Remote config i18n** allows string updates without app release

### Risks

- **Oversized controllers** — `HomeController` and `RideOrderDetailController` are difficult to test and maintain
- **Tight coupling** — controllers directly `Get.find` other controllers across module boundaries
- **No automated environment management** — easy to ship dev URL to production
- **Dual chat architectures** — increased complexity and potential user confusion
- **No local caching layer** — repeated API calls; offline behavior limited
- **Payment feature half-built** — UI ahead of backend integration
- **Build artifacts in repo** — `ride_order_done/controllers/build/` should be gitignored
- **Token/session edge cases** — `prefs.clear()` on logout wipes language preference too

---

## 23. Recommended Improvements

Preserving GetX architecture:

1. **Split mega-controllers** — Extract `HomeController` map logic, socket handlers, and version-check into mixins or dedicated services; same for `RideOrderDetailController` socket/Firestore sections
2. **Fix HOME binding duplication** — Register `AccountController`/`ActivityController` in one place only (either `HomeBinding` or separate bindings, not both)
3. **Introduce `--dart-define` or flavors** — Replace manual `environment.dart` edits with `APP_ENV=dev|prod` build config
4. **Register repositories in bindings** — `Get.lazyPut<UserRepository>()` for testability and consistency
5. **Complete payment method layer** — Add `PaymentMethodRepository`, wire controllers to API, unify checkout payment selection
6. **Consolidate chat strategy** — Document and eventually unify Firestore vs Sendbird responsibilities; remove dead code paths
7. **Preserve language on logout** — Save `language_code` before `prefs.clear()`, restore after
8. **Add `.gitignore` entries** — Exclude `**/build/` under `lib/` and iOS/Android build caches
9. **Extract socket event handlers** — Move switch/case logic from `SocketServices` into per-event handler classes
10. **Standardize API error handling** — Base repository mixin for `code != 200` checks and token header injection
11. **Align Sendbird user ID** — Use `prefixSendbirdUser` from `environment.dart` consistently
12. **Add integration tests** — At minimum for auth flow (splash → login → home) and order creation happy path

---

## Key File References

| File | Role |
|------|------|
| `lib/main.dart` | App bootstrap, services, routing callback |
| `lib/environment.dart` | API/socket URLs, environment flag |
| `lib/app/routes/app_pages.dart` | All route definitions |
| `lib/app/services/api_services.dart` | Dio client, interceptors |
| `lib/app/utils/common_helper.dart` | Logout, loading dialog |
| `lib/app/modules/home/controllers/home_controller.dart` | Core home orchestration |
| `lib/app/modules/splash_screen/controllers/splash_screen_controller.dart` | Auth gate |
| `pubspec.yaml` | Dependencies, assets, version |

---

*Last analyzed: June 2026 — based on workspace state including in-progress payment method modules.*
