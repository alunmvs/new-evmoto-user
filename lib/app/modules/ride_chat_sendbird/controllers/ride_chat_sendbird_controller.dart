import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/sendbird_chat_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/app/widgets/loading_dialog.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

import '../../../routes/app_pages.dart';

class MyGroupChannelHandler extends GroupChannelHandler {
  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    Get.find<RideChatSendbirdController>().messageList.add(message);

    if (Get.currentRoute == Routes.RIDE_CHAT_SENDBIRD) {
      Get.find<RideChatSendbirdController>().groupChannel.value!.markAsRead();
    }
  }

  @override
  void onReadStatusUpdated(GroupChannel channel) {
    Get.find<RideChatSendbirdController>().getMemberReadStatus();
  }
}

class RideChatSendbirdController extends GetxController {
  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final sendbirdChatServices = Get.find<SendbirdChatServices>();
  final homeController = Get.find<HomeController>();

  final textEditingController = TextEditingController();
  final refreshController = RefreshController();

  final groupChannel = Rx<GroupChannel?>(null);

  final driverId = Rx<int?>(null);
  final driverName = Rx<String?>(null);
  final driverLicensePlate = Rx<String?>(null);
  final driverAvatarUrl = Rx<String?>(null);

  final orderId = Rx<int?>(null);
  final orderType = Rx<int?>(null);
  final state = Rx<int?>(null);

  final messageList = <RootMessage>[].obs;
  final isSeeMoreMessageList = true.obs;

  final isAttachmentOptionOpen = false.obs;

  final membersReadStatus = {}.obs;

  final isCriticalError = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    isCriticalError.value = false;

    driverId.value = Get.arguments['driver_id'];
    driverName.value = Get.arguments['driver_name'];
    driverAvatarUrl.value = Get.arguments['driver_avatar_url'];
    driverLicensePlate.value = Get.arguments['driver_license_plate'];
    orderId.value = Get.arguments['order_id'];
    orderType.value = Get.arguments['order_type'];
    state.value = Get.arguments['state'];

    if (sendbirdChatServices.isSuccessInitialize.value == false) {
      await sendbirdChatServices.isSuccessInitialize.stream.firstWhere(
        (value) => value == true,
      );
    }

    try {
      await getChannelUrl();
      await updateMetaData();

      await getMessageList();

      SendbirdChat.removeChannelHandler('UNIQUE_HANDLER_ID');
      SendbirdChat.addChannelHandler(
        'UNIQUE_HANDLER_ID',
        MyGroupChannelHandler(),
      );

      await getMemberReadStatus();
      await groupChannel.value!.markAsRead();
    } on RequestFailedException catch (e) {
      SnackbarHelper.showSnackbarError(
        text: "Terjadi kesalahan dari server (${e.code})",
      );
      isCriticalError.value = true;
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

    SendbirdChat.removeChannelHandler('UNIQUE_HANDLER_ID');
  }

  Future<void> getMemberReadStatus() async {
    final membersReadStatus = groupChannel.value!.getReadStatus(true);
    this.membersReadStatus.value = membersReadStatus;
    this.membersReadStatus.refresh();
  }

  Future<void> getChannelUrl() async {
    groupChannel.value = await sendbirdChatServices.getChannelByDriverId(
      driverId: driverId.value!,
    );
    if (groupChannel.value == null) {
      groupChannel.value = (await sendbirdChatServices.createChannelByDriverId(
        driverId: driverId.value!,
        driverName: driverName.value,
        driverAvatarUrl: driverAvatarUrl.value,
      ))!;
    }
  }

  Future<void> updateMetaData() async {
    await sendbirdChatServices.updateMetaData(
      groupChannel: groupChannel.value!,
      orderId: orderId.value!,
      orderType: orderType.value!,
      state: state.value!,
    );
  }

  Future<void> getMessageList() async {
    final params = MessageListParams()
      ..previousResultSize = 10
      ..nextResultSize = 0
      ..includeReactions = true
      ..includeMetaArray = true;

    messageList.value = await groupChannel.value!.getMessagesByTimestamp(
      DateTime.now().millisecondsSinceEpoch,
      params,
    );
  }

  Future<void> seeMoreMessageList() async {
    final params = MessageListParams()
      ..previousResultSize = 10
      ..nextResultSize = 0
      ..includeReactions = true
      ..includeMetaArray = true;

    var messageList = await groupChannel.value!.getMessagesByTimestamp(
      this.messageList.first.createdAt,
      params,
    );

    isSeeMoreMessageList.value = messageList.isEmpty;

    for (var message in messageList.reversed) {
      this.messageList.insert(0, message);
    }
  }

  Future<void> sendMessage({required String message}) async {
    final userMessage = groupChannel.value!.sendUserMessage(
      UserMessageCreateParams(message: message),
    );

    messageList.add(userMessage);
    textEditingController.clear();
  }

  Future<void> sendAttachmentFromGallery() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 720,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image != null) {
      var fileMessageCreateParams = FileMessageCreateParams.withFile(
        File(image.path),
      );

      groupChannel.value!.sendFileMessage(
        fileMessageCreateParams,
        handler: (message, e) {
          messageList.add(message);
        },
        progressHandler: (sentBytes, totalBytes) {
          if (sentBytes < totalBytes) {
            if (Get.isDialogOpen == false) {
              Get.dialog(LoadingDialog(), barrierDismissible: false);
            }
          } else {
            if (Get.isDialogOpen == true) {
              Get.close(1);
            }
          }
        },
      );

      isAttachmentOptionOpen.value = false;
      textEditingController.clear();
    }
  }

  Future<void> sendAttachmentFromCamera() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 720,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image != null) {
      Get.dialog(LoadingDialog(), barrierDismissible: false);

      var fileMessageCreateParams = FileMessageCreateParams.withFile(
        File(image.path),
      );

      groupChannel.value!.sendFileMessage(
        fileMessageCreateParams,
        handler: (message, e) {
          messageList.add(message);
        },
        progressHandler: (sentBytes, totalBytes) {
          if (sentBytes < totalBytes) {
            if (Get.isDialogOpen == false) {
              Get.dialog(LoadingDialog(), barrierDismissible: false);
            }
          } else {
            if (Get.isDialogOpen == true) {
              Get.close(1);
            }
          }
        },
      );

      // messageList.add(userMessage);
      isAttachmentOptionOpen.value = false;
      textEditingController.clear();

      Get.close(1);
    }
  }

  bool isChatRead({
    required DateTime messageCreatedAt,
    required DateTime driverLastSeenAt,
  }) {
    return driverLastSeenAt.isAfter(messageCreatedAt) ||
        driverLastSeenAt.isAtSameMomentAs(messageCreatedAt);
  }
}
