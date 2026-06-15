import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/controllers/create_order_ride_checkout_controller.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/views/create_order_ride_checkout_view/checkout_footer_sub_view/checkout_estimated_distance_and_time_sub_view.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/views/create_order_ride_checkout_view/checkout_footer_sub_view/checkout_payment_and_promo_sub_view.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/views/create_order_ride_checkout_view/checkout_footer_sub_view/checkout_price_list_sub_view.dart';
import 'package:new_evmoto_user/app/utils/common_helper.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:new_evmoto_user/main.dart';

class CheckoutFooterSubView extends GetView<CreateOrderRideCheckoutController> {
  const CheckoutFooterSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Positioned(
        bottom: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.isFetch.value == false) ...[
                if (controller.driverNearbyList.isEmpty) ...[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
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
                      ],
                    ),
                  ),
                ],
                if (controller.driverNearbyList.isNotEmpty) ...[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
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
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 16),
              ],
              CheckoutEstimatedDistanceAndTimeSubView(),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: controller.themeColorServices.neutralsColorGrey0.value,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: controller.themeColorServices.overlayDark200.value
                          .withValues(alpha: 0.3),
                      blurRadius: 32,
                      spreadRadius: -6,
                      offset: Offset(0, -1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckoutPriceListSubView(),
                        Container(
                          height: 6,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Color(0XFFE8E8E8)),
                        ),
                        SizedBox(height: 16),
                        CheckoutPaymentAndPromoSubView(),
                        SizedBox(height: 16),
                        DashedLine(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey300
                              .value,
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 46,
                                width: 110,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 12,
                                    ),
                                    side: BorderSide(
                                      color: controller
                                          .themeColorServices
                                          .primaryBlue
                                          .value,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: () async {
                                    var dateRecommendationController =
                                        FixedExtentScrollController(
                                          initialItem: controller
                                              .selectedDateIndex
                                              .value,
                                        );

                                    var timeRecommendationController =
                                        FixedExtentScrollController(
                                          initialItem: controller
                                              .selectedTimeIndex
                                              .value,
                                        );

                                    final timeRecommendationList =
                                        <DateTime>[].obs;

                                    final selectedDate = Rx<DateTime?>(null);
                                    final selectedTime = Rx<DateTime?>(null);

                                    final selectedDateIndex = 0.obs;
                                    final selectedTimeIndex = 0.obs;

                                    selectedDate.value =
                                        controller.selectedDate.value;
                                    selectedDateIndex.value =
                                        controller.selectedDateIndex.value;

                                    timeRecommendationList.value =
                                        await controller
                                            .generateTimeRecommendationList(
                                              selectedDate: selectedDate.value!,
                                            );

                                    selectedTime.value =
                                        controller.selectedTime.value;
                                    selectedTimeIndex.value =
                                        controller.selectedTimeIndex.value;

                                    await Get.bottomSheet(
                                      Obx(
                                        () => ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(16),
                                            topLeft: Radius.circular(16),
                                          ),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: 600,
                                              maxHeight: MediaQuery.of(
                                                navigatorKey.currentContext!,
                                              ).size.height,
                                            ),
                                            child: Material(
                                              color: controller
                                                  .themeColorServices
                                                  .neutralsColorGrey0
                                                  .value,
                                              child: SizedBox(
                                                width: MediaQuery.of(
                                                  context,
                                                ).size.width,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(
                                                        context,
                                                      ).size.width,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 16,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                              colors: [
                                                                Color(
                                                                  0XFFF5F9FF,
                                                                ),
                                                                Color(
                                                                  0XFFCDE2F8,
                                                                ),
                                                              ],
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                              stops: [0.0, 1],
                                                            ),
                                                      ),
                                                      child: Text(
                                                        "Pilih Pesanan Terjadwal",
                                                        style: controller
                                                            .typographyServices
                                                            .bodySmallBold
                                                            .value,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 16,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 7,
                                                            child: SizedBox(
                                                              height: 218,
                                                              width:
                                                                  MediaQuery.of(
                                                                    context,
                                                                  ).size.width,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Expanded(
                                                                    child: ListWheelScrollView.useDelegate(
                                                                      controller:
                                                                          dateRecommendationController,
                                                                      physics:
                                                                          const FixedExtentScrollPhysics(),
                                                                      perspective:
                                                                          0.005,
                                                                      diameterRatio:
                                                                          2.0,
                                                                      itemExtent:
                                                                          32.0 +
                                                                          24.0,
                                                                      onSelectedItemChanged:
                                                                          (
                                                                            int
                                                                            index,
                                                                          ) async {
                                                                            selectedDate.value =
                                                                                controller.dateRecommendationList[index];
                                                                            selectedDateIndex.value =
                                                                                index;

                                                                            timeRecommendationList.value = await controller.generateTimeRecommendationList(
                                                                              selectedDate: selectedDate.value!,
                                                                            );

                                                                            selectedTime.value =
                                                                                timeRecommendationList.first;
                                                                            selectedTimeIndex.value =
                                                                                0;
                                                                            timeRecommendationController.jumpTo(
                                                                              0,
                                                                            );

                                                                            timeRecommendationList.refresh();
                                                                          },

                                                                      childDelegate: ListWheelChildBuilderDelegate(
                                                                        childCount: controller
                                                                            .dateRecommendationList
                                                                            .length,
                                                                        builder:
                                                                            (
                                                                              context,
                                                                              index,
                                                                            ) {
                                                                              return Obx(
                                                                                () => Container(
                                                                                  padding: EdgeInsets.symmetric(
                                                                                    horizontal: 16,
                                                                                    vertical: 12,
                                                                                  ),
                                                                                  decoration:
                                                                                      selectedDate.value ==
                                                                                          controller.dateRecommendationList[index]
                                                                                      ? BoxDecoration(
                                                                                          color: Color(
                                                                                            0XFFF6F6F6,
                                                                                          ),
                                                                                          border: Border.all(
                                                                                            color: controller.themeColorServices.primaryBlue.value,
                                                                                          ),
                                                                                          borderRadius: BorderRadius.circular(
                                                                                            12,
                                                                                          ),
                                                                                        )
                                                                                      : null,
                                                                                  child: Align(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Text(
                                                                                      DateFormat(
                                                                                        'EEEE, dd-MM-yyyy',
                                                                                        'id_ID',
                                                                                      ).format(
                                                                                        controller.dateRecommendationList[index],
                                                                                      ),
                                                                                      style: controller.typographyServices.bodyLargeRegular.value.copyWith(
                                                                                        color:
                                                                                            selectedDate.value ==
                                                                                                controller.dateRecommendationList[index]
                                                                                            ? controller.themeColorServices.primaryBlue.value
                                                                                            : Color(
                                                                                                0XFFB3B3B3,
                                                                                              ),
                                                                                        fontWeight:
                                                                                            selectedDate.value ==
                                                                                                controller.dateRecommendationList[index]
                                                                                            ? FontWeight.w700
                                                                                            : FontWeight.w400,
                                                                                      ),
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 16),
                                                          Expanded(
                                                            flex: 5,
                                                            child: SizedBox(
                                                              height: 218,
                                                              width:
                                                                  MediaQuery.of(
                                                                    context,
                                                                  ).size.width,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Expanded(
                                                                    child: ListWheelScrollView.useDelegate(
                                                                      controller:
                                                                          timeRecommendationController,
                                                                      physics:
                                                                          const FixedExtentScrollPhysics(),
                                                                      perspective:
                                                                          0.005,
                                                                      diameterRatio:
                                                                          2.0,
                                                                      itemExtent:
                                                                          32.0 +
                                                                          24.0,
                                                                      onSelectedItemChanged:
                                                                          (
                                                                            int
                                                                            index,
                                                                          ) {
                                                                            selectedTime.value =
                                                                                timeRecommendationList[index];
                                                                            selectedTimeIndex.value =
                                                                                index;
                                                                          },

                                                                      childDelegate: ListWheelChildBuilderDelegate(
                                                                        childCount:
                                                                            timeRecommendationList.length,
                                                                        builder:
                                                                            (
                                                                              context,
                                                                              index,
                                                                            ) {
                                                                              return Obx(
                                                                                () => Container(
                                                                                  padding: EdgeInsets.symmetric(
                                                                                    horizontal: 16,
                                                                                    vertical: 12,
                                                                                  ),
                                                                                  decoration:
                                                                                      selectedTime.value ==
                                                                                          timeRecommendationList[index]
                                                                                      ? BoxDecoration(
                                                                                          color: Color(
                                                                                            0XFFF6F6F6,
                                                                                          ),
                                                                                          border: Border.all(
                                                                                            color: controller.themeColorServices.primaryBlue.value,
                                                                                          ),
                                                                                          borderRadius: BorderRadius.circular(
                                                                                            12,
                                                                                          ),
                                                                                        )
                                                                                      : null,
                                                                                  child: Align(
                                                                                    alignment: Alignment.center,
                                                                                    child: Text(
                                                                                      DateFormat(
                                                                                        'HH : mm',
                                                                                      ).format(
                                                                                        timeRecommendationList[index],
                                                                                      ),
                                                                                      style: controller.typographyServices.bodyLargeRegular.value.copyWith(
                                                                                        color:
                                                                                            selectedTime.value ==
                                                                                                timeRecommendationList[index]
                                                                                            ? controller.themeColorServices.primaryBlue.value
                                                                                            : Color(
                                                                                                0XFFB3B3B3,
                                                                                              ),
                                                                                        fontWeight:
                                                                                            selectedTime.value ==
                                                                                                timeRecommendationList[index]
                                                                                            ? FontWeight.w700
                                                                                            : FontWeight.w400,
                                                                                      ),
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                        16,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: controller
                                                            .themeColorServices
                                                            .neutralsColorGrey0
                                                            .value,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: controller
                                                                .themeColorServices
                                                                .overlayDark100
                                                                .value
                                                                .withValues(
                                                                  alpha: 0.12,
                                                                ),
                                                            blurRadius: 16,
                                                            spreadRadius: 0,
                                                            offset: Offset(
                                                              0,
                                                              0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            height: 46,
                                                            width: 120,
                                                            child: OutlinedButton(
                                                              style: OutlinedButton.styleFrom(
                                                                side: BorderSide(
                                                                  color: controller
                                                                      .themeColorServices
                                                                      .redColor
                                                                      .value,
                                                                ),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        16,
                                                                      ),
                                                                ),
                                                              ),
                                                              onPressed: () async {
                                                                Get.close(1);
                                                                controller
                                                                        .isAdvanceOrderEnable
                                                                        .value =
                                                                    false;
                                                                controller
                                                                    .selectedDate
                                                                    .value = controller
                                                                    .dateRecommendationList
                                                                    .first;
                                                                controller
                                                                        .selectedDateIndex
                                                                        .value =
                                                                    0;
                                                                controller
                                                                    .timeRecommendationList
                                                                    .value = await controller
                                                                    .generateTimeRecommendationList(
                                                                      selectedDate:
                                                                          selectedDate
                                                                              .value!,
                                                                    );
                                                                controller
                                                                    .selectedTime
                                                                    .value = controller
                                                                    .timeRecommendationList
                                                                    .first;
                                                                controller
                                                                        .selectedTimeIndex
                                                                        .value =
                                                                    0;
                                                              },
                                                              child: Text(
                                                                "Batalkan",
                                                                style: controller
                                                                    .typographyServices
                                                                    .bodyLargeBold
                                                                    .value
                                                                    .copyWith(
                                                                      color: controller
                                                                          .themeColorServices
                                                                          .redColor
                                                                          .value,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 16),
                                                          Expanded(
                                                            child: LoaderElevatedButton(
                                                              onPressed: () async {
                                                                controller
                                                                        .isAdvanceOrderEnable
                                                                        .value =
                                                                    true;
                                                                controller
                                                                        .selectedDate
                                                                        .value =
                                                                    selectedDate
                                                                        .value;
                                                                controller
                                                                        .selectedTime
                                                                        .value =
                                                                    selectedTime
                                                                        .value;
                                                                controller
                                                                        .selectedDateIndex
                                                                        .value =
                                                                    selectedDateIndex
                                                                        .value;
                                                                controller
                                                                        .selectedTimeIndex
                                                                        .value =
                                                                    selectedTimeIndex
                                                                        .value;
                                                                controller
                                                                        .timeRecommendationList
                                                                        .value =
                                                                    timeRecommendationList;

                                                                Get.close(1);
                                                              },
                                                              child: Text(
                                                                "Pilih",
                                                                style: controller
                                                                    .typographyServices
                                                                    .bodyLargeBold
                                                                    .value
                                                                    .copyWith(
                                                                      color: controller
                                                                          .themeColorServices
                                                                          .neutralsColorGrey0
                                                                          .value,
                                                                    ),
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
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (controller
                                              .isAdvanceOrderEnable
                                              .value ==
                                          true) ...[
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/icon_date_advance_order_selected.svg",
                                                width: 15,
                                                height: 16.67,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            controller
                                                        .isAdvanceOrderEnable
                                                        .value ==
                                                    false
                                                ? (controller
                                                          .languageServices
                                                          .language
                                                          .value
                                                          .advanceBookingButton ??
                                                      "-")
                                                : controller
                                                      .getAdvanceBookingSelectedDateTime(),
                                            style: controller
                                                .typographyServices
                                                .bodyLargeBold
                                                .value
                                                .copyWith(
                                                  color: controller
                                                      .themeColorServices
                                                      .primaryBlue
                                                      .value,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                      if (controller
                                              .isAdvanceOrderEnable
                                              .value ==
                                          false) ...[
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              controller
                                                          .isAdvanceOrderEnable
                                                          .value ==
                                                      false
                                                  ? (controller
                                                            .languageServices
                                                            .language
                                                            .value
                                                            .advanceBookingButton ??
                                                        "-")
                                                  : controller
                                                        .getAdvanceBookingSelectedDateTime(),
                                              style: controller
                                                  .typographyServices
                                                  .bodyLargeBold
                                                  .value
                                                  .copyWith(
                                                    color: controller
                                                        .themeColorServices
                                                        .primaryBlue
                                                        .value,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: LoaderElevatedButton(
                                  isShowLoading: false,
                                  onPressed:
                                      controller
                                              .selectedOrderRidePricing
                                              .value
                                              .id ==
                                          null
                                      ? null
                                      : () async {
                                          await controller.onTapSubmit();
                                        },
                                  child: Text(
                                    controller
                                            .languageServices
                                            .language
                                            .value
                                            .orderEvMoto ??
                                        "-",
                                    style: controller
                                        .typographyServices
                                        .bodyLargeBold
                                        .value
                                        .copyWith(color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
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
