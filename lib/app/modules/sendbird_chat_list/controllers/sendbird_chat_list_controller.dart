import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/sendbird_chat_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class MyGroupChannelHandler extends GroupChannelHandler {
  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    Get.find<SendbirdChatListController>().getGroupChannelList();
  }

  @override
  void onReadStatusUpdated(GroupChannel channel) {
    Get.find<SendbirdChatListController>().getGroupChannelList();
  }
}

class SendbirdChatListController extends GetxController {
  final sendbirdChatServices = Get.find<SendbirdChatServices>();
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();
  final homeController = Get.find<HomeController>();
  final refreshController = RefreshController();

  final groupChannelList = <GroupChannel>[].obs;

  final unreadMessageCountGroupChannel = {}.obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    if (sendbirdChatServices.isSuccessInitialize.value == false) {
      await sendbirdChatServices.isSuccessInitialize.stream.firstWhere(
        (value) => value == true,
      );
    }
    try {
      await getGroupChannelList();
    } on RequestFailedException catch (e) {
      SnackbarHelper.showSnackbarError(
        text: "Terjadi kesalahan dari server (${e.code})",
      );
    }
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    removeAllChannelHandlers();
  }

  void removeAllChannelHandlers() {
    for (var groupchannel in groupChannelList) {
      SendbirdChat.removeChannelHandler(groupchannel.channelUrl);
    }
  }

  Future<void> getGroupChannelList() async {
    removeAllChannelHandlers();
    var groupChannelList = <GroupChannel>[];
    unreadMessageCountGroupChannel.value = {};

    var query = GroupChannelListQuery();
    var channelList = await query.next();

    for (var channel in channelList) {
      for (var member in channel.members) {
        if (member.userId ==
            "user_${homeController.userServices.userInfo.value.id}") {
          unreadMessageCountGroupChannel[channel.channelUrl] =
              channel.unreadMessageCount;
          groupChannelList.add(channel);

          SendbirdChat.addChannelHandler(
            channel.channelUrl,
            MyGroupChannelHandler(),
          );
        }
      }
    }

    this.groupChannelList.value = groupChannelList;
  }

  Future<void> refreshUnreadMessageCountGroupChannel() async {
    unreadMessageCountGroupChannel.value = {};

    var query = GroupChannelListQuery();
    var channelList = await query.next();

    for (var channel in channelList) {
      for (var member in channel.members) {
        if (member.userId ==
            "user_${homeController.userServices.userInfo.value.id}") {
          unreadMessageCountGroupChannel[channel.channelUrl] =
              channel.unreadMessageCount;
        }
      }
    }
  }

  String? getDriverProfileUrl({required GroupChannel groupChannel}) {
    for (var member in groupChannel.members) {
      if (member.userId !=
          "user_${homeController.userServices.userInfo.value.id}") {
        return member.profileUrl;
      }
    }
    return null;
  }

  String? getDriverName({required GroupChannel groupChannel}) {
    for (var member in groupChannel.members) {
      if (member.userId !=
          "user_${homeController.userServices.userInfo.value.id}") {
        return member.nickname;
      }
    }
    return null;
  }
}
