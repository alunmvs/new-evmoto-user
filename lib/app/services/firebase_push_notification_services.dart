import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_detail/controllers/advanced_booking_detail_controller.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import 'package:new_evmoto_user/app/repositories/notification_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/sendbird_services.dart';
import 'package:new_evmoto_user/app/widgets/advanced_booking_expired_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

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

  var isSendbirdCall = message.data.keys.contains('sendbird_call');
  if (isSendbirdCall) {
    // final sendbirdServices = Get.find<SendbirdServices>();
    var data = message.data;

    var commandType = jsonDecode(data['sendbird_call'])?['command']?['type'];

    if (commandType == 'dial') {
      // sendbirdServices.handleFirebasePushNotificationData(data: data);

      var driverName = jsonDecode(
        data['sendbird_call'],
      )['command']['payload']['caller']['nickname'];
      var driverAvatarUrl =
          jsonDecode(
                data['sendbird_call'],
              )['command']['payload']['caller']['profile_url'] ==
              ''
          ? null
          : jsonDecode(
              data['sendbird_call'],
            )['command']['payload']['caller']['profile_url'];
      var extra = data;

      var callKitParams = CallKitParams(
        id: jsonDecode(
          extra['sendbird_call'],
        )?['command']?['payload']?['call_id'],
        nameCaller: driverName,
        appName: 'EvMoto',
        avatar: driverAvatarUrl,
        handle: '0123456789',
        type: 0,
        textAccept: 'Accept',
        textDecline: 'Decline',
        missedCallNotification: NotificationParams(
          showNotification: false,
          isShowCallback: false,
          subtitle: 'Missed call',
          callbackText: 'Call back',
        ),
        callingNotification: const NotificationParams(
          showNotification: true,
          isShowCallback: true,
          subtitle: 'Calling...',
          callbackText: 'Hang Up',
        ),
        duration: 60000,
        extra: extra,
        android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          // logoUrl: 'https://i.pravatar.cc/100',
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0060C6',
          actionColor: '#FFFFFF',
          textColor: '#ffffff',
          incomingCallNotificationChannelName: "Incoming Call",
          missedCallNotificationChannelName: "Missed Call",
          isShowCallID: false,
        ),
        ios: IOSParams(
          iconName: 'CallKitLogo',
          handleType: 'generic',
          supportsVideo: true,
          maximumCallGroups: 2,
          maximumCallsPerCallGroup: 1,
          audioSessionMode: 'default',
          audioSessionActive: true,
          audioSessionPreferredSampleRate: 44100.0,
          audioSessionPreferredIOBufferDuration: 0.005,
          supportsDTMF: true,
          supportsHolding: true,
          supportsGrouping: false,
          supportsUngrouping: false,
          ringtonePath: 'system_ringtone_default',
        ),
      );
      await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
      return;
    }
    if (commandType == 'cancel') {
      FlutterCallkitIncoming.hideCallkitIncoming(
        CallKitParams(
          id: jsonDecode(
            data['sendbird_call'],
          )['command']['payload']['call_id'],
        ),
      );

      flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        "Panggilan dari Driver Tidak Terjawab",
        "Driver Anda menunggu konfirmasi. Balas panggilan sekarang agar perjalanan Anda tidak tertunda.",
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

      return;
    }

    var excludeShowNotification = [
      'other_device_accepted',
      'audio',
      'video',
      'candidate',
      'offer',
      'end',
      'dial_rcv',
      'accept',
      'answer',
      'decline',
    ];

    if (excludeShowNotification.contains(commandType)) {
      return;
    }
  }

  var isSendbird = message.data.keys.contains('sendbird');
  if (isSendbird) {
    flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      "Anda mendapatkan pesan baru dari Driver",
      message.data['message'].replaceFirst(RegExp(r'^.*?:'), '').trim(),
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
    return;
  }

  if (message.data['notification_type'] == 'ORDER_STATE_CHANGES') {
    if (Get.currentRoute == Routes.RIDE_ORDER_DETAIL ||
        Get.currentRoute == Routes.CHAT_DETAIL) {
      Get.find<RideOrderDetailController>().handleSocketOrderStatus();
    }
    return;
  }

  flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    message.data['title'],
    message.data['body'],
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

  final callId = "".obs;
  final data = {}.obs;

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

    await flutterLocalNotificationsPlugin.initialize(
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
    await flutterCallkitIncomingListener();
  }

  Future<void> initTokens() async {
    if (Platform.isIOS) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      final fcmToken = await FirebaseMessaging.instance.getToken();

      this.fcmToken.value = fcmToken ?? '';
      this.apnsToken.value = apnsToken ?? '';
      // print("ini fcm token $fcmToken");

      var deviceId = await getDeviceId();
      var appVersion = await getVersion();
      var osVersion = await getOSVersion();

      await notificationRepository.subscribeNotification(
        fcmToken: fcmToken,
        apnsToken: apnsToken,
        deviceType: "1",
        deviceId: deviceId,
        appVersion: appVersion,
        osVersion: osVersion,
      );
    } else {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      this.fcmToken.value = fcmToken ?? '';
      // print("ini fcm token $fcmToken");

      var deviceId = await getDeviceId();
      var appVersion = await getVersion();
      var osVersion = await getOSVersion();

      await notificationRepository.subscribeNotification(
        fcmToken: fcmToken,
        apnsToken: null,
        deviceType: "1",
        deviceId: deviceId,
        appVersion: appVersion,
        osVersion: osVersion,
      );
    }
  }

  Future<void> initListeners() async {
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {})
        .onError((err) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print("[DEBUG NOTIFICATION] ${message.data}");
      var isSendbirdCall = message.data.keys.contains('sendbird_call');
      if (isSendbirdCall) {
        var data = message.data;

        var commandType = jsonDecode(
          data['sendbird_call'],
        )?['command']?['type'];

        if (commandType == 'dial') {
          showIncomingCall(
            extra: data,
            driverAvatarUrl:
                jsonDecode(
                      data['sendbird_call'],
                    )['command']['payload']['caller']['profile_url'] ==
                    ''
                ? null
                : jsonDecode(
                    data['sendbird_call'],
                  )['command']['payload']['caller']['profile_url'],
            driverName: jsonDecode(
              data['sendbird_call'],
            )['command']['payload']['caller']['nickname'],
          );
          return;
        }

        if (commandType == 'cancel') {
          FlutterCallkitIncoming.hideCallkitIncoming(
            CallKitParams(
              id: jsonDecode(
                data['sendbird_call'],
              )['command']['payload']['call_id'],
            ),
          );

          flutterLocalNotificationsPlugin.show(
            DateTime.now().millisecondsSinceEpoch ~/ 1000,
            "Panggilan dari Driver Tidak Terjawab",
            "Driver Anda menunggu konfirmasi. Balas panggilan sekarang agar perjalanan Anda tidak tertunda.",
            NotificationDetails(
              android: AndroidNotificationDetails(
                'default_channel',
                'Default',
                importance: Importance.max,
                priority: Priority.high,
                largeIcon: DrawableResourceAndroidBitmap(
                  'ic_notification_large',
                ),
                icon: 'ic_notification_small',
                color: const Color(0XFF0060C6),
              ),
            ),
          );

          return;
        }

        if (commandType == 'end') {
          FlutterCallkitIncoming.endCall(
            jsonDecode(data['sendbird_call'])['command']['payload']['call_id'],
          );
          if (Get.currentRoute == Routes.RIDE_CALL_SENDBIRD) {
            Get.back();
          }
          return;
        }

        var excludeShowNotification = [
          'other_device_accepted',
          'audio',
          'video',
          'candidate',
          'offer',
          // 'end',
          'dial_rcv',
          'accept',
          'answer',
          'decline',
        ];

        if (excludeShowNotification.contains(commandType)) {
          return;
        }
      }

      var isSendbird = message.data.keys.contains('sendbird');
      if (isSendbird) {
        flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
          "Anda mendapatkan pesan baru dari Driver",
          message.data['message'].replaceFirst(RegExp(r'^.*?:'), '').trim(),
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

        if (Get.currentRoute == Routes.RIDE_ORDER_DETAIL) {
          Get.find<RideOrderDetailController>().getOrderRideDetail();
        }
        return;
      }

      if (message.data['notification_type'] == 'ADVANCE_ORDER_EXPIRED') {
        if (Get.currentRoute == Routes.ADVANCED_BOOKING_DETAIL) {
          Get.find<AdvancedBookingDetailController>().refreshAll();
        }
        Get.dialog(
          AdvancedBookingExpiredDialog(
            onTapConfirm: () async {
              Get.until((route) => Get.currentRoute == Routes.HOME);
              Get.find<HomeController>().indexNavigationBar.value = 0;
            },
          ),
        );
      }

      if ([
        'ADVANCE_ORDER_DRIVER_FOUND',
      ].contains(message.data['notification_type'])) {
        if (Get.currentRoute == Routes.ADVANCED_BOOKING_DETAIL) {
          Get.find<AdvancedBookingDetailController>().refreshAll();
        }
      }

      if (message.data['notification_type'] == 'ORDER_STATE_CHANGES') {
        if (Get.currentRoute == Routes.RIDE_ORDER_DETAIL ||
            Get.currentRoute == Routes.CHAT_DETAIL) {
          Get.find<RideOrderDetailController>().handleSocketOrderStatus();
        }
        return;
      }

      flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        message.data['title'],
        message.data['body'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'Default',
            importance: Importance.max,
            priority: Priority.high,
            largeIcon: DrawableResourceAndroidBitmap('ic_notification_large'),
            icon: 'ic_notification_small',
            color: const Color(0XFF0060C6),
            sound: RawResourceAndroidNotificationSound(''),
          ),
        ),
      );
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {},
    );
  }

  Future<void> onUnsubscribe() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {}
    await notificationRepository.unsubscribeNotification(
      fcmToken: fcmToken.value != "" ? fcmToken.value : null,
      apnsToken: apnsToken.value != "" ? apnsToken.value : null,
    );
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

  Future<void> flutterCallkitIncomingListener() async {
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
      switch (event!.event) {
        case Event.actionCallIncoming:
          // TODO: received an incoming call
          break;
        case Event.actionCallStart:
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
          break;
        case Event.actionCallAccept:
          final sendbirdServices = Get.find<SendbirdServices>();
          await sendbirdServices.handleFirebasePushNotificationData(
            data: event.body['extra'],
          );

          await Future.delayed(Duration(milliseconds: 500));

          await Permission.microphone.request();

          await sendbirdServices.pickupCall(
            callId: jsonDecode(
              event.body['extra']['sendbird_call'],
            )['command']['payload']['call_id'],
          );

          Get.toNamed(
            Routes.RIDE_CALL_SENDBIRD,
            arguments: {
              "call_id": jsonDecode(
                event.body['extra']['sendbird_call'],
              )['command']['payload']['call_id'],
              "is_caller": false,
              "driver_id": null,
              "driver_name": jsonDecode(
                event.body['extra']['sendbird_call'],
              )['command']['payload']['caller']['nickname'],
              "driver_avatar_url":
                  jsonDecode(
                        event.body['extra']['sendbird_call'],
                      )['command']['payload']['caller']['profile_url'] ==
                      ''
                  ? null
                  : jsonDecode(
                      event.body['extra']['sendbird_call'],
                    )['command']['payload']['caller']['profile_url'],
            },
          );
          break;
        case Event.actionCallDecline:
          final sendbirdServices = Get.find<SendbirdServices>();
          await sendbirdServices.handleFirebasePushNotificationData(
            data: event.body['extra'],
          );

          await Future.delayed(Duration(milliseconds: 500));

          await sendbirdServices.rejectCall(
            callId: jsonDecode(
              event.body['extra']['sendbird_call'],
            )['command']['payload']['call_id'],
          );
          break;
        case Event.actionCallEnded:
          // TODO: ended an incoming/outgoing call
          final sendbirdServices = Get.find<SendbirdServices>();

          await sendbirdServices.endCall();
          break;
        case Event.actionCallTimeout:
          // TODO: missed an incoming call
          break;
        case Event.actionCallCallback:
          // TODO: click action `Call back` from missed call notification
          break;
        case Event.actionCallToggleHold:
          // TODO: only iOS
          break;
        case Event.actionCallToggleMute:
          // TODO: only iOS
          break;
        case Event.actionCallToggleDmtf:
          // TODO: only iOS
          break;
        case Event.actionCallToggleGroup:
          // TODO: only iOS
          break;
        case Event.actionCallToggleAudioSession:
          // TODO: only iOS
          break;
        case Event.actionDidUpdateDevicePushTokenVoip:
          // TODO: only iOS
          break;
        case Event.actionCallCustom:
          // TODO: for custom action
          break;
        case Event.actionCallConnected:
          // TODO: Handle this case.
          break;
      }
    });
  }

  Future<void> showIncomingCall({
    required Map<String, dynamic>? extra,
    required String driverName,
    required String? driverAvatarUrl,
  }) async {
    var callKitParams = CallKitParams(
      id: jsonDecode(
        extra!['sendbird_call'],
      )?['command']?['payload']?['call_id'],
      nameCaller: driverName,
      appName: 'EvMoto',
      avatar: driverAvatarUrl,
      handle: '0123456789',
      type: 0,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: NotificationParams(
        showNotification: false,
        isShowCallback: false,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      callingNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Calling...',
        callbackText: 'Hang Up',
      ),
      duration: 60000,
      extra: extra,
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        // logoUrl: 'https://i.pravatar.cc/100',
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0060C6',
        actionColor: '#FFFFFF',
        textColor: '#ffffff',
        incomingCallNotificationChannelName: "Incoming Call",
        missedCallNotificationChannelName: "Missed Call",
        isShowCallID: false,
      ),
      ios: IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  }
}
