import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/models/coupon_model.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/controllers/create_order_ride_checkout_controller.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';

class CheckoutPaymentAndPromoSubView
    extends GetView<CreateOrderRideCheckoutController> {
  const CheckoutPaymentAndPromoSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.RIDE_CHECKOUT_SELECT_PAYMENT_METHOD);
                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          if (controller.payType.value == 3) ...[
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/icon_cash_1.svg",
                                    width: 20,
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              controller.languageServices.language.value.cash ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallBold
                                  .value,
                            ),
                          ],
                          SizedBox(width: 52),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: SizedBox(
                      height: 14.5,
                      child: VerticalDivider(
                        width: 0,
                        color: Color(0XFFB9B9B9),
                      ),
                    ),
                  ),
                  SizedBox(width: 38),
                  if (controller.availableCouponList.isEmpty) ...[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/icon_discount.svg",
                                width: 16,
                                height: 16,
                                colorFilter: ColorFilter.mode(
                                  Color(0XFFB3B3B3),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 4),
                          Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .noPromoAvailable ??
                                "-",
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
                  if (controller.availableCouponList.isNotEmpty) ...[
                    if (controller.selectedCoupon.value.id == null) ...[
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            var result = await Get.toNamed(
                              Routes.CREATE_ORDER_RIDE_PROMO,
                              arguments: {
                                "selected_coupon":
                                    controller.selectedCoupon.value,
                              },
                            );

                            if (result != null) {
                              controller.selectedCoupon.value = result;
                              try {
                                await controller.getOrderRidePricingList();
                              } on DioException catch (e) {
                                controller.selectedCoupon.value = Coupon();
                                SnackbarHelper.showSnackbarError(
                                  text: e.response?.data,
                                );
                              } catch (e) {
                                SnackbarHelper.showSnackbarError(
                                  text: e.toString(),
                                );
                              }
                            }
                          },
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_discount.svg",
                                      width: 16,
                                      height: 16,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 4),
                                Text(
                                  controller
                                          .languageServices
                                          .language
                                          .value
                                          .selectPromo ??
                                      "-",
                                  style: controller
                                      .typographyServices
                                      .bodySmallBold
                                      .value,
                                ),
                                Spacer(),
                                SizedBox(width: 8),
                                SvgPicture.asset(
                                  "assets/icons/icon_arrow_right.svg",
                                  width: 10.83 * 1.3,
                                  height: 6.25 * 1.3,
                                  colorFilter: ColorFilter.mode(
                                    Color(0XFF2E2E2E),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (controller.selectedCoupon.value.id != null) ...[
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            var result = await Get.toNamed(
                              Routes.CREATE_ORDER_RIDE_PROMO,
                              arguments: {
                                "selected_coupon":
                                    controller.selectedCoupon.value,
                              },
                            );

                            if (result != null) {
                              controller.selectedCoupon.value = result;
                              try {
                                await controller.getOrderRidePricingList();
                              } on DioException catch (e) {
                                controller.selectedCoupon.value = Coupon();
                                SnackbarHelper.showSnackbarError(
                                  text: e.response?.data,
                                );
                              } catch (e) {
                                SnackbarHelper.showSnackbarError(
                                  text: e.toString(),
                                );
                              }
                            }
                          },
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_discount.svg",
                                      width: 16,
                                      height: 16,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0XFFEFF7FF),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Text(
                                    "${controller.languageServices.language.value.discount} ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(controller.selectedCoupon.value.money)}",
                                    style: controller
                                        .typographyServices
                                        .captionLargeRegular
                                        .value
                                        .copyWith(
                                          color: controller
                                              .themeColorServices
                                              .primaryBlue
                                              .value,
                                        ),
                                  ),
                                ),
                                Spacer(),
                                SizedBox(width: 8),
                                SvgPicture.asset(
                                  "assets/icons/icon_arrow_right.svg",
                                  width: 10.83 * 1.3,
                                  height: 6.25 * 1.3,
                                  colorFilter: ColorFilter.mode(
                                    Color(0XFF2E2E2E),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
