import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/activity/views/activity_view/activity_history_order_card_sub_view.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../controllers/activity_controller.dart';

class ActivityView extends GetView<ActivityController> {
  const ActivityView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: controller.themeColorServices.neutralsColorGrey0.value,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(28),
            topLeft: Radius.circular(28),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: controller.isFetch.value
                  ? Center(
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color:
                              controller.themeColorServices.primaryBlue.value,
                        ),
                      ),
                    )
                  : SmartRefresher(
                      header: MaterialClassicHeader(
                        color: controller.themeColorServices.primaryBlue.value,
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
                      enablePullUp: controller.historyOrderSeeMore.value,
                      onRefresh: () async {
                        await controller.refreshAll();
                        controller.historyOrderRefreshController
                            .refreshCompleted();
                      },
                      onLoading: () async {
                        await controller.seeMoreHistoryOrderList();
                        controller.historyOrderRefreshController.loadComplete();
                      },
                      controller: controller.historyOrderRefreshController,
                      child: controller.historyOrderList.isEmpty
                          ? Column(
                              children: [
                                SizedBox(height: 134),
                                SvgPicture.asset(
                                  "assets/images/img_latest_activity_not_found.svg",
                                  height: 120,
                                  width: 120,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Kamu sudah mencoba EVMoto?",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
                                      .value,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Kamu bisa berpergian dengan nyaman, aman dan tentunya gak nambahin polusi di jakarta dong!",
                                  style: controller
                                      .typographyServices
                                      .bodySmallRegular
                                      .value,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                                LoaderElevatedButton(
                                  isWidthFitToContent: true,
                                  onPressed: () async {
                                    await controller.homeController
                                        .onTapRideService(
                                          isFillCurrentLocation: false,
                                        );
                                    await controller.refreshAll();
                                  },
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  borderSide: BorderSide(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorBlue200
                                        .value,
                                    width: 2,
                                  ),
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
                                  ),
                                ),
                              ],
                            )
                          : SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // for (var activeOrder in controller.activeOrderList) ...[
                                    //   ActivityActiveOrderCardSubView(
                                    //     activeOrder: activeOrder,
                                    //   ),
                                    //   DashedLine(
                                    //     height: 0,
                                    //     dashSpace: 8,
                                    //     dashWidth: 8,
                                    //     color: controller
                                    //         .themeColorServices
                                    //         .neutralsColorGrey200
                                    //         .value,
                                    //   ),
                                    // ],
                                    for (var historyOrder
                                        in controller.historyOrderList) ...[
                                      ActivityHistoryOrderCardSubView(
                                        historyOrder: historyOrder,
                                      ),
                                      DashedLine(
                                        height: 0,
                                        dashSpace: 8,
                                        dashWidth: 8,
                                        color: controller
                                            .themeColorServices
                                            .neutralsColorGrey200
                                            .value,
                                      ),
                                    ],
                                  ],
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
