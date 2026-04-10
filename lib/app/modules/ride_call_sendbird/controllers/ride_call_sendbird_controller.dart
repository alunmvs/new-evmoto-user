import 'dart:async';

import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/sendbird_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class RideCallSendbirdController extends GetxController {
  final sendbirdServices = Get.find<SendbirdServices>();

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final callStopWatchTimer = StopWatchTimer();
  final isCaller = false.obs;
  final connectedAt = DateTime.now().obs;

  final driverName = "".obs;
  final driverAvatarUrl = "".obs;
  final driverId = "".obs;

  final callId = "".obs;

  final startDialingAt = DateTime.now().obs;

  Timer? globalTimer;

  final isMicrophoneOn = true.obs;
  final isSpeakerOn = false.obs;
  final isCriticalError = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    isCriticalError.value = false;
    callId.value = Get.arguments?['call_id'] ?? '';
    isCaller.value = Get.arguments['is_caller'];
    driverName.value = Get.arguments['driver_name'];
    driverAvatarUrl.value = Get.arguments['driver_avatar_url'] ?? '';

    if (sendbirdServices.isSuccessInitialize.value == false) {
      await sendbirdServices.isSuccessInitialize.stream.firstWhere(
        (value) => value == true,
      );
    }

    try {
      if (isCaller.value == true) {
        startDialingAt.value = DateTime.now();
        driverId.value = Get.arguments['driver_id'].toString();
        final sendBirdServices = Get.find<SendbirdServices>();

        sendBirdServices.startCall(
          calleeId:
              driverId.value == "999999" ||
                  driverId.value == "dashboard_testing"
              ? driverId.value
              : "driver_${driverId.value}",
        );

        globalTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
          if (DateTime.now().difference(startDialingAt.value).inSeconds == 45) {
            final sendbirdServices = Get.find<SendbirdServices>();
            await FlutterCallkitIncoming.endAllCalls();
            await sendbirdServices.endCall();
            Get.back();
          }
        });
      }

      if (isCaller.value == false) {
        callStopWatchTimer.onStartTimer();
      }
    } catch (e) {
      SnackbarHelper.showSnackbarError(text: "Terjadi kesalahan dari server");
      isCriticalError.value = true;
    }

    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
    await callStopWatchTimer.dispose();
    globalTimer?.cancel();
  }
}
