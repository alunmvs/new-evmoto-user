import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/views/create_order_ride_view/create_order_ride_current_location_sub_view.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/views/create_order_ride_view/create_order_ride_latest_order_location_sub_view.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/views/create_order_ride_view/create_order_ride_searched_location_sub_view.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/views/create_order_ride_view/create_order_ride_text_field_destination_origin_sub_view.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import '../controllers/create_order_ride_controller.dart';

class CreateOrderRideView extends GetView<CreateOrderRideController> {
  const CreateOrderRideView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.back ?? "-",
            selectionColor:
                controller.themeColorServices.neutralsColorGrey600.value,

            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          titleSpacing: 16,
          actions: [
            GestureDetector(
              onTap: () async {
                if (controller.isOriginHasPrimaryFocus.value) {
                  await controller.onTapOriginMapSelect();
                } else {
                  await controller.onTapDestinationMapSelect();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller
                        .themeColorServices
                        .neutralsColorGrey200
                        .value,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/icon_maps.svg",
                      width: 16,
                      height: 16,
                      color: controller.themeColorServices.primaryBlue.value,
                    ),
                    SizedBox(width: 4),
                    Text(
                      controller.languageServices.language.value.selectViaMap ??
                          "-",
                      style: controller
                          .typographyServices
                          .captionLargeRegular
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
              ),
            ),
            SizedBox(width: 16),
          ],
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CreateOrderRideTextFieldDestinationOriginSubView(),
                  ),
                  SizedBox(height: 16),
                  DashedLine(
                    height: 0,
                    dashSpace: 4,
                    dashWidth: 4,
                    color: controller
                        .themeColorServices
                        .neutralsColorGrey200
                        .value,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.isOriginHasPrimaryFocus.value ==
                              true) ...[
                            if (controller.keywordOrigin.value == '' &&
                                controller
                                    .recommendationCurrentLocationList
                                    .isNotEmpty) ...[
                              CreateOrderRideCurrentLocationSubView(),
                            ] else ...[
                              CreateOrderRideSearchedLocationSubView(),
                            ],
                          ],
                          if (controller.isDestinationHasPrimaryFocus.value ==
                              true) ...[
                            if (controller.keywordDestination.value == '' &&
                                controller
                                    .recommendationCurrentLocationList
                                    .isNotEmpty) ...[
                              CreateOrderRideCurrentLocationSubView(),
                            ] else ...[
                              CreateOrderRideSearchedLocationSubView(),
                            ],
                          ],
                          if ((controller.isOriginHasPrimaryFocus.value ==
                                      true &&
                                  controller
                                      .recommendationOriginLocationList
                                      .isNotEmpty) ||
                              (controller.isDestinationHasPrimaryFocus.value ==
                                      true &&
                                  controller
                                      .recommendationDestinationLocationList
                                      .isNotEmpty)) ...[
                            Container(
                              height: 6,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Color(0XFFE8E8E8),
                              ),
                            ),
                            CreateOrderRideLatestOrderLocationSubView(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
