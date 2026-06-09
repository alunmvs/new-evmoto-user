import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/evmoto_order_chat_participants_model.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/services/user_services.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ChatListController extends GetxController {
  final userServices = Get.find<UserServices>();

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final roomList = <EvmotoOrderChatParticipants>[].obs;
  QueryDocumentSnapshot? lastDoc;

  final isSeeMoreRoomList = true.obs;

  final refreshController = RefreshController();

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    await getChatList();
    isFetch.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getChatList() async {
    roomList.value = [];
    isSeeMoreRoomList.value = true;
    lastDoc = null;

    var evmotoOrderChatParticipants = await FirebaseFirestore.instance
        .collection('evmoto_order_chat_participants')
        .where('userId', isEqualTo: userServices.userInfo.value.id.toString())
        .orderBy('createdAt', descending: true)
        .limit(10)
        .get();

    if (evmotoOrderChatParticipants.docs.isNotEmpty) {
      lastDoc = evmotoOrderChatParticipants.docs.last;
    } else {
      lastDoc = null;
    }

    for (var doc in evmotoOrderChatParticipants.docs) {
      var data = EvmotoOrderChatParticipants.fromJson(doc.data());
      data.docId = doc.id;
      roomList.add(data);
    }

    if (lastDoc == null) {
      isSeeMoreRoomList.value = false;
    }
  }

  Future<void> seeMoreChatList() async {
    if (lastDoc == null) {
      return;
    }

    var evmotoOrderChatParticipants = await FirebaseFirestore.instance
        .collection('evmoto_order_chat_participants')
        .where('userId', isEqualTo: userServices.userInfo.value.id.toString())
        .orderBy('createdAt', descending: true)
        .startAfterDocument(lastDoc!)
        .limit(10)
        .get();

    if (evmotoOrderChatParticipants.docs.isNotEmpty) {
      lastDoc = evmotoOrderChatParticipants.docs.last;
    } else {
      lastDoc = null;
    }

    for (var doc in evmotoOrderChatParticipants.docs) {
      var data = EvmotoOrderChatParticipants.fromJson(doc.data());
      data.orderId = doc.id;
      roomList.add(data);
    }

    if (lastDoc == null) {
      isSeeMoreRoomList.value = false;
    }
  }

  Future<void> getChatLatestMessageList() async {}
}
