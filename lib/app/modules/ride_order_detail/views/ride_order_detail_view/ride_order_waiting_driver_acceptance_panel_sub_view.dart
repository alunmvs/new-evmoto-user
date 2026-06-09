import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import 'package:new_evmoto_user/app/utils/common_helper.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideOrderWaitingDriverAcceptancePanelSubView
    extends GetView<RideOrderDetailController> {
  const RideOrderWaitingDriverAcceptancePanelSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: 120 + (controller.isFetch.value ? 0 : 50),
      maxHeight: 190 + (controller.isFetch.value ? 0 : 25 + 20),
      padding: EdgeInsets.all(0),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      color: Colors.transparent,
      boxShadow: [],
      panelBuilder: (sc) {
        return Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.isFetch.value == false) ...[
                SizedBox(height: 8),
                if (controller.driverNearbyList.isEmpty) ...[
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0XFFFFF7ED),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0XFFA65226)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_alert_circle_driver_nearby_empty.svg",
                                  width: 13.33,
                                  height: 13.33,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4),
                          RichText(
                            text: TextSpan(
                              text:
                                  controller
                                      .languageServices
                                      .language
                                      .value
                                      .nearestDriverNotAvailable ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value
                                  .copyWith(color: Color(0XFFA65226)),
                              children: <TextSpan>[],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (controller.driverNearbyList.isNotEmpty) ...[
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0XFFF2F8FF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0XFF0060C6)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_pinpoint_primary_blue.svg",
                                  width: 9.33,
                                  height: 11.67,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4),
                          RichText(
                            text: TextSpan(
                              text:
                                  controller
                                      .languageServices
                                      .language
                                      .value
                                      .nearestDriverAvailable1 ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value
                                  .copyWith(color: Color(0XFF0060C6)),
                              children: <TextSpan>[
                                TextSpan(
                                  text: formatDistanceNearestDriver(
                                    controller
                                        .nearestDistanceDriverNearby
                                        .value,
                                    controller
                                        .languageServices
                                        .language
                                        .value
                                        .nearestDriverAvailable2,
                                  ),
                                  style: controller
                                      .typographyServices
                                      .bodySmallBold
                                      .value
                                      .copyWith(color: Color(0XFF0060C6)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 16),
              ],
              Expanded(
                child: Container(
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
                            .overlayDark200
                            .value
                            .withValues(alpha: 0.3),
                        blurRadius: 32,
                        spreadRadius: -6,
                        offset: Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 16,
                      //     vertical: 12,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     gradient: LinearGradient(
                      //       colors: [Color(0XFFF5F9FF), Color(0XFFCDE2F8)],
                      //       begin: Alignment.topCenter,
                      //       end: Alignment.bottomCenter,
                      //       stops: [0.0, 0.5],
                      //     ),
                      //     borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(16),
                      //       topRight: Radius.circular(16),
                      //     ),
                      //   ),
                      //   child: SizedBox(
                      //     height: 14,
                      //     child: Marquee(
                      //       text:
                      //           "${(controller.languageServices.language.value.driverPickUp ?? "-")} · ${formatDoubleToString(double.parse(controller.socketDriverPositionData.value.reservationMileage ?? "0.0"))} ${controller.languageServices.language.value.km} · ${controller.getEstimatedTimeInMinutesWaitingDriverPickUpInText().toLowerCase()}",
                      //       style: controller
                      //           .typographyServices
                      //           .bodySmallBold
                      //           .value,
                      //       blankSpace: 16,
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey0
                                      .value,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 16),
                                    Container(
                                      width: 33,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey300
                                            .value,
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: sc,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 16,
                                          bottom: 16,
                                          right: 16,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller
                                                      .languageServices
                                                      .language
                                                      .value
                                                      .evMotorcycleDriverSearch ??
                                                  "-",
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeBold
                                                  .value,
                                            ),
                                            SizedBox(height: 16),
                                            LinearProgressIndicator(
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                              minHeight: 8,
                                              color: controller
                                                  .themeColorServices
                                                  .primaryBlue
                                                  .value,
                                              backgroundColor: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey200
                                                  .value,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: 46,
                          width: MediaQuery.of(context).size.width,
                          child: TextButton(
                            onPressed: () async {
                              await controller
                                  .onTapOrderRideCancelBeforeDriver();
                            },
                            style: ButtonStyle(
                              overlayColor: WidgetStateProperty.all(
                                controller
                                    .themeColorServices
                                    .sematicColorRed400
                                    .value
                                    .withValues(alpha: 0.1),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            child: Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .cancel ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodyLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed500
                                        .value,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    return SlidingUpPanel(
      minHeight: 120,
      maxHeight: 190,
      padding: EdgeInsets.all(0),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      boxShadow: [
        BoxShadow(
          color: controller.themeColorServices.overlayDark200.value.withValues(
            alpha: 0.3,
          ),
          blurRadius: 32,
          spreadRadius: -6,
          offset: Offset(0, -1),
        ),
      ],
      panel: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: controller.themeColorServices.neutralsColorGrey0.value,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 16),
                Container(
                  width: 33,
                  height: 4,
                  decoration: BoxDecoration(
                    color: controller
                        .themeColorServices
                        .neutralsColorGrey300
                        .value,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, bottom: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller
                          .languageServices
                          .language
                          .value
                          .evMotorcycleDriverSearch ??
                      "-",
                  style: controller.typographyServices.bodyLargeBold.value,
                ),
                SizedBox(height: 16),
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(999),
                  minHeight: 8,
                  color: controller.themeColorServices.primaryBlue.value,
                  backgroundColor:
                      controller.themeColorServices.neutralsColorGrey200.value,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 46,
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: () async {
                  await controller.onTapOrderRideCancelBeforeDriver();
                },
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(
                    controller.themeColorServices.sematicColorRed400.value
                        .withValues(alpha: 0.1),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                child: Text(
                  controller.languageServices.language.value.cancel ?? "-",
                  style: controller.typographyServices.bodyLargeBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .sematicColorRed500
                            .value,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
