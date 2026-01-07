import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../controllers/ride_call_controller.dart';

class RideCallView extends GetView<RideCallController> {
  const RideCallView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) async {
          if (result == true) {
            await FirebaseFirestore.instance
                .collection('evmoto_order_chat_calls')
                .doc(controller.docsId.value)
                .set({
                  "callEndedAt": FieldValue.serverTimestamp(),
                  "callEndedBy": "driver",
                }, SetOptions(merge: true));
          } else {
            await FirebaseFirestore.instance
                .collection('evmoto_order_chat_calls')
                .doc(controller.docsId.value)
                .set({
                  "callEndedAt": FieldValue.serverTimestamp(),
                  "callEndedBy": "user",
                }, SetOptions(merge: true));
          }

          await controller.stopAllMediaRecorder();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Menelepon...",
              style: controller.typographyServices.bodyLargeBold.value,
            ),
            centerTitle: false,
            backgroundColor:
                controller.themeColorServices.neutralsColorGrey0.value,
            surfaceTintColor:
                controller.themeColorServices.neutralsColorGrey0.value,
          ),
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
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
              : Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0XFFFFFFFF), Color(0XFFCDE2F8)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          SizedBox(height: 16 * 3),
                          if (controller.isCallAnswered.value == true &&
                              controller
                                      .evmotoOrderChatCalls
                                      .value
                                      .answeredAt !=
                                  null) ...[
                            StreamBuilder<int>(
                              stream: controller.callStopWatchTimer.rawTime,
                              initialData: 0,
                              builder: (context, snapshot) {
                                final value = snapshot.data!;

                                return Obx(
                                  () => Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0XFFF2F2F2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      StopWatchTimer.getDisplayTime(
                                        value,
                                        hours:
                                            DateTime.now()
                                                .difference(
                                                  controller
                                                      .evmotoOrderChatCalls
                                                      .value
                                                      .answeredAt!,
                                                )
                                                .inHours >=
                                            1,
                                        milliSecond: false,
                                      ),
                                      style: controller
                                          .typographyServices
                                          .bodySmallBold
                                          .value
                                          .copyWith(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 16 * 2),
                          ],
                          if (controller
                                      .rideOrderDetailController
                                      .orderRideDetail
                                      .value
                                      .userHeadImg ==
                                  null ||
                              controller
                                      .rideOrderDetailController
                                      .orderRideDetail
                                      .value
                                      .userHeadImg ==
                                  "") ...[
                            CircleAvatar(
                              radius: 128 / 2,
                              child: SvgPicture.asset(
                                "assets/icons/icon_profile.svg",
                                width: 128,
                                height: 128,
                              ),
                            ),
                          ],
                          if (controller
                                      .rideOrderDetailController
                                      .orderRideDetail
                                      .value
                                      .userHeadImg !=
                                  null &&
                              controller
                                      .rideOrderDetailController
                                      .orderRideDetail
                                      .value
                                      .userHeadImg !=
                                  "") ...[
                            CircleAvatar(
                              radius: 128 / 2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(99999),
                                child: CachedNetworkImage(
                                  imageUrl: controller
                                      .rideOrderDetailController
                                      .orderRideDetail
                                      .value
                                      .userHeadImg!,
                                  width: 128,
                                  height: 128,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: 16),
                          Text(
                            controller
                                    .rideOrderDetailController
                                    .orderRideDetail
                                    .value
                                    .user ??
                                "-",
                            style: controller
                                .typographyServices
                                .headingSmallBold
                                .value
                                .copyWith(color: Color(0XFF2E2E2E)),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.2,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  for (var track
                                      in controller.localStream!
                                          .getAudioTracks()) {
                                    track.enabled =
                                        !controller.isMicrophoneOn.value;
                                    controller.isMicrophoneOn.value =
                                        !controller.isMicrophoneOn.value;
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey0
                                        .value,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: controller
                                            .themeColorServices
                                            .overlayDark200
                                            .value
                                            .withValues(alpha: 0.06),
                                        blurRadius: 10,
                                        spreadRadius: 0,
                                        offset: Offset(0, 3.33),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        controller.isMicrophoneOn.value
                                            ? "assets/icons/icon_microphone_on.png"
                                            : "assets/icons/icon_microphone_off.png",
                                        width: 24,
                                        height: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 16 * 2),
                              GestureDetector(
                                onTap: () async {
                                  controller.isSpeakerOn.value =
                                      !controller.isSpeakerOn.value;
                                  await Helper.setSpeakerphoneOn(
                                    controller.isSpeakerOn.value,
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: controller.isSpeakerOn.value
                                        ? Color(0XFF29CD29)
                                        : controller
                                              .themeColorServices
                                              .neutralsColorGrey0
                                              .value,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: controller
                                            .themeColorServices
                                            .overlayDark200
                                            .value
                                            .withValues(alpha: 0.06),
                                        blurRadius: 10,
                                        spreadRadius: 0,
                                        offset: Offset(0, 3.33),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        controller.isSpeakerOn.value
                                            ? "assets/icons/icon_speaker_white.png"
                                            : "assets/icons/icon_speaker.png",
                                        width: 24,
                                        height: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16 * 2),
                          GestureDetector(
                            onTap: () async {
                              if (Get.currentRoute == Routes.RIDE_CALL) {
                                Get.back();
                              }
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Color(0XFFF44336),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: controller
                                        .themeColorServices
                                        .overlayDark200
                                        .value
                                        .withValues(alpha: 0.06),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    offset: Offset(0, 3.33),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/icon_call_close_white.png",
                                    width: 32,
                                    height: 32,
                                  ),
                                ],
                              ),
                            ),
                          ),
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
