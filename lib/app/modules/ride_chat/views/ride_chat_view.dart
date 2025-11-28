import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';

import '../controllers/ride_chat_controller.dart';

class RideChatView extends GetView<RideChatController> {
  const RideChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/icons/icon_profile.svg",
                width: 32,
                height: 32,
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Franky Fransisco Marlissa",
                    style: controller.typographyServices.bodyLargeBold.value
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
                    "B 3457 KZE",
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
          actions: [
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.RIDE_CALL);
              },
              child: SizedBox(
                height: 24,
                width: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/icon_phone.svg",
                      width: 16.78,
                      height: 18,
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey700
                          .value,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
          ],
          centerTitle: false,
          titleSpacing: 0,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor:
            controller.themeColorServices.sematicColorBlue100.value,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                "assets/images/img_background_chat.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.05),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
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
                                  .neutralsColorGrey0
                                  .value,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Halo Mas! 👋",
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
                                  "10:10",
                                  style: controller
                                      .typographyServices
                                      .captionLargeRegular
                                      .value
                                      .copyWith(color: Color(0XFFD0D1DB)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
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
                                  .neutralsColorGrey0
                                  .value,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "This is your delivery driver from EV Moto. I'm just around the corner from your place. 😊",
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
                                  "10:10",
                                  style: controller
                                      .typographyServices
                                      .captionLargeRegular
                                      .value
                                      .copyWith(color: Color(0XFFD0D1DB)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Hi!",
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
                                  Text(
                                    "10:10",
                                    style: controller
                                        .typographyServices
                                        .captionLargeRegular
                                        .value
                                        .copyWith(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Awesome, thanks for letting me know! Can't wait for my delivery. 🎉",
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
                                  Text(
                                    "10:11",
                                    style: controller
                                        .typographyServices
                                        .captionLargeRegular
                                        .value
                                        .copyWith(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
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
                                  .neutralsColorGrey0
                                  .value,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "No problem at all!\nI'll be there in about 15 minutes.",
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
                                  "10:11",
                                  style: controller
                                      .typographyServices
                                      .captionLargeRegular
                                      .value
                                      .copyWith(color: Color(0XFFD0D1DB)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
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
                                  .neutralsColorGrey0
                                  .value,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "I'll text you when I arrive.",
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
                                  "10:11",
                                  style: controller
                                      .typographyServices
                                      .captionLargeRegular
                                      .value
                                      .copyWith(color: Color(0XFFD0D1DB)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Mantap 😊",
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
                                  Text(
                                    "10:12",
                                    style: controller
                                        .typographyServices
                                        .captionLargeRegular
                                        .value
                                        .copyWith(
                                          color: controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: controller
                            .themeColorServices
                            .overlayDark100
                            .value
                            .withValues(alpha: 0.1),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                color: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_add_square.svg",
                                    width: 12,
                                    height: 12,
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey0
                                        .value,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                hintText: 'Ketik Pesan...',
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
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey400
                                        .value,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey400
                                        .value,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
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
                          SizedBox(width: 12),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_send_message.svg",
                                  width: 16,
                                  height: 16,
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                ),
                              ],
                            ),
                          ),
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
                                Container(
                                  width: 80,
                                  height: 89,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey200
                                          .value,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: controller
                                              .themeColorServices
                                              .sematicColorBlue100
                                              .value,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                        "Galeri",
                                        style: controller
                                            .typographyServices
                                            .bodySmallRegular
                                            .value,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 40),
                                Container(
                                  width: 80,
                                  height: 89,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey200
                                          .value,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: controller
                                              .themeColorServices
                                              .sematicColorBlue100
                                              .value,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                        "Kamera",
                                        style: controller
                                            .typographyServices
                                            .bodySmallRegular
                                            .value,
                                      ),
                                    ],
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
          ],
        ),
      ),
    );
  }
}
