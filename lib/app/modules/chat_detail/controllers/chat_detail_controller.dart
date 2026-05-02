import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_evmoto_user/app/data/models/evmoto_order_chat_messages_model.dart';
import 'package:new_evmoto_user/app/data/models/evmoto_order_chat_participants_model.dart';
import 'package:new_evmoto_user/app/repositories/upload_image_repository.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/common_helper.dart';

class ChatDetailController extends GetxController {
  final UploadImageRepository uploadImageRepository;

  ChatDetailController({required this.uploadImageRepository});

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final evmotoOrderChatParticipants = EvmotoOrderChatParticipants().obs;
  final evmotoOrderChatMessagesList = <EvmotoOrderChatMessages>[].obs;

  StreamSubscription? streamEvmotoOrderChatParticipants;
  StreamSubscription? streamEvmotoOrderChatMessages;

  final textEditingController = TextEditingController();

  final docId = "".obs;
  final attachmentUrl = "".obs;
  final message = "".obs;

  final isAttachmentOptionOpen = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    docId.value = Get.arguments['doc_id'];
    await streamExistingChatRoom();
    await streamExistingChatList();
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    streamEvmotoOrderChatParticipants?.cancel();
    streamEvmotoOrderChatMessages?.cancel();
    super.onClose();
  }

  Future<void> streamExistingChatList() async {
    await streamEvmotoOrderChatParticipants?.cancel();
    streamEvmotoOrderChatMessages = FirebaseFirestore.instance
        .collection('evmoto_order_chat_messages')
        .where('evmotoOrderChatParticipantsDocumentId', isEqualTo: docId.value)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((snapshots) async {
          var evmotoOrderChatMessagesList = <EvmotoOrderChatMessages>[];
          for (var doc in snapshots.docs) {
            var evmotoOrderChatMessages = EvmotoOrderChatMessages.fromJson(
              doc.data(),
            );
            evmotoOrderChatMessages.evmotoOrderChatMessagesId = doc.id;
            evmotoOrderChatMessagesList.add(evmotoOrderChatMessages);
          }
          this.evmotoOrderChatMessagesList.value = evmotoOrderChatMessagesList;
          await markAllMessageRead();
        });
  }

  Future<void> streamExistingChatRoom() async {
    await streamEvmotoOrderChatParticipants?.cancel();
    streamEvmotoOrderChatParticipants = FirebaseFirestore.instance
        .collection('evmoto_order_chat_participants')
        .doc(docId.value)
        .snapshots()
        .listen((snapshots) {
          evmotoOrderChatParticipants.value =
              EvmotoOrderChatParticipants.fromJson(snapshots.data() ?? {});
          evmotoOrderChatParticipants.value.docId = snapshots.id;
          print("[DEBUG CHAT] ${snapshots.data()}");
          print("[DEBUG CHAT] Docs Id ${snapshots.id}");
        });
  }

  Future<void> markAllMessageRead() async {
    final batch = FirebaseFirestore.instance.batch();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('evmoto_order_chat_messages')
        .where('evmotoOrderChatParticipantsDocumentId', isEqualTo: docId.value)
        .where('senderType', isEqualTo: "driver")
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in querySnapshot.docs) {
      batch.set(doc.reference, {
        "isRead": true,
        "readAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }

  Future<void> sendMessage() async {
    print("oke-3");
    if (message.value != "" || attachmentUrl.value != "") {
      var data = {
        "evmotoOrderChatParticipantsDocumentId": docId.value,
        "senderAttachmentUrl": attachmentUrl.value,
        "senderId": evmotoOrderChatParticipants.value.driverId,
        "senderMessage": message.value,
        "senderType": "user",
        "isRead": false,
        "sendAt": FieldValue.serverTimestamp(),
        "createdAt": FieldValue.serverTimestamp(),
      };

      print(data);

      await FirebaseFirestore.instance
          .collection('evmoto_order_chat_messages')
          .add(data);

      print(evmotoOrderChatParticipants.value.docId);
      print({
        'lastMessage': message.value != "" ? message.value : "Attachment",
        'lastMessageAt': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('evmoto_order_chat_participants')
          .doc(docId.value)
          .set({
            'lastMessage': message.value != "" ? message.value : "Attachment",
            'lastMessageAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      message.value = "";
      attachmentUrl.value = "";
      isAttachmentOptionOpen.value = false;
      textEditingController.clear();
    }
  }

  Future<void> uploadAttachmentCamera() async {
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

  Future<void> uploadAttachmentAlbum() async {
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
}
