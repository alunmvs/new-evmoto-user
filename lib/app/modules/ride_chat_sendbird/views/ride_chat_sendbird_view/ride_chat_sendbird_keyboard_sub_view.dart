import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/ride_chat_sendbird/controllers/ride_chat_sendbird_controller.dart';

class RideChatSendbirdKeyboardSubView
    extends GetView<RideChatSendbirdController> {
  const RideChatSendbirdKeyboardSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.isTripHasEnded.value == true) ...[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                controller.languageServices.language.value.tripHasEnded ?? "-",
                style: controller.typographyServices.bodySmallRegular.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          if (controller.isTripHasEnded.value == false) ...[
            Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: controller.themeColorServices.neutralsColorGrey0.value,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SvgPicture.asset(
                              //   "assets/icons/icon_add_square.svg",
                              //   width: 12,
                              //   height: 12,
                              //   color: controller
                              //       .themeColorServices
                              //       .neutralsColorGrey0
                              //       .value,
                              // ),
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
                            if (controller.textEditingController.text.trim() !=
                                "") {
                              await controller.sendMessage(
                                message: controller.textEditingController.text,
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
                      //         message: controller
                      //             .textEditingController
                      //             .text,
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
                      //       mainAxisAlignment:
                      //           MainAxisAlignment.center,
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
                                await controller.sendAttachmentFromGallery();
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
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                        borderRadius: BorderRadius.circular(8),
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
                                            colorFilter: ColorFilter.mode(
                                              controller
                                                  .themeColorServices
                                                  .sematicColorBlue500
                                                  .value,
                                              BlendMode.srcIn,
                                            ),
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
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 40),
                            GestureDetector(
                              onTap: () async {
                                await controller.sendAttachmentFromCamera();
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
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                        borderRadius: BorderRadius.circular(8),
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
                                            colorFilter: ColorFilter.mode(
                                              controller
                                                  .themeColorServices
                                                  .sematicColorBlue500
                                                  .value,
                                              BlendMode.srcIn,
                                            ),
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
                                      textAlign: TextAlign.center,
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
        ],
      ),
    );
  }
}
