# API Guidelines

## Overview

This project uses a **GetX + Repository** architecture for HTTP networking. There is no `lib/core/network`, `lib/features/**/data`, or code-generated API client layer (no Retrofit, Chopper, or `json_serializable`).

### Architecture

```
UI (View)
  → Controller (GetX)
    → Repository
      → ApiServices.dio (shared Dio instance)
        → Backend API
```

Supporting services sit alongside repositories:

- `UserServices` caches user profile state and delegates to `UserRepository`.
- `ApiServices` is registered as a permanent `GetxService` in `main.dart` and owns the shared `Dio` client.

### Network Stack

| Layer | Location | Role |
|---|---|---|
| HTTP client | `lib/app/services/api_services.dart` | Shared `Dio` instance, interceptors, global headers |
| Environment | `lib/environment.dart` | `baseUrl`, `socketUrl`, `env` constants |
| Repositories | `lib/app/repositories/*.dart` | Endpoint calls, auth headers, response parsing |
| Models | `lib/app/data/models/*.dart` | Manual `fromJson` / `toJson` data classes |
| Controllers | `lib/app/modules/*/controllers/*.dart` | UI state, error display, pagination orchestration |

### Main Libraries

- **dio** `^5.9.2` — HTTP client
- **dio_curl_logger** — request/response curl logging (disabled by default)
- **get** `^4.7.3` — DI, routing, reactive state
- **flutter_secure_storage** — token and device ID storage
- **firebase_crashlytics** — network error reporting
- **pull_to_refresh_flutter3** — pagination UI refresh

### Request Flow Example

Login OTP verification:

```
LoginRegisterVerificationOtpController.onSubmitOTP()
  → LoginRegisterRepository.loginByOtp()
    → apiServices.dio.post("$baseUrl/account/base/user/captchaLogin", ...)
      → LoginData.fromJson(response.data['data'])
  → FlutterSecureStorage.write(key: "token", ...)
  → UserServices.getUserInfo()
```

---

## API Client Configuration

### Base URL Strategy

Base URLs are **compile-time constants** in `lib/environment.dart`. The active environment is selected by commenting/uncommenting blocks — there is no runtime flavor switching or `.env` file.

```dart
// lib/environment.dart (active: Development v2)
const String baseUrl = 'http://8.215.203.97:8500';
const String socketUrl = '8.215.203.97';
const String env = "dev";
```

Repositories build full URLs manually:

```dart
var url = "$baseUrl/user/api/user/queryUserInfo";
```

`Dio` is **not** configured with a `baseUrl` in `BaseOptions`. Every repository concatenates `$baseUrl` + path.

### Environment Handling

- `env == "dev"` shows a dev banner overlay in `main.dart`.
- Production, Development v1, and Development v2 configs exist as commented alternatives in `environment.dart`.
- Socket host is separate from HTTP `baseUrl` (`socketUrl` on port `8888` in `SocketServices`).

### Timeout Configuration

Configured once in `ApiServices`:

```dart
final Dio dio = Dio(
  BaseOptions(
    connectTimeout: Duration(seconds: 10),
    sendTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 15),
  ),
);
```

### Interceptors

`ApiServices.onInit()` registers two interceptors:

#### 1. CurlLoggingInterceptor

```dart
dio.interceptors.add(
  CurlLoggingInterceptor(showRequestLog: false, showResponseLog: false),
);
```

Logging is present but **disabled** (`showRequestLog` and `showResponseLog` are `false`).

#### 2. InterceptorsWrapper (request, error, response)

**On request** — global headers appended to every call:

| Header | Value |
|---|---|
| `version` | App package version from `PackageInfo` |
| `deviceid` | UUID stored in `FlutterSecureStorage` (`device_id` key) |
| `timestamp` | `DateTime.now().millisecondsSinceEpoch` |
| `from` | `"android"` / `"ios"` / `"others"` |
| `role` | `"user"` |
| `nonce` | MD5 hash of current timestamp |

```dart
options.headers['version'] = packageVersion.value;
options.headers['deviceid'] = deviceId.value;
options.headers['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();
options.headers['from'] = Platform.isAndroid ? "android" : Platform.isIOS ? "ios" : "others";
options.headers['role'] = "user";
options.headers['nonce'] = generateMd5Timestamp();
```

**On error** — `DioException` messages are replaced with localized strings from `LanguageServices`, then reported to Firebase Crashlytics before re-throwing.

**On response** — session expiry handling:

```dart
if (response.data is Map<String, dynamic>) {
  if (response.data['code'] == 600) {
    if (Get.currentRoute != Routes.LOGIN_REGISTER) {
      await clearDataLogout();
      Get.offAllNamed(Routes.LOGIN_REGISTER);
      SnackbarHelper.showSnackbarError(...);
    }
  }
}
```

API business code `600` triggers forced logout. This is handled globally in the interceptor, not in individual repositories.

### Logging

- **dio_curl_logger**: installed, disabled.
- **Firebase Crashlytics**: records `DioException` details (type, URI, headers, request data, response body) in the error interceptor.
- Commented `print` debug statements exist in some repositories and interceptors.

### Proxy Support (Dev)

`main.dart` reads system proxy settings via `native_flutter_proxy` and applies them through a custom `HttpOverrides` class. Commented proxy code also exists in `ApiServices` for manual Charles/mitmproxy setup.

---

## Endpoint Definition Convention

Endpoints are **not** declared in a centralized API interface. Each repository method defines its own URL string inline.

### URL Structure

Backend paths follow a microservice-style prefix pattern:

```
$baseUrl/{service}/{scope}/{resource}/{action}
```

Real examples from the codebase:

| Repository | Method | URL |
|---|---|---|
| `LoginRegisterRepository` | `loginByOtp` | `$baseUrl/account/base/user/captchaLogin` |
| `UserRepository` | `getUserInfo` | `$baseUrl/user/api/user/queryUserInfo` |
| `OrderRideRepository` | `requestOrderRide` | `$baseUrl/businessProcess/api/orderPrivateCar/saveOrderPrivateCar` |
| `OrderRideRepository` | `getActiveOrderList` | `$baseUrl/orderServer/api/order/queryServingOrder` |
| `GeocodingRepository` | `getGeocodingPlaceByQuery` | `$baseUrl/businessProcess/api/geocoding/places` |
| `AdvanceBookingRepository` | `getAdvancedBookingDetail` | `$baseUrl/businessProcess/api/advanceBooking/$id` |
| `OpenMapsRepository` | `getDirection` | `$baseUrl/businessProcess/api/osrm/route/v1/driving/$originLon,$originLat;$destLon,$destLat` |
| `SavedAddressRepository` | `deleteSavedAddress` | `$baseUrl/account/user/address/$id` |

### HTTP Methods

| Method | Usage |
|---|---|
| `POST` | Dominant method; used for most reads and all writes |
| `GET` | Geocoding, driver nearby, advance booking list/detail, saved addresses |
| `PUT` | Saved address update |
| `DELETE` | Saved address delete |

### Path Parameters

Used sparingly for resource IDs embedded in the URL:

```dart
// Advance booking detail
var url = "$baseUrl/businessProcess/api/advanceBooking/$id";

// Saved address delete
var url = "$baseUrl/account/user/address/$id";

// OSRM routing (coordinates in path)
var url = "$baseUrl/businessProcess/api/osrm/route/v1/driving/$originLongitude,$originLatitude;$destinationLongitude,$destinationLatitude";
```

### Query Parameters

Used with `GET` requests:

```dart
// Geocoding reverse
var response = await dio.get(
  url,
  queryParameters: {"lat": latitude, "lng": longitude},
  options: Options(headers: headers),
);

// Advance booking list
var queryParameters = {"pageNo": pageNo, "pageSize": pageSize};
var response = await dio.get(url, queryParameters: queryParameters, ...);

// Driver nearby
queryParameters: {"lat": lat, "lon": lon}
```

### Request Body Formats

Two body styles are used inconsistently across repositories:

**1. `FormData` (multipart/form-data)** — most common for authenticated POST calls:

```dart
var formData = FormData.fromMap({
  "language": language,
  "pageNum": pageNum,
  "size": size,
});

var headers = {
  "Content-Type": "multipart/form-data",
  'Authorization': "Bearer $token",
};

await dio.post(url, data: formData, options: Options(headers: headers));
```

**2. Plain JSON map** — used for some newer endpoints:

```dart
var headers = {
  "Content-Type": "application/json",
  'Authorization': "Bearer $token",
};

await dio.post(url, data: {"bookingId": bookingId}, options: Options(headers: headers));
```

**3. Unauthenticated `FormData`** — login and OTP:

```dart
await dio.post(url, data: formData); // no Authorization header
```

### Naming Conventions

- Repository classes: `{Feature}Repository` (e.g. `OrderRideRepository`)
- Repository methods: verb + noun in camelCase (e.g. `getActiveOrderList`, `requestOrderRide`)
- Model classes: noun in PascalCase, often suffixed with context (e.g. `OrderRide`, `HistoryOrder`, `LoginData`)
- No shared API route constants file exists

---

## Request Models

### Folder Structure

```
lib/app/data/models/
  user_info_model.dart
  login_data_model.dart
  order_ride_model.dart
  ...
```

There are no separate request/DTO folders. Request payloads are built inline in repository methods as `Map` or `FormData.fromMap(...)`.

### Naming Rules

- Files: `{entity}_model.dart` (snake_case)
- Classes: `{Entity}` in PascalCase (no `Request` / `Dto` suffix)
- Fields: camelCase matching backend JSON keys

### Serialization Approach

**Manual serialization only.** No `freezed`, `json_serializable`, or code generation.

Every model implements hand-written constructors:

```dart
class UserInfo {
  int? id;
  String? name;
  // ...

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    // ...
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    // ...
    return data;
  }
}
```

### Request Payload Examples

Login OTP:

```dart
FormData.fromMap({
  "phone": phone,
  "code": code,
  "lat": lat,
  "lng": lng,
  "language": language,
})
```

Create order:

```dart
FormData.fromMap({
  "startLat": startLat,
  "endLat": endLat,
  "amount": amount,
  "payType": payType,
  "couponId": couponId,
  "priceNo": priceNo,
  // ...20+ fields
})
```

---

## Response Models

### Response Envelope

Most backend responses follow this structure:

```json
{
  "code": 200,
  "msg": "success message or error message",
  "data": { ... } | [ ... ] | "string"
}
```

Repositories check `code` and throw `msg` on failure:

```dart
if (response.data['code'] != null && response.data['code'] != 200) {
  if (response.data['msg'] != null) {
    throw response.data['msg'];
  }
}

return UserInfo.fromJson(response.data['data']);
```

### Variations

| Pattern | Example | Notes |
|---|---|---|
| Standard envelope | Most endpoints | `response.data['data']` |
| Coupon order list | `CouponRepository.getOrderCouponList` | Data in `response.data['coupon']`, not `data` |
| Query images | `QueryImageRepository` | List in `response.data['list']` |
| Upload image | `UploadImageRepository` | URL in `response.data["url"]`, no code check |
| Advance booking list | `AdvanceBookingRepository` | Paginated list at `response.data['data']['list']` |
| Validate location | `ValidateLocationResponse` | Entire response parsed as model (includes `code`, `msg`, `data`) |
| OSRM directions | `OpenMapDirection` | Third-party format parsed directly from `response.data` |

### DTO / Entity Mapping

**There is no separate domain entity layer.** Models in `lib/app/data/models/` serve as both API DTOs and UI/domain objects. Repositories return these models directly to controllers.

```
API response JSON
  → Model.fromJson(response.data['data'])
    → returned to Controller
      → bound to .obs reactive state in UI
```

No `UserResponse → UserEntity` mapping exists.

### List Parsing Pattern

```dart
var result = <ActiveOrder>[];
for (var activeOrder in response.data['data']) {
  result.add(ActiveOrder.fromJson(activeOrder));
}
return result;
```

---

## Repository Pattern

### Repository Responsibilities

Each repository class:

1. Resolves `ApiServices` via `Get.find<ApiServices>()`
2. Builds the full URL from `$baseUrl`
3. Reads auth token from `FlutterSecureStorage` (when required)
4. Sets per-request headers (`Content-Type`, `Authorization`)
5. Executes the HTTP call through `apiServices.dio`
6. Checks `response.data['code']` and throws `response.data['msg']` on error
7. Parses `response.data['data']` into model(s)
8. Re-throws `DioException` unchanged

### Data Source Layer

**No separate remote/local data source classes exist.** Repositories are the data access layer. There is no `features/**/datasource` or `features/**/remote` directory.

### Dependency Injection

Repositories are instantiated in GetX bindings and injected into controllers via constructor:

```dart
// lib/app/modules/home/bindings/home_binding.dart
Get.lazyPut<HomeController>(
  () => HomeController(
    userRepository: UserRepository(),
    orderRideRepository: OrderRideRepository(),
    couponRepository: CouponRepository(),
    // ...
  ),
);
```

Each binding creates **new repository instances** per controller registration. Repositories are stateless and cheap to construct.

### Service Layer (Partial)

`UserServices` is the only dedicated service that wraps a repository for shared app state:

```dart
class UserServices extends GetxService {
  final userRepository = UserRepository();
  final userInfo = UserInfo().obs;

  Future<void> getUserInfo() async {
    userInfo.value = await userRepository.getUserInfo(
      language: languageServices.languageCodeSystem.value,
    );
  }
}
```

### Real Example: Order Ride Flow

```dart
// Controller
class CreateOrderRideCheckoutController extends GetxController {
  final OrderRideRepository orderRideRepository;
  // ...
  var result = await orderRideRepository.requestOrderRide(...);
}

// Repository
class OrderRideRepository {
  final apiServices = Get.find<ApiServices>();

  Future<RequestedOrderRide> requestOrderRide({...}) async {
    var url = "$baseUrl/businessProcess/api/orderPrivateCar/saveOrderPrivateCar";
    // build FormData, read token, post, check code, parse
    return RequestedOrderRide.fromJson(response.data['data']);
  }
}
```

### All Repositories

| Repository | Primary Domain |
|---|---|
| `LoginRegisterRepository` | OTP login |
| `OtpRepository` | OTP request |
| `UserRepository` | User profile CRUD, account deletion |
| `OrderRideRepository` | Ride orders, pricing, cancellation, payment, reviews |
| `AdvanceBookingRepository` | Scheduled bookings |
| `CouponRepository` | Vouchers and coupons |
| `SavedAddressRepository` | Saved addresses (REST-style CRUD) |
| `GeocodingRepository` | Address search and reverse geocoding |
| `DriverNearbyRepository` | Nearby driver positions |
| `AdvertisementRepository` | Home screen ads |
| `AgreementRepository` | Terms and privacy policy content |
| `NotificationRepository` | FCM/APNS subscription |
| `UploadImageRepository` | Image upload (API + Firebase Storage) |
| `QueryImageRepository` | Splash screen images |
| `VersioningServerRepository` | App version checks |
| `OpenMapsRepository` | Route directions (OSRM proxy) |

---

## Error Handling

### DioException Handling

**Global layer** (`ApiServices` interceptor):

- Maps `DioExceptionType` to localized user-facing messages
- Stores the localized message in `DioException.error`
- Reports to Firebase Crashlytics
- Re-throws the modified `DioException`

**Repository layer**:

```dart
} on DioException {
  rethrow;
}
```

Repositories do not catch or transform `DioException`. Business logic errors are thrown as raw `String` (`throw response.data['msg']`).

**Controller layer** — standard pattern across the app:

```dart
try {
  await repository.someMethod(...);
} on DioException catch (e) {
  SnackbarHelper.showSnackbarError(text: e.error.toString());
} catch (e) {
  SnackbarHelper.showSnackbarError(text: e.toString());
}
```

- `DioException` → display `e.error` (localized network message from interceptor)
- `String` thrown by repository (business error `msg`) → display `e.toString()`
- `Exception` → caught in some controllers (e.g. checkout) as a third branch

### Custom Exception / Failure Classes

**None exist.** The project does not use:

- Custom exception classes
- `Failure` types
- `Result<T>` / `Either<L, R>` wrappers
- Sealed error hierarchies

### Business Error Codes

| Code | Handling |
|---|---|
| `200` | Success (implicit — only non-200 is checked) |
| `600` | Session expired — global interceptor forces logout |
| Other | Repository throws `response.data['msg']` as `String` |

### Error Handling Inconsistencies

- `UploadImageRepository` converts `DioException` to `String` via `throw e.message.toString()` instead of rethrowing
- `UserRepository.updateName` does not check response `code`
- `DriverNearbyRepository` does not check response `code`
- `GeocodingRepository.getAddressByLatitudeLongitude` does not check response `code`
- `NotificationRepository.unsubscribeNotification` does not check response `code`
- `OrderRideRepository.validateLocation` has its code check commented out

---

## Authentication

### Token Storage

```dart
// Write on login
var storage = FlutterSecureStorage();
await storage.write(key: "token", value: loginData.token);

// Read in repositories
var token = await storage.read(key: 'token');

// Delete on logout
await storage.delete(key: 'token');
```

Token key: `"token"` in `FlutterSecureStorage`.

### Authorization Headers

Auth is **per-request**, not via a global interceptor. Each authenticated repository method manually reads the token and sets:

```dart
var headers = {
  "Content-Type": "multipart/form-data", // or "application/json"
  'Authorization': "Bearer $token",
};
```

There is no centralized auth interceptor that injects the Bearer token automatically.

### Token Refresh Flow

**Not implemented.** No refresh token endpoint, no token expiry retry logic, and no automatic re-authentication beyond the global `code == 600` forced logout.

### Session Handling

1. **Splash screen** checks for token presence → routes to `HOME` or `LOGIN_REGISTER`
2. **API code 600** in any response triggers `clearDataLogout()` and redirect to login
3. **Manual logout** via `common_helper.logout()` clears token, SharedPreferences, socket, and FCM subscription

```dart
// lib/app/utils/common_helper.dart
await Future.wait([
  firebasePushNotificationServices.onUnsubscribe(),
  storage.delete(key: 'token'),
  socketServices.closeWebsocket(),
  prefs.clear(),
]);
userServices.clearUserInfo();
Get.offAllNamed(Routes.LOGIN_REGISTER);
```

### Device Identity

Device ID is generated once (UUID v4) and stored in secure storage under `"device_id"`. It is sent as the `deviceid` header on every request via the global interceptor.

---

## Pagination

Pagination is implemented at the **controller level** with two backend parameter conventions.

### Pattern A: `pageNum` + `size` (FormData POST)

Used by: order lists, coupon lists.

```dart
// Repository
FormData.fromMap({
  "pageNum": pageNum,
  "size": size,
  "language": language,
});

// Controller (ActivityController)
historyOrderPageNum.value = 1;
var list = await orderRideRepository.getHistoryOrderList(
  pageNum: historyOrderPageNum.value,
  size: historyOrderSize.value,  // default: 10
);

// Load more
historyOrderPageNum.value += 1;
var more = await orderRideRepository.getHistoryOrderList(...);
if (more.isEmpty) historyOrderSeeMore.value = false;
historyOrderList.addAll(more);
```

### Pattern B: `pageNo` + `pageSize` (GET query params)

Used by: advance booking list.

```dart
// Repository
var queryParameters = {"pageNo": pageNo, "pageSize": pageSize};
var response = await dio.get(url, queryParameters: queryParameters, ...);

// Response structure
for (var item in response.data['data']?['list'] ?? []) {
  result.add(AdvancedBooking.fromJson(item));
}
```

### UI Integration

`pull_to_refresh_flutter3` `RefreshController` is used in:

- `ActivityController` (active orders, history, advance bookings)
- `VoucherListController`
- `CreateOrderRidePromoController`
- Chat list views

### Pagination State Variables

Controllers track:

- `pageNum` / `pageNo` — current page (1-based)
- `size` / `pageSize` — page size
- `seeMore` / `isSeeMore*` — whether more data is available (set `false` when a page returns empty)

There is no total count or `hasNextPage` field from the backend. "Has more" is inferred by checking if the returned list is empty.

---

## File Upload

### API Multipart Upload

`UploadImageRepository.uploadImage` uploads via Dio `FormData`:

```dart
var url = "$baseUrl/account/base/driver/img/upload";

var formData = FormData.fromMap({
  "file": await MultipartFile.fromFile(file.path, filename: file.name),
});

var response = await dio.post(url, data: formData);
return response.data["url"];
```

- No `Authorization` header on this endpoint
- No `code`/`msg` envelope check — returns `response.data["url"]` directly
- Error handling differs: `on DioException catch (e) { throw e.message.toString(); }`

### Firebase Storage Upload

Avatar uploads bypass the REST API and use Firebase Storage directly:

```dart
final storageRef = FirebaseStorage.instance.ref().child('evmoto_user_avatar/$fileName');
await storageRef.putFile(file);
return await storageRef.getDownloadURL();
```

The returned download URL is then saved to the user profile via `UserRepository.updateUserInformation(avatarUrl: ...)`.

---

## API Coding Standards

Rules inferred from the current codebase. Follow these when adding new API integrations.

1. **All HTTP calls must go through a Repository class** in `lib/app/repositories/`. Never call `Dio` from controllers, views, or services (except `ApiServices` itself).

2. **Use the shared `ApiServices.dio` instance** via `Get.find<ApiServices>()`. Do not create new `Dio()` instances.

3. **Build URLs as `"$baseUrl/{path}"`** using the constant from `lib/environment.dart`.

4. **Read the auth token per-request** from `FlutterSecureStorage(key: 'token')` and set `Authorization: Bearer $token` in request headers for authenticated endpoints.

5. **Check `response.data['code']`** and throw `response.data['msg']` when code is not `200`:

   ```dart
   if (response.data['code'] != null && response.data['code'] != 200) {
     if (response.data['msg'] != null) {
       throw response.data['msg'];
     }
   }
   ```

6. **Parse responses with manual `fromJson`** model classes in `lib/app/data/models/`. Do not introduce code generation unless the team agrees on a migration.

7. **Re-throw `DioException` unchanged** in repositories: `} on DioException { rethrow; }`.

8. **Handle errors in controllers** with the standard try/catch pattern using `SnackbarHelper`:

   ```dart
   } on DioException catch (e) {
     SnackbarHelper.showSnackbarError(text: e.error.toString());
   } catch (e) {
     SnackbarHelper.showSnackbarError(text: e.toString());
   }
   ```

9. **Inject repositories via constructor** in controllers and register them in GetX bindings (`Get.lazyPut`).

10. **Use `FormData.fromMap(...)` with `Content-Type: multipart/form-data`** for POST requests unless the endpoint specifically requires JSON (match the style of nearby endpoints in the same service prefix).

11. **Pass `language`** from `LanguageServices.languageCodeSystem.value` on endpoints that support localization.

12. **Do not handle `code == 600` in repositories** — the global `ApiServices` response interceptor handles session expiry.

13. **Return typed models** from repository methods (`Future<UserInfo>`, `Future<List<Coupon>>`, `Future<void>`), not raw `Response` objects.

14. **Declare `firebaseRemoteConfigServices`** in repositories if following existing convention, even when unused (existing pattern across all 16 repositories).

---

## Current Inconsistencies

### Request Format

| Issue | Details |
|---|---|
| Mixed body types | Same service area uses both `FormData` (multipart) and plain JSON `Map` (e.g. `OrderRideRepository` vs `AdvanceBookingRepository` under `businessProcess`) |
| Mixed HTTP methods for reads | Most reads use `POST` + `FormData`; newer endpoints use `GET` + query params |
| Content-Type mismatch | Some `FormData` posts set `Content-Type: multipart/form-data` explicitly; unauthenticated posts (login, OTP) omit headers entirely |

### Error Handling

| Issue | Details |
|---|---|
| Missing code checks | `UserRepository.updateName`, `DriverNearbyRepository`, `GeocodingRepository.getAddressByLatitudeLongitude`, `NotificationRepository.unsubscribeNotification`, `UploadImageRepository` |
| Different throw style | `UploadImageRepository` throws `e.message.toString()` instead of rethrowing `DioException` |
| Commented-out validation | `OrderRideRepository.validateLocation` has code check disabled |
| Response key variance | `data` vs `coupon` vs `list` vs `url` — no standard parsing helper |

### Pagination

| Issue | Details |
|---|---|
| Parameter naming | `pageNum`/`size` vs `pageNo`/`pageSize` across different endpoints |
| No server-side total | Client infers "has more" only from empty results |

### Architecture

| Issue | Details |
|---|---|
| No domain layer | Models serve as both DTO and domain entity |
| Token read duplication | Every authenticated repository method repeats `FlutterSecureStorage` + header boilerplate |
| Unused dependency | `firebaseRemoteConfigServices` is declared in every repository but never used within repository methods |
| `UserServices` vs direct repository | Most features call repositories from controllers; only user profile goes through `UserServices` |
| Dual upload paths | Images upload via REST API; avatars upload via Firebase Storage — two different systems |
| No API route constants | URL strings are scattered across 16 repository files with no shared definition |

### Project Structure

The analysis scope paths (`lib/core/network`, `lib/features/**/data`, `lib/shared/network`) **do not exist** in this project. The actual layout is `lib/app/{services,repositories,data/models,modules}`.

---

## Recommended Improvements

These suggestions preserve the existing GetX + Repository architecture while reducing inconsistency.

### High Priority

1. **Add an auth request interceptor** in `ApiServices` that reads the token from `FlutterSecureStorage` and sets `Authorization: Bearer $token` automatically. This removes ~5 lines of duplicated boilerplate from every authenticated repository method.

2. **Extract a shared response handler** helper:

   ```dart
   void checkResponseCode(Map<String, dynamic> data) {
     if (data['code'] != null && data['code'] != 200) {
       throw data['msg'] ?? 'Unknown error';
     }
   }
   ```

   Apply consistently to all repositories, including those currently missing checks.

3. **Standardize error rethrowing** in `UploadImageRepository` to match the `on DioException { rethrow; }` pattern used everywhere else.

### Medium Priority

4. **Create an `api_endpoints.dart` constants file** grouping URLs by service prefix (`account`, `orderServer`, `businessProcess`, etc.) to reduce scattered magic strings and make endpoint discovery easier.

5. **Align request body format** within each backend service — prefer `application/json` for new endpoints under `businessProcess` and `account/user` (already trending that way), document which legacy endpoints require `FormData`.

6. **Unify pagination parameters** — when adding new endpoints, standardize on `pageNum`/`size` or `pageNo`/`pageSize` and document which backend services use which.

7. **Remove unused `firebaseRemoteConfigServices`** field from repositories, or use it for dynamic base URL / feature flags if intended.

### Low Priority

8. **Consider `json_serializable`** for new models to reduce manual `fromJson`/`toJson` boilerplate and parsing bugs. Migrate existing models incrementally.

9. **Introduce a thin `ApiResponse<T>` wrapper** for consistent envelope parsing without adopting a full clean architecture:

   ```dart
   class ApiResponse<T> {
     final int code;
     final String? msg;
     final T? data;
   }
   ```

10. **Enable curl logging in dev** by tying `CurlLoggingInterceptor` visibility to `env == "dev"`.

11. **Environment config** — replace comment-switching in `environment.dart` with Flutter flavors or `--dart-define` for safer multi-environment builds.

---

## Assumptions and Gaps

| Topic | Status |
|---|---|
| Retrofit / Chopper | **Not used** — confirmed absent from dependencies and code |
| `freezed` / `json_serializable` | **Not used** — all models are hand-written |
| Token refresh | **Not present** — assumed session is invalidated only via code `600` |
| `lib/core/network`, `lib/features/**` | **Do not exist** — project uses `lib/app/` structure |
| Remote Config in repositories | Field declared but **never referenced** in repository method bodies |
| Rate limiting / retry | **Not implemented** beyond socket reconnection |
| API versioning | Only `version` header sent; no `/v1/` path prefix pattern observed |
