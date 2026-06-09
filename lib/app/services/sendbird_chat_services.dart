import 'dart:io';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/services/firebase_push_notification_services.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class SendbirdChatServices extends GetxService {
  final isSuccessInitialize = false.obs;

  Future<void> initialize() async {
    final firebaseRemoteConfigServices =
        Get.find<FirebaseRemoteConfigServices>();
    final firebasePushNotificationServices =
        Get.find<FirebasePushNotificationServices>();
    final homeController = Get.find<HomeController>();

    try {
      await SendbirdChat.init(
        appId: firebaseRemoteConfigServices.remoteConfig.getString(
          'sendbird_app_id',
        ),
      );

      if (homeController.userServices.userInfo.value.id != null) {
        await SendbirdChat.connect(
          "user_${homeController.userServices.userInfo.value.id}",
          nickname: homeController.userServices.userInfo.value.name,
        );
        isSuccessInitialize.value = true;
      }
      if (firebasePushNotificationServices.fcmToken.value != "") {
        await SendbirdChat.registerPushToken(
          type: PushTokenType.fcm,
          token: firebasePushNotificationServices.fcmToken.value,
          alwaysPush: true,
        );
      }

      if (firebasePushNotificationServices.apnsToken.value != "") {
        if (Platform.isIOS) {
          await SendbirdChat.registerPushToken(
            type: PushTokenType.apns,
            token: firebasePushNotificationServices.apnsToken.value,
            alwaysPush: true,
          );
        }
      }
    } catch (e) {}
  }

  Future<GroupChannel?> getChannelByDriverId({required int driverId}) async {
    var query = GroupChannelListQuery();
    var channelList = await query.next();

    for (var channel in channelList) {
      for (var member in channel.members) {
        if (member.userId == "driver_$driverId") {
          return channel;
        }
      }
    }

    return null;
  }

  Future<GroupChannel?> createChannelByDriverId({
    required int driverId,
    required String? driverName,
    required String? driverAvatarUrl,
  }) async {
    var params = GroupChannelCreateParams()
      ..name = driverName
      ..isPublic = true
      ..isDistinct = false
      ..userIds = ["driver_$driverId"];

    var groupChannel = await GroupChannel.createChannel(params);

    return groupChannel;
  }

  Future<void> updateMetaData({
    required GroupChannel groupChannel,
    required int orderId,
    required int orderType,
    required int state,
  }) async {
    await groupChannel.updateMetaData({
      'orderId': orderId.toString(),
      'orderType': orderType.toString(),
      'state': state.toString(),
    });
  }

  Future<void> clearLogout() async {
    await SendbirdChat.disconnect();
  }
}
