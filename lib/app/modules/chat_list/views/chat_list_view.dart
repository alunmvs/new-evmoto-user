import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../routes/app_pages.dart';
import '../controllers/chat_list_controller.dart';

class ChatListView extends GetView<ChatListController> {
  const ChatListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Pesan",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: controller.isFetch.value
            ? Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: controller.themeColorServices.primaryBlue.value,
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 6, color: Color(0XFFF2F2F2), thickness: 6),
                  Expanded(
                    child: SmartRefresher(
                      header: MaterialClassicHeader(
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                      footer: ClassicFooter(
                        loadStyle: LoadStyle.HideAlways,
                        textStyle: controller
                            .typographyServices
                            .bodySmallRegular
                            .value
                            .copyWith(
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                        canLoadingIcon: null,
                        loadingIcon: null,
                        idleIcon: null,
                        noMoreIcon: null,
                        failedIcon: null,
                      ),
                      enablePullDown: true,
                      enablePullUp: controller.isSeeMoreRoomList.value,
                      onRefresh: () async {
                        await Future.wait([controller.getChatList()]);
                        controller.refreshController.refreshCompleted();
                      },
                      onLoading: () async {
                        await Future.wait([controller.seeMoreChatList()]);
                        controller.refreshController.loadComplete();
                      },
                      controller: controller.refreshController,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var room in controller.roomList) ...[
                              GestureDetector(
                                onTap: () async {
                                  await Get.toNamed(
                                    Routes.CHAT_DETAIL,
                                    arguments: {"doc_id": room.docId},
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (room.driverProfileUrl == null ||
                                          room.driverProfileUrl == "") ...[
                                        CircleAvatar(
                                          radius: 42 / 2,
                                          child: SvgPicture.asset(
                                            "assets/icons/icon_profile.svg",
                                            width: 42,
                                            height: 42,
                                          ),
                                        ),
                                      ],
                                      if (room.driverProfileUrl != null &&
                                          room.driverProfileUrl != "") ...[
                                        CircleAvatar(
                                          radius: 42 / 2,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                room.driverProfileUrl!,
                                                maxWidth: 42,
                                                maxHeight: 42,
                                              ),
                                        ),
                                      ],
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              room.driverName ?? "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeBold
                                                  .value,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              room.orderId ?? "-",
                                              style: controller
                                                  .typographyServices
                                                  .captionLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: Color(0XFFB3B3B3),
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (room.lastMessage != null) ...[
                                              SizedBox(height: 6),
                                              Text(
                                                room.lastMessage ?? "-",
                                                style: controller
                                                    .typographyServices
                                                    .bodySmallRegular
                                                    .value
                                                    .copyWith(
                                                      color: Color(0XFF808080),
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      if (room.lastMessageAt != null) ...[
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat(
                                                'HH:mm',
                                              ).format(room.lastMessageAt!),
                                              style: controller
                                                  .typographyServices
                                                  .captionLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: Color(0XFFB3B3B3),
                                                  ),
                                            ),
                                            if ((room.totalUnreadChatDriver ??
                                                    0) >
                                                0) ...[
                                              SizedBox(height: 4),
                                              CircleAvatar(
                                                radius: 18 / 2,
                                                backgroundColor: controller
                                                    .themeColorServices
                                                    .primaryBlue
                                                    .value,
                                                child: Text(
                                                  (room.totalUnreadChatDriver ??
                                                          0)
                                                      .toString(),
                                                  style: controller
                                                      .typographyServices
                                                      .captionSmallRegular
                                                      .value
                                                      .copyWith(
                                                        color: Color(
                                                          0XFFFFFFFF,
                                                        ),
                                                      ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Color(0XFFE6E6E6),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
