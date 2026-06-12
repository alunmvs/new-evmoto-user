# UI Guidelines — new-evmoto-user

Reverse-engineered from the existing Flutter + GetX codebase. These guidelines reflect **actual implementation**, not generic Flutter advice.

**Analysis date:** June 2026  
**Modules analyzed:** 37 feature modules under `lib/app/modules/`  
**Views analyzed:** ~106 `*_view.dart` files

---

## 1. Overview

### UI Architecture

This project uses a **GetX feature-module architecture** generated and maintained via `get_cli`:

```
Route (GetPage)
  → Binding (dependency injection)
    → Controller (state + business logic)
      → View (GetView)
        → SubViews (feature-local widgets)
        → Shared Widgets (lib/app/widgets/)
```

**Data flow:**
- Controllers hold reactive state (`Rx` / `.obs`) and call repositories/services.
- Views read controller state via `GetView<Controller>` and rebuild with `Obx`.
- Global design tokens live in **GetxService** singletons, not in `ThemeData`.

**App entry (`lib/main.dart`):**
- `GetMaterialApp` with `AppPages.routes` and `AppPages.INITIAL` (`/splash-screen`).
- Permanent services registered at startup: `ThemeColorServices`, `TypographyServices`, `LanguageServices`, `ApiServices`, etc.
- Global `SafeArea` + tap-to-dismiss-keyboard applied in `builder`.
- `rootScaffoldMessengerKey` used for app-wide snackbars.

### What does NOT exist in this project

The following folders from the analysis scope are **not present**:

| Expected path | Status |
|---|---|
| `lib/app/theme/` | Not found |
| `lib/app/design_system/` | Not found |
| `lib/app/core/` | Not found |
| `lib/app/shared/` | Not found |
| `lib/app/common/` | Not found |
| `lib/app/global_widgets/` | Not found |

Design tokens are instead in `lib/app/services/theme_color_services.dart` and `lib/app/services/typography_services.dart`.

---

## 2. UI Folder Structure

```
lib/
└── app/
    ├── modules/          # Feature screens (37 modules)
    │   └── {feature}/
    │       ├── bindings/
    │       ├── controllers/
    │       └── views/
    │           ├── {feature}_view.dart
    │           └── {feature}_view/          # Sub-view folder (optional)
    │               └── *_sub_view.dart
    ├── routes/
    │   ├── app_pages.dart    # GetPage registration
    │   └── app_routes.dart   # Route constants (part of app_pages)
    ├── widgets/              # Shared/reusable UI components
    │   ├── dialogs/
    │   └── bottomsheets/
    ├── services/             # Global services incl. theme, typography, i18n
    ├── data/                 # Models and constants
    ├── repositories/         # API/data access
    └── utils/                # Helpers (snackbar, maps, etc.)
```

### Responsibilities

| Folder | Role |
|---|---|
| `modules/` | Feature-specific UI, state, and DI bindings |
| `routes/` | Central route table (`AppPages`, `Routes`, `_Paths`) |
| `widgets/` | Cross-feature reusable widgets, dialogs, bottom sheets |
| `services/` | App-wide singletons: colors, typography, language, API, sockets |
| `utils/` | Non-UI helpers (`SnackbarHelper`, `common_helper`, etc.) |
| `data/` | Models consumed by controllers |
| `repositories/` | Instantiated in bindings, injected into controllers |

---

## 3. Module Structure

### Organization

Every feature module follows the GetX CLI convention:

```
lib/app/modules/{feature_name}/
├── bindings/{feature_name}_binding.dart
├── controllers/{feature_name}_controller.dart
└── views/{feature_name}_view.dart
```

Complex screens decompose into **sub-views** under a nested folder:

```
lib/app/modules/home/views/
├── home_view.dart
└── home_view/
    ├── home_map_sub_view.dart
    ├── home_app_bar_sub_view.dart
    └── home_bottom_navigation_bar_subview.dart
```

### Naming Conventions

| Artifact | Pattern | Example |
|---|---|---|
| Module folder | `snake_case` | `create_order_ride_checkout` |
| Binding class | `{PascalFeature}Binding` | `CreateOrderRideCheckoutBinding` |
| Controller class | `{PascalFeature}Controller` | `CreateOrderRideCheckoutController` |
| Main view class | `{PascalFeature}View` | `CreateOrderRideCheckoutView` |
| Sub-view class | `{Descriptive}SubView` | `CheckoutFooterSubView` |
| Sub-view file | `{descriptive}_sub_view.dart` | `checkout_footer_sub_view.dart` |
| Route path | `/kebab-case` | `/create-order-ride-checkout` |
| Route constant | `SCREAMING_SNAKE_CASE` | `Routes.CREATE_ORDER_RIDE_CHECKOUT` |

### All Feature Modules (37)

`account`, `account_payment_method`, `account_payment_method_gopay_detail`, `activity`, `activity_detail`, `add_account_payment_method`, `add_edit_address`, `add_edit_address_other`, `add_edit_user_information`, `advanced_booking_detail`, `advanced_booking_searching_driver`, `chat_detail`, `chat_list`, `create_order_ride`, `create_order_ride_checkout`, `create_order_ride_map_select`, `create_order_ride_promo`, `home`, `login_register`, `login_register_verification_otp`, `onboarding_registration_form`, `photo_viewer`, `privacy_policy`, `ride_call_sendbird`, `ride_chat_sendbird`, `ride_checkout_select_payment_method`, `ride_order_cancel`, `ride_order_detail`, `ride_order_done`, `search_address`, `sendbird_chat_detail`, `sendbird_chat_list`, `setting_language`, `setting_saved_location`, `splash_screen`, `terms_and_conditions`, `voucher_list`

---

## 4. View Guidelines

### Dominant Pattern: `GetView<Controller>`

Nearly all screens extend `GetView` with a `const` constructor:

```dart
// lib/app/modules/login_register/views/login_register_view.dart
class LoginRegisterView extends GetView<LoginRegisterController> {
  const LoginRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(/* ... */));
  }
}
```

`GetView` provides the `controller` getter automatically — no manual `Get.find`.

### Sub-Views

Feature sections are extracted into sub-views that **also extend `GetView`** and reference the parent module's controller:

```dart
// lib/app/modules/account/views/account_view/account_menu_section_1_sub_view.dart
class AccountMenuSection1SubView extends GetView<AccountController> {
  const AccountMenuSection1SubView({super.key});
  // ...
}
```

Sub-views are composed in the parent view:

```dart
// lib/app/modules/home/views/home_view.dart
children: [
  HomeMapSubView(),
  HomeShortcutSubView(),
  HomeAdvertisementListSubView(),
  HomeActiveOrderSubView(),
],
```

### Exceptions (Inconsistencies)

| Class | Base | File | Reason |
|---|---|---|---|
| `SearchAddressView` | `StatelessWidget` | `search_address_view.dart` | Uses `Get.find<SearchAddressController>(tag: Get.arguments['tag'])` manually |
| `ActivityCardStatus` | `StatelessWidget` | `activity_card_status_sub_view.dart` | Stateless dispatcher widget, no controller access |

### Not Used

- `GetWidget` — **0 usages**
- `StatefulWidget` — **0 usages** in `lib/app/`
- `GetBuilder` — **0 usages**

### Preferred Approach

1. Use `GetView<FeatureController>` for all screens and sub-views.
2. Wrap reactive sections in `Obx`.
3. Use `const` constructors on views where possible.
4. Keep views free of business logic — delegate to controller methods.

---

## 5. Controller Guidelines

### Base Class

All controllers extend `GetxController`:

```dart
class LoginRegisterController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  // ...
}
```

### Responsibilities

Controllers are responsible for:
- Reactive state (`final foo = value.obs`)
- Form state (`TextEditingController`, `GlobalKey<FormState>`)
- Repository calls (injected via constructor)
- Navigation (`Get.toNamed`, `Get.back`, etc.)
- Showing dialogs/bottom sheets/snackbars
- Lifecycle data fetching

Views should **not** contain API calls, validation logic, or navigation — though some views do trigger `Get.toNamed` directly (see inconsistencies).

### Dependency Injection Pattern

Repositories are constructor-injected; services are resolved via `Get.find`:

```dart
// lib/app/modules/home/controllers/home_controller.dart
class HomeController extends GetxController {
  final UserRepository userRepository;
  // ...

  HomeController({required this.userRepository, /* ... */});

  final themeColorServices = Get.find<ThemeColorServices>();
  final languageServices = Get.find<LanguageServices>();
}
```

### Lifecycle Methods

| Method | Usage in Project |
|---|---|
| `onInit()` | Primary data-loading entry point. Often sets `isFetch.value = true`, calls APIs, then `isFetch.value = false`. |
| `onReady()` | Present in many controllers but frequently empty or only calls `super.onReady()`. |
| `onClose()` | Disposes `TextEditingController`, cancels timers, removes listeners. |

**Example — splash screen init:**

```dart
// lib/app/modules/splash_screen/controllers/splash_screen_controller.dart
@override
Future<void> onInit() async {
  super.onInit();
  isFetch.value = true;
  try {
    await checkIfAppFirstRun();
    await getSplashScreenQueryImage();
    isFetch.value = false;
    // navigate based on token
    Get.offAndToNamed(Routes.HOME);
  } on DioException catch (e) {
    SnackbarHelper.showSnackbarError(text: e.error.toString());
    isCriticalError.value = true;
    isFetch.value = false;
  }
}
```

---

## 6. State Management Guidelines

### Reactive Primitives

| Pattern | Usage |
|---|---|
| `.obs` on primitives, models, lists | Primary state mechanism |
| `RxList`, `RxMap` | Used for collections (e.g. `driverNearbyList`, `markers`) |
| `Obx(() => ...)` | **Exclusive** rebuild mechanism for reactive UI |
| `GetBuilder` | **Not used** |
| `update()` | **Not used** (no `GetBuilder` consumers) |
| Workers (`ever`, `debounce`, `interval`) | Rare — only `ever()` found in `RideOrderDetailController` |

### When to Use `Obx`

Wrap any widget tree that reads `.value` from reactive variables:

```dart
// lib/app/modules/home/views/home_view.dart
return Obx(() => PopScope(
  child: Scaffold(
    backgroundColor: controller.indexNavigationBar.value == 0
        ? controller.themeColorServices.neutralsColorGrey0.value
        : controller.themeColorServices.primaryBlue.value,
    // ...
  ),
));
```

Nested `Obx` is common for isolating rebuilds inside large screens (e.g. `HomeView` panel builder).

### Common State Variable Names

| Variable | Meaning |
|---|---|
| `isFetch` | Initial/full-screen data loading |
| `isCriticalError` | Unrecoverable fetch failure (shows retry via `GlobalBodyHandler`) |
| `isFormValid` | Form submit button enablement |
| `isLoading` / `isShowLoading` | Button or inline loading (via `LoaderElevatedButton`) |
| `isFetchAddressSearch` | Secondary/sub-resource loading |

### Accessing Services in Views

Through the controller (dominant):

```dart
controller.themeColorServices.primaryBlue.value
controller.typographyServices.bodyLargeBold.value
controller.languageServices.language.value.loginTitle ?? "-"
```

---

## 7. Widget Composition Guidelines

### Three Tiers

```
┌─────────────────────────────────────────┐
│  Screen View ({Feature}View)            │
│  ┌───────────────────────────────────┐  │
│  │  Sub-Views (*_sub_view.dart)      │  │  ← Feature-local, GetView-based
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │  Shared Widgets (lib/app/widgets/)│  │  ← Cross-feature reusable
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

### When to Create Each

| Type | Location | When |
|---|---|---|
| **Local sub-view** | `modules/{feature}/views/{feature}_view/` | UI section > ~50 lines, reused within same feature, needs controller access |
| **Shared widget** | `lib/app/widgets/` | Used by 2+ features (buttons, dialogs, bottom sheets, error handlers) |
| **Inline widget** | Inside view file | Small one-off UI with no reuse expected |

### Real Examples

**Screen widget:**
- `lib/app/modules/ride_order_detail/views/ride_order_detail_view.dart`

**Feature sub-views (deeply nested):**
- `lib/app/modules/activity/views/activity_view/activity_history_order_card_sub_view/activity_card_status_sub_view/activity_card_status_completed_sub_view.dart`

**Shared widgets:**
- `lib/app/widgets/loader_elevated_button_widget.dart`
- `lib/app/widgets/global_body_handler.dart`
- `lib/app/widgets/dialogs/payment_method_gopay_success_bind_dialog.dart`

### Composition Pattern in Complex Screens

`RideOrderDetailView` composes 10+ sub-views; `HomeView` embeds other module views (`ActivityView`, `AccountView`) inside an `IndexedStack` for bottom navigation.

---

## 8. Design System

### Token Location

There is no `design_system/` folder. Tokens are **GetxService singletons**:

| Token Type | Service | File |
|---|---|---|
| Colors | `ThemeColorServices` | `lib/app/services/theme_color_services.dart` |
| Typography | `TypographyServices` | `lib/app/services/typography_services.dart` |
| Strings/i18n | `LanguageServices` | `lib/app/services/language_services.dart` |

### Usage Pattern

```dart
final themeColorServices = Get.find<ThemeColorServices>();
final typographyServices = Get.find<TypographyServices>();

// In widget:
color: themeColorServices.primaryBlue.value
style: typographyServices.bodyLargeBold.value
```

All tokens are wrapped in `.obs` (reactive), accessed via `.value`.

### Spacing Conventions (Observed)

| Value | Usage |
|---|---|
| `4` | Tight gaps (label to field) |
| `8` | Small spacing, icon gaps |
| `12` | Input content padding, small card padding |
| `16` | **Standard horizontal screen padding**, section gaps |
| `24` | Card internal padding, larger section gaps |
| `32` | Large section breaks |

### Border Radius Conventions

| Value | Usage |
|---|---|
| `8` | Text fields, small icon containers |
| `10` | Alert banners, small chips |
| `12` | Cards, snackbars, images |
| `16` | Containers, dialogs, bottom sheets, panels |
| `9999` / `99999999` | Circular buttons, FAB-style controls |

### Elevation / Shadows

No centralized elevation tokens. Shadows are inline `BoxShadow`:

```dart
BoxShadow(
  color: themeColorServices.overlayDark200.value.withValues(alpha: 0.12),
  blurRadius: 16,
  spreadRadius: 2,
  offset: Offset(0, -1),
)
```

### Background Gradients (Repeated Pattern)

Many form/settings screens use:

```dart
LinearGradient(
  colors: [Color(0XFFF5F9FF), Color(0XFFCDE2F8)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
)
```

Seen in: `search_address_view.dart`, `account_payment_method_view.dart`, `setting_saved_location_view.dart`, and others.

---

## 9. Theme Guidelines

### ThemeData

Minimal `ThemeData` in `lib/main.dart` — only `textSelectionTheme` is configured:

```dart
theme: ThemeData(
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Get.find<ThemeColorServices>().primaryBlue.value,
    selectionColor: Get.find<ThemeColorServices>().primaryBlue.value
        .withValues(alpha: 0.2),
    selectionHandleColor: Get.find<ThemeColorServices>().primaryBlue.value,
  ),
),
```

### No Theme Extensions

No `ThemeExtension`, no `AppTheme` class, no dark mode.

### System UI

Configured globally in `main()`:

```dart
SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
));
```

### AppBar Styling

Per-screen inline styling (not from `ThemeData.appBarTheme`):

```dart
AppBar(
  backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
  surfaceTintColor: controller.themeColorServices.neutralsColorGrey0.value,
  title: Text("...", style: controller.typographyServices.bodyLargeBold.value),
  centerTitle: false,
)
```

---

## 10. Color Guidelines

**Source:** `lib/app/services/theme_color_services.dart`

### Primary

| Token | Hex | Usage |
|---|---|---|
| `primaryBlue` | `#0060C6` | Primary actions, focus borders, progress indicators, links |

### Semantic — Red (Error/Danger)

| Token | Hex |
|---|---|
| `sematicColorRed100` | `#FFD2D2` |
| `sematicColorRed400` | `#F44336` |
| `sematicColorRed500` | `#A32A21` |
| `redColor` | `#E11C0B` |

### Semantic — Green (Success)

| Token | Hex |
|---|---|
| `sematicColorGreen100` | `#CAEDDB` |
| `sematicColorGreen200` | `#99CEB3` |
| `sematicColorGreen400` | `#63B871` |
| `sematicColorGreen500` | `#17412C` |

### Semantic — Blue

| Token | Hex |
|---|---|
| `sematicColorBlue100` | `#CFE9FC` |
| `sematicColorBlue200` | `#7AC0F8` |
| `sematicColorBlue300` | `#4DABF5` |
| `sematicColorBlue400` | `#2196F3` |
| `sematicColorBlue500` | `#145F9A` |
| `sematicColorBlue600` | `#072841` |

### Semantic — Yellow (Warning)

| Token | Hex |
|---|---|
| `sematicColorYellow100` | `#FFEACC` |
| `sematicColorYellow300` | `#FFAD33` |
| `sematicColorYellow400` | `#FF9800` |

### Neutrals — Grey

| Token | Hex | Usage |
|---|---|---|
| `neutralsColorGrey0` | `#FFFFFF` | White backgrounds, button text |
| `neutralsColorGrey100` | `#F2F2F2` | Light backgrounds |
| `neutralsColorGrey200` | `#E5E5E5` | Borders |
| `neutralsColorGrey300` | `#D9D9D9` | Disabled buttons |
| `neutralsColorGrey400` | `#B2B2B2` | Hints, placeholders |
| `neutralsColorGrey500` | `#808080` | Secondary text |
| `neutralsColorGrey600`–`900` | `#4D4D4D`–`#2C2D3A` | Dark text/backgrounds |

### Neutrals — Slate

| Token | Hex |
|---|---|
| `neutralsColorSlate100` | `#E0E3EB` |
| `neutralsColorSlate300` | `#94A1BC` |
| `neutralsColorSlate400` | `#7C8CB0` |
| `neutralsColorSlate700` | `#242B37` |
| `neutralsColorSlate800` | `#1A1F28` |

### Overlay

| Token | Notes |
|---|---|
| `overlayDark100`, `overlayDark200` | `#000000` — used with `.withValues(alpha: ...)` for shadows |

### Snackbar Colors (Hardcoded in SnackbarHelper)

| Type | Background | Text |
|---|---|---|
| Success | `#E1FFE9` | `#005216` |
| Error | `#FFEBEB` | `#CD0000` |

---

## 11. Typography Guidelines

**Source:** `lib/app/services/typography_services.dart`  
**Font:** Google Fonts — **Nunito Sans**

### Scale

| Token | Weight | Size | Line Height | Typical Use |
|---|---|---|---|---|
| `headingLargeBold` | 700 | 32 | 1.2 | — (defined, rarely seen in views) |
| `headingMediumBold` | 700 | 24 | 1.2 | — |
| `headingSmallBold` | 700 | 20 | 1.4 | Screen titles (login) |
| `bodyLargeBold` | 700 | 16 | 1.4 | AppBar titles, section headers, buttons |
| `bodyLargeRegular` | 400 | 16 | 1.4 | — |
| `bodySmallRegular` | 400 | 14 | 1.2 | Body text, input text |
| `bodySmallBold` | 700 | 14 | 1.2 | Emphasized body, card titles |
| `captionLargeBold` | 700 | 12 | 1.2 | Small labels |
| `captionLargeRegular` | 500 | 12 | 1.2 | Secondary info, addresses |
| `captionSmallBold` | 700 | 10 | 1.2 | Dev overlay |
| `captionSmallRegular` | 500 | 10 | 1.2 | Dev overlay |

### Usage Pattern

```dart
Text(
  controller.languageServices.language.value.loginTitle ?? "-",
  style: controller.typographyServices.headingSmallBold.value,
)

// With color override:
style: controller.typographyServices.bodySmallRegular.value.copyWith(
  color: controller.themeColorServices.neutralsColorGrey400.value,
)
```

### No Material TextTheme

The project does **not** use `Theme.of(context).textTheme`. All text styling goes through `TypographyServices`.

---

## 12. Layout Guidelines

### Screen Padding

**Standard horizontal padding: `16`**

```dart
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: /* content */,
)
```

### Section Spacing

Common vertical rhythm: `SizedBox(height: 8)`, `16`, `24`, `32` between sections.

### Scrolling Patterns

| Pattern | Where |
|---|---|
| `SingleChildScrollView` | Form screens (login, settings, checkout) |
| `ListView` / `Column` + scroll | Activity lists |
| `SmartRefresher` / `RefreshIndicator` | Pull-to-refresh lists |
| `IndexedStack` | Home bottom navigation (preserves tab state) |
| `SlidingUpPanel` | Home map bottom sheet |
| `Stack` | Layered backgrounds (gradient behind content) |

### Background Layer Pattern

Many screens use a `Stack` with a full-screen gradient/container behind scrollable content:

```dart
body: Stack(
  children: [
    Container(/* gradient background */),
    SingleChildScrollView(/* foreground content */),
  ],
)
```

### SafeArea

- **Not** used in individual module views.
- Applied globally in `main.dart` `builder` wrapping the entire app (`bottom: true` only).
- Dev mode adds extra `SafeArea` + debug overlay.

### AppBar

- Default `toolbarHeight`: `56`
- Titles typically left-aligned (`centerTitle: false`)
- White/transparent backgrounds

---

## 13. Responsive Design Guidelines

### Strategy: MediaQuery Proportions

The project uses **fixed design-width ratios** based on a **375px** reference frame:

```dart
width: MediaQuery.of(context).size.width * 317 / 375
height: MediaQuery.of(context).size.height * (147 / 812)
```

`812` is used as the reference screen height in `GlobalBodyHandler`.

### Not Found

| Tool | Status |
|---|---|
| `flutter_screenutil` / `ScreenUtil` | Not used |
| `LayoutBuilder` | Not used |
| `responsive_framework` | Not used |
| Breakpoint-based layouts | Not used |

### Full-Width Elements

Buttons and containers frequently use:

```dart
width: MediaQuery.of(context).size.width
```

`LoaderElevatedButton` defaults to full screen width unless `isWidthFitToContent: true`.

---

## 14. Navigation Guidelines

### Route Registration

All routes in `lib/app/routes/app_pages.dart`:

```dart
GetPage(
  name: _Paths.RIDE_ORDER_DETAIL,
  page: () => const RideOrderDetailView(),
  binding: RideOrderDetailBinding(),
),
```

### Naming Convention

| Layer | Format | Example |
|---|---|---|
| `_Paths` constant | `/kebab-case` | `/ride-order-detail` |
| `Routes` constant | `SCREAMING_SNAKE` | `Routes.RIDE_ORDER_DETAIL` |

### Multi-Binding Routes

Home registers multiple bindings for tab controllers:

```dart
GetPage(
  name: _Paths.HOME,
  page: () => const HomeView(),
  bindings: [HomeBinding(), AccountBinding(), ActivityBinding()],
),
```

### Navigation Methods (Observed)

| Method | When Used |
|---|---|
| `Get.toNamed(Routes.FEATURE, arguments: {...})` | Push new screen |
| `Get.offAndToNamed(Routes.FEATURE)` | Replace current (splash → home/login) |
| `Get.offAllNamed(Routes.FEATURE)` | Clear stack (logout) |
| `Get.back()` / `Get.back(result: data)` | Pop with optional result |
| `Get.close(1)` | Close dialog/bottom sheet |

### Arguments Pattern

```dart
Get.toNamed(Routes.LOGIN_REGISTER_VERIFICATION_OTP, arguments: {
  "mobile_phone": "62...",
});

// In binding — tagged controller:
Get.lazyPut<SearchAddressController>(
  () => SearchAddressController(geocodingRepository: GeocodingRepository()),
  tag: Get.arguments['tag'],
);
```

### Transitions

Only splash and login routes set `transition: Transition.noTransition`. All others use GetX default.

### Routing Callback

`main.dart` refreshes home/activity data when navigating to `Routes.HOME`.

---

## 15. Binding Guidelines

### Strategy

All bindings use **`Get.lazyPut`** — controllers are created on first route access.

```dart
// lib/app/modules/account/bindings/account_binding.dart
class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountController>(
      () => AccountController(
        otpRepository: OtpRepository(),
        userRepository: UserRepository(),
        orderRideRepository: OrderRideRepository(),
      ),
    );
  }
}
```

### Patterns

| Pattern | Example |
|---|---|
| Standard lazy put | All 37 bindings |
| Repository in binding | `UserRepository()` instantiated in binding, passed to controller |
| Tagged lazy put | `SearchAddressBinding` uses `tag: Get.arguments['tag']` |
| Multiple bindings per route | `HomeBinding` + `AccountBinding` + `ActivityBinding` on `/home` |
| `Get.put(..., permanent: true)` | Only for app-level services in `main.dart`, not feature controllers |
| `fenix:` | Not used |

### Permanent Services (main.dart)

```dart
Get.put(ThemeColorServices(), permanent: true);
Get.put(TypographyServices(), permanent: true);
Get.put(LanguageServices(), permanent: true);
// ... ApiServices, SocketServices, etc.
```

---

## 16. Form Guidelines

### Form Structure

```dart
// Controller:
final loginRegisterFormKey = GlobalKey<FormState>();
final mobileNumberTextEditingController = TextEditingController();
final isFormValid = false.obs;

// View:
Form(
  key: controller.loginRegisterFormKey,
  child: TextFormField(
    controller: controller.mobileNumberTextEditingController,
    validator: (value) { /* inline validation */ },
    onChanged: (value) {
      controller.mobilePhone.value = value;
      controller.validateForm();
    },
  ),
)
```

### TextFormField vs TextField

| Widget | When |
|---|---|
| `TextFormField` | Validated forms (login, registration, address) |
| `TextField` | Search inputs without form validation (`search_address_view.dart`) |

### Input Decoration Pattern

Inputs are styled **inline per screen** with consistent values:

```dart
decoration: InputDecoration(
  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: neutralsColorGrey400),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: primaryBlue, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: sematicColorRed500),
  ),
)
```

### Validation

- Inline `validator` callbacks on `TextFormField`
- Controller method `validateForm()` checks `formKey.currentState!.validate()`
- `isFormValid.obs` controls button enabled state
- `AutovalidateMode.disabled` — validation on submit/change, not on every keystroke initially

### Submit Buttons

Use `LoaderElevatedButton` with conditional `onPressed`:

```dart
LoaderElevatedButton(
  onPressed: controller.isFormValid.value ? () async {
    await controller.onTapSubmit();
  } : null,
  buttonColor: controller.isFormValid.value
      ? controller.themeColorServices.primaryBlue.value
      : controller.themeColorServices.neutralsColorGrey300.value,
  child: Text("Submit", style: /* ... */),
)
```

### Input Formatters

```dart
inputFormatters: [FilteringTextInputFormatter.digitsOnly]
```

---

## 17. Loading State Guidelines

### Full-Screen Loading

**Pattern 1: `isFetch` + `CircularProgressIndicator`**

```dart
if (controller.isFetch.value) ...[
  Center(child: SizedBox(
    width: 25, height: 25,
    child: CircularProgressIndicator(
      color: controller.themeColorServices.primaryBlue.value,
    ),
  )),
]
```

**Pattern 2: `GlobalBodyHandler`**

```dart
GlobalBodyHandler(
  isFetch: controller.isFetch.value,
  isCriticalError: controller.isCriticalError.value,
  onInit: () async { await controller.onInit(); },
  body: /* actual content */,
)
```

Used in: `splash_screen_view`, `ride_order_detail_view`, `activity_detail_view`, `ride_chat_sendbird_view`, `ride_call_sendbird_view`, `sendbird_chat_detail_view`, `advanced_booking_detail_view`, `home_view`.

### Blocking Dialog Loading

```dart
Get.dialog(LoadingDialog(), barrierDismissible: false);
// ... async work ...
Get.back();
```

Used in chat controllers and `add_edit_user_information_controller`.

### Button Loading

`LoaderElevatedButton` manages its own `isLoading.obs` internally — shows `CircularProgressIndicator` inside the button and morphs to a circle.

### No Skeleton Loaders

Skeleton/shimmer loading patterns are **not used** in this project.

---

## 18. Error State Guidelines

### Snackbar (Transient Errors)

```dart
// lib/app/utils/snackbar_helper.dart
SnackbarHelper.showSnackbarError(text: "message");
SnackbarHelper.showSnackbarSuccess(text: "message");
```

- Uses `rootScaffoldMessengerKey` from `main.dart` (not `Get.snackbar`)
- Floating, rounded (12px), 3-second duration
- Custom SVG icons from `assets/icons/`

### Critical Error (Full Screen)

`GlobalBodyHandler` shows:
- `assets/images/img_error.png`
- Localized title/description from `LanguageServices`
- Retry button via `LoaderElevatedButton`

### Error Dialogs

Custom dialog widgets for domain-specific errors:
- `lib/app/widgets/driver_cancel_dialog.dart`
- `lib/app/widgets/advanced_booking_cancel_dialog.dart`
- `lib/app/widgets/advanced_booking_expired_dialog.dart`

Triggered via `Get.dialog(...)` from controllers or services (`socket_services.dart`, `home_controller.dart`).

---

## 19. Empty State Guidelines

### Dedicated Empty Sub-Views

| Widget | Module | Asset |
|---|---|---|
| `VoucherEmptyListSubView` | voucher_list | `img_voucher_not_found.png` |
| `SavedAddressListEmptySubView` | setting_saved_location | Text-only (no image) |

### Inline Empty States

**Search — location not found** (`search_address_view.dart`):
- Image: `img_location_not_found.png` (72×72)
- Title + description from `LanguageServices`

**Home — no nearby drivers** (`home_view.dart`):
- Inline warning banner with `icon_alert_circle_driver_nearby_empty.svg`

### Pattern

```dart
if (controller.list.isEmpty) ...[
  // Image (optional)
  Text(title, style: typographyServices.bodyLargeBold.value),
  SizedBox(height: 8),
  Text(description, style: typographyServices.bodySmallRegular.value),
]
```

---

## 20. Dialog Guidelines

### Invocation

Dialogs are shown from **controllers** (dominant) and occasionally from **views**:

```dart
await Get.dialog(
  PaymentMethodGopaySuccessBindDialog(),
  barrierDismissible: true,
);
```

### Dialog Widget Structure

Located in `lib/app/widgets/dialogs/` (newer) or `lib/app/widgets/` (older):

```dart
class PaymentMethodGopaySuccessBindDialog extends StatelessWidget {
  final themeColorServices = Get.find<ThemeColorServices>();
  // ...

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              color: themeColorServices.neutralsColorGrey0.value,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: /* content */,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Conventions

| Aspect | Pattern |
|---|---|
| Dismiss | `Get.close(1)` or X button with `icon_close.svg` |
| Border radius | `16` on dialog container |
| Max width | `400` (constrained) |
| Actions | `LoaderElevatedButton` |
| Loading | `LoadingDialog` with `barrierDismissible: false` |

### Dialog Inventory

| File | Purpose |
|---|---|
| `loading_dialog.dart` | Blocking spinner |
| `dialogs/order_free_cancellation_fee_dialog.dart` | Promo/info |
| `dialogs/payment_method_gopay_*` | GoPay payment flow |
| `driver_cancel_dialog.dart` | Driver cancellation |
| `advanced_booking_cancel_dialog.dart` | Booking cancellation |
| `advanced_booking_expired_dialog.dart` | Expired booking |

---

## 21. Bottom Sheet Guidelines

### Invocation

From controllers (dominant):

```dart
await Get.bottomSheet(
  OrderCheckoutAdditionalCancellationFeeBottomsheet(),
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
);
```

### Widget Location

`lib/app/widgets/bottomsheets/`

### Structure Pattern

```dart
class OrderCheckoutAdditionalCancellationFeeBottomsheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: Material(
            color: themeColorServices.neutralsColorGrey0.value,
            child: Container(padding: EdgeInsets.all(16), /* ... */),
          ),
        ),
      ],
    );
  }
}
```

### Conventions

- Top corners: `Radius.circular(16)`
- Close via `Get.close(1)` + `icon_close.svg`
- `backgroundColor: Colors.transparent` on `Get.bottomSheet` call
- Some bottom sheets are defined inline in controllers (e.g. `account_controller.dart`, `setting_saved_location_controller.dart`) — see inconsistencies

---

## 22. Reusable Components

### Core Widgets

| Component | Location | Purpose |
|---|---|---|
| `LoaderElevatedButton` | `widgets/loader_elevated_button_widget.dart` | Primary CTA with async loading state |
| `GlobalBodyHandler` | `widgets/global_body_handler.dart` | Loading spinner / critical error / content switcher |
| `LoadingDialog` | `widgets/loading_dialog.dart` | Modal blocking loader |
| `DashedLine` | `widgets/dashed_line.dart` | Dashed divider line |
| `AccessLocationRequiredWidget` | `widgets/access_location_required_widget.dart` | Location permission prompt UI |
| `DriverNearbyPositionWidget` | `widgets/driver_nearby_position_widget.dart` | Map marker overlay |

### Helpers (UI-related)

| Helper | Location | Purpose |
|---|---|---|
| `SnackbarHelper` | `utils/snackbar_helper.dart` | Success/error snackbars |

### Dialogs

See Section 20.

### Bottom Sheets

| Component | Location |
|---|---|
| `OrderCheckoutAdditionalCancellationFeeBottomsheet` | `widgets/bottomsheets/` |

### Usage Example — LoaderElevatedButton

```dart
LoaderElevatedButton(
  onPressed: () async { await controller.submit(); },
  buttonColor: themeColorServices.primaryBlue.value,
  child: Text(
    "Submit",
    style: typographyServices.bodyLargeBold.value.copyWith(
      color: themeColorServices.neutralsColorGrey0.value,
    ),
  ),
)
```

### What's NOT Shared (Gap)

The project does **not** have shared wrappers for:
- `AppScaffold`
- `AppTextField` / `AppTextFormField`
- `AppBar` widget
- `AppCard`

These are duplicated inline across views.

---

## 23. UI Coding Standards

Standards inferred from dominant codebase patterns:

1. **Use `GetView<Controller>` for all screens and sub-views** with `const` constructors.
2. **Wrap reactive UI in `Obx`** — do not use `GetBuilder` or `setState`.
3. **Keep business logic in controllers** — API calls, navigation, dialog showing, validation.
4. **Access design tokens via services** — `Get.find<ThemeColorServices>()`, `TypographyServices`, `LanguageServices`.
5. **Use `LanguageServices` for all user-facing strings** — with `?? "-"` fallback.
6. **Use `LoaderElevatedButton` for async submit actions** instead of raw `ElevatedButton`.
7. **Use `GlobalBodyHandler` for screens with initial data fetch + error retry**.
8. **Use `SnackbarHelper` for toast messages** — not `Get.snackbar` or `ScaffoldMessenger` directly.
9. **Decompose large views into `*_sub_view.dart` files** under a nested view folder.
10. **Use 16px horizontal padding** as the default screen inset.
11. **Use `BorderRadius.circular(8)` for inputs, `16` for cards/containers**.
12. **Place cross-feature widgets in `lib/app/widgets/`** — feature-specific widgets stay in the module.
13. **Register controllers via `Bindings` with `Get.lazyPut`** — inject repositories in the binding constructor.
14. **Use `Get.toNamed(Routes.CONSTANT)` for navigation** — route constants from `app_pages.dart`.
15. **Prefer `SvgPicture.asset` for icons** and `Image.asset` for illustrations/photos.

---

## 24. Current Inconsistencies

### View Layer

| Issue | Details |
|---|---|
| `SearchAddressView` uses `StatelessWidget` | Only view that manually `Get.find`s controller with a tag instead of `GetView` |
| `ActivityCardStatus` uses `StatelessWidget` | Naming breaks `*SubView` convention |
| `home_bottom_navigation_bar_subview.dart` | Uses `subview` (lowercase) vs `sub_view` everywhere else |
| `const` constructor inconsistency | `SearchAddressView()` registered without `const` in `AppPages` |
| Navigation in views vs controllers | Some views call `Get.toNamed` directly (e.g. `login_register_view.dart`); most navigation is in controllers |

### Design Tokens

| Issue | Details |
|---|---|
| Hardcoded colors alongside `ThemeColorServices` | e.g. `Color(0XFFA65226)`, `Color(0XFFB3B3B3)`, `Color(0XFFE5E5E5)` in views and dialogs |
| Hardcoded strings | Newer payment method screens (`account_payment_method_view.dart`, GoPay dialogs) use inline Indonesian text instead of `LanguageServices` |
| No shared input theme | `InputDecoration` duplicated per screen with slight variations |
| Snackbar colors hardcoded | `SnackbarHelper` uses fixed hex values, not `ThemeColorServices` |

### Architecture

| Issue | Details |
|---|---|
| Duplicate controller registration | `HomeBinding` and `AccountBinding` both register `AccountController`; HOME route uses both |
| Bottom sheets in controllers | `account_controller.dart` and `setting_saved_location_controller.dart` define bottom sheet UI inline in controller files |
| `LoaderElevatedButton` has instance `isLoading.obs` | Declared as instance field on `StatelessWidget` — works but is unconventional |
| `onReady()` often empty | Many controllers override `onReady` with no logic |
| No `onClose` cleanup in many controllers | `TextEditingController` disposal inconsistent |

### State Management

| Issue | Details |
|---|---|
| No `GetBuilder` at all | Project is 100% `Obx` — large `Obx` wrappers may over-rebuild |
| Workers rarely used | Only one `ever()` worker in entire codebase |
| Mixed fetch state names | `isFetch`, `isFetchAddress`, `isFetchAddressSearch`, `isFetchAdvertisementList`, `isFetchTotalUnreadMessageCount` |

### Responsive

| Issue | Details |
|---|---|
| No responsive framework | All sizing via `MediaQuery` ratios or fixed pixels |
| Inconsistent ratio base | Most use `375` width reference; heights use `812` in some places only |

---

## 25. Recommended Improvements

Improvements that preserve the existing GetX architecture:

### High Priority

1. **Extract shared `AppTextFormField`** — Consolidate the repeated `InputDecoration` pattern (8px radius, grey border, blue focus, red error) into one widget in `lib/app/widgets/`.
2. **Migrate hardcoded strings to `LanguageServices`** — Especially in `account_payment_method_*` and GoPay dialog files.
3. **Migrate hardcoded colors to `ThemeColorServices`** — Add tokens for commonly inlined values (`#B3B3B3`, `#E5E5E5`, `#F5F9FF`, `#CDE2F8`, snackbar colors).
4. **Convert `SearchAddressView` to `GetView`** — Use `GetView<SearchAddressController>` with tag support for consistency.

### Medium Priority

5. **Extract shared `AppScaffold`** — Standardize the gradient background + `Stack` + `SingleChildScrollView` pattern used in 15+ screens.
6. **Move inline bottom sheets to `lib/app/widgets/bottomsheets/`** — Controllers in `account_controller.dart` and `setting_saved_location_controller.dart` should only invoke them.
7. **Resolve duplicate `AccountController` binding** — Home route should rely on `HomeBinding` only, or use `Get.lazyPut` with `fenix: true` to avoid duplicate registration.
8. **Add `AppBar` widget** — Standardize white background, `bodyLargeBold` title, no surface tint.

### Low Priority

9. **Standardize sub-view naming** — Rename `home_bottom_navigation_bar_subview.dart` → `home_bottom_navigation_bar_sub_view.dart` and `ActivityCardStatus` → `ActivityCardStatusSubView`.
10. **Use smaller `Obx` scopes** — Break top-level `Obx` in large views (`HomeView`, `LoginRegisterView`) into nested `Obx` around only reactive subtrees.
11. **Add `onClose` disposal consistently** — All controllers with `TextEditingController` should dispose in `onClose`.
12. **Consider `ever`/`debounce` workers** — For search input (`search_address_controller`) instead of direct `onChanged` API calls.

### Not Recommended

- Migrating away from GetX
- Introducing `GetBuilder` alongside `Obx`
- Adding a full `ThemeData` / dark mode without product requirement
- Introducing `ScreenUtil` mid-project (would conflict with existing `MediaQuery` ratio system)

---

## Quick Reference

```
New Screen Checklist:
  □ Create module: bindings/ + controllers/ + views/
  □ {Feature}Binding with Get.lazyPut + repository injection
  □ {Feature}Controller extends GetxController with isFetch/isCriticalError
  □ {Feature}View extends GetView with Obx + Scaffold
  □ Register GetPage in app_pages.dart
  □ Add Routes constant in app_routes.dart
  □ Use ThemeColorServices + TypographyServices + LanguageServices
  □ Use 16px horizontal padding, 8px input radius, 16px card radius
  □ Use LoaderElevatedButton for submits, SnackbarHelper for toasts
  □ Use GlobalBodyHandler if screen has initial data fetch
```
