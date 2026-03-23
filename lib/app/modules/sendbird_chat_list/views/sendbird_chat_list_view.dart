import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../controllers/sendbird_chat_list_controller.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';

class SendbirdChatListView extends GetView<SendbirdChatListController> {
  const SendbirdChatListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            controller.languageServices.language.value.message ?? "-",
            style: controller.typographyServices.bodyLargeBold.value,
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
                  Expanded(
                    child: Container(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey0
                          .value,
                      child: SmartRefresher(
                        controller: controller.refreshController,
                        onRefresh: () async {
                          await controller.getGroupChannelList();
                          controller.refreshController.refreshCompleted();
                        },
                        header: MaterialClassicHeader(
                          color:
                              controller.themeColorServices.primaryBlue.value,
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
                        enablePullUp: true,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
                                if (controller.groupChannelList.isEmpty) ...[
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                147 /
                                                812,
                                          ),
                                          Image.asset(
                                            "assets/images/img_chat_empty.png",
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                176 /
                                                375,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            controller
                                                    .languageServices
                                                    .language
                                                    .value
                                                    .noMessageYet ??
                                                "-",
                                            style: controller
                                                .typographyServices
                                                .bodyLargeBold
                                                .value,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 8),
                                          SizedBox(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                297 /
                                                375,
                                            child: Text(
                                              controller
                                                      .languageServices
                                                      .language
                                                      .value
                                                      .conversationWillAppear ??
                                                  "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodySmallRegular
                                                  .value
                                                  .copyWith(
                                                    color: controller
                                                        .themeColorServices
                                                        .neutralsColorGrey600
                                                        .value,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                for (var groupChannel
                                    in controller.groupChannelList) ...[
                                  GestureDetector(
                                    onTap: () async {
                                      await Get.toNamed(
                                        Routes.SENDBIRD_CHAT_DETAIL,
                                        arguments: {
                                          "group_channel_url":
                                              groupChannel.channelUrl,
                                        },
                                      );
                                      await controller.getGroupChannelList();
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 21,
                                                backgroundColor: controller
                                                    .themeColorServices
                                                    .neutralsColorGrey0
                                                    .value,
                                                backgroundImage:
                                                    controller
                                                            .getDriverProfileUrl(
                                                              groupChannel:
                                                                  groupChannel,
                                                            ) ==
                                                        null
                                                    ? AssetImage(
                                                        'assets/icons/icon_profile.png',
                                                      )
                                                    : CachedNetworkImageProvider(
                                                        controller
                                                            .getDriverProfileUrl(
                                                              groupChannel:
                                                                  groupChannel,
                                                            )!,
                                                      ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller.getDriverName(
                                                            groupChannel:
                                                                groupChannel,
                                                          ) ??
                                                          "-",
                                                      style: controller
                                                          .typographyServices
                                                          .bodyLargeBold
                                                          .value,
                                                    ),
                                                    SizedBox(height: 6),
                                                    Text(
                                                      groupChannel
                                                              .lastMessage
                                                              ?.message ??
                                                          "-",
                                                      style: controller
                                                          .typographyServices
                                                          .bodySmallRegular
                                                          .value
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                              0XFF7D7D7D,
                                                            ),
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    DateFormat(
                                                      'hh:mm a',
                                                    ).format(
                                                      DateTime.fromMillisecondsSinceEpoch(
                                                        groupChannel
                                                            .lastMessage!
                                                            .createdAt,
                                                      ).toLocal(),
                                                    ),
                                                    style: controller
                                                        .typographyServices
                                                        .captionLargeRegular
                                                        .value
                                                        .copyWith(
                                                          color: Color(
                                                            0XFFB3B3B3,
                                                          ),
                                                        ),
                                                  ),
                                                  if (groupChannel
                                                          .unreadMessageCount >
                                                      0) ...[
                                                    SizedBox(height: 4),
                                                    CircleAvatar(
                                                      radius: 18 / 2,
                                                      backgroundColor: controller
                                                          .themeColorServices
                                                          .primaryBlue
                                                          .value,
                                                      child: Text(
                                                        groupChannel
                                                            .unreadMessageCount
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
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Divider(
                                            height: 0,
                                            color: Color(0XFFE6E6E6),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                ],

                                SizedBox(height: 16),
                              ],
                            ),
                          ),
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
