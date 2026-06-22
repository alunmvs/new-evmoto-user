import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_pricing_model.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_checkout/controllers/create_order_ride_checkout_controller.dart';
import 'package:shimmer/shimmer.dart';

class CheckoutPriceListSubView
    extends GetView<CreateOrderRideCheckoutController> {
  const CheckoutPriceListSubView({super.key});

  static const _selectionAnimationDuration = Duration(milliseconds: 250);
  static const _imageSizeUnselected = 32.0;
  static const _imageSizeSelected = 52.0;

  bool _isSelected(int? pricingId) =>
      controller.selectedOrderRidePricing.value.id == pricingId;

  double _imageSizeFor(bool isSelected) =>
      isSelected ? _imageSizeSelected : _imageSizeUnselected;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.isFetch.value == true) ...[
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.white,
                child: Container(
                  height: 18 * 3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.white,
                child: Container(
                  height: 18 * 3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
          if (controller.isFetch.value == false) ...[
            for (var orderRidePricing in controller.orderRidePricingList) ...[
              _buildPricingListItem(orderRidePricing),
              Divider(height: 0, color: Color(0XFFE9E9E9)),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildPricingListItem(OrderRidePricing orderRidePricing) {
    final isSelected = _isSelected(orderRidePricing.id);
    final imageSize = _imageSizeFor(isSelected);
    final nameColor = controller.themeColorServices.neutralsColorSlate800.value;

    return GestureDetector(
      onTap: () {
        controller.selectedOrderRidePricing.value = orderRidePricing;
      },
      child: AnimatedContainer(
        duration: _selectionAnimationDuration,
        curve: Curves.easeInOut,
        color: isSelected ? Color(0XFFEDF6FF) : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildPricingImage(imageUrl: orderRidePricing.img, size: imageSize),
            SizedBox(width: 8),
            AnimatedDefaultTextStyle(
              duration: _selectionAnimationDuration,
              curve: Curves.easeInOut,
              style:
                  (isSelected
                          ? controller.typographyServices.bodyLargeBold.value
                          : controller.typographyServices.bodySmallBold.value)
                      .copyWith(color: nameColor),
              child: Text(orderRidePricing.name ?? "-"),
            ),
            SizedBox(width: 4),
            SvgPicture.asset(
              "assets/icons/icon_account.svg",
              width: 12,
              height: 12,
              colorFilter: ColorFilter.mode(
                controller.themeColorServices.neutralsColorGrey400.value,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 4),
            Text(
              "1",
              style: controller.typographyServices.bodySmallRegular.value
                  .copyWith(
                    color: controller
                        .themeColorServices
                        .neutralsColorGrey400
                        .value,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            SizedBox(width: 8),
            if (orderRidePricing.discountMoney != null &&
                orderRidePricing.discountMoney != 0.0) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: controller.themeColorServices.primaryBlue.value,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  controller.languageServices.language.value.promo ?? "-",
                  style: controller.typographyServices.captionSmallBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                      ),
                ),
              ),
            ],
            SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp',
                    decimalDigits: 0,
                  ).format(
                    orderRidePricing.discountMoney == null
                        ? orderRidePricing.amount!
                        : (orderRidePricing.amount! -
                              orderRidePricing.discountMoney!),
                  ),
                  style: controller.typographyServices.bodyLargeBold.value,
                ),
                if (orderRidePricing.discountMoney != null &&
                    orderRidePricing.discountMoney != 0.0) ...[
                  Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ).format(orderRidePricing.amount ?? 0.0),
                    style: controller.typographyServices.captionLargeBold.value
                        .copyWith(
                          color: controller
                              .themeColorServices
                              .neutralsColorGrey400
                              .value,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: controller
                              .themeColorServices
                              .neutralsColorGrey400
                              .value,
                        ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingImage({required String? imageUrl, required double size}) {
    const borderRadius = BorderRadius.all(Radius.circular(9.23));
    const placeholderIconRatio = Size(23.38 / 32, 17.31 / 32);

    return AnimatedContainer(
      duration: _selectionAnimationDuration,
      curve: Curves.easeInOut,
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: imageUrl == null
            ? LinearGradient(
                colors: [Color(0XFFF5F9FF), Color(0XFFCDE2F8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
      ),
      child: imageUrl != null
          ? CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover)
          : Center(
              child: SvgPicture.asset(
                "assets/icons/icon_ride.svg",
                width: size * placeholderIconRatio.width,
                height: size * placeholderIconRatio.height,
              ),
            ),
    );
  }
}
