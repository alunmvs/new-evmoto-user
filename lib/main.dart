import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/activity/controllers/activity_controller.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/services/api_services.dart';
import 'package:new_evmoto_user/app/services/deep_link_services.dart';
import 'package:new_evmoto_user/app/services/firebase_push_notification_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/location_services.dart';
import 'package:new_evmoto_user/app/services/sendbird_chat_services.dart';
import 'package:new_evmoto_user/app/services/sendbird_services.dart';
import 'package:new_evmoto_user/app/services/socket_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:new_evmoto_user/app/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/routes/app_pages.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = (errorDetails) {
    try {
      FirebaseCrashlytics.instance.recordError(
        errorDetails.exception,
        errorDetails.stack,
        fatal: true,
      );
    } catch (e) {}
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    try {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } catch (e) {}
    return true;
  };
  Get.put(ThemeColorServices(), permanent: true);
  Get.put(TypographyServices(), permanent: true);
  Get.put(LanguageServices(), permanent: true);
  Get.put(ApiServices(), permanent: true);
  Get.put(FirebaseRemoteConfigServices(), permanent: true);
  await Get.find<FirebaseRemoteConfigServices>().manualOnInit();
  await Get.find<LanguageServices>().manualOnInit();
  Get.put(FirebasePushNotificationServices(), permanent: true);
  Get.put(SocketServices(), permanent: true);
  Get.put(SendbirdServices(), permanent: true);
  Get.put(SendbirdChatServices(), permanent: true);
  Get.put(LocationServices(), permanent: true);
  Get.put(DeepLinkServices(), permanent: true);
  Get.put(UserServices(), permanent: true);

  runApp(
    GetMaterialApp(
      title: "Evmoto",
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('id', 'ID'),
        Locale('zh', 'CN'),
      ],
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Get.find<ThemeColorServices>().primaryBlue.value,
          selectionColor: Get.find<ThemeColorServices>().primaryBlue.value
              .withValues(alpha: 0.2),
          selectionHandleColor:
              Get.find<ThemeColorServices>().primaryBlue.value,
        ),
      ),
      routingCallback: (routing) async {
        if (routing?.current == Routes.HOME) {
          var prefs = await SharedPreferences.getInstance();

          var processList = <Future>[];
          if (prefs.getBool('home_controller_registered') == true) {
            var homeController = Get.find<HomeController>();
            processList.add(homeController.refreshAll());
          }

          if (prefs.getBool('activity_controller_registered') == true) {
            var activityController = Get.find<ActivityController>();
            processList.add(activityController.refreshAll());
          }

          await Future.wait(processList);
        }
      },
      builder: (context, child) {
        return SafeArea(
          top: false,
          left: false,
          right: false,
          bottom: true,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: child!,
            // child: Stack(
            //   children: [
            //     child!,
            //     Obx(
            //       () => Align(
            //         alignment: Alignment.topCenter,
            //         child: Material(
            //           child: Padding(
            //             padding: const EdgeInsets.only(top: 16 * 3),
            //             child: Text(
            //               Get.find<SocketServices>().isSocketClose.value ==
            //                       false
            //                   ? "${Get.find<SocketServices>().pingMs.value} ms"
            //                   : Get.find<SocketServices>()
            //                             .isProcessConnect
            //                             .value ==
            //                         true
            //                   ? "Reconnecting"
            //                   : "Disconnected",
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ),
        );
      },
    ),
  );
}
