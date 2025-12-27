import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import 'package:new_evmoto_user/app/repositories/upload_image_repository.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/common_helper.dart';

class RideChatController extends GetxController {
  final UploadImageRepository uploadImageRepository;

  RideChatController({required this.uploadImageRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final rideOrderDetailController = Get.find<RideOrderDetailController>();

  final textEditingController = TextEditingController();

  final isAttachmentOptionOpen = false.obs;
  final attachmentUrl = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Stream<QuerySnapshot> getMessagesStream({required String roomId}) {
    return FirebaseFirestore.instance
        .collection('evmoto_order_chat_messages')
        .where('evmotoOrderChatParticipantsDocumentId', isEqualTo: roomId)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<void> sendMessage({required String message}) async {
    await FirebaseFirestore.instance
        .collection('evmoto_order_chat_messages')
        .add({
          "evmotoOrderChatParticipantsDocumentId": rideOrderDetailController
              .orderRideDetail
              .value
              .orderId
              .toString(),
          "senderId": rideOrderDetailController.orderRideDetail.value.userId,
          "senderType": "user",
          "senderMessage": message,
          "senderAttachmentUrl": attachmentUrl.value == ""
              ? null
              : attachmentUrl.value,
          "createdAt": FieldValue.serverTimestamp(),
        });

    attachmentUrl.value = "";
    isAttachmentOptionOpen.value = false;
    textEditingController.clear();
  }

  Future<void> uploadAttachmentFromGallery() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 720,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image != null) {
      showLoadingDialog();
      attachmentUrl.value = await uploadImageRepository.uploadImage(
        file: image,
      );

      Get.close(1);
    }
  }

  Future<void> uploadAttachmentFromCamera() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 720,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image != null) {
      showLoadingDialog();
      attachmentUrl.value = await uploadImageRepository.uploadImage(
        file: image,
      );

      Get.close(1);
    }
  }
}
