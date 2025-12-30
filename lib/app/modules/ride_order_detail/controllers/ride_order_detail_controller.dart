import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_evmoto_user/app/data/models/evmoto_order_chat_participants_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_server_model.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/repositories/google_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/bitmap_descriptor_helper.dart';
import 'package:new_evmoto_user/app/utils/google_maps_helper.dart';
import 'package:new_evmoto_user/main.dart';

class RideOrderDetailController extends GetxController
    with WidgetsBindingObserver {
  final GoogleMapsRepository googleMapsRepository;
  final OrderRideRepository orderRideRepository;

  RideOrderDetailController({
    required this.googleMapsRepository,
    required this.orderRideRepository,
  });

  final homeController = Get.find<HomeController>();

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final initialCameraPosition = CameraPosition(
    target: LatLng(-6.1744651, 106.822745),
    zoom: 14,
  ).obs;
  late GoogleMapController googleMapController;

  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;
  final polylinesCoordinate = <LatLng>[].obs;

  final driverLatitude = "".obs;
  final driverLongitude = "".obs;

  final currentLatitude = "".obs;
  final currentLongitude = "".obs;

  final orderRideDetail = OrderRide().obs;
  final orderRideServerDetail = OrderRideServer().obs;
  final orderId = "".obs;
  final orderType = 0.obs;

  late Timer? driverCurrentLocationTimer;
  late Timer? refocusMapBoundsTimer;
  late Timer? refreshStatusDriverGivePriceTimer;

  final isPinLocationWaitingForDriverHide = true.obs;
  final isSchedulerDriverCurrentLocationIsProcess = false.obs;

  final estimatedTimeInMinutes = 0.0.obs;
  final estimatedDistanceInKm = 0.0.obs;
  final estimatedSpeedInKmh = 40.obs;

  final payType = 3.obs;

  final evmotoOrderChatParticipants = EvmotoOrderChatParticipants().obs;

  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    orderId.value = Get.arguments['order_id'] ?? "";
    orderType.value = Get.arguments['order_type'] ?? 1;

    await Future.wait([getOrderRideDetail(), getOrderRideServerDetail()]);
    await joinFirestoreChatRooms();
    WidgetsBinding.instance.addObserver(this);
    isFetch.value = false;
    await Future.delayed(Duration(seconds: 1));

    if (orderRideDetail.value.state == 1) {
      await setupMapWaitingForDriver();
    }
    if (orderRideDetail.value.state == 2) {
      // Driver Grab / Accepted
      await setupGoogleMapsPickUpCustomer();
    }
    if (orderRideDetail.value.state == 3) {
      // Driver On Going Origin
      await setupGoogleMapsPickUpCustomer();
    }

    if (orderRideDetail.value.state == 4) {
      // Driver Arrived on Origin
      await setupGoogleMapOriginToDestination();
    }

    if (orderRideDetail.value.state == 5) {
      // Driver On Going Destination
      await setupGoogleMapOriginToDestination();
    }

    if (orderRideDetail.value.state == 6) {
      // Driver Arrived on Destination
      await setupGoogleMapOriginToDestination();
    }

    if (orderRideDetail.value.state == 7) {
      // Driver Give Price
      await setupGoogleMapOriginToDestination();
    }

    await Future.wait([
      setupSchedulerDriverCurrentLocation(),
      setupSchedulerDriverRefocusMapBound(),
      setupRefreshStatusDriverGivePrice(),
    ]);

    generateEstimatedDistanceAndTimeInMinutes();

    if (orderRideDetail.value.state == 7) {
      // Driver Give Price
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAndToNamed(
          Routes.RIDE_ORDER_DONE,
          arguments: {"order_id": orderId.value, "order_type": orderType.value},
        );
      });
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    try {
      googleMapController.dispose();
    } catch (e) {}
    try {
      driverCurrentLocationTimer?.cancel();
    } catch (e) {}
    try {
      refocusMapBoundsTimer?.cancel();
    } catch (e) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await FirebaseFirestore.instance
          .collection('evmoto_order_chat_participants')
          .doc(orderRideDetail.value.orderId.toString())
          .set({
            "userId": orderRideDetail.value.userId,
            "userName": homeController.userInfo.value.name,
            "userIsOnline": true,
            "userLastSeen": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } else if (state == AppLifecycleState.paused) {
      await FirebaseFirestore.instance
          .collection('evmoto_order_chat_participants')
          .doc(orderRideDetail.value.orderId.toString())
          .set({
            "userId": orderRideDetail.value.userId,
            "userName": homeController.userInfo.value.name,
            "userIsOnline": false,
            "userLastSeen": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    }
  }

  Future<void> joinFirestoreChatRooms() async {
    var docs = await FirebaseFirestore.instance
        .collection('evmoto_order_chat_participants')
        .doc(orderRideDetail.value.orderId.toString())
        .get();

    if (docs.exists == true) {
      evmotoOrderChatParticipants.value = EvmotoOrderChatParticipants.fromJson(
        docs.data()!,
      );
    }

    if (docs.exists == false ||
        (docs.exists == true && docs.data()?['userId'] == null)) {
      await FirebaseFirestore.instance
          .collection('evmoto_order_chat_participants')
          .doc(orderRideDetail.value.orderId.toString())
          .set({
            "userId": orderRideDetail.value.userId,
            "userName": homeController.userInfo.value.name,
            "userIsOnline": true,
            "userLastSeen": FieldValue.serverTimestamp(),
            "userJoinedAt": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    }
  }

  void generateEstimatedDistanceAndTimeInMinutes() {
    estimatedDistanceInKm.value = calculateTotalDistance(polylinesCoordinate);
    estimatedTimeInMinutes.value =
        (estimatedDistanceInKm.value / estimatedSpeedInKmh.value) * 60;
  }

  Future<void> setupRefreshStatusDriverGivePrice() async {
    refreshStatusDriverGivePriceTimer = Timer.periodic(Duration(seconds: 5), (
      timer,
    ) async {
      if (orderRideDetail.value.state == 6) {
        await getOrderRideDetail();
      }

      if (orderRideDetail.value.state == 7) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAndToNamed(
            Routes.RIDE_ORDER_DONE,
            arguments: {
              "order_id": orderId.value,
              "order_type": orderType.value,
            },
          );
        });
      }
    });
  }

  Future<void> refreshAll() async {
    markers.clear();
    polylines.clear();
    polylinesCoordinate.clear();
    driverCurrentLocationTimer?.cancel();
    driverCurrentLocationTimer = null;
    refocusMapBoundsTimer?.cancel();
    refocusMapBoundsTimer = null;

    await Future.wait([getOrderRideDetail(), getOrderRideServerDetail()]);

    if (orderRideDetail.value.state == 1) {
      await setupMapWaitingForDriver();
    }
    if (orderRideDetail.value.state == 2) {
      // Driver Grab / Accepted
      await setupGoogleMapsPickUpCustomer();
    }
    if (orderRideDetail.value.state == 3) {
      // Driver On Going Origin
      await setupGoogleMapsPickUpCustomer();
    }

    if (orderRideDetail.value.state == 4) {
      // Driver Arrived on Origin
      await setupGoogleMapOriginToDestination();
    }

    if (orderRideDetail.value.state == 5) {
      // Driver On Going Destination
      await setupGoogleMapOriginToDestination();
    }

    if (orderRideDetail.value.state == 6) {
      // Driver Arrived on Destination
      await setupGoogleMapOriginToDestination();
    }

    if (orderRideDetail.value.state == 7) {
      // Driver Give Price
      await setupGoogleMapOriginToDestination();
    }

    await Future.wait([
      setupSchedulerDriverCurrentLocation(),
      setupSchedulerDriverRefocusMapBound(),
    ]);

    generateEstimatedDistanceAndTimeInMinutes();

    if (orderRideDetail.value.state == 7) {
      // Driver Give Price
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAndToNamed(
          Routes.RIDE_ORDER_DONE,
          arguments: {"order_id": orderId.value, "order_type": orderType.value},
        );
      });
    }
  }

  Future<void> getOrderRideDetail() async {
    orderRideDetail.value = (await orderRideRepository
        .getOrderRideDetailbyOrderId(
          language: languageServices.languageCodeSystem.value,
          orderId: orderId.value,
          orderType: orderType.value,
        ));
  }

  Future<void> getOrderRideServerDetail() async {
    orderRideServerDetail.value = (await orderRideRepository
        .getOrderRideServerDetail(
          language: languageServices.languageCodeSystem.value,
          orderId: orderId.value,
          orderType: orderType.value,
        ));

    driverLatitude.value = orderRideServerDetail.value.lat!;
    driverLongitude.value = orderRideServerDetail.value.lon!;
  }

  Future<void> setupMapWaitingForDriver() async {
    await googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          orderRideDetail.value.startLat!,
          orderRideDetail.value.startLon!,
        ),
        16,
      ),
    );
    isPinLocationWaitingForDriverHide.value = false;
  }

  Future<void> setupGoogleMapsPickUpCustomer() async {
    isPinLocationWaitingForDriverHide.value = true;

    if (driverLatitude.value != "" && driverLongitude.value != "") {
      polylines.clear();

      var markerId = MarkerId("driver_current_location");
      var newMarker = Marker(
        markerId: markerId,
        position: LatLng(
          double.parse(driverLatitude.value),
          double.parse(driverLongitude.value),
        ),
        icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
          'assets/icons/icon_driver.svg',
          Size(32, 53),
        ),
      );
      upsertMarker(markerId: markerId, newMarker: newMarker);

      markerId = MarkerId("appointment_origin");
      newMarker = Marker(
        markerId: markerId,
        position: LatLng(
          orderRideDetail.value.startLat!,
          orderRideDetail.value.startLon!,
        ),
        icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
          'assets/icons/icon_pinpoint.svg',
          Size(32, 34),
        ),
      );
      upsertMarker(markerId: markerId, newMarker: newMarker);

      var googleDirectionList = await googleMapsRepository.getDirection(
        originLatitude: driverLatitude.value,
        originLongitude: driverLongitude.value,
        destinationLatitude: orderRideDetail.value.startLat.toString(),
        destinationLongitude: orderRideDetail.value.startLon.toString(),
        region: "en",
      );

      var result = PolylinePoints.decodePolyline(
        googleDirectionList.first.overviewPolyline!.points!,
      );
      var polylineCoordinates = result
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();
      polylinesCoordinate.value = polylineCoordinates;

      polylines.add(
        Polyline(
          polylineId: PolylineId("route"),
          points: polylineCoordinates,
          color: Color(0XFF37C086),
          width: 6,
        ),
      );

      LatLngBounds bounds;

      var originLatitude = double.parse(this.driverLatitude.value);
      var originLongitude = double.parse(this.driverLongitude.value);
      var destinationLatitude = this.orderRideDetail.value.startLat!;
      var destinationLongitude = this.orderRideDetail.value.startLon!;

      if (originLatitude > destinationLatitude &&
          originLongitude > destinationLongitude) {
        bounds = LatLngBounds(
          southwest: LatLng(destinationLatitude, destinationLongitude),
          northeast: LatLng(originLatitude, originLongitude),
        );
      } else if (originLongitude > destinationLongitude) {
        bounds = LatLngBounds(
          southwest: LatLng(originLatitude, destinationLongitude),
          northeast: LatLng(destinationLatitude, originLongitude),
        );
      } else if (originLatitude > destinationLatitude) {
        bounds = LatLngBounds(
          southwest: LatLng(destinationLatitude, originLongitude),
          northeast: LatLng(originLatitude, destinationLongitude),
        );
      } else {
        bounds = LatLngBounds(
          southwest: LatLng(originLatitude, originLongitude),
          northeast: LatLng(destinationLatitude, destinationLongitude),
        );
      }

      final basePadding = Get.width * 0.1;
      double latDiff = (bounds.northeast.latitude - bounds.southwest.latitude)
          .abs();
      double lngDiff = (bounds.northeast.longitude - bounds.southwest.longitude)
          .abs();
      double areaFactor = (latDiff + lngDiff) * 80000;
      var dynamicPadding = (basePadding + areaFactor).clamp(60, 200);

      await googleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, dynamicPadding.toDouble()),
      );
    } else {}
  }

  Future<void> setupGoogleMapOriginToDestination() async {
    polylines.clear();

    markers.value = markers
        .where((m) => m.markerId != MarkerId('appointment_origin'))
        .toSet();

    var markerId = MarkerId("origin");
    var newMarker = Marker(
      markerId: MarkerId("origin"),
      position: LatLng(
        orderRideDetail.value.startLat!,
        orderRideDetail.value.startLon!,
      ),
      icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
        'assets/icons/icon_origin.svg',
        Size(22.67, 22.67),
      ),
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);

    markerId = MarkerId("destination");
    newMarker = Marker(
      markerId: markerId,
      position: LatLng(
        orderRideDetail.value.endLat!,
        orderRideDetail.value.endLon!,
      ),
      icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
        'assets/icons/icon_pinpoint.svg',
        Size(27, 31),
      ),
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);

    markerId = MarkerId("driver_current_location");
    newMarker = Marker(
      markerId: markerId,
      position: LatLng(
        double.parse(driverLatitude.value),
        double.parse(driverLongitude.value),
      ),
      icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
        'assets/icons/icon_driver.svg',
        Size(32, 53),
      ),
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);

    var googleDirectionList = await googleMapsRepository.getDirection(
      originLatitude: orderRideDetail.value.startLat.toString(),
      originLongitude: orderRideDetail.value.startLon.toString(),
      destinationLatitude: orderRideDetail.value.endLat.toString(),
      destinationLongitude: orderRideDetail.value.endLon.toString(),
      region: "en",
    );

    var result = PolylinePoints.decodePolyline(
      googleDirectionList.first.overviewPolyline!.points!,
    );
    var polylineCoordinates = result
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();
    polylinesCoordinate.value = polylineCoordinates;

    polylines.clear();
    isFetch.value = true;
    polylines.add(
      Polyline(
        polylineId: PolylineId("route"),
        points: polylineCoordinates,
        color: Color(0XFF37C086),
        width: 6,
      ),
    );
    isFetch.value = false;
    polylines.refresh();

    LatLngBounds bounds;

    var originLatitude = this.orderRideDetail.value.startLat!;
    var originLongitude = this.orderRideDetail.value.startLon!;
    var destinationLatitude = this.orderRideDetail.value.endLat!;
    var destinationLongitude = this.orderRideDetail.value.endLon!;

    if (originLatitude > destinationLatitude &&
        originLongitude > destinationLongitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatitude, destinationLongitude),
        northeast: LatLng(originLatitude, originLongitude),
      );
    } else if (originLongitude > destinationLongitude) {
      bounds = LatLngBounds(
        southwest: LatLng(originLatitude, destinationLongitude),
        northeast: LatLng(destinationLatitude, originLongitude),
      );
    } else if (originLatitude > destinationLatitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatitude, originLongitude),
        northeast: LatLng(originLatitude, destinationLongitude),
      );
    } else {
      bounds = LatLngBounds(
        southwest: LatLng(originLatitude, originLongitude),
        northeast: LatLng(destinationLatitude, destinationLongitude),
      );
    }

    final basePadding = Get.width * 0.1;
    double latDiff = (bounds.northeast.latitude - bounds.southwest.latitude)
        .abs();
    double lngDiff = (bounds.northeast.longitude - bounds.southwest.longitude)
        .abs();
    double areaFactor = (latDiff + lngDiff) * 80000;
    var dynamicPadding = (basePadding + areaFactor).clamp(60, 200);

    await googleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, dynamicPadding.toDouble()),
    );
  }

  void upsertMarker({required Marker newMarker, required MarkerId markerId}) {
    var isNewMarkerExists = markers.any((m) => m.markerId == markerId);

    if (isNewMarkerExists) {
      markers.value = markers
          .map((m) => m.markerId == markerId ? newMarker : m)
          .toSet();
    } else {
      markers.add(newMarker);
    }
  }

  Future<void> setupSchedulerDriverCurrentLocation() async {
    driverCurrentLocationTimer = Timer.periodic(Duration(seconds: 3), (
      timer,
    ) async {
      if (isSchedulerDriverCurrentLocationIsProcess.value == false) {
        isSchedulerDriverCurrentLocationIsProcess.value = true;
        var markerId = MarkerId("driver_current_location");
        var newMarker = Marker(
          markerId: markerId,
          position: LatLng(
            double.parse(driverLatitude.value),
            double.parse(driverLongitude.value),
          ),
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
            'assets/icons/icon_driver.svg',
            Size(32, 53),
          ),
        );
        upsertMarker(markerId: markerId, newMarker: newMarker);

        updatePolyline(
          LatLng(
            double.parse(driverLatitude.value),
            double.parse(driverLongitude.value),
          ),
        );

        try {
          await checkDriverOffRoute();
        } catch (e) {}
        isSchedulerDriverCurrentLocationIsProcess.value = false;
      }
    });
  }

  Future<void> checkDriverOffRoute() async {
    var driverPosition = LatLng(
      double.parse(driverLatitude.value),
      double.parse(driverLongitude.value),
    );

    var routePoint = polylinesCoordinate;

    var distanceFromRoute = getDistanceFromRoute(driverPosition, routePoint);

    if (distanceFromRoute > 50) {
      if (orderRideDetail.value.state == 2 ||
          orderRideDetail.value.state == 3) {
        polylines.clear();

        var markerId = MarkerId("driver_current_location");
        var newMarker = Marker(
          markerId: markerId,
          position: LatLng(
            double.parse(driverLatitude.value),
            double.parse(driverLongitude.value),
          ),
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
            'assets/icons/icon_driver.svg',
            Size(32, 53),
          ),
        );
        upsertMarker(markerId: markerId, newMarker: newMarker);

        markerId = MarkerId("appointment_origin");
        newMarker = Marker(
          markerId: markerId,
          position: LatLng(
            orderRideDetail.value.startLat!,
            orderRideDetail.value.startLon!,
          ),
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromPngAsset(
            'assets/icons/icon_order_appointment_point.png',
            Size(46, 46),
          ),
        );
        upsertMarker(markerId: markerId, newMarker: newMarker);

        var googleDirectionList = await googleMapsRepository.getDirection(
          originLatitude: driverLatitude.value,
          originLongitude: driverLongitude.value,
          destinationLatitude: orderRideDetail.value.startLat.toString(),
          destinationLongitude: orderRideDetail.value.startLon.toString(),
          region: "en",
        );

        var result = PolylinePoints.decodePolyline(
          googleDirectionList.first.overviewPolyline!.points!,
        );
        var polylineCoordinates = result
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();
        polylinesCoordinate.value = polylineCoordinates;

        polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Color(0XFF37C086),
            width: 6,
          ),
        );

        generateEstimatedDistanceAndTimeInMinutes();

        LatLngBounds bounds;

        var originLatitude = double.parse(this.driverLatitude.value);
        var originLongitude = double.parse(this.driverLongitude.value);
        var destinationLatitude = this.orderRideDetail.value.startLat!;
        var destinationLongitude = this.orderRideDetail.value.startLon!;

        if (originLatitude > destinationLatitude &&
            originLongitude > destinationLongitude) {
          bounds = LatLngBounds(
            southwest: LatLng(destinationLatitude, destinationLongitude),
            northeast: LatLng(originLatitude, originLongitude),
          );
        } else if (originLongitude > destinationLongitude) {
          bounds = LatLngBounds(
            southwest: LatLng(originLatitude, destinationLongitude),
            northeast: LatLng(destinationLatitude, originLongitude),
          );
        } else if (originLatitude > destinationLatitude) {
          bounds = LatLngBounds(
            southwest: LatLng(destinationLatitude, originLongitude),
            northeast: LatLng(originLatitude, destinationLongitude),
          );
        } else {
          bounds = LatLngBounds(
            southwest: LatLng(originLatitude, originLongitude),
            northeast: LatLng(destinationLatitude, destinationLongitude),
          );
        }

        final basePadding = Get.width * 0.1;
        double latDiff = (bounds.northeast.latitude - bounds.southwest.latitude)
            .abs();
        double lngDiff =
            (bounds.northeast.longitude - bounds.southwest.longitude).abs();
        double areaFactor = (latDiff + lngDiff) * 80000;
        var dynamicPadding = (basePadding + areaFactor).clamp(60, 200);

        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, dynamicPadding.toDouble()),
        );
      }

      if (orderRideDetail.value.state == 4 ||
          orderRideDetail.value.state == 5 ||
          orderRideDetail.value.state == 6) {
        polylines.clear();

        var markerId = MarkerId("driver_current_location");
        var newMarker = Marker(
          markerId: markerId,
          position: LatLng(
            double.parse(driverLatitude.value),
            double.parse(driverLongitude.value),
          ),
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
            'assets/icons/icon_driver.svg',
            Size(32, 53),
          ),
        );
        upsertMarker(markerId: markerId, newMarker: newMarker);

        markerId = MarkerId("destination");
        newMarker = Marker(
          markerId: markerId,
          position: LatLng(
            orderRideDetail.value.endLat!,
            orderRideDetail.value.endLon!,
          ),
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromPngAsset(
            'assets/icons/icon_order_destination.png',
            Size(29, 29),
          ),
        );
        upsertMarker(markerId: markerId, newMarker: newMarker);

        var googleDirectionList = await googleMapsRepository.getDirection(
          originLatitude: driverLatitude.value,
          originLongitude: driverLongitude.value,
          destinationLatitude: orderRideDetail.value.endLat.toString(),
          destinationLongitude: orderRideDetail.value.endLon.toString(),
          region: "en",
        );

        var result = PolylinePoints.decodePolyline(
          googleDirectionList.first.overviewPolyline!.points!,
        );
        var polylineCoordinates = result
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();
        polylinesCoordinate.value = polylineCoordinates;

        polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Color(0XFF37C086),
            width: 6,
          ),
        );

        LatLngBounds bounds;

        var originLatitude = double.parse(this.driverLatitude.value);
        var originLongitude = double.parse(this.driverLongitude.value);
        var destinationLatitude = this.orderRideDetail.value.startLat!;
        var destinationLongitude = this.orderRideDetail.value.startLon!;

        if (originLatitude > destinationLatitude &&
            originLongitude > destinationLongitude) {
          bounds = LatLngBounds(
            southwest: LatLng(destinationLatitude, destinationLongitude),
            northeast: LatLng(originLatitude, originLongitude),
          );
        } else if (originLongitude > destinationLongitude) {
          bounds = LatLngBounds(
            southwest: LatLng(originLatitude, destinationLongitude),
            northeast: LatLng(destinationLatitude, originLongitude),
          );
        } else if (originLatitude > destinationLatitude) {
          bounds = LatLngBounds(
            southwest: LatLng(destinationLatitude, originLongitude),
            northeast: LatLng(originLatitude, destinationLongitude),
          );
        } else {
          bounds = LatLngBounds(
            southwest: LatLng(originLatitude, originLongitude),
            northeast: LatLng(destinationLatitude, destinationLongitude),
          );
        }

        final basePadding = Get.width * 0.1;
        double latDiff = (bounds.northeast.latitude - bounds.southwest.latitude)
            .abs();
        double lngDiff =
            (bounds.northeast.longitude - bounds.southwest.longitude).abs();
        double areaFactor = (latDiff + lngDiff) * 80000;
        var dynamicPadding = (basePadding + areaFactor).clamp(60, 200);

        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, dynamicPadding.toDouble()),
        );
      }
    }
  }

  void updatePolyline(LatLng driverPos) {
    var result = getClosestPointIndex(driverPos, polylinesCoordinate);

    var closestIndex = result['index'];
    var minDistance = result['min_distance'];
    var threshold = 30.0;

    if (minDistance < threshold && closestIndex > 0) {
      polylinesCoordinate.value = polylinesCoordinate.sublist(closestIndex);

      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: PolylineId("route"),
          color: Color(0XFF37C086),
          width: 5,
          points: polylinesCoordinate,
        ),
      );

      generateEstimatedDistanceAndTimeInMinutes();
    }
  }

  Future<void> setupSchedulerDriverRefocusMapBound() async {
    refocusMapBoundsTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await onTapRefocus();
    });
  }

  Future<void> onTapRefocus() async {
    if (orderRideDetail.value.state == 1) {
      await googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            orderRideDetail.value.startLat!,
            orderRideDetail.value.startLon!,
          ),
          16,
        ),
      );
      isPinLocationWaitingForDriverHide.value = false;
    } else if (orderRideDetail.value.state == 2 ||
        orderRideDetail.value.state == 3) {
      LatLngBounds bounds;

      var originLatitude = double.parse(driverLatitude.value);
      var originLongitude = double.parse(driverLongitude.value);
      var destinationLatitude = this.orderRideDetail.value.startLat!;
      var destinationLongitude = this.orderRideDetail.value.startLon!;

      if (originLatitude > destinationLatitude &&
          originLongitude > destinationLongitude) {
        bounds = LatLngBounds(
          southwest: LatLng(destinationLatitude, destinationLongitude),
          northeast: LatLng(originLatitude, originLongitude),
        );
      } else if (originLongitude > destinationLongitude) {
        bounds = LatLngBounds(
          southwest: LatLng(originLatitude, destinationLongitude),
          northeast: LatLng(destinationLatitude, originLongitude),
        );
      } else if (originLatitude > destinationLatitude) {
        bounds = LatLngBounds(
          southwest: LatLng(destinationLatitude, originLongitude),
          northeast: LatLng(originLatitude, destinationLongitude),
        );
      } else {
        bounds = LatLngBounds(
          southwest: LatLng(originLatitude, originLongitude),
          northeast: LatLng(destinationLatitude, destinationLongitude),
        );
      }

      final basePadding = Get.width * 0.1;
      double latDiff = (bounds.northeast.latitude - bounds.southwest.latitude)
          .abs();
      double lngDiff = (bounds.northeast.longitude - bounds.southwest.longitude)
          .abs();
      double areaFactor = (latDiff + lngDiff) * 80000;
      var dynamicPadding = (basePadding + areaFactor).clamp(60, 200);

      await googleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, dynamicPadding.toDouble()),
      );
    } else {
      LatLngBounds bounds;

      var originLatitude = double.parse(driverLatitude.value);
      var originLongitude = double.parse(driverLongitude.value);
      var destinationLatitude = this.orderRideDetail.value.endLat!;
      var destinationLongitude = this.orderRideDetail.value.endLon!;

      if (originLatitude > destinationLatitude &&
          originLongitude > destinationLongitude) {
        bounds = LatLngBounds(
          southwest: LatLng(destinationLatitude, destinationLongitude),
          northeast: LatLng(originLatitude, originLongitude),
        );
      } else if (originLongitude > destinationLongitude) {
        bounds = LatLngBounds(
          southwest: LatLng(originLatitude, destinationLongitude),
          northeast: LatLng(destinationLatitude, originLongitude),
        );
      } else if (originLatitude > destinationLatitude) {
        bounds = LatLngBounds(
          southwest: LatLng(destinationLatitude, originLongitude),
          northeast: LatLng(originLatitude, destinationLongitude),
        );
      } else {
        bounds = LatLngBounds(
          southwest: LatLng(originLatitude, originLongitude),
          northeast: LatLng(destinationLatitude, destinationLongitude),
        );
      }
      final basePadding = Get.width * 0.1;
      double latDiff = (bounds.northeast.latitude - bounds.southwest.latitude)
          .abs();
      double lngDiff = (bounds.northeast.longitude - bounds.southwest.longitude)
          .abs();
      double areaFactor = (latDiff + lngDiff) * 80000;
      var dynamicPadding = (basePadding + areaFactor).clamp(60, 200);

      await googleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, dynamicPadding.toDouble()),
      );
    }
  }

  Future<void> onTapOrderRideCancelBeforeDriver() async {
    await Get.dialog(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: themeColorServices.neutralsColorGrey0.value,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Apakah Anda yakin ingin membatalkan pesanan?",
                        style: typographyServices.bodyLargeBold.value,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              width: Get.width,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: themeColorServices
                                        .neutralsColorGrey300
                                        .value,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () async {
                                  Get.close(1);
                                },
                                child: Text(
                                  "Tutup",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey400
                                            .value,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              width: Get.width,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await orderRideRepository.cancelOrderRide(
                                    orderId: orderId.value,
                                    orderType: orderType.value,
                                    language: languageServices
                                        .languageCodeSystem
                                        .value,
                                    reason: null,
                                    remark: null,
                                  );
                                  Get.close(1);
                                  Get.back();

                                  var snackBar = SnackBar(
                                    behavior: SnackBarBehavior.fixed,
                                    backgroundColor: themeColorServices
                                        .sematicColorGreen400
                                        .value,
                                    content: Text(
                                      languageServices
                                              .language
                                              .value
                                              .snackbarCancelTransactionSuccess ??
                                          "-",
                                      style: typographyServices
                                          .bodySmallRegular
                                          .value
                                          .copyWith(
                                            color: themeColorServices
                                                .neutralsColorGrey0
                                                .value,
                                          ),
                                    ),
                                  );
                                  rootScaffoldMessengerKey.currentState
                                      ?.showSnackBar(snackBar);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeColorServices
                                      .sematicColorRed400
                                      .value,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  "Batalkan",
                                  style: typographyServices.bodyLargeBold.value
                                      .copyWith(
                                        color: themeColorServices
                                            .neutralsColorGrey0
                                            .value,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getEstimatedTimeInMinutesInText() {
    int jam = estimatedTimeInMinutes.value ~/ 60;
    int menit = (estimatedTimeInMinutes.value % 60).round();

    if (jam > 0) {
      return '$jam ${languageServices.language.value.hour} $menit ${languageServices.language.value.minute}';
    } else {
      return '$menit ${languageServices.language.value.minute}';
    }
  }
}
