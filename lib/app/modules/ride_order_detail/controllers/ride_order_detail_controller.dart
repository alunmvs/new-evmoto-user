import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/models/evmoto_order_chat_participants_model.dart';
import 'package:new_evmoto_user/app/data/models/open_map_direction_model.dart'
    as directionModel;
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_server_model.dart';
import 'package:new_evmoto_user/app/data/models/socket_driver_position_data_model.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/repositories/google_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/sendbird_chat_services.dart';
import 'package:new_evmoto_user/app/services/socket_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/bitmap_descriptor_helper.dart';

import 'package:new_evmoto_user/app/utils/google_maps_helper.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/app/utils/time_process_helper.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:new_evmoto_user/main.dart';
import 'dart:async';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class RideOrderDetailController extends GetxController {
  final GoogleMapsRepository googleMapsRepository;
  final OrderRideRepository orderRideRepository;
  final OpenMapsRepository openMapsRepository;

  RideOrderDetailController({
    required this.googleMapsRepository,
    required this.orderRideRepository,
    required this.openMapsRepository,
  });

  final homeController = Get.find<HomeController>();

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final sendbirdChatServices = Get.find<SendbirdChatServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();
  final socketServices = Get.find<SocketServices>();

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

  Timer? driverCurrentLocationTimer;
  Timer? refocusMapBoundsTimer;
  Timer? refreshStatusDriverGivePriceTimer;

  final isPinLocationWaitingForDriverHide = true.obs;
  final isSchedulerDriverCurrentLocationIsProcess = false.obs;

  final payType = 3.obs;

  final evmotoOrderChatParticipants = EvmotoOrderChatParticipants().obs;

  Timer? manualRefreshStatusTimer;

  final driverToOriginDirection = directionModel.OpenMapDirection().obs;
  final driverToDestinationDirection = directionModel.OpenMapDirection().obs;
  final originToDestinationDirection = directionModel.OpenMapDirection().obs;

  final isDriverToOriginDirectionVisible = true.obs;
  final isDriverToDestinationDirectionVisible = true.obs;
  final isOriginToDestinationDirectionVisible = true.obs;
  final isMarkerDriverVisible = true.obs;
  final isMarkerOriginVisible = true.obs;
  final isMarkerDestinationVisible = true.obs;

  final state = 0.obs;
  final previousState = 0.obs;

  final isGoogleMapControllerCreated = false.obs;

  Timer? allSchedulerTimer;

  // debug purposes
  final distanceFromRoute = 0.0.obs;
  final distanceFromNearestRoute = 0.0.obs;
  final totalHitAPIGetDirectionDriverToOrigin = 0.obs;
  final totalHitAPIGetDirectionDriverToDestination = 0.obs;
  final totalRefreshStatus = 0.obs;

  // Driver's Waiting Time
  final driverArrivedOriginAt = DateTime.now().obs;
  final driverArrivedOriginWaitingTimeSeconds = 0.obs;
  Timer? driverWaitingTimer;

  final isCriticalError = false.obs;
  final isFetch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    isFetch.value = true;
    orderId.value = Get.arguments['order_id'] ?? "";
    orderType.value = Get.arguments['order_type'] ?? 1;
    // Essentials
    await measureTime(
      "[Essentials] Get Order Ride Detail & Get Order Ride Server Detail",
      () => Future.wait([getOrderRideDetail(), getOrderRideServerDetail()]),
    );

    await Future.wait([checkOrderHasBeenCancelled()]);

    if (state.value == 2) {
      if (driverLatitude.value == "") {
        await driverLatitude.stream.firstWhere((value) => value != "");
      }
    }

    await measureTime(
      "[Essentials] Get All Routing Cache",
      () => Future.wait([getAllRoutingCache()]),
    );
    isFetch.value = false;

    await isGoogleMapControllerCreated.stream.firstWhere(
      (value) => value == true,
    );

    // Status Based
    await Future.wait([updateVisibility()]);
    await Future.wait([
      setupAllMarkers(),
      setupAllRouting(),
      updateCameraAutoFocus(),
    ]);

    if ([2, 3, 4, 5, 6, 7, 8].contains(state.value)) {
      await updateDriverPositionReducedPolyline();
      await updateDriverPositionReroutingOffRoute();
    }

    ever(state, (value) async {
      await measureTime(
        "[Essentials] Get Order Ride Detail & Get Order Ride Server Detail",
        () => Future.wait([getOrderRideDetail(), getOrderRideServerDetail()]),
      );

      if (value == 1) {}

      if (value == 2) {
        if (driverLatitude.value == "") {
          await driverLatitude.stream.firstWhere((value) => value != "");
          await getAllRoutingCache();
        }
      }

      await measureTime(
        "[Essentials] Get All Routing Cache",
        () => Future.wait([getAllRoutingCache()]),
      );

      await updateVisibility();
      await Future.wait([
        setupAllMarkers(),
        setupAllRouting(),
        updateCameraAutoFocus(),
      ]);
      await Future.wait([checkReceiveInvoice()]);

      if ([2, 3, 4, 5, 6, 7, 8].contains(state.value)) {
        await updateDriverPositionReducedPolyline();
        await updateDriverPositionReroutingOffRoute();
      }

      previousState.value = value;
    });

    await Future.wait([checkReceiveInvoice()]);

    // old
    // isFetch.value = true;
    // isCriticalError.value = false;
    // orderId.value = Get.arguments['order_id'] ?? "";
    // orderType.value = Get.arguments['order_type'] ?? 1;

    // try {
    //   await Future.wait([getOrderRideDetail(), getOrderRideServerDetail()]);

    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     if (orderRideDetail.value.state == 10) {
    //       Get.back();
    //       SnackbarHelper.showSnackbarError(
    //         text: languageServices.language.value.orderHasBeenCancelled ?? "-",
    //       );
    //     }
    //   });
    // } on DioException catch (e) {
    //   SnackbarHelper.showSnackbarError(text: e.error.toString());
    //   isCriticalError.value = true;
    // }

    // isFetch.value = false;

    // if (isCriticalError.value == false) {
    //   await Future.delayed(Duration(seconds: 1));

    //   if (orderRideDetail.value.state == 1) {
    //     await setupMapWaitingForDriver();
    //   }
    //   if (orderRideDetail.value.state == 2) {
    //     // Driver Grab / Accepted
    //     await setupGoogleMapsPickUpCustomer();
    //   }
    //   if (orderRideDetail.value.state == 3) {
    //     // Driver On Going Origin
    //     await setupGoogleMapsPickUpCustomer();
    //   }

    //   if (orderRideDetail.value.state == 4) {
    //     // Driver Arrived on Origin
    //     await setupGoogleMapOriginToDestination();
    //   }

    //   if (orderRideDetail.value.state == 5) {
    //     // Driver On Going Destination
    //     await setupGoogleMapOriginToDestination();
    //   }

    //   if (orderRideDetail.value.state == 6) {
    //     // Driver Arrived on Destination
    //     await setupGoogleMapOriginToDestination();
    //   }

    //   if (orderRideDetail.value.state == 7) {
    //     // Driver Give Price
    //     await setupGoogleMapOriginToDestination();
    //   }

    //   await Future.wait([
    //     setupSchedulerDriverCurrentLocation(),
    //     setupSchedulerDriverRefocusMapBound(),
    //     setupRefreshStatusDriverGivePrice(),
    //   ]);

    //

    //   if (orderRideDetail.value.state == 6 ||
    //       orderRideDetail.value.state == 7 ||
    //       orderRideDetail.value.state == 8) {
    //     // Driver Give Price
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       if (Get.currentRoute != Routes.RIDE_ORDER_DONE &&
    //           Get.currentRoute != Routes.HOME) {
    //         Get.offAndToNamed(
    //           Routes.RIDE_ORDER_DONE,
    //           arguments: {
    //             "order_id": orderId.value,
    //             "order_type": orderType.value,
    //           },
    //         );
    //       }
    //     });
    //   }
    // }

    // manualRefreshStatusTimer = Timer.periodic(Duration(seconds: 5), (
    //   value,
    // ) async {
    //   if (socketServices.isSocketClose.value == true) {
    //     var isHasConnection =
    //         await InternetConnectionChecker.instance.hasConnection;
    //     if (isHasConnection == true) {
    //       try {
    //         await refreshAll();
    //       } catch (e) {}
    //     }
    //   }
    // });

    allSchedulerTimer = Timer.periodic(Duration(seconds: 5), (value) async {
      if (socketServices.isSocketClose.value == true) {
        var isHasConnection =
            await InternetConnectionChecker.instance.hasConnection;
        if (isHasConnection == true) {
          try {
            await measureTime(
              "[Essentials] Get Order Ride Detail & Get Order Ride Server Detail",
              () => Future.wait([
                getOrderRideDetail(),
                getOrderRideServerDetail(),
              ]),
            );
          } catch (e) {}
        }
      }

      if ([1, 2].contains(state.value)) {
        await measureTime(
          "Check Number of Push Rounds Has Exceeded",
          () => Future.wait([checkNumberOfPushRoundsHasExceeded()]),
        );
        totalRefreshStatus.value += 1;
      }
    });

    driverWaitingTimer = Timer.periodic(Duration(seconds: 1), (value) async {
      if (orderRideDetail.value.state == 4) {
        driverArrivedOriginWaitingTimeSeconds.value = DateTime.now()
            .difference(driverArrivedOriginAt.value)
            .inSeconds;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
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
    try {
      refreshStatusDriverGivePriceTimer?.cancel();
    } catch (e) {}
    try {
      manualRefreshStatusTimer?.cancel();
    } catch (e) {}
    try {
      allSchedulerTimer?.cancel();
    } catch (e) {}
    try {
      driverWaitingTimer?.cancel();
    } catch (e) {}
  }

  Future<void> setupRefreshStatusDriverGivePrice() async {
    refreshStatusDriverGivePriceTimer ??= Timer.periodic(Duration(seconds: 5), (
      timer,
    ) async {
      if (orderRideDetail.value.state == 6) {
        await getOrderRideDetail();
      }

      if (orderRideDetail.value.state == 7) {
        if (Get.currentRoute != Routes.RIDE_ORDER_DONE &&
            Get.currentRoute != Routes.HOME) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Get.currentRoute != Routes.RIDE_ORDER_DONE) {
              Get.offAndToNamed(
                Routes.RIDE_ORDER_DONE,
                arguments: {
                  "order_id": orderId.value,
                  "order_type": orderType.value,
                },
              );
            }
          });
        }
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

    if (orderRideDetail.value.state == 6 ||
        orderRideDetail.value.state == 7 ||
        orderRideDetail.value.state == 8) {
      // Driver Give Price
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.currentRoute != Routes.RIDE_ORDER_DONE &&
            Get.currentRoute != Routes.HOME) {
          Get.offAndToNamed(
            Routes.RIDE_ORDER_DONE,
            arguments: {
              "order_id": orderId.value,
              "order_type": orderType.value,
            },
          );
        }
      });
    }
  }

  Future<void> setupMapWaitingForDriver() async {
    if (isClosed) return;
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
    if (isClosed) return;
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
          'assets/icons/icon_pinpoint_map_green.svg',
          Size(28, 35),
        ),
      );
      upsertMarker(markerId: markerId, newMarker: newMarker);

      var openMapDirection = await openMapsRepository.getDirection(
        originLatitude: driverLatitude.value,
        originLongitude: driverLongitude.value,
        destinationLatitude: orderRideDetail.value.startLat.toString(),
        destinationLongitude: orderRideDetail.value.startLon.toString(),
      );

      var polylineCoordinates = openMapDirection
          .routes!
          .first
          .geometry!
          .coordinates!
          .map((p) => LatLng(p[1], p[0]))
          .toList();

      polylinesCoordinate.value = polylineCoordinates;

      polylines.add(
        Polyline(
          polylineId: PolylineId("route"),
          points: polylineCoordinates,
          color: Color(0XFF4DABF5),
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

      await googleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
      );
    } else {}
  }

  Future<void> setupGoogleMapOriginToDestination() async {
    if (isClosed) return;
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
        'assets/icons/icon_pinpoint_map_green.svg',
        Size(28, 35),
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
        'assets/icons/icon_pinpoint_map_red.svg',
        Size(28, 35),
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

    var openMapDirection = await openMapsRepository.getDirection(
      originLatitude: orderRideDetail.value.startLat.toString(),
      originLongitude: orderRideDetail.value.startLon.toString(),
      destinationLatitude: orderRideDetail.value.endLat.toString(),
      destinationLongitude: orderRideDetail.value.endLon.toString(),
    );

    var polylineCoordinates = openMapDirection
        .routes!
        .first
        .geometry!
        .coordinates!
        .map((p) => LatLng(p[1], p[0]))
        .toList();

    polylinesCoordinate.value = polylineCoordinates;

    polylines.clear();

    isFetch.value = true;
    polylines.add(
      Polyline(
        polylineId: PolylineId("route"),
        points: polylineCoordinates,
        color: Color(0XFF4DABF5),
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

    await googleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
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
    driverCurrentLocationTimer ??= Timer.periodic(Duration(seconds: 3), (
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
    if (isClosed) return;
    var driverPosition = LatLng(
      double.parse(driverLatitude.value),
      double.parse(driverLongitude.value),
    );

    var routePoint = polylinesCoordinate;

    var distanceFromRoute = getDistanceFromRoute(driverPosition, routePoint);

    if (distanceFromRoute > 300) {
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
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
            'assets/icons/icon_pinpoint_map_green.svg',
            Size(28, 35),
          ),
        );
        upsertMarker(markerId: markerId, newMarker: newMarker);

        var openMapDirection = await openMapsRepository.getDirection(
          originLatitude: driverLatitude.value,
          originLongitude: driverLongitude.value,
          destinationLatitude: orderRideDetail.value.startLat.toString(),
          destinationLongitude: orderRideDetail.value.startLon.toString(),
        );

        var polylineCoordinates = openMapDirection
            .routes!
            .first
            .geometry!
            .coordinates!
            .map((p) => LatLng(p[1], p[0]))
            .toList();

        polylinesCoordinate.value = polylineCoordinates;

        polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Color(0XFF4DABF5),
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

        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
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
          icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
            'assets/icons/icon_pinpoint_map_red.svg',
            Size(28, 35),
          ),
        );
        upsertMarker(markerId: markerId, newMarker: newMarker);

        var openMapDirection = await openMapsRepository.getDirection(
          originLatitude: driverLatitude.value,
          originLongitude: driverLongitude.value,
          destinationLatitude: orderRideDetail.value.endLat.toString(),
          destinationLongitude: orderRideDetail.value.endLon.toString(),
        );

        var polylineCoordinates = openMapDirection
            .routes!
            .first
            .geometry!
            .coordinates!
            .map((p) => LatLng(p[1], p[0]))
            .toList();

        polylinesCoordinate.value = polylineCoordinates;

        polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: Color(0XFF4DABF5),
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

        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
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
          color: Color(0XFF4DABF5),
          width: 5,
          points: polylinesCoordinate,
        ),
      );
    }
  }

  Future<void> setupSchedulerDriverRefocusMapBound() async {
    refocusMapBoundsTimer ??= Timer.periodic(Duration(seconds: 5), (
      timer,
    ) async {
      await onTapRefocus();
    });
  }

  Future<void> onTapRefocus() async {
    if (isClosed) return;
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

      var movementDirection = compareLatLng(
        originLat: originLatitude,
        originLng: originLongitude,
        destLat: destinationLatitude,
        destLng: destinationLongitude,
      );

      if (movementDirection == MovementDirection.vertical) {
        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.height * 0.3),
        );
      } else {
        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
        );
      }
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

      var movementDirection = compareLatLng(
        originLat: originLatitude,
        originLng: originLongitude,
        destLat: destinationLatitude,
        destLng: destinationLongitude,
      );

      if (movementDirection == MovementDirection.vertical) {
        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.height * 0.3),
        );
      } else {
        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
        );
      }
    }
  }

  MovementDirection compareLatLng({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) {
    final double deltaLat = (destLat - originLat).abs();
    final double deltaLng = (destLng - originLng).abs();

    if (deltaLat > deltaLng) {
      return MovementDirection.vertical;
    } else {
      return MovementDirection.horizontal;
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
                        languageServices
                                .language
                                .value
                                .cancelOrderTitleDialog ??
                            "-",
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
                                  languageServices.language.value.close ?? "-",
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
                            child: LoaderElevatedButton(
                              onPressed: () async {
                                try {
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
                                } on DioException catch (e) {
                                  SnackbarHelper.showSnackbarError(
                                    text: e.error.toString(),
                                  );
                                } on Exception catch (e) {
                                  SnackbarHelper.showSnackbarError(
                                    text: e.toString(),
                                  );
                                }
                              },
                              buttonColor:
                                  themeColorServices.sematicColorRed400.value,
                              child: Text(
                                languageServices.language.value.cancel ?? "-",
                                style: typographyServices.bodyLargeBold.value
                                    .copyWith(
                                      color: themeColorServices
                                          .neutralsColorGrey0
                                          .value,
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

  String getEstimatedTimeInMinutesWaitingDriverPickUpInText() {
    if (orderRideServerDetail.value.reservationTime != null) {
      int jam =
          double.parse(orderRideServerDetail.value.reservationTime!) ~/ 60;
      int menit =
          (double.parse(orderRideServerDetail.value.reservationTime!) % 60)
              .round();

      if (jam > 0) {
        return '$jam ${languageServices.language.value.hour} $menit ${languageServices.language.value.minute}';
      } else {
        return '$menit ${languageServices.language.value.minute}';
      }
    }

    return '';
  }

  String getEstimatedHourMinuteArrive() {
    var now = DateTime.now();
    int menit =
        (double.parse(orderRideServerDetail.value.laveTime ?? "0.0") % 60)
            .round();
    var estimatedArrived = now.add(Duration(minutes: menit));
    var formattedTime = DateFormat('HH:mm').format(estimatedArrived);
    return formattedTime;
  }

  String getEstimatedHourMinuteWaitingTime() {
    var now = DateTime.now();
    var estimatedWaitingTime = now.add(
      Duration(minutes: orderRideDetail.value.freeWaitMinutes ?? 0),
    );
    var formattedTime = DateFormat('HH:mm').format(estimatedWaitingTime);
    return formattedTime;
  }

  // orderRideDetail
  Future<void> getOrderRideDetail() async {
    orderRideDetail.value = (await orderRideRepository
        .getOrderRideDetailbyOrderId(
          orderId: orderId.value,
          orderType: orderType.value,
        ));
    state.value = orderRideDetail.value.state ?? 0;
    if (orderRideDetail.value.driverArrivedOriginAt != null) {
      driverArrivedOriginAt.value = DateTime.parse(
        orderRideDetail.value.driverArrivedOriginAt!.replaceFirst(' ', 'T'),
      );
    }
  }

  // orderRideServerDetail
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

  // driverToOriginDirection & originToDestinationDirection
  Future<void> getAllRoutingCache({
    bool forceUpdateDriverToOrigin = false,
    bool forceUpdateDriverToDestination = false,
  }) async {
    var prefs = await SharedPreferences.getInstance();

    var driverToOriginDirectionCache = prefs.getString(
      'order_${orderRideDetail.value.orderId}_driver_to_origin_direction_cache_${orderRideDetail.value.driverId}',
    );
    var driverToDestinationDirectionCache = prefs.getString(
      'order_${orderRideDetail.value.orderId}_driver_to_destination_direction_cache_${orderRideDetail.value.driverId}',
    );

    var totalHitAPIGetDirectionDriverToOrigin =
        prefs.getInt(
          'order_${orderRideDetail.value.orderId}_driver_to_origin_total_hit_api_${orderRideDetail.value.driverId}',
        ) ??
        0;

    var totalHitAPIGetDirectionDriverToDestination =
        prefs.getInt(
          'order_${orderRideDetail.value.orderId}_driver_to_destination_total_hit_api_${orderRideDetail.value.driverId}',
        ) ??
        0;
    // var originToDestinationCache = prefs.getString(
    //   'order_${orderRideDetail.value.orderId}_origin_to_destination_direction_cache',
    // );

    if ([2, 3, 4].contains(state.value)) {
      if (driverLatitude.value != "") {
        if (driverToOriginDirectionCache == null ||
            forceUpdateDriverToOrigin == true) {
          driverToOriginDirection.value = await openMapsRepository.getDirection(
            originLatitude: driverLatitude.value,
            originLongitude: driverLongitude.value,
            destinationLatitude: orderRideDetail.value.startLat.toString(),
            destinationLongitude: orderRideDetail.value.startLon.toString(),
          );
          totalHitAPIGetDirectionDriverToOrigin += 1;
          await prefs.setString(
            'order_${orderRideDetail.value.orderId}_driver_to_origin_direction_cache_${orderRideDetail.value.driverId}',
            jsonEncode(driverToOriginDirection.value.toJson()),
          );
          await prefs.setInt(
            'order_${orderRideDetail.value.orderId}_driver_to_origin_total_hit_api_${orderRideDetail.value.driverId}',
            totalHitAPIGetDirectionDriverToOrigin,
          );
          this.totalHitAPIGetDirectionDriverToOrigin.value =
              totalHitAPIGetDirectionDriverToOrigin;
        } else {
          driverToOriginDirection.value =
              directionModel.OpenMapDirection.fromJson(
                jsonDecode(driverToOriginDirectionCache),
              );
        }
      }
    }

    if ([5, 6, 7, 8].contains(state.value)) {
      if (driverLatitude.value != "") {
        if (driverToDestinationDirectionCache == null ||
            forceUpdateDriverToDestination == true) {
          driverToDestinationDirection.value = await openMapsRepository
              .getDirection(
                originLatitude: driverLatitude.value,
                originLongitude: driverLongitude.value,
                destinationLatitude: orderRideDetail.value.endLat.toString(),
                destinationLongitude: orderRideDetail.value.endLon.toString(),
              );
          totalHitAPIGetDirectionDriverToDestination += 1;
          await prefs.setString(
            'order_${orderRideDetail.value.orderId}_driver_to_destination_direction_cache_${orderRideDetail.value.driverId}',
            jsonEncode(driverToDestinationDirection.value.toJson()),
          );
          await prefs.setInt(
            'order_${orderRideDetail.value.orderId}_driver_to_destination_total_hit_api_${orderRideDetail.value.driverId}',
            totalHitAPIGetDirectionDriverToDestination,
          );
          this.totalHitAPIGetDirectionDriverToDestination.value =
              totalHitAPIGetDirectionDriverToDestination;
        } else {
          driverToDestinationDirection.value =
              directionModel.OpenMapDirection.fromJson(
                jsonDecode(driverToDestinationDirectionCache),
              );
        }
      }
    }

    // if (originToDestinationCache == null) {
    //   originToDestinationDirection.value = await openMapsRepository
    //       .getDirection(
    //         originLatitude: orderRideDetail.value.startLat.toString(),
    //         originLongitude: orderRideDetail.value.startLon.toString(),
    //         destinationLatitude: orderRideDetail.value.endLat.toString(),
    //         destinationLongitude: orderRideDetail.value.endLon.toString(),
    //       );

    //   await prefs.setString(
    //     'order_${orderRideDetail.value.orderId}_origin_to_destination_direction_cache',
    //     jsonEncode(originToDestinationDirection.value.toJson()),
    //   );
    // } else {
    //   originToDestinationDirection.value = directionModel
    //       .OpenMapDirection.fromJson(jsonDecode(originToDestinationCache));
    // }
  }

  // markers
  Future<void> setupAllMarkers() async {
    if ([1].contains(state.value)) {
      markers.clear();
    }

    if ([2, 3, 4].contains(state.value)) {
      var driverMarkerId = MarkerId("driver");
      var driverNewMarker = Marker(
        markerId: driverMarkerId,
        position: LatLng(
          double.parse(driverLatitude.value),
          double.parse(driverLongitude.value),
        ),
        icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
          'assets/icons/icon_driver.svg',
          Size(32, 53),
        ),
        visible: isMarkerDriverVisible.value,
      );
      upsertMarker(markerId: driverMarkerId, newMarker: driverNewMarker);

      var originMarkerId = MarkerId("origin");
      var originNewMarker = Marker(
        markerId: originMarkerId,
        position: LatLng(
          orderRideDetail.value.startLat!,
          orderRideDetail.value.startLon!,
        ),
        icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
          'assets/icons/icon_pinpoint_map_green.svg',
          Size(28, 35),
        ),
        visible: isMarkerOriginVisible.value,
      );
      upsertMarker(markerId: originMarkerId, newMarker: originNewMarker);
    }

    if ([5, 6, 7, 8].contains(state.value)) {
      var driverMarkerId = MarkerId("driver");
      var driverNewMarker = Marker(
        markerId: driverMarkerId,
        position: LatLng(
          double.parse(driverLatitude.value),
          double.parse(driverLongitude.value),
        ),
        icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
          'assets/icons/icon_driver.svg',
          Size(32, 53),
        ),
        visible: isMarkerDriverVisible.value,
      );
      upsertMarker(markerId: driverMarkerId, newMarker: driverNewMarker);

      var originMarkerId = MarkerId("origin");
      var originNewMarker = Marker(
        markerId: originMarkerId,
        position: LatLng(
          orderRideDetail.value.startLat!,
          orderRideDetail.value.startLon!,
        ),
        icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
          'assets/icons/icon_pinpoint_map_green.svg',
          Size(28, 35),
        ),
        visible: isMarkerOriginVisible.value,
      );
      upsertMarker(markerId: originMarkerId, newMarker: originNewMarker);

      var destinationMarkerId = MarkerId("destination");
      var destinationNewMarker = Marker(
        markerId: destinationMarkerId,
        position: LatLng(
          orderRideDetail.value.endLat!,
          orderRideDetail.value.endLon!,
        ),
        icon: await BitmapDescriptorHelper.getBitmapDescriptorFromSvgAsset(
          'assets/icons/icon_pinpoint_map_red.svg',
          Size(28, 35),
        ),
        visible: isMarkerDestinationVisible.value,
      );
      upsertMarker(
        markerId: destinationMarkerId,
        newMarker: destinationNewMarker,
      );
    }
  }

  // googleMapController
  Future<void> updateCameraAutoFocus() async {
    // waiting driver accept
    if ([1].contains(state.value)) {
      await googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            orderRideDetail.value.startLat!,
            orderRideDetail.value.startLon!,
          ),
          16,
        ),
      );
    }

    // driver to origin
    if ([2, 3, 4].contains(state.value)) {
      LatLngBounds bounds;

      var originLatitude = double.parse(driverLatitude.value);
      var originLongitude = double.parse(driverLongitude.value);
      var destinationLatitude = orderRideDetail.value.startLat!;
      var destinationLongitude = orderRideDetail.value.startLon!;

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

      var movementDirection = compareLatLng(
        originLat: originLatitude,
        originLng: originLongitude,
        destLat: destinationLatitude,
        destLng: destinationLongitude,
      );

      if (movementDirection == MovementDirection.vertical) {
        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.height * 0.2),
        );
      } else {
        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
        );
      }
    }

    // driver to destination
    if ([5, 6, 7, 8].contains(state.value)) {
      LatLngBounds bounds;

      var originLatitude = double.parse(driverLatitude.value);
      var originLongitude = double.parse(driverLongitude.value);
      var destinationLatitude = orderRideDetail.value.endLat!;
      var destinationLongitude = orderRideDetail.value.endLon!;

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

      var movementDirection = compareLatLng(
        originLat: originLatitude,
        originLng: originLongitude,
        destLat: destinationLatitude,
        destLng: destinationLongitude,
      );

      if (movementDirection == MovementDirection.vertical) {
        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.height * 0.2),
        );
      } else {
        await googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
        );
      }
    }
  }

  // polylines & polylinesCoordinate
  Future<void> setupAllRouting() async {
    polylines.clear();
    polylinesCoordinate.clear();

    // waiting driver accept
    if ([1].contains(state.value)) {}

    // driver to origin
    if ([2, 3, 4].contains(state.value)) {
      polylinesCoordinate.value = driverToOriginDirection
          .value
          .routes!
          .first
          .geometry!
          .coordinates!
          .map((p) => LatLng(p[1], p[0]))
          .toList();
      polylines.add(
        Polyline(
          polylineId: PolylineId("driver_to_origin_direction"),
          points: polylinesCoordinate,
          color: Color(0XFF4DABF5),
          width: 6,
          visible: isDriverToOriginDirectionVisible.value,
        ),
      );
    }

    // driver to destination
    if ([5, 6, 7, 8].contains(state.value)) {
      polylinesCoordinate.value = driverToDestinationDirection
          .value
          .routes!
          .first
          .geometry!
          .coordinates!
          .map((p) => LatLng(p[1], p[0]))
          .toList();
      polylines.add(
        Polyline(
          polylineId: PolylineId("driver_to_destination_direction"),
          points: polylinesCoordinate,
          color: Color(0XFF4DABF5),
          width: 6,
          visible: isDriverToDestinationDirectionVisible.value,
        ),
      );
    }
  }

  // driverLatitude & driverLongitude & markers
  Future<void> handleSocketDriverPosition({
    required SocketDriverPositionData socketDriverPositionData,
  }) async {
    driverLatitude.value = socketDriverPositionData.lat.toString();
    driverLongitude.value = socketDriverPositionData.lon.toString();
    var markerId = MarkerId("driver");
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
      visible: isMarkerDriverVisible.value,
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);
    await updateDriverPositionReducedPolyline();
    await updateDriverPositionReroutingOffRoute();
    await updateCameraAutoFocus();
  }

  // orderRideDetail & orderRideServerDetail
  Future<void> handleSocketOrderStatus() async {
    await Future.wait([getOrderRideDetail(), getOrderRideServerDetail()]);
  }

  Future<void> updateVisibility() async {
    if ([1].contains(state.value)) {
      isDriverToOriginDirectionVisible.value = false;
      isOriginToDestinationDirectionVisible.value = false;
      isMarkerDriverVisible.value = false;
      isMarkerOriginVisible.value = false;
      isMarkerDestinationVisible.value = false;
      isPinLocationWaitingForDriverHide.value = false;
    }

    if ([2, 3, 4].contains(state.value)) {
      isDriverToOriginDirectionVisible.value = true;
      isOriginToDestinationDirectionVisible.value = true;
      isMarkerDriverVisible.value = true;
      isMarkerOriginVisible.value = true;
      isMarkerDestinationVisible.value = false;
      isPinLocationWaitingForDriverHide.value = true;
    }

    if ([5, 6, 7, 8].contains(state.value)) {
      isDriverToOriginDirectionVisible.value = false;
      isOriginToDestinationDirectionVisible.value = true;
      isMarkerDriverVisible.value = true;
      isMarkerOriginVisible.value = true;
      isMarkerDestinationVisible.value = true;
      isPinLocationWaitingForDriverHide.value = true;
    }
  }

  Future<void> checkReceiveInvoice() async {
    if (orderRideDetail.value.state == 7 || orderRideDetail.value.state == 8) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.currentRoute != Routes.RIDE_ORDER_DONE &&
            Get.currentRoute != Routes.HOME) {
          Get.offAndToNamed(
            Routes.RIDE_ORDER_DONE,
            arguments: {
              "order_id": orderId.value,
              "order_type": orderType.value,
            },
          );
        }
      });
    }
  }

  Future<void> checkOrderHasBeenCancelled() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (orderRideDetail.value.state == 10) {
        Get.back();
        SnackbarHelper.showSnackbarError(
          text: languageServices.language.value.orderHasBeenCancelled ?? "-",
        );
      }
    });
  }

  Future<void> checkNumberOfPushRoundsHasExceeded() async {
    await measureTime(
      "[Essentials] Get Order Ride Detail & Get Order Ride Server Detail",
      () => Future.wait([getOrderRideDetail(), getOrderRideServerDetail()]),
    );

    await checkOrderHasBeenCancelled();
  }

  Future<void> updateDriverPositionReducedPolyline() async {
    var closestPointIndex = getClosestPointIndex(
      LatLng(
        double.parse(driverLatitude.value),
        double.parse(driverLongitude.value),
      ),
      polylinesCoordinate,
    );

    var closestIndex = closestPointIndex['index'];
    var minDistance = closestPointIndex['min_distance'];
    var threshold = 30.0;

    this.distanceFromNearestRoute.value = minDistance;

    if (minDistance < threshold && closestIndex > 0) {
      polylinesCoordinate.value = polylinesCoordinate.sublist(closestIndex);

      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: PolylineId("updated_polyline"),
          color: Color(0XFF4DABF5),
          width: 5,
          points: polylinesCoordinate,
        ),
      );
    }
  }

  Future<void> updateDriverPositionReroutingOffRoute() async {
    var distanceFromRoute = getDistanceFromRoute(
      LatLng(
        double.parse(driverLatitude.value),
        double.parse(driverLongitude.value),
      ),
      polylinesCoordinate,
    );

    this.distanceFromRoute.value = distanceFromRoute;

    if (distanceFromRoute > 50) {
      if ([2, 3, 4].contains(state.value)) {
        await getAllRoutingCache(forceUpdateDriverToOrigin: true);
        await setupAllRouting();
      }

      if ([5, 6, 7, 8].contains(state.value)) {
        await getAllRoutingCache(forceUpdateDriverToDestination: true);
        await setupAllRouting();
      }
    }
  }

  String driverWaitingTimeDuration() {
    final duration = Duration(
      seconds: driverArrivedOriginWaitingTimeSeconds.value,
    );

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int secs = duration.inSeconds.remainder(60);

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (hours > 0) {
      return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(secs)}";
    } else {
      return "${twoDigits(minutes)}:${twoDigits(secs)}";
    }
  }
}

enum MovementDirection { vertical, horizontal }
