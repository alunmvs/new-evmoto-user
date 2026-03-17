import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
                  title: Row(
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
                        style:
                            controller.typographyServices.bodyLargeBold.value,
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
                    SizedBox(height: 6),
                    if (controller.messageList.isEmpty) ...[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 16),
                              Text(
                                "Belum ada pesan, mulai percakapan dengan mengirim pesan pertama.",
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
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
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
                                    for (var message
                                        in controller.messageList) ...[
                                      if (message is FileMessage) ...[
                                        if (message.sender!.userId.contains(
                                          "user_",
                                        )) ...[
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                  ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 12,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(16),
                                                        topLeft:
                                                            Radius.circular(16),
                                                        bottomLeft:
                                                            Radius.circular(16),
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.toNamed(
                                                          Routes.PHOTO_VIEWER,
                                                          arguments: {
                                                            "photo_attachment_url":
                                                                message
                                                                    .secureUrl,
                                                          },
                                                        );
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        child:
                                                            CachedNetworkImage(
                                                              imageUrl: message
                                                                  .secureUrl,
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
                                                                      messageCreatedAt: DateTime.fromMillisecondsSinceEpoch(
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
                                                  bottomRight: Radius.circular(
                                                    16,
                                                  ),
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
                                                          color: Color(
                                                            0XFFD0D1DB,
                                                          ),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                  ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 12,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(16),
                                                        topLeft:
                                                            Radius.circular(16),
                                                        bottomLeft:
                                                            Radius.circular(16),
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                                      messageCreatedAt: DateTime.fromMillisecondsSinceEpoch(
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
                                                  bottomRight: Radius.circular(
                                                    16,
                                                  ),
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
                                                          color: Color(
                                                            0XFFD0D1DB,
                                                          ),
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
                                                bottomRight: Radius.circular(
                                                  16,
                                                ),
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
                                                        color: Color(
                                                          0XFFD0D1DB,
                                                        ),
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
                    Container(
                      padding: EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: controller
                        //         .themeColorServices
                        //         .overlayDark100
                        //         .value
                        //         .withValues(alpha: 0.1),
                        //     blurRadius: 16,
                        //     spreadRadius: 2,
                        //     offset: Offset(0, -1),
                        //   ),
                        // ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // if (controller.attachmentUrl.value != "") ...[
                          //   Stack(
                          //     clipBehavior: Clip.none,
                          //     children: [
                          //       Padding(
                          //         padding: const EdgeInsets.only(
                          //           top: 16,
                          //           right: 16,
                          //         ),
                          //         child: ClipRRect(
                          //           borderRadius: BorderRadius.circular(8),
                          //           child: CachedNetworkImage(
                          //             imageUrl:
                          //                 controller.attachmentUrl.value,
                          //             width: 100,
                          //           ),
                          //         ),
                          //       ),
                          //       Positioned(
                          //         right: 0,
                          //         child: GestureDetector(
                          //           onTap: () {
                          //             controller.attachmentUrl.value = "";
                          //           },
                          //           child: CircleAvatar(
                          //             backgroundColor: controller
                          //                 .themeColorServices
                          //                 .sematicColorRed400
                          //                 .value,
                          //             radius: 16,
                          //             child: SvgPicture.asset(
                          //               "assets/icons/icon_close.svg",
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          //   SizedBox(height: 16),
                          // ],
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.isAttachmentOptionOpen.value =
                                      !controller.isAttachmentOptionOpen.value;
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_box_outlined,
                                        color: controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: controller.textEditingController,
                                  onSubmitted: (value) async {
                                    if (controller.textEditingController.text
                                            .trim() !=
                                        "") {
                                      await controller.sendMessage(
                                        message: controller
                                            .textEditingController
                                            .text,
                                      );
                                    }
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: controller
                                        .themeColorServices
                                        .neutralsColorGrey100
                                        .value,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    hintText:
                                        controller
                                            .languageServices
                                            .language
                                            .value
                                            .typeMessage ??
                                        "-",
                                    hintStyle: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value
                                        .copyWith(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey400
                                              .value,
                                        ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9999),
                                      borderSide: BorderSide(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey100
                                            .value,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9999),
                                      borderSide: BorderSide(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey100
                                            .value,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9999),
                                      borderSide: BorderSide(
                                        color: controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(width: 12),
                              // GestureDetector(
                              //   onTap: () async {
                              //     if (controller.textEditingController.text
                              //             .trim() !=
                              //         "") {
                              //       await controller.sendMessage(
                              //         message:
                              //             controller.textEditingController.text,
                              //       );
                              //     }
                              //   },
                              //   child: Container(
                              //     height: 40,
                              //     width: 40,
                              //     decoration: BoxDecoration(
                              //       color: controller
                              //           .themeColorServices
                              //           .primaryBlue
                              //           .value,
                              //       borderRadius: BorderRadius.circular(8),
                              //     ),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.center,
                              //       children: [
                              //         SvgPicture.asset(
                              //           "assets/icons/icon_send_message.svg",
                              //           width: 16,
                              //           height: 16,
                              //           color: controller
                              //               .themeColorServices
                              //               .neutralsColorGrey0
                              //               .value,
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          if (controller.isAttachmentOptionOpen.value) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await controller
                                            .sendAttachmentFromGallery();
                                      },
                                      child: Container(
                                        width: 80,
                                        height: 89,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey200
                                                .value,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: controller
                                                    .themeColorServices
                                                    .sematicColorBlue100
                                                    .value,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_gallery.svg",
                                                    width: 24,
                                                    height: 24,
                                                    color: controller
                                                        .themeColorServices
                                                        .sematicColorBlue500
                                                        .value,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              controller
                                                      .languageServices
                                                      .language
                                                      .value
                                                      .gallery ??
                                                  "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodySmallRegular
                                                  .value,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    GestureDetector(
                                      onTap: () async {
                                        await controller
                                            .sendAttachmentFromCamera();
                                      },
                                      child: Container(
                                        width: 80,
                                        height: 89,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey200
                                                .value,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: controller
                                                    .themeColorServices
                                                    .sematicColorBlue100
                                                    .value,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/icon_camera.svg",
                                                    width: 24.079988479614258,
                                                    height: 20.717695236206055,
                                                    color: controller
                                                        .themeColorServices
                                                        .sematicColorBlue500
                                                        .value,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              controller
                                                      .languageServices
                                                      .language
                                                      .value
                                                      .camera ??
                                                  "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodySmallRegular
                                                  .value,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 34 - 16),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
