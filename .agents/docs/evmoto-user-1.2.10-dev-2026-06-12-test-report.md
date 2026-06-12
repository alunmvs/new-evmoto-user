# Evmoto User — Automated Test Report

> A simple summary of automated checks run on the app. Written for product owners, QA, and anyone who wants to know *what was tested* without reading code.

---

## At a Glance

| Item | Detail |
|------|--------|
| **App name** | Evmoto User |
| **App version** | 1.2.10 |
| **Environment** | Production (`prod`) |
| **Test date** | 12 June 2026 |
| **Test run time** | ~44 seconds |
| **Total checks** | 193 |
| **Passed** | 193 |
| **Failed** | 0 |
| **Overall result** | ✅ All checks passed |

---

## What Was Tested?

Automated tests simulate how a user interacts with the app — typing a phone number, tapping buttons, booking a ride, viewing vouchers — and confirm that the app behaves as expected. No real phone calls, SMS, live payments, or production server requests are made during these tests; they run on a simulated device with mocked services.

The checks cover **33 feature areas** across the app, from splash screen and login through ride booking, orders, chat, account settings, and legal pages.

---

## 1. Splash Screen — Behind the Scenes (Unit Tests)

*File: `splash_screen_controller_test.dart`*  
*4 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before any data is loaded | ✅ Pass |
| 2 | Splash image is loaded from the server on startup | ✅ Pass |
| 3 | App handles missing splash images gracefully (no crash) | ✅ Pass |
| 4 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 2. Splash Screen — What the User Sees (Widget Tests)

*File: `splash_screen_view_test.dart`*  
*2 checks — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Loading spinner is shown while the splash image is being fetched | ✅ Pass |
| 2 | Loading spinner is shown when no splash image URL is available | ✅ Pass |

---

## 3. Login Screen — Behind the Scenes (Unit Tests)

*File: `login_register_controller_test.dart`*  
*9 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | When the screen first opens, the phone field is empty and the Continue button stays inactive | ✅ Pass |
| 2 | A valid Indonesian mobile number (starts with 8, 8–15 digits) is accepted | ✅ Pass |
| 3 | An empty phone number keeps the Continue button inactive | ✅ Pass |
| 4 | A number that does **not** start with 8 is rejected | ✅ Pass |
| 5 | A number shorter than 8 digits is rejected | ✅ Pass |
| 6 | A number longer than 15 digits is rejected | ✅ Pass |
| 7 | The form updates automatically as the user types | ✅ Pass |
| 8 | Tapping Continue with a valid number (e.g. `8123 4567 89`) sends the user to the OTP screen with the correct full number (`628123456789`) | ✅ Pass |
| 9 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 4. Login Screen — What the User Sees (Widget Tests)

*File: `login_register_view_test.dart`*  
*6 checks — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen shows the title "Login to Evmoto", description, phone label, country code (+62), and Continue button | ✅ Pass |
| 2 | Continue button is disabled when the phone field is empty | ✅ Pass |
| 3 | Continue button becomes active when a valid phone number is entered | ✅ Pass |
| 4 | Error message appears when the number does not start with 8 | ✅ Pass |
| 5 | Error message appears when the number has fewer than 8 digits | ✅ Pass |
| 6 | Tapping Continue with a valid number opens the OTP verification screen with the correct phone number | ✅ Pass |

---

## 5. OTP Verification Screen — Behind the Scenes (Unit Tests)

*File: `login_register_verification_otp_controller_test.dart`*  
*9 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Before the screen loads, all values start in a safe empty state | ✅ Pass |
| 2 | The phone number from the previous screen is received correctly | ✅ Pass |
| 3 | If no phone number is provided, the field stays empty (no crash) | ✅ Pass |
| 4 | Requesting a new OTP calls the server with the right phone number and starts a 60-second wait timer before resend | ✅ Pass |
| 5 | A network error while requesting OTP is handled gracefully (app does not crash) | ✅ Pass |
| 6 | Entering a correct OTP and having location available takes the user to the Home screen | ✅ Pass |
| 7 | If location is unavailable, login is blocked and the user stays on the OTP screen | ✅ Pass |
| 8 | A wrong OTP or server error during login is handled gracefully (app does not crash) | ✅ Pass |
| 9 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 6. OTP Verification Screen — What the User Sees (Widget Tests)

*File: `login_register_verification_otp_view_test.dart`*  
*7 checks — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen shows "Verify OTP", instructions, the user's phone number, OTP input box, and Resend option | ✅ Pass |
| 2 | A loading spinner is shown while the app is fetching data (content is hidden) | ✅ Pass |
| 3 | "OTP does not match" message appears when the code is wrong | ✅ Pass |
| 4 | "Resend" link is available when the wait timer has finished | ✅ Pass |
| 5 | A countdown (e.g. "45") is shown while the user must wait before resending | ✅ Pass |
| 6 | Tapping Resend sends a new OTP request and restarts the 60-second timer | ✅ Pass |
| 7 | Entering a complete OTP code logs the user in and opens the Home screen | ✅ Pass |

---

## 7. Onboarding Registration — Behind the Scenes (Unit Tests)

*File: `onboarding_registration_form_controller_test.dart`*  
*4 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | User profile data is loaded from the server | ✅ Pass |
| 3 | Submit is blocked when the full name field is empty | ✅ Pass |
| 4 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 8. Onboarding Registration — What the User Sees (Widget Tests)

*File: `onboarding_registration_form_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Registration form shows name, email, and submit controls | ✅ Pass |

---

## 9. Home Screen — Behind the Scenes (Unit Tests)

*File: `home_controller_test.dart`*  
*6 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Date comparison correctly identifies the same calendar day | ✅ Pass |
| 3 | Date comparison correctly rejects different calendar days | ✅ Pass |
| 4 | Home bookmark flag is false when no home address is saved | ✅ Pass |
| 5 | Work bookmark flag is false when no work address is saved | ✅ Pass |
| 6 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 10. Home Screen — What the User Sees (Widget Tests)

*File: `home_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Home screen shows main layout and key labels when data is ready | ✅ Pass |

---

## 11. Create Order Ride — Behind the Scenes (Unit Tests)

*File: `create_order_ride_controller_test.dart`*  
*4 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Have empty location fields before onInit | ✅ Pass |
| 2 | Saved addresses and ride history are loaded when the screen opens | ✅ Pass |
| 3 | Pickup and destination addresses are filled from navigation data | ✅ Pass |
| 4 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 12. Create Order Ride — What the User Sees (Widget Tests)

*File: `create_order_ride_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Create ride screen shows pickup, destination, and booking controls | ✅ Pass |

---

## 13. Map Location Select — Behind the Scenes (Unit Tests)

*File: `create_order_ride_map_select_controller_test.dart`*  
*4 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Have default initial state before fillForm | ✅ Pass |
| 2 | Map picker receives the correct address type and geocoded location | ✅ Pass |
| 3 | Confirming a map pin returns the selected location to the previous screen | ✅ Pass |
| 4 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 14. Map Location Select — What the User Sees (Widget Tests)

*File: `create_order_ride_map_select_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Map location picker shows a loading state while initializing | ✅ Pass |

---

## 15. Ride Checkout — Behind the Scenes (Unit Tests)

*File: `create_order_ride_checkout_controller_test.dart`*  
*4 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Checkout screen receives pickup and destination from the booking flow | ✅ Pass |
| 3 | Selected ride pricing option is carried into checkout | ✅ Pass |
| 4 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 16. Ride Checkout — What the User Sees (Widget Tests)

*File: `create_order_ride_checkout_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Checkout screen shows fare summary and payment controls | ✅ Pass |

---

## 17. Ride Promo — Behind the Scenes (Unit Tests)

*File: `create_order_ride_promo_controller_test.dart`*  
*3 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Available promo coupons are loaded when the promo screen opens | ✅ Pass |
| 3 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 18. Ride Promo — What the User Sees (Widget Tests)

*File: `create_order_ride_promo_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Promo screen shows coupon list and selection controls | ✅ Pass |

---

## 19. Ride Order Detail — Behind the Scenes (Unit Tests)

*File: `ride_order_detail_controller_test.dart`*  
*3 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Parse order_id and order_type from Get.arguments | ✅ Pass |
| 3 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 20. Ride Order Detail — What the User Sees (Widget Tests)

*File: `ride_order_detail_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Ride detail screen shows order info when data is loaded | ✅ Pass |

---

## 21. Ride Order Done — Behind the Scenes (Unit Tests)

*File: `ride_order_done_controller_test.dart`*  
*7 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Total fare is calculated correctly from all fare components | ✅ Pass |
| 3 | Coupon discount amount is shown when a coupon is applied | ✅ Pass |
| 4 | Discount amount is shown when no coupon is applied | ✅ Pass |
| 5 | "I have paid" button appears after the 5-minute waiting period | ✅ Pass |
| 6 | Order done screen receives the correct order ID and type | ✅ Pass |
| 7 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 22. Ride Order Done — What the User Sees (Widget Tests)

*File: `ride_order_done_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Completed ride screen shows fare summary and rating controls | ✅ Pass |

---

## 23. Cancel Ride Order — Behind the Scenes (Unit Tests)

*File: `ride_order_cancel_controller_test.dart`*  
*5 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Before the screen loads, all values start in a safe empty state | ✅ Pass |
| 2 | Cancel screen receives the correct order ID and type | ✅ Pass |
| 3 | Cancel button stays disabled when no reason is entered | ✅ Pass |
| 4 | Cancel button becomes active when a cancellation reason is entered | ✅ Pass |
| 5 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 24. Cancel Ride Order — What the User Sees (Widget Tests)

*File: `ride_order_cancel_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Cancel order screen shows reason input and confirm button | ✅ Pass |

---

## 25. Advanced Booking Detail — Behind the Scenes (Unit Tests)

*File: `advanced_booking_detail_controller_test.dart`*  
*7 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Parse id from Get.arguments without repository calls | ✅ Pass |
| 3 | Advanced booking total fare is calculated correctly | ✅ Pass |
| 4 | Cancel option is available for scheduled advance bookings | ✅ Pass |
| 5 | "Order again" is available for cancelled advance bookings | ✅ Pass |
| 6 | "Order again" is available after a completed advance booking | ✅ Pass |
| 7 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 26. Advanced Booking Detail — What the User Sees (Widget Tests)

*File: `advanced_booking_detail_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Advanced booking detail screen shows booking info and actions | ✅ Pass |

---

## 27. Advanced Booking — Searching Driver — Behind the Scenes (Unit Tests)

*File: `advanced_booking_searching_driver_controller_test.dart`*  
*4 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Parse id from Get.arguments without repository calls | ✅ Pass |
| 3 | Driver search timer can be stopped without errors | ✅ Pass |
| 4 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 28. Advanced Booking — Searching Driver — What the User Sees (Widget Tests)

*File: `advanced_booking_searching_driver_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Searching driver screen shows status while looking for a driver | ✅ Pass |

---

## 29. Activity List — Behind the Scenes (Unit Tests)

*File: `activity_controller_test.dart`*  
*3 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Ride history and advance bookings are loaded on screen open | ✅ Pass |
| 3 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 30. Activity List — What the User Sees (Widget Tests)

*File: `activity_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Activity screen shows history tabs and empty state when no rides exist | ✅ Pass |

---

## 31. Activity Detail — Behind the Scenes (Unit Tests)

*File: `activity_detail_controller_test.dart`*  
*6 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Parse order_id and order_type from Get.arguments | ✅ Pass |
| 3 | Activity detail fare total is calculated correctly | ✅ Pass |
| 4 | Activity detail shows coupon discount when applied | ✅ Pass |
| 5 | Activity detail shows standard discount when no coupon exists | ✅ Pass |
| 6 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 32. Activity Detail — What the User Sees (Widget Tests)

*File: `activity_detail_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Activity detail screen shows ride summary when data is ready | ✅ Pass |

---

## 33. Search Address — Behind the Scenes (Unit Tests)

*File: `search_address_controller_test.dart`*  
*6 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Search screen knows whether user is setting home, work, or other address | ✅ Pass |
| 3 | Search screen enters edit mode when address type is not specified | ✅ Pass |
| 4 | Distance is displayed in kilometers for long distances | ✅ Pass |
| 5 | Distance is displayed in meters for short distances | ✅ Pass |
| 6 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 34. Search Address — What the User Sees (Widget Tests)

*File: `search_address_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Address search screen shows search bar and results for home location | ✅ Pass |

---

## 35. Add/Edit Address — Behind the Scenes (Unit Tests)

*File: `add_edit_address_controller_test.dart`*  
*4 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Address form is pre-filled from a map search result | ✅ Pass |
| 3 | Address form is pre-filled from an existing saved address | ✅ Pass |
| 4 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 36. Add/Edit Address — What the User Sees (Widget Tests)

*File: `add_edit_address_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Add address screen shows name, address, and save controls | ✅ Pass |

---

## 37. Add/Edit Other Address — Behind the Scenes (Unit Tests)

*File: `add_edit_address_other_controller_test.dart`*  
*4 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Address form is pre-filled from an existing saved address | ✅ Pass |
| 3 | Save button becomes active when all required address fields are valid | ✅ Pass |
| 4 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 38. Add/Edit Other Address — What the User Sees (Widget Tests)

*File: `add_edit_address_other_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Add other address screen shows label and location fields | ✅ Pass |

---

## 39. Saved Locations — Behind the Scenes (Unit Tests)

*File: `setting_saved_location_controller_test.dart`*  
*3 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Saved addresses are loaded from the server | ✅ Pass |
| 3 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 40. Saved Locations — What the User Sees (Widget Tests)

*File: `setting_saved_location_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Saved locations screen shows home, work, and other addresses | ✅ Pass |

---

## 41. Voucher List — Behind the Scenes (Unit Tests)

*File: `voucher_list_controller_test.dart`*  
*5 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Voucher list is loaded from the server | ✅ Pass |
| 3 | Tapping "See more" loads the next page of vouchers | ✅ Pass |
| 4 | "See more" is hidden when there are no additional vouchers | ✅ Pass |
| 5 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 42. Voucher List — What the User Sees (Widget Tests)

*File: `voucher_list_view_test.dart`*  
*2 checks — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Voucher list screen shows available vouchers | ✅ Pass |
| 2 | Empty state message is shown when the user has no vouchers | ✅ Pass |

---

## 43. Account — Behind the Scenes (Unit Tests)

*File: `account_controller_test.dart`*  
*2 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Account screen starts with no package info and loading flag off | ✅ Pass |
| 2 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 44. Account — What the User Sees (Widget Tests)

*File: `account_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Account screen shows profile info, settings menu, and app version | ✅ Pass |

---

## 45. Edit User Information — Behind the Scenes (Unit Tests)

*File: `add_edit_user_information_controller_test.dart`*  
*3 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Form fields are pre-filled with the user's existing profile data | ✅ Pass |
| 3 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 46. Edit User Information — What the User Sees (Widget Tests)

*File: `add_edit_user_information_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Edit profile screen shows name, email, and save controls | ✅ Pass |

---

## 47. Language Settings — Behind the Scenes (Unit Tests)

*File: `setting_language_controller_test.dart`*  
*4 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Have empty tempLanguageCode before onInit | ✅ Pass |
| 2 | Current app language is pre-selected on the language screen | ✅ Pass |
| 3 | Selecting a language updates the temporary selection | ✅ Pass |
| 4 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 48. Language Settings — What the User Sees (Widget Tests)

*File: `setting_language_view_test.dart`*  
*2 checks — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Language settings screen shows available language options | ✅ Pass |
| 2 | Tapping a language option updates the selection visually | ✅ Pass |

---

## 49. Chat List — Behind the Scenes (Unit Tests)

*File: `chat_list_controller_test.dart`*  
*2 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 50. Chat List — What the User Sees (Widget Tests)

*File: `chat_list_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Support chat list shows conversations when data is ready | ✅ Pass |

---

## 51. Chat Detail — Behind the Scenes (Unit Tests)

*File: `chat_detail_controller_test.dart`*  
*3 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Support chat receives conversation ID without connecting to Firebase | ✅ Pass |
| 3 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 52. Chat Detail — What the User Sees (Widget Tests)

*File: `chat_detail_view_test.dart`*  
*2 checks — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Support chat detail shows messages when data is ready | ✅ Pass |
| 2 | User's own messages are displayed in the chat thread | ✅ Pass |

---

## 53. Sendbird Chat List — Behind the Scenes (Unit Tests)

*File: `sendbird_chat_list_controller_test.dart`*  
*2 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 54. Sendbird Chat List — What the User Sees (Widget Tests)

*File: `sendbird_chat_list_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Chat list shows empty state when there are no conversations | ✅ Pass |

---

## 55. Sendbird Chat Detail — Behind the Scenes (Unit Tests)

*File: `sendbird_chat_detail_controller_test.dart`*  
*5 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Chat detail screen receives the correct conversation channel | ✅ Pass |
| 3 | Read receipt shows when the driver has read the message | ✅ Pass |
| 4 | Read receipt is hidden when the driver has not read the message | ✅ Pass |
| 5 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 56. Sendbird Chat Detail — What the User Sees (Widget Tests)

*File: `sendbird_chat_detail_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Sendbird chat detail shows conversation messages | ✅ Pass |

---

## 57. Ride Chat (Sendbird) — Behind the Scenes (Unit Tests)

*File: `ride_chat_sendbird_controller_test.dart`*  
*4 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Ride chat screen receives order info without connecting to Sendbird | ✅ Pass |
| 3 | Read receipt shows when the driver has read the message | ✅ Pass |
| 4 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 58. Ride Chat (Sendbird) — What the User Sees (Widget Tests)

*File: `ride_chat_sendbird_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | In-ride chat screen shows message list and input field | ✅ Pass |

---

## 59. Ride Call (Sendbird) — Behind the Scenes (Unit Tests)

*File: `ride_call_sendbird_controller_test.dart`*  
*3 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Screen starts with safe default values before loading data | ✅ Pass |
| 2 | Call screen receives driver info without initiating a real call | ✅ Pass |
| 3 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 60. Ride Call (Sendbird) — What the User Sees (Widget Tests)

*File: `ride_call_sendbird_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | In-ride call screen shows driver name and call controls | ✅ Pass |

---

## 61. Privacy Policy — Behind the Scenes (Unit Tests)

*File: `privacy_policy_controller_test.dart`*  
*3 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Have empty agreement and isFetch false before onInit | ✅ Pass |
| 2 | Privacy policy content is loaded from the server | ✅ Pass |
| 3 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 62. Privacy Policy — What the User Sees (Widget Tests)

*File: `privacy_policy_view_test.dart`*  
*2 checks — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | A loading spinner is shown while the app is fetching data (content is hidden) | ✅ Pass |
| 2 | Policy text is displayed after loading completes | ✅ Pass |

---

## 63. Terms & Conditions — Behind the Scenes (Unit Tests)

*File: `terms_and_conditions_controller_test.dart`*  
*3 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Have empty agreement and isFetch false before onInit | ✅ Pass |
| 2 | Terms and conditions content is loaded from the server | ✅ Pass |
| 3 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 64. Terms & Conditions — What the User Sees (Widget Tests)

*File: `terms_and_conditions_view_test.dart`*  
*2 checks — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | A loading spinner is shown while the app is fetching data (content is hidden) | ✅ Pass |
| 2 | Policy text is displayed after loading completes | ✅ Pass |

---

## 65. Photo Viewer — Behind the Scenes (Unit Tests)

*File: `photo_viewer_controller_test.dart`*  
*4 checks — all passed*

These tests verify the rules and logic that power the screen, without showing the full visual layout.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Have empty photoAttachmentUrl as initial state | ✅ Pass |
| 2 | Photo viewer receives the correct image URL | ✅ Pass |
| 3 | Photo viewer handles missing image URL gracefully | ✅ Pass |
| 4 | Closing the screen cleans up properly with no errors | ✅ Pass |

---

## 66. Photo Viewer — What the User Sees (Widget Tests)

*File: `photo_viewer_view_test.dart`*  
*1 check — all passed*

These tests open the actual screen and confirm that labels, buttons, and messages appear correctly.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | Photo viewer displays the image in a full-screen view | ✅ Pass |

---

## 67. General App Health Check — Smoke Test

*File: `widget_test.dart`*  
*1 check — all passed*

This test verifies the app can start without errors.

| # | What we checked | Result |
|---|-----------------|--------|
| 1 | The basic app shell can start and display content without errors | ✅ Pass |

---

## Areas Not Covered by This Report

These automated checks **do not** currently test:

- Real SMS delivery or live OTP from production servers
- Live payment processing or third-party payment gateways
- Real-time driver GPS tracking on physical maps
- Sendbird voice/video calls with real network connections
- Firebase push notifications on physical devices
- Performance, battery usage, or memory on real iOS / Android hardware
- End-to-end integration across multiple screens in a single user journey

Those areas would need separate manual testing or additional integration tests in the future.

---

## How to Re-run These Tests

From the project folder, run:

```bash
flutter test test/ --reporter expanded
```

Expected outcome: `All tests passed!` in roughly 40–50 seconds.

---

## Document Info

| Field | Value |
|-------|-------|
| **Generated** | 12 June 2026 |
| **App version** | 1.2.10 |
| **Environment** | prod (Production) |
| **Test framework** | Flutter Test |
| **Source test files** | 67 files under `test/` |

---

*This report reflects the state of automated tests at the time of generation. Re-run tests after any code change to get an up-to-date result.*