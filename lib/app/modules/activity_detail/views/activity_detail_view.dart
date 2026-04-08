import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/constants/order_state_const.dart';
import 'package:new_evmoto_user/app/modules/activity_detail/views/activity_detail_view/activity_detail_cancel_driver_information_sub_view.dart';
import 'package:new_evmoto_user/app/modules/activity_detail/views/activity_detail_view/activity_detail_cancel_reason_sub_view.dart';
import 'package:new_evmoto_user/app/modules/activity_detail/views/activity_detail_view/activity_detail_driver_information_sub_view.dart';
import 'package:new_evmoto_user/app/modules/activity_detail/views/activity_detail_view/activity_detail_form_rating_review_sub_view.dart';
import 'package:new_evmoto_user/app/modules/activity_detail/views/activity_detail_view/activity_detail_invoice_sub_view.dart';
import 'package:new_evmoto_user/app/modules/activity_detail/views/activity_detail_view/activity_detail_map_origin_destination_information_sub_view.dart';
import 'package:new_evmoto_user/app/modules/activity_detail/views/activity_detail_view/activity_detail_rating_review_sub_view.dart';
import 'package:new_evmoto_user/app/widgets/global_body_handler.dart';
import '../controllers/activity_detail_controller.dart';

class ActivityDetailView extends GetView<ActivityDetailController> {
  const ActivityDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: controller.isCriticalError.value
              ? null
              : Text(
                  controller.isFetch.value
                      ? ""
                      : DateFormat(
                          'dd MMMM yyyy ⬩ HH:mm',
                          controller.languageServices.languageCode.value,
                        ).format(
                          DateTime.parse(
                            controller.orderRideDetail.value.insertTime!
                                .replaceFirst(' ', 'T'),
                          ),
                        ),
                  selectionColor:
                      controller.themeColorServices.neutralsColorGrey600.value,

                  style: controller.typographyServices.bodyLargeBold.value,
                ),
          centerTitle: false,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          surfaceTintColor:
              controller.themeColorServices.neutralsColorGrey0.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: GlobalBodyHandler(
          isFetch: false,
          isCriticalError: controller.isCriticalError.value,
          onInit: () async {
            await controller.onInit();
          },
          body: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        if (OrderState.CANCELLED_STATE_LIST.contains(
                          controller.orderRideDetail.value.state,
                        )) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child:
                                ActivityDetailCancelDriverInformationSubView(),
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ActivityDetailDriverInformationSubView(),
                          ),
                        ],
                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            height: 33,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorSlate100
                                  .value,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                controller.orderRideDetail.value.orderNum
                                    .toString(),
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
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          height: 5.5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey100
                                .value,
                          ),
                        ),
                        if (OrderState.WAITING_RATING_EVALUATION ==
                            controller.orderRideDetail.value.state) ...[
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ActivityDetailFormRatingReviewSubView(),
                          ),
                        ],
                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child:
                              ActivityDetailMapOriginDestinationInformationSubView(),
                        ),
                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ActivityDetailInvoiceSubView(),
                        ),
                        if (controller.orderRideDetail.value.remark != "" &&
                            controller.orderRideDetail.value.remark !=
                                null) ...[
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ActivityDetailCancelReasonSubView(),
                          ),
                        ],
                        if (controller.orderRideDetail.value.orderScore !=
                                null &&
                            controller.orderRideDetail.value.orderScore !=
                                0) ...[
                          SizedBox(height: 12),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: ActivityDetailRatingReviewSubView(),
                          ),
                        ],
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              if (controller.isFetch.value == true) ...[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: controller.themeColorServices.neutralsColorGrey0.value,
                  child: Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        bottomNavigationBar:
            controller.isFetch.value || controller.isCriticalError.value
            ? null
            : BottomAppBar(
                height: 78,
                padding: EdgeInsets.all(16),
                color: controller.themeColorServices.neutralsColorGrey0.value,
                shadowColor: controller.themeColorServices.overlayDark100.value
                    .withValues(alpha: 0.1),
                child: Column(
                  children: [
                    SizedBox(
                      height: 46,
                      width: Get.width,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color:
                                controller.themeColorServices.primaryBlue.value,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          await controller.onTapOrderAgain();
                        },
                        child: Text(
                          controller
                                  .languageServices
                                  .language
                                  .value
                                  .orderAgain ??
                              "-",
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
