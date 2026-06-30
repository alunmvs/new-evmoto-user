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
                        CheckoutPaymentAndPromoSubView(),
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

                                    var timeHourRecommendationController =
                                        FixedExtentScrollController(
                                          initialItem: controller
                                              .selectedTimeHourIndex
                                              .value,
                                        );
                                    var timeMinuteRecommendationController =
                                        FixedExtentScrollController(
                                          initialItem: controller
                                              .selectedTimeMinuteIndex
                                              .value,
                                        );

                                    final timeHourRecommendationList =
                                        <String>[].obs;
                                    final timeMinuteRecommendationList =
                                        <String>[].obs;

                                    final selectedDate = Rx<DateTime?>(null);
                                    final selectedTimeHour = Rx<String?>(null);
                                    final selectedTimeMinute = Rx<String?>(
                                      null,
                                    );

                                    final selectedDateIndex = 0.obs;
                                    final selectedTimeHourIndex = 0.obs;
                                    final selectedTimeMinuteIndex = 0.obs;

                                    selectedDate.value =
                                        controller.selectedDate.value;
                                    selectedDateIndex.value =
                                        controller.selectedDateIndex.value;

                                    timeHourRecommendationList.value =
                                        await controller
                                            .generateTimeHourRecommendationList(
                                              selectedDate: selectedDate.value!,
                                            );

                                    selectedTimeHour.value =
                                        controller.selectedTimeHour.value ??
                                        timeHourRecommendationList.first;
                                    selectedTimeHourIndex.value =
                                        controller.selectedTimeHourIndex.value;

                                    timeMinuteRecommendationList.value =
                                        await controller
                                            .generateTimeMinuteRecommendationList(
                                              selectedDate: selectedDate.value!,
                                              selectedHour:
                                                  selectedTimeHour.value!,
                                            );

                                    selectedTimeMinute.value =
                                        controller.selectedTimeMinute.value;
                                    if (!timeMinuteRecommendationList.contains(
                                      selectedTimeMinute.value,
                                    )) {
                                      selectedTimeMinute.value =
                                          timeMinuteRecommendationList.first;
                                      selectedTimeMinuteIndex.value = 0;
                                    } else {
                                      selectedTimeMinuteIndex.value =
                                          timeMinuteRecommendationList.indexOf(
                                            selectedTimeMinute.value!,
                                          );
                                    }

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

                                                                            // old
                                                                            // timeRecommendationList.value = await controller.generateTimeRecommendationList(
                                                                            //   selectedDate: selectedDate.value!,
                                                                            // );
                                                                            // selectedTime.value =
                                                                            //     timeRecommendationList.first;
                                                                            // selectedTimeIndex.value =
                                                                            //     0;
                                                                            // timeRecommendationController.jumpTo(
                                                                            //   0,
                                                                            // );

                                                                            // timeRecommendationList.refresh();

                                                                            // new
                                                                            timeHourRecommendationList.value = await controller.generateTimeHourRecommendationList(
                                                                              selectedDate: selectedDate.value!,
                                                                            );

                                                                            selectedTimeHour.value =
                                                                                timeHourRecommendationList.first;
                                                                            selectedTimeHourIndex.value =
                                                                                0;
                                                                            timeHourRecommendationController.jumpTo(
                                                                              0,
                                                                            );
                                                                            timeHourRecommendationList.refresh();

                                                                            timeMinuteRecommendationList.value =
                                                                                await controller.generateTimeMinuteRecommendationList(
                                                                                  selectedDate: selectedDate.value!,
                                                                                  selectedHour: selectedTimeHour.value!,
                                                                                );

                                                                            selectedTimeMinute.value =
                                                                                timeMinuteRecommendationList.first;
                                                                            selectedTimeMinuteIndex.value =
                                                                                0;
                                                                            timeMinuteRecommendationController.jumpTo(
                                                                              0,
                                                                            );
                                                                            timeMinuteRecommendationList.refresh();
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
                                                            flex: 2,
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
                                                                          timeHourRecommendationController,
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
                                                                            selectedTimeHour.value =
                                                                                timeHourRecommendationList[index];
                                                                            selectedTimeHourIndex.value =
                                                                                index;

                                                                            timeMinuteRecommendationList.value =
                                                                                await controller.generateTimeMinuteRecommendationList(
                                                                                  selectedDate: selectedDate.value!,
                                                                                  selectedHour: timeHourRecommendationList[index],
                                                                                );

                                                                            if (!timeMinuteRecommendationList.contains(
                                                                              selectedTimeMinute.value,
                                                                            )) {
                                                                              selectedTimeMinute.value =
                                                                                  timeMinuteRecommendationList.first;
                                                                              selectedTimeMinuteIndex.value =
                                                                                  0;
                                                                              timeMinuteRecommendationController.jumpToItem(
                                                                                0,
                                                                              );
                                                                            } else {
                                                                              selectedTimeMinuteIndex.value =
                                                                                  timeMinuteRecommendationList.indexOf(
                                                                                    selectedTimeMinute.value!,
                                                                                  );
                                                                              timeMinuteRecommendationController.jumpToItem(
                                                                                selectedTimeMinuteIndex.value,
                                                                              );
                                                                            }
                                                                            timeMinuteRecommendationList.refresh();
                                                                          },

                                                                      childDelegate: ListWheelChildBuilderDelegate(
                                                                        childCount:
                                                                            timeHourRecommendationList.length,
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
                                                                                      selectedTimeHour.value ==
                                                                                          timeHourRecommendationList[index]
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
                                                                                      timeHourRecommendationList[index],
                                                                                      style: controller.typographyServices.bodyLargeRegular.value.copyWith(
                                                                                        color:
                                                                                            selectedTimeHour.value ==
                                                                                                timeHourRecommendationList[index]
                                                                                            ? controller.themeColorServices.primaryBlue.value
                                                                                            : Color(
                                                                                                0XFFB3B3B3,
                                                                                              ),
                                                                                        fontWeight:
                                                                                            selectedTimeHour.value ==
                                                                                                timeHourRecommendationList[index]
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
                                                            flex: 2,
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
                                                                          timeMinuteRecommendationController,
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
                                                                            selectedTimeMinute.value =
                                                                                timeMinuteRecommendationList[index];
                                                                            selectedTimeMinuteIndex.value =
                                                                                index;
                                                                          },
                                                                      childDelegate: ListWheelChildBuilderDelegate(
                                                                        childCount:
                                                                            timeMinuteRecommendationList.length,
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
                                                                                      selectedTimeMinute.value ==
                                                                                          timeMinuteRecommendationList[index]
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
                                                                                      timeMinuteRecommendationList[index],
                                                                                      style: controller.typographyServices.bodyLargeRegular.value.copyWith(
                                                                                        color:
                                                                                            selectedTimeMinute.value ==
                                                                                                timeMinuteRecommendationList[index]
                                                                                            ? controller.themeColorServices.primaryBlue.value
                                                                                            : Color(
                                                                                                0XFFB3B3B3,
                                                                                              ),
                                                                                        fontWeight:
                                                                                            selectedTimeMinute.value ==
                                                                                                timeMinuteRecommendationList[index]
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
                                                                    .timeHourRecommendationList
                                                                    .value = await controller
                                                                    .generateTimeHourRecommendationList(
                                                                      selectedDate:
                                                                          controller
                                                                              .dateRecommendationList
                                                                              .first,
                                                                    );
                                                                controller
                                                                    .selectedTimeHour
                                                                    .value = controller
                                                                    .timeHourRecommendationList
                                                                    .first;
                                                                controller
                                                                        .timeMinuteRecommendationList
                                                                        .value =
                                                                    await controller
                                                                        .generateTimeMinuteRecommendationList(
                                                                          selectedDate: controller
                                                                              .dateRecommendationList
                                                                              .first,
                                                                          selectedHour: controller
                                                                              .selectedTimeHour
                                                                              .value!,
                                                                        );
                                                                controller
                                                                    .selectedTimeMinute
                                                                    .value = controller
                                                                    .timeMinuteRecommendationList
                                                                    .first;
                                                                controller
                                                                        .selectedTimeHourIndex
                                                                        .value =
                                                                    0;
                                                                controller
                                                                        .selectedTimeMinuteIndex
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
                                                                // new
                                                                controller
                                                                        .selectedTimeHour
                                                                        .value =
                                                                    selectedTimeHour
                                                                        .value;
                                                                controller
                                                                        .selectedTimeMinute
                                                                        .value =
                                                                    selectedTimeMinute
                                                                        .value;
                                                                controller
                                                                        .selectedDateIndex
                                                                        .value =
                                                                    selectedDateIndex
                                                                        .value;
                                                                // new
                                                                controller
                                                                        .selectedTimeHourIndex
                                                                        .value =
                                                                    selectedTimeHourIndex
                                                                        .value;
                                                                controller
                                                                        .selectedTimeMinuteIndex
                                                                        .value =
                                                                    selectedTimeMinuteIndex
                                                                        .value;

                                                                controller
                                                                        .timeHourRecommendationList
                                                                        .value =
                                                                    timeHourRecommendationList;
                                                                controller
                                                                        .timeMinuteRecommendationList
                                                                        .value =
                                                                    timeMinuteRecommendationList;

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
