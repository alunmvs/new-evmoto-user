import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/modules/ride_call_sendbird/controllers/ride_call_sendbird_controller.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/firebase_push_notification_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';

class SendbirdServices extends GetxService {
  var methodChannel = MethodChannel('com.sendbird.calls/method');
  final isSuccessInitialize = false.obs;

  Future<void> initialize() async {
    final firebaseRemoteConfigServices =
        Get.find<FirebaseRemoteConfigServices>();
    final firebasePushNotificationServices =
        Get.find<FirebasePushNotificationServices>();
    final homeController = Get.find<HomeController>();

    try {
      methodChannel.setMethodCallHandler(handleNativeListener);
      if (homeController.userServices.userInfo.value.id != null) {
        if (Platform.isAndroid) {
          await methodChannel.invokeMethod("init", {
            "app_id": firebaseRemoteConfigServices.remoteConfig.getString(
              'sendbird_app_id',
            ),
            "user_id": "user_${homeController.userServices.userInfo.value.id}",
            "access_token": '',
            "push_token": firebasePushNotificationServices.fcmToken.value,
          });
        }
        if (Platform.isIOS) {
          await methodChannel.invokeMethod("init", {
            "app_id": firebaseRemoteConfigServices.remoteConfig.getString(
              'sendbird_app_id',
            ),
            "user_id": "user_${homeController.userServices.userInfo.value.id}",
            "user_access_token": '',
            "push_token": firebasePushNotificationServices.fcmToken.value,
            "apns_token": firebasePushNotificationServices.fcmToken.value,
          });
        }
        isSuccessInitialize.value = true;
      }
    } catch (e) {
      print("ini error $e");
    }
  }

  Future<void> handleNativeListener(MethodCall call) async {
    final firebasePushNotificationServices =
        Get.find<FirebasePushNotificationServices>();

    switch (call.method) {
      case "info":
        print("[Debug Sendbird] Success Receive Info Authenticate");
        break;
      case "testing_debug":
        break;
      case "direct_call_received":
        print(
          "[Debug Sendbird] Direct Call Receive ${call.arguments['call_id']} ${call.arguments['caller_nickname']} ${call.arguments['profile_url']}",
        );
        firebasePushNotificationServices.showIncomingCall(
          extra: {
            "sendbird_call": jsonEncode({
              "command": {
                "payload": {
                  "call_id": call.arguments['call_id'],
                  "caller": {
                    "nickname": call.arguments['caller_nickname'],
                    "profile_url": call.arguments['profile_url'],
                  },
                },
              },
            }),
          },
          driverName: call.arguments['caller_nickname'],
          driverAvatarUrl: call.arguments['profile_url'],
        );

        break;
      case "direct_call_ended":
        if (Get.currentRoute == Routes.RIDE_CALL_SENDBIRD) {
          Get.back();
        }
        FlutterCallkitIncoming.endCall(call.arguments['call_id']);
        break;
      case "start_direct_call_connected":
        final rideCallSendbirdController =
            Get.find<RideCallSendbirdController>();
        rideCallSendbirdController.isFetch.value = true;
        rideCallSendbirdController.callStopWatchTimer.onStartTimer();
        // rideCallSendbirdController.callId.value = call.arguments['call_id'];
        rideCallSendbirdController.isFetch.value = false;
        break;
      case "start_direct_call_ended":
        FlutterCallkitIncoming.endCall(call.arguments['call_id']);
        if (Get.currentRoute == Routes.RIDE_CALL_SENDBIRD) {
          Get.back();
        }
        break;
      default:
        print("[Debug Sendbird] call.method ${call.method}");
        break;
    }
  }

  Future<bool> checkIsCallActive() async {
    return await methodChannel.invokeMethod('check_is_call_active', {});
  }

  Future<void> handleFirebasePushNotificationData({
    required Map<dynamic, dynamic> data,
  }) async {
    await methodChannel.invokeMethod('handle_firebase_push_notification_data', {
      'data': data,
    });
  }

  Future<void> startCall({required String calleeId}) async {
    await methodChannel.invokeMethod("start_direct_call", {
      "callee_id": calleeId,
    });
  }

  Future<void> pickupCall({required String callId}) async {
    await methodChannel.invokeMethod("answer_direct_call", {"call_id": callId});
  }

  Future<void> rejectCall({required String callId}) async {
    await methodChannel.invokeMethod("reject_direct_call", {"call_id": callId});
  }

  Future<void> endCall() async {
    await methodChannel.invokeMethod("end_direct_call", {});
  }

  Future<void> loadspeakerOn() async {
    await methodChannel.invokeMethod("loadspeaker_on", {});
  }

  Future<void> loadspeakerOff() async {
    await methodChannel.invokeMethod("loadspeaker_off", {});
  }

  Future<void> microphoneOn() async {
    await methodChannel.invokeMethod("microphone_on", {});
  }

  Future<void> microphoneOff() async {
    await methodChannel.invokeMethod("microphone_off", {});
  }

  Future<void> clearLogout() async {
    if (Platform.isIOS) {
      await methodChannel.invokeMethod("clear_logout", {});
    }
  }
}
