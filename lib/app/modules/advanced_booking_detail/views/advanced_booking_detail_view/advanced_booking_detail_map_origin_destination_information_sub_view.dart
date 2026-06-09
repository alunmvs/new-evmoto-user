import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_detail/controllers/advanced_booking_detail_controller.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_detail/views/advanced_booking_detail_view/advanced_booking_detail_driver_information_sub_view.dart';
import 'package:new_evmoto_user/app/utils/general_helper.dart';
import 'package:timelines_plus/timelines_plus.dart';

class AdvancedBookingDetailMapOriginDestinationInformationSubView
    extends GetView<AdvancedBookingDetailController> {
  const AdvancedBookingDetailMapOriginDestinationInformationSubView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 340 / 180,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: controller.initialCameraPosition.value,
                onMapCreated: (GoogleMapController googleMapController) async {
                  controller.googleMapController = googleMapController;
                },
                markers: controller.markers,
                polylines: controller.polylines,
                tiltGesturesEnabled: false,
                zoomGesturesEnabled: false,
                rotateGesturesEnabled: false,
                scrollGesturesEnabled: false,
                zoomControlsEnabled: false,
                cameraTargetBounds: CameraTargetBounds(
                  LatLngBounds(
                    southwest: LatLng(-11.0, 95.0),
                    northeast: LatLng(6.5, 141.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          if (controller.orderRideDetail.value.orderNum != null) ...[
            Container(
              height: 33,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color:
                    controller.themeColorServices.neutralsColorSlate100.value,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  controller.orderRideDetail.value.orderNum.toString(),
                  style: controller.typographyServices.bodySmallRegular.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey700
                            .value,
                      ),
                ),
              ),
            ),
            SizedBox(height: 12),
          ],
          if (controller.orderRideDetail.value.orderId != null &&
              controller.orderRideDetail.value.driverId != null) ...[
            AdvancedBookingDetailDriverInformationSubView(),
            SizedBox(height: 12),
          ],
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: controller.themeColorServices.neutralsColorGrey200.value,
              ),
            ),
            child: Timeline.tileBuilder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              builder: TimelineTileBuilder(
                contentsAlign: ContentsAlign.basic,
                nodePositionBuilder: (context, index) {
                  return 0;
                },
                indicatorPositionBuilder: (context, index) {
                  return 0;
                },
                startConnectorBuilder: (context, index) {
                  if (index != 0) {
                    return DashedLineConnector(
                      color: controller
                          .themeColorServices
                          .neutralsColorSlate400
                          .value,
                    );
                  }
                  return null;
                },
                endConnectorBuilder: (context, index) {
                  if (index != 1) {
                    return DashedLineConnector(
                      color: controller
                          .themeColorServices
                          .neutralsColorSlate400
                          .value,
                    );
                  }
                  return null;
                },
                indicatorBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.5),
                      child: SizedBox(
                        width: 29,
                        height: 29,
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/icons/icon_pinpoint_green.svg",
                            width: 19.94,
                            height: 25.63,
                          ),
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.5),
                    child: SizedBox(
                      width: 29,
                      height: 29,
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/icon_pinpoint_red.svg",
                          width: 19.94,
                          height: 25.63,
                        ),
                      ),
                    ),
                  );
                },
                contentsBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: 4,
                    right: 4,
                    bottom: index != 1 ? 27 : 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0) ...[
                        Row(
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .pickup ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .captionLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey700
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),

                        if (controller.advancedBooking.value.startAddressName !=
                                '' &&
                            controller.advancedBooking.value.startAddressName !=
                                null) ...[
                          Text(
                            controller.advancedBooking.value.startAddressName ??
                                "-",
                            style: controller
                                .typographyServices
                                .bodySmallBold
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey700
                                      .value,
                                ),
                          ),
                        ] else ...[
                          Text(
                            controller.advancedBooking.value.startAddress ??
                                "-",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey700
                                      .value,
                                ),
                          ),
                        ],
                      ],
                      if (index == 1) ...[
                        Row(
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .objective ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .captionLargeBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey700
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        if (controller.advancedBooking.value.endAddressName !=
                                '' &&
                            controller.advancedBooking.value.endAddressName !=
                                null) ...[
                          Text(
                            controller.advancedBooking.value.endAddressName ??
                                "-",
                            style: controller
                                .typographyServices
                                .bodySmallBold
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey700
                                      .value,
                                ),
                          ),
                        ] else ...[
                          Text(
                            controller.advancedBooking.value.endAddress ?? "-",
                            style: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey700
                                      .value,
                                ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                itemCount: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
