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

  final appId = ''.obs;
  final userId = ''.obs;

  Future<void> initialize() async {
    final firebaseRemoteConfigServices =
        Get.find<FirebaseRemoteConfigServices>();
    final firebasePushNotificationServices =
        Get.find<FirebasePushNotificationServices>();
    final homeController = Get.find<HomeController>();

    methodChannel.setMethodCallHandler(handleNativeListener);
    await methodChannel.invokeMethod("init", {
      "app_id": firebaseRemoteConfigServices.remoteConfig.getString(
        'sendbird_app_id',
      ),
      "user_id": "user_210",
      "access_token": '',
      "push_token": firebasePushNotificationServices.fcmToken.value,
    });
  }

  Future<void> handleNativeListener(MethodCall call) async {
    switch (call.method) {
      case "testing_debug":
        print("testing debug : ${call.arguments['note']}");
        break;
      case "direct_call_ended":
        FlutterCallkitIncoming.endCall(call.arguments['call_id']);
        if (Get.currentRoute == Routes.RIDE_CALL_SENDBIRD) {
          Get.back();
        }
        break;
      case "start_direct_call_connected":
        final rideCallSendbirdController =
            Get.find<RideCallSendbirdController>();
        rideCallSendbirdController.isFetch.value = true;
        rideCallSendbirdController.callStopWatchTimer.onStartTimer();
        rideCallSendbirdController.callId.value = call.arguments['call_id'];
        rideCallSendbirdController.isFetch.value = false;
        break;
      case "start_direct_call_ended":
        FlutterCallkitIncoming.endCall(call.arguments['call_id']);
        if (Get.currentRoute == Routes.RIDE_CALL_SENDBIRD) {
          Get.back();
        }

        break;
    }
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
}
