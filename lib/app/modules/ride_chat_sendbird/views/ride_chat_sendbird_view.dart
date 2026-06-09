import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/modules/ride_chat_sendbird/views/ride_chat_sendbird_view/ride_chat_sendbird_keyboard_sub_view.dart';
import 'package:new_evmoto_user/app/widgets/global_body_handler.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

import '../../../routes/app_pages.dart';
import '../controllers/ride_chat_sendbird_controller.dart';

class RideChatSendbirdView extends GetView<RideChatSendbirdController> {
  const RideChatSendbirdView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: controller.isCriticalError.value
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 32 / 2,
                      backgroundImage: CachedNetworkImageProvider(
                        controller.driverAvatarUrl.value!,
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.driverName.value ?? "-",
                          style: controller
                              .typographyServices
                              .bodyLargeBold
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey700
                                    .value,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          controller.driverLicensePlate.value ?? "",
                          style: controller
                              .typographyServices
                              .captionSmallRegular
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey500
                                    .value,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
          centerTitle: false,
          titleSpacing: 0,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: GlobalBodyHandler(
          isFetch: controller.isFetch.value,
          isCriticalError: controller.isCriticalError.value,
          onInit: () async {
            await controller.onInit();
          },
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              // Positioned(
              //   top: 0,
              //   left: 0,
              //   right: 0,
              //   child: Image.asset(
              //     "assets/images/img_background_chat.png",
              //     width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height,
              //     fit: BoxFit.cover,
              //     opacity: const AlwaysStoppedAnimation(0.05),
              //   ),
              // ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SmartRefresher(
                        reverse: true,
                        controller: controller.refreshController,
                        enablePullDown: false,
                        enablePullUp: controller.isSeeMoreMessageList.value,
                        onLoading: () async {
                          await controller.seeMoreMessageList();
                          controller.refreshController.loadComplete();
                        },
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              for (var message in controller.messageList) ...[
                                if (message is FileMessage) ...[
                                  if (message.sender!.userId ==
                                      "user_${controller.homeController.userServices.userInfo.value.id!}") ...[
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
                                                      BorderRadius.circular(8),
                                                  child: CachedNetworkImage(
                                                    imageUrl: message.secureUrl,
                                                    width: 100,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
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
                                                  SizedBox(width: 4),
                                                  SvgPicture.asset(
                                                    controller.isChatRead(
                                                              driverLastSeenAt:
                                                                  DateTime.fromMillisecondsSinceEpoch(
                                                                    controller
                                                                        .membersReadStatus["driver_${controller.driverId}"]['last_seen_at'],
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
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (message.sender!.userId ==
                                      "driver_${controller.driverId.value}") ...[
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
                                  if (message.sender!.userId ==
                                      "user_${controller.homeController.userServices.userInfo.value.id!}") ...[
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
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
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
                                                  SizedBox(width: 4),
                                                  SvgPicture.asset(
                                                    controller.isChatRead(
                                                              driverLastSeenAt:
                                                                  DateTime.fromMillisecondsSinceEpoch(
                                                                    controller
                                                                        .membersReadStatus["driver_${controller.driverId}"]['last_seen_at'],
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
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (message.sender!.userId ==
                                      "driver_${controller.driverId.value}") ...[
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
                              ],
                              SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                    RideChatSendbirdKeyboardSubView(),
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
