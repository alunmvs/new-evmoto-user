import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/modules/sendbird_chat_detail/views/sendbird_chat_detail_view/sendbird_chat_detail_keyboard_sub_view.dart';
import 'package:new_evmoto_user/app/widgets/global_body_handler.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

import '../../../routes/app_pages.dart';
import '../controllers/sendbird_chat_detail_controller.dart';

class SendbirdChatDetailView extends GetView<SendbirdChatDetailController> {
  const SendbirdChatDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          FocusScope.of(context).unfocus();
          await controller.groupChannel.value!.markAsRead();
        },
        onPanStart: (details) async {
          await controller.groupChannel.value!.markAsRead();
        },
        child: Scaffold(
          appBar: controller.isFetch.value
              ? null
              : AppBar(
                  titleSpacing: 0,
                  title: controller.isCriticalError.value
                      ? null
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 21,
                              backgroundColor: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              backgroundImage:
                                  controller.driverProfileUrl.value == null
                                  ? AssetImage('assets/icons/icon_profile.png')
                                  : CachedNetworkImageProvider(
                                      controller.driverProfileUrl.value!,
                                    ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              controller.driverName.value ?? "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value,
                            ),
                          ],
                        ),
                  centerTitle: false,
                  backgroundColor:
                      controller.themeColorServices.neutralsColorGrey0.value,
                  surfaceTintColor:
                      controller.themeColorServices.neutralsColorGrey0.value,
                ),
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey100.value,
          body: GlobalBodyHandler(
            isFetch: controller.isFetch.value,
            isCriticalError: controller.isCriticalError.value,
            onInit: () async {
              await controller.onInit();
            },
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6),
                if (controller.messageList.isEmpty) ...[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .noMessageYetStartConverstation ??
                                "-",
                            style: controller
                                .typographyServices
                                .captionLargeRegular
                                .value
                                .copyWith(color: Color(0XFF7D7D7D)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                Expanded(
                  child: Container(
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
                    child: SmartRefresher(
                      reverse: true,
                      controller: controller.refreshController,
                      enablePullDown: false,
                      enablePullUp: controller.isSeeMoreMessageList.value,
                      onLoading: () async {
                        await controller.seeMoreMessageList();
                        controller.refreshController.loadComplete();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
                                for (var message in controller.messageList) ...[
                                  if (message is FileMessage) ...[
                                    if (message.sender!.userId.contains(
                                      "user_",
                                    )) ...[
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(16),
                                                topLeft: Radius.circular(16),
                                                bottomLeft: Radius.circular(16),
                                              ),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0XFF2D74BF),
                                                  Color(0XFF114E8E),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                stops: [0.0, 1.0],
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed(
                                                      Routes.PHOTO_VIEWER,
                                                      arguments: {
                                                        "photo_attachment_url":
                                                            message.secureUrl,
                                                      },
                                                    );
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          message.secureUrl,
                                                      width: 100,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      DateFormat(
                                                        'HH:mm',
                                                      ).format(
                                                        DateTime.fromMillisecondsSinceEpoch(
                                                          message.createdAt,
                                                        ).toLocal(),
                                                      ),
                                                      style: controller
                                                          .typographyServices
                                                          .captionLargeRegular
                                                          .value
                                                          .copyWith(
                                                            color: Color(
                                                              0XFFD0D1DB,
                                                            ),
                                                          ),
                                                    ),
                                                    SizedBox(width: 4),
                                                    if (controller
                                                            .membersReadStatus[controller
                                                            .driverId
                                                            .value] !=
                                                        null) ...[
                                                      SvgPicture.asset(
                                                        controller.isChatRead(
                                                                  driverLastSeenAt: DateTime.fromMillisecondsSinceEpoch(
                                                                    controller
                                                                        .membersReadStatus[controller
                                                                        .driverId
                                                                        .value]['last_seen_at'],
                                                                  ).toLocal(),
                                                                  messageCreatedAt:
                                                                      DateTime.fromMillisecondsSinceEpoch(
                                                                        message
                                                                            .createdAt,
                                                                      ).toLocal(),
                                                                ) ==
                                                                true
                                                            ? "assets/icons/icon_msg_read.svg"
                                                            : "assets/icons/icon_msg_delivery.svg",
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                    ] else ...[
                                                      SvgPicture.asset(
                                                        "assets/icons/icon_msg_delivery.svg",
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (message.sender!.userId.contains(
                                      "driver_",
                                    )) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(16),
                                              topLeft: Radius.circular(16),
                                              bottomRight: Radius.circular(16),
                                            ),
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey100
                                                .value,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                    Routes.PHOTO_VIEWER,
                                                    arguments: {
                                                      "photo_attachment_url":
                                                          message.secureUrl,
                                                    },
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: CachedNetworkImage(
                                                    imageUrl: message.secureUrl,
                                                    width: 100,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                DateFormat('HH:mm').format(
                                                  DateTime.fromMillisecondsSinceEpoch(
                                                    message.createdAt,
                                                  ).toLocal(),
                                                ),
                                                style: controller
                                                    .typographyServices
                                                    .captionLargeRegular
                                                    .value
                                                    .copyWith(
                                                      color: Color(0XFFD0D1DB),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: 8),
                                  ],
                                  if (message is UserMessage) ...[
                                    if (message.sender!.userId.contains(
                                      "user_",
                                    )) ...[
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(16),
                                                topLeft: Radius.circular(16),
                                                bottomLeft: Radius.circular(16),
                                              ),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0XFF2D74BF),
                                                  Color(0XFF114E8E),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                stops: [0.0, 1.0],
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  message.message,
                                                  style: controller
                                                      .typographyServices
                                                      .bodyLargeRegular
                                                      .value
                                                      .copyWith(
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey0
                                                            .value,
                                                      ),
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      DateFormat(
                                                        'HH:mm',
                                                      ).format(
                                                        DateTime.fromMillisecondsSinceEpoch(
                                                          message.createdAt,
                                                        ).toLocal(),
                                                      ),
                                                      style: controller
                                                          .typographyServices
                                                          .captionLargeRegular
                                                          .value
                                                          .copyWith(
                                                            color: Color(
                                                              0XFFD0D1DB,
                                                            ),
                                                          ),
                                                    ),
                                                    SizedBox(width: 4),

                                                    if (controller
                                                            .membersReadStatus[controller
                                                            .driverId
                                                            .value] !=
                                                        null) ...[
                                                      SvgPicture.asset(
                                                        controller.isChatRead(
                                                                  driverLastSeenAt: DateTime.fromMillisecondsSinceEpoch(
                                                                    controller
                                                                        .membersReadStatus[controller
                                                                        .driverId]['last_seen_at'],
                                                                  ).toLocal(),
                                                                  messageCreatedAt:
                                                                      DateTime.fromMillisecondsSinceEpoch(
                                                                        message
                                                                            .createdAt,
                                                                      ).toLocal(),
                                                                ) ==
                                                                true
                                                            ? "assets/icons/icon_msg_read.svg"
                                                            : "assets/icons/icon_msg_delivery.svg",
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                    ] else ...[
                                                      SvgPicture.asset(
                                                        "assets/icons/icon_msg_delivery.svg",
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (message.sender!.userId.contains(
                                      "driver_",
                                    )) ...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(16),
                                              topLeft: Radius.circular(16),
                                              bottomRight: Radius.circular(16),
                                            ),
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey100
                                                .value,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                message.message,
                                                style: controller
                                                    .typographyServices
                                                    .bodyLargeRegular
                                                    .value
                                                    .copyWith(
                                                      color: controller
                                                          .themeColorServices
                                                          .neutralsColorGrey900
                                                          .value,
                                                    ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                DateFormat('HH:mm').format(
                                                  DateTime.fromMillisecondsSinceEpoch(
                                                    message.createdAt,
                                                  ).toLocal(),
                                                ),
                                                style: controller
                                                    .typographyServices
                                                    .captionLargeRegular
                                                    .value
                                                    .copyWith(
                                                      color: Color(0XFFD0D1DB),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: 8),
                                  ],
                                  if (message is AdminMessage) ...[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(16),
                                            topLeft: Radius.circular(16),
                                            bottomRight: Radius.circular(16),
                                          ),
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey100
                                              .value,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              message.message,
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorGrey900
                                                        .value,
                                                  ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              DateFormat('HH:mm').format(
                                                DateTime.fromMillisecondsSinceEpoch(
                                                  message.createdAt,
                                                ).toLocal(),
                                              ),
                                              style: controller
                                                  .typographyServices
                                                  .captionLargeRegular
                                                  .value
                                                  .copyWith(
                                                    color: Color(0XFFD0D1DB),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                  ],
                                ],
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SendbirdChatDetailKeyboardSubView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
