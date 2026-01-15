import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/repositories/notification_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(
      android: AndroidInitializationSettings('ic_notification_small'),
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload == 'detail_page') {}
    },
  );

  flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    message.notification?.title,
    message.notification?.body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        'default_channel',
        'Default',
        importance: Importance.max,
        priority: Priority.high,
        largeIcon: DrawableResourceAndroidBitmap('ic_notification_large'),
        icon: 'ic_notification_small',
        color: const Color(0XFF0060C6),
      ),
    ),
  );
}

class FirebasePushNotificationServices extends GetxService {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final notificationRepository = NotificationRepository();

  final fcmToken = "".obs;
  final apnsToken = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> requestPermission() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('ic_notification_small'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload == 'detail_page') {}
      },
    );

    await initTokens();
    await initListeners();
  }

  Future<void> initTokens() async {
    if (Platform.isIOS) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print("ini fcm token $fcmToken");

      var deviceId = await getDeviceId();
      var appVersion = await getVersion();
      var osVersion = await getOSVersion();

      // await notificationRepository.subscribeNotification(
      //   fcmToken: fcmToken,
      //   apnsToken: apnsToken,
      //   deviceType: "1",
      //   deviceId: deviceId,
      //   appVersion: appVersion,
      //   osVersion: osVersion,
      // );
    } else {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print("ini fcm token $fcmToken");

      var deviceId = await getDeviceId();
      var appVersion = await getVersion();
      var osVersion = await getOSVersion();

      // await notificationRepository.subscribeNotification(
      //   fcmToken: fcmToken,
      //   apnsToken: null,
      //   deviceType: "1",
      //   deviceId: deviceId,
      //   appVersion: appVersion,
      //   osVersion: osVersion,
      // );
    }
  }

  Future<void> initListeners() async {
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {})
        .onError((err) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        message.notification?.title,
        message.notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'Default',
            importance: Importance.max,
            priority: Priority.high,
            largeIcon: DrawableResourceAndroidBitmap('ic_notification_large'),
            icon: 'ic_notification_small',
            color: const Color(0XFF0060C6),
          ),
        ),
      );
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        message.notification?.title,
        message.notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'Default',
            importance: Importance.max,
            priority: Priority.high,
            largeIcon: DrawableResourceAndroidBitmap('ic_notification_large'),
            icon: 'ic_notification_small',
            color: const Color(0XFF0060C6),
          ),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {},
    );
  }

  Future<void> onUnsubscribe() async {
    await FirebaseMessaging.instance.deleteToken();
    // await notificationRepository.unsubscribeNotification(
    //   fcmToken: fcmToken.value != "" ? fcmToken.value : null,
    //   apnsToken: apnsToken.value != "" ? apnsToken.value : null,
    // );
  }

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? "";
    }

    return "";
  }

  Future<String> getOSVersion() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.release;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    } else {
      return "Unknown OS";
    }
  }

  Future<String> getVersion() async {
    var packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
