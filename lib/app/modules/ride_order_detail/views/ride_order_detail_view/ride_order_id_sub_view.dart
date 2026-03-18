import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';

class RideOrderIdSubView extends GetView<RideOrderDetailController> {
  const RideOrderIdSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: controller.themeColorServices.neutralsColorGrey200.value,
        ),
        borderRadius: BorderRadius.circular(12),
        color: controller.themeColorServices.neutralsColorGrey0.value,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.languageServices.language.value.orderId ?? "-",
            style: controller.typographyServices.bodySmallBold.value.copyWith(
              color: controller.themeColorServices.neutralsColorGrey700.value,
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: controller.themeColorServices.neutralsColorSlate100.value,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Center(
              child: Text(
                controller.orderRideDetail.value.orderId.toString(),
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
        ],
      ),
    );
  }
}
