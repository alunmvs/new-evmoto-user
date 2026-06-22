import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride_recommendation_pickup_location/controllers/create_order_ride_recommendation_pickup_location_controller.dart';
import 'package:new_evmoto_user/app/utils/common_helper.dart';
import 'package:new_evmoto_user/app/widgets/dashed_line.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';

class RecommendationPickupLocationFooterSubView extends StatefulWidget {
  const RecommendationPickupLocationFooterSubView({super.key});

  @override
  State<RecommendationPickupLocationFooterSubView> createState() =>
      _RecommendationPickupLocationFooterSubViewState();
}

class _RecommendationPickupLocationFooterSubViewState
    extends State<RecommendationPickupLocationFooterSubView> {
  final controller =
      Get.find<CreateOrderRideRecommendationPickupLocationController>();
  final noteTextEditingController = TextEditingController();
  int selectedLocationIndex = 1;

  static const _pickupLocations = [
    (
      name: 'ECGO EV Moto Wijaya',
      address: 'Jl. Wijaya I No.67, RT.6/RW.4, Petogogan, Kec. Kby...',
    ),
    (
      name: 'Wisma PMI',
      address: 'Jl. Wijaya I No.63, RT.8/RW.1, Petogogan, Kec. Kby...',
    ),
    (
      name: 'Kantor Pos Petogogan',
      address: 'Jl. Wijaya II No.12, Petogogan, Kec. Kby. Baru...',
    ),
    (
      name: 'Toko Kelontong Sejahtera',
      address: 'Jl. Wijaya I No.45, RT.3/RW.2, Petogogan, Kec. Kby...',
    ),
    (
      name: 'Masjid Al-Ikhlas',
      address: 'Jl. Wijaya III No.8, Petogogan, Kec. Kby. Baru...',
    ),
  ];

  @override
  void dispose() {
    noteTextEditingController.dispose();
    super.dispose();
  }

  Widget _buildPickupLocationItem(int index) {
    final location = _pickupLocations[index];
    final isSelected = selectedLocationIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLocationIndex = index;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0XFFF2F8FF)
              : controller.themeColorServices.neutralsColorGrey0.value,
          border: Border.all(
            color: controller.themeColorServices.primaryBlue.value,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/icon_pinpoint_green.svg',
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name,
                    style: controller.typographyServices.bodySmallBold.value
                        .copyWith(
                          color: controller
                              .themeColorServices
                              .neutralsColorSlate800
                              .value,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Text(
                    location.address,
                    style: controller
                        .typographyServices
                        .captionLargeRegular
                        .value
                        .copyWith(
                          color: controller
                              .themeColorServices
                              .neutralsColorSlate800
                              .value,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
                                offset: Offset(0, -1),
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
              if (controller.isFetch.value == false) ...[
                SizedBox(height: 8),
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
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: controller.themeColorServices.neutralsColorGrey0.value,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
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
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .pickupLocation ??
                                'Lokasi Penjemputan',
                            style: controller
                                .typographyServices
                                .bodyLargeBold
                                .value,
                          ),
                          GestureDetector(
                            onTap: () {},
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
                                  SizedBox(width: 6),
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
                    SizedBox(height: 12),
                    SizedBox(
                      height: 150,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _pickupLocations.length,
                        separatorBuilder: (_, __) => SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          return _buildPickupLocationItem(index);
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: noteTextEditingController,
                        style: controller
                            .typographyServices
                            .bodySmallRegular
                            .value,
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
                          contentPadding: EdgeInsets.symmetric(
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
                      child: LoaderElevatedButton(
                        isShowLoading: false,
                        buttonColor:
                            controller.themeColorServices.primaryBlue.value,
                        onPressed: () async {},
                        child: Text(
                          'Pilih Lokasi',
                          style: controller
                              .typographyServices
                              .bodyLargeBold
                              .value
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
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
