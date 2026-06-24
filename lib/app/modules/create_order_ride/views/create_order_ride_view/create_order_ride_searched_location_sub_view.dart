import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_navigation_point_model.dart';
import 'package:new_evmoto_user/app/data/models/geocoding_place_with_points_model.dart';
import 'package:new_evmoto_user/app/modules/create_order_ride/controllers/create_order_ride_controller.dart';

class CreateOrderRideSearchedLocationSubView
    extends GetView<CreateOrderRideController> {
  const CreateOrderRideSearchedLocationSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          if (controller.isOriginHasPrimaryFocus.value == true) ...[
            for (var location in controller.originGeocodingPlaceList) ...[
              _GeocodingPlaceSearchResultItem(
                location: location,
                onTapPlace: () async {
                  await controller.onTapOriginSearchedLocation(
                    selectedPlace: location,
                  );
                },
                onTapNavigationPoint: (navigationPoint) async {
                  await controller.onTapOriginSearchedLocation(
                    selectedPlace: location,
                    selectedNavigationPoint: navigationPoint,
                  );
                },
              ),
              Divider(
                height: 0,
                color: controller.themeColorServices.neutralsColorGrey200.value,
              ),
            ],
          ] else ...[
            for (var location in controller.destinationGeocodingPlaceList) ...[
              _GeocodingPlaceSearchResultItem(
                location: location,
                onTapPlace: () async {
                  await controller.onTapDestinationSearchedLocation(
                    selectedPlace: location,
                  );
                },
                onTapNavigationPoint: (navigationPoint) async {
                  await controller.onTapDestinationSearchedLocation(
                    selectedPlace: location,
                    selectedNavigationPoint: navigationPoint,
                  );
                },
              ),
              Divider(
                height: 0,
                color: controller.themeColorServices.neutralsColorGrey200.value,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _GeocodingPlaceSearchResultItem extends StatefulWidget {
  const _GeocodingPlaceSearchResultItem({
    required this.location,
    required this.onTapPlace,
    required this.onTapNavigationPoint,
  });

  final GeocodingPlaceWithPoints location;
  final Future<void> Function() onTapPlace;
  final Future<void> Function(GeocodingNavigationPoint navigationPoint)
  onTapNavigationPoint;

  @override
  State<_GeocodingPlaceSearchResultItem> createState() =>
      _GeocodingPlaceSearchResultItemState();
}

class _GeocodingPlaceSearchResultItemState
    extends State<_GeocodingPlaceSearchResultItem> {
  static const _initialNavigationPointsVisible = 3;

  bool _isExpanded = false;

  CreateOrderRideController get controller => Get.find();

  List<GeocodingNavigationPoint> get _navigationPoints =>
      widget.location.pointRecommendation?.navigationPoints ?? [];

  String _formatDistanceKm(double? distanceMeters) {
    if (distanceMeters == null) {
      return '';
    }

    return '${(distanceMeters / 1000).toStringAsFixed(1)}${controller.languageServices.language.value.km}';
  }

  String? _navigationPointDistance(GeocodingNavigationPoint navigationPoint) {
    if (navigationPoint.customDistanceM == null) {
      return null;
    }

    return _formatDistanceKm(navigationPoint.customDistanceM);
  }

  @override
  Widget build(BuildContext context) {
    final navigationPoints = _navigationPoints;
    final hiddenNavigationPointsCount =
        navigationPoints.length > _initialNavigationPointsVisible
        ? navigationPoints.length - _initialNavigationPointsVisible
        : 0;
    final visibleNavigationPoints = _isExpanded
        ? navigationPoints
        : navigationPoints.take(_initialNavigationPointsVisible).toList();
    final subAddress =
        widget.location.pointRecommendation?.address ??
        widget.location.address ??
        '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.onTapPlace,
          child: Container(
            padding: const EdgeInsets.only(
              top: 14,
              left: 16,
              right: 16,
              bottom: 8,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MainLocationIcon(
                  distanceLabel: widget.location.customDistanceM != null
                      ? _formatDistanceKm(widget.location.customDistanceM)
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.location.name == "" ||
                                widget.location.name == null
                            ? "-"
                            : widget.location.name!,
                        style: controller.typographyServices.bodySmallBold.value
                            .copyWith(
                              color: controller
                                  .themeColorServices
                                  .sematicColorBlue600
                                  .value,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.location.address ?? "-",
                        style: controller
                            .typographyServices
                            .captionLargeRegular
                            .value
                            .copyWith(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey500
                                  .value,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        for (
          var index = 0;
          index < visibleNavigationPoints.length;
          index++
        ) ...[
          GestureDetector(
            onTap: () =>
                widget.onTapNavigationPoint(visibleNavigationPoints[index]),
            child: Container(
              padding: EdgeInsets.only(
                top: 8,
                left: 40,
                right: 16,
                bottom:
                    index == visibleNavigationPoints.length - 1 &&
                        (hiddenNavigationPointsCount == 0 || _isExpanded)
                    ? 16
                    : 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SubLocationIcon(
                    distanceLabel: _navigationPointDistance(
                      visibleNavigationPoints[index],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          visibleNavigationPoints[index].name == "" ||
                                  visibleNavigationPoints[index].name == null
                              ? "-"
                              : visibleNavigationPoints[index].name!,
                          style: controller
                              .typographyServices
                              .bodySmallBold
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey700
                                    .value,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subAddress,
                          style: controller
                              .typographyServices
                              .captionLargeRegular
                              .value
                              .copyWith(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey500
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
          ),
        ],
        if (hiddenNavigationPointsCount > 0 && !_isExpanded) ...[
          GestureDetector(
            onTap: () => setState(() => _isExpanded = true),
            child: Container(
              padding: const EdgeInsets.only(
                top: 4,
                left: 40,
                right: 16,
                bottom: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Lihat lainnya ($hiddenNavigationPointsCount)',
                      style: controller
                          .typographyServices
                          .captionLargeRegular
                          .value
                          .copyWith(
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey500
                                .value,
                          ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: controller
                        .themeColorServices
                        .neutralsColorGrey500
                        .value,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _MainLocationIcon extends GetView<CreateOrderRideController> {
  const _MainLocationIcon({this.distanceLabel});

  final String? distanceLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: controller.themeColorServices.sematicColorBlue100.value,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/icon_pinpoint_primary_blue.svg',
              width: 11,
              height: 14.14,
            ),
          ),
        ),
        if (distanceLabel != null && distanceLabel!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            distanceLabel!,
            style: controller.typographyServices.captionSmallRegular.value
                .copyWith(
                  color:
                      controller.themeColorServices.neutralsColorGrey500.value,
                ),
          ),
        ],
      ],
    );
  }
}

class _SubLocationIcon extends GetView<CreateOrderRideController> {
  const _SubLocationIcon({this.distanceLabel});

  final String? distanceLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/icon_pinpoint_primary_blue.svg',
              width: 9,
              height: 11.5,
            ),
          ),
        ),
        if (distanceLabel != null && distanceLabel!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            distanceLabel!,
            style: controller.typographyServices.captionSmallRegular.value
                .copyWith(
                  color:
                      controller.themeColorServices.neutralsColorGrey500.value,
                ),
          ),
        ],
      ],
    );
  }
}
