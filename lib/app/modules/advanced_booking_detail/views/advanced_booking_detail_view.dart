import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_detail/views/advanced_booking_detail_view/activity_detail_invoice_sub_view.dart';
import 'package:new_evmoto_user/app/modules/advanced_booking_detail/views/advanced_booking_detail_view/advanced_booking_detail_map_origin_destination_information_sub_view.dart';
import 'package:new_evmoto_user/app/widgets/global_body_handler.dart';

import '../controllers/advanced_booking_detail_controller.dart';

class AdvancedBookingDetailView
    extends GetView<AdvancedBookingDetailController> {
  const AdvancedBookingDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: controller.isCriticalError.value
              ? null
              : Text(
                  "Detail Jadwal Pemesanan",
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
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0XFFD3D3D3), width: 2),
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0XFFF5F5F5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_calendar_schedule_fill.svg",
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "21 Mei 2026 · 10:05",
                                style: controller
                                    .typographyServices
                                    .bodyLargeBold
                                    .value,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Pesanan akan diproses sesuai jadwal yang telah dipilih. Mohon periksa kembali jadwal pesanan Anda.",
                                style: controller
                                    .typographyServices
                                    .bodySmallRegular
                                    .value
                                    .copyWith(color: Color(0XFFB3B3B3)),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child:
                      AdvancedBookingDetailMapOriginDestinationInformationSubView(),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AdvancedBookingDetailInvoiceSubView(),
                ),
                SizedBox(height: 16),
              ],
            ),
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
                          side: BorderSide(color: Colors.transparent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {},
                        child: Text(
                          controller.languageServices.language.value.cancel ??
                              "-",
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
                  ],
                ),
              ),
      ),
    );
  }
}
