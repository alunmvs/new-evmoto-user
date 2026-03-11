import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/sendbird_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class RideCallSendbirdController extends GetxController {
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

  final isFetch = false.obs;

  @override
  void onInit() async {
    super.onInit();
    isFetch.value = true;
    callId.value = Get.arguments?['call_id'] ?? '';
    isCaller.value = Get.arguments['is_caller'];
    driverName.value = Get.arguments['driver_name'];
    driverAvatarUrl.value = Get.arguments['driver_avatar_url'];

    if (isCaller.value == true) {
      driverId.value = Get.arguments['driver_id'].toString();
      final sendBirdServices = Get.find<SendbirdServices>();

      await sendBirdServices.startCall(calleeId: driverId.value);
    }

    if (isCaller.value == false) {
      callStopWatchTimer.onStartTimer();
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
  }
}
