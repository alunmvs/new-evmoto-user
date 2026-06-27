import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_map_select/controllers/create_order_ride_map_select_controller.dart';
import 'package:new_evmoto_user/app/utils/common_helper.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:shimmer/shimmer.dart';

// Height of each recommendation card item (including inter-item gap).
const double _kItemExtent = 88.0;

// Visible height of the ListWheelScrollView area: shows 2.5 items so the
// partial third item hints that the list is scrollable.
const double _kVisibleHeight = _kItemExtent * 2.5;

// Internal height of the LWSV widget. Must be large enough so its vertical
// center (lwsvH / 2) can be shifted to the top of the visible area.
const double _kLwsvHeight = _kItemExtent * 4.0;

// Upward shift applied via Positioned(top:) so the LWSV's center aligns
// with the top of the first item in the visible area.
//   center of LWSV  = _kLwsvHeight / 2  = 2 * itemH
//   desired center position in visible area = 0.5 * itemH (top of first item)
//   offset = -(center - desired) = -(2*itemH - 0.5*itemH) = -1.5*itemH
const double _kOffsetY = -(_kLwsvHeight / 2 - _kItemExtent / 2);

class MapSelectFooterSubView
    extends GetView<CreateOrderRideMapSelectController> {
  MapSelectFooterSubView({super.key});
  final recommendationLocationController = FixedExtentScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Positioned(
        bottom: 0,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Current location button
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await controller
                              .moveGoogleMapCameraToCurrentLocation();
                        },
                        child: Container(
                          width: 41,
                          height: 41,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(99999999),
                            boxShadow: [
                              BoxShadow(
                                color: controller
                                    .themeColorServices
                                    .overlayDark200
                                    .value
                                    .withValues(alpha: 0.12),
                                blurRadius: 16,
                                spreadRadius: 2,
                                offset: const Offset(0, -1),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/icon_current_location.svg",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Driver nearby status badge
              if (controller.type.value == "origin") ...[
                if (controller.isFetch.value == false) ...[
                  const SizedBox(height: 8),
                  if (controller.driverNearbyList.isEmpty)
                    _DriverNearbyBadge(controller: controller, isEmpty: true),
                  if (controller.driverNearbyList.isNotEmpty)
                    _DriverNearbyBadge(controller: controller, isEmpty: false),
                  const SizedBox(height: 16),
                ],
              ],

              if (controller.type.value == "destination") ...[
                const SizedBox(height: 16),
              ],

              // Main card panel
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: controller.themeColorServices.neutralsColorGrey0.value,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: controller.themeColorServices.overlayDark200.value
                          .withValues(alpha: 0.3),
                      blurRadius: 32,
                      spreadRadius: -6,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Header row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Pilih Lokasi",
                            style: controller
                                .typographyServices
                                .bodyLargeBold
                                .value,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey0
                                  .value,
                              child: Row(
                                children: [
                                  Text(
                                    controller
                                            .languageServices
                                            .language
                                            .value
                                            .changeLocation ??
                                        'Ubah Lokasi',
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value
                                        .copyWith(
                                          color: controller
                                              .themeColorServices
                                              .primaryBlue
                                              .value,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  const SizedBox(width: 6),
                                  SvgPicture.asset(
                                    'assets/icons/icon_edit.svg',
                                    width: 12,
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Recommendation location wheel (top-selected)
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: _kVisibleHeight,
                      child: controller.isFetchAddress.value == true
                          ? _RecommendationLocationShimmer(
                              controller: controller,
                            )
                          : Stack(
                              clipBehavior: Clip.hardEdge,
                              children: [
                                if (controller.isFetchAddress.value == false)
                                  Positioned(
                                    top: _kOffsetY,
                                    left: 0,
                                    right: 0,
                                    height: _kLwsvHeight,
                                    child:
                                        controller
                                            .recommendationLocationList
                                            .isEmpty
                                        ? const SizedBox.shrink()
                                        : ListWheelScrollView.useDelegate(
                                            controller:
                                                recommendationLocationController,
                                            physics:
                                                const FixedExtentScrollPhysics(),
                                            // Near-zero perspective → flat card appearance
                                            perspective: 0.001,
                                            diameterRatio: 99999.0,
                                            itemExtent: _kItemExtent,
                                            onSelectedItemChanged: (int index) {
                                              controller
                                                      .selectedIndexRecommendationLocation
                                                      .value =
                                                  index;
                                              controller
                                                  .moveGoogleMapCameraToRecommendationLocation(
                                                    index,
                                                  );
                                            },
                                            childDelegate: ListWheelChildBuilderDelegate(
                                              childCount: controller
                                                  .recommendationLocationList
                                                  .length,
                                              builder: (context, index) {
                                                final loc = controller
                                                    .recommendationLocationList[index];
                                                final name =
                                                    loc.name ??
                                                    loc
                                                        .pointRecommendation
                                                        ?.name ??
                                                    '-';
                                                final address =
                                                    loc.address ??
                                                    loc
                                                        .pointRecommendation
                                                        ?.address ??
                                                    '-';

                                                return Obx(() {
                                                  final isSelected =
                                                      controller
                                                          .selectedIndexRecommendationLocation
                                                          .value ==
                                                      index;

                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 4,
                                                        ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 10,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: isSelected
                                                          ? const Color(
                                                              0xFFF2F8FF,
                                                            )
                                                          : Colors.white,
                                                      border: Border.all(
                                                        color: isSelected
                                                            ? controller
                                                                  .themeColorServices
                                                                  .primaryBlue
                                                                  .value
                                                            : controller
                                                                  .themeColorServices
                                                                  .neutralsColorGrey300
                                                                  .value,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/icons/icon_pinpoint_green.svg',
                                                          width: 20,
                                                          height: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                name,
                                                                style: controller
                                                                    .typographyServices
                                                                    .bodySmallBold
                                                                    .value
                                                                    .copyWith(
                                                                      color:
                                                                          isSelected
                                                                          ? controller.themeColorServices.neutralsColorSlate800.value
                                                                          : controller.themeColorServices.neutralsColorGrey400.value,
                                                                    ),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              const SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                address,
                                                                style: controller
                                                                    .typographyServices
                                                                    .captionLargeRegular
                                                                    .value
                                                                    .copyWith(
                                                                      color:
                                                                          isSelected
                                                                          ? controller.themeColorServices.neutralsColorGrey500.value
                                                                          : controller.themeColorServices.neutralsColorGrey300.value,
                                                                    ),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                              },
                                            ),
                                          ),
                                  ),
                              ],
                            ),
                    ),
                    // Additional note field
                    if (controller.type.value == "origin") ...[
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: controller.noteTextEditingController,
                          style: controller
                              .typographyServices
                              .bodySmallRegular
                              .value,
                          onChanged: (value) {
                            controller.pickupNote.value = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Catatan tambahan (opsional)',
                            hintStyle: controller
                                .typographyServices
                                .bodySmallRegular
                                .value
                                .copyWith(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey400
                                      .value,
                                ),
                            filled: true,
                            fillColor: controller
                                .themeColorServices
                                .neutralsColorGrey100
                                .value,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey300
                                    .value,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: controller
                                    .themeColorServices
                                    .primaryBlue
                                    .value,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    DashedLine(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey300
                          .value,
                    ),
                    const SizedBox(height: 16),

                    // Confirm button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LoaderElevatedButton(
                        isShowLoading: false,
                        buttonColor:
                            controller.themeColorServices.primaryBlue.value,
                        onPressed: controller.isFetchAddress.value == true
                            ? null
                            : () async {
                                controller.onTapSubmit();
                              },
                        child: Text(
                          controller.title.value ?? 'Pilih Lokasi',
                          style: controller
                              .typographyServices
                              .bodyLargeBold
                              .value
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
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

class _RecommendationLocationShimmer extends StatelessWidget {
  const _RecommendationLocationShimmer({required this.controller});

  final CreateOrderRideMapSelectController controller;

  static const _addressWidths = [0.72, 0.55, 0.38];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final greyBorder = controller.themeColorServices.neutralsColorGrey300.value;
    final primaryBlue = controller.themeColorServices.primaryBlue.value;

    return SizedBox(
      height: _kVisibleHeight,
      child: ClipRect(
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.white,
          child: Column(
            children: List.generate(3, (i) {
              final isSelected = i == 0;
              final addressWidth = (screenWidth - 72) * _addressWidths[i];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                height: _kItemExtent - 8,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF2F8FF) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? primaryBlue : greyBorder,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 13,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 11,
                            width: addressWidth,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _DriverNearbyBadge extends GetView<CreateOrderRideMapSelectController> {
  const _DriverNearbyBadge({required this.controller, required this.isEmpty});

  @override
  final CreateOrderRideMapSelectController controller;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isEmpty
                    ? const Color(0xFFFFF7ED)
                    : const Color(0xFFF2F8FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isEmpty
                      ? const Color(0xFFA65226)
                      : const Color(0xFF0060C6),
                ),
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
                          isEmpty
                              ? "assets/icons/icon_alert_circle_driver_nearby_empty.svg"
                              : "assets/icons/icon_pinpoint_primary_blue.svg",
                          width: isEmpty ? 13.33 : 9.33,
                          height: isEmpty ? 13.33 : 11.67,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  RichText(
                    text: TextSpan(
                      text: isEmpty
                          ? (controller
                                    .languageServices
                                    .language
                                    .value
                                    .nearestDriverNotAvailable ??
                                "-")
                          : (controller
                                    .languageServices
                                    .language
                                    .value
                                    .nearestDriverAvailable1 ??
                                "-"),
                      style: controller.typographyServices.bodySmallBold.value
                          .copyWith(
                            color: isEmpty
                                ? const Color(0xFFA65226)
                                : const Color(0xFF0060C6),
                          ),
                      children: isEmpty
                          ? []
                          : [
                              TextSpan(
                                text: formatDistanceNearestDriver(
                                  controller.nearestDistanceDriverNearby.value,
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
                                    .copyWith(color: const Color(0xFF0060C6)),
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
    );
  }
}
