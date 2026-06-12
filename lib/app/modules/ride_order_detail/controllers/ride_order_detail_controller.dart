import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/data/models/advanced_booking_model.dart';
import 'package:new_evmoto_user/app/data/models/driver_nearby_model.dart';
import 'package:new_evmoto_user/app/data/models/evmoto_order_chat_messages_model.dart';
import 'package:new_evmoto_user/app/data/models/evmoto_order_chat_participants_model.dart';
import 'package:new_evmoto_user/app/data/models/open_map_direction_model.dart'
    as direction_model;
import 'package:new_evmoto_user/app/data/models/order_ride_model.dart';
import 'package:new_evmoto_user/app/data/models/order_ride_server_model.dart';
import 'package:new_evmoto_user/app/data/models/socket_driver_position_data_model.dart';
import 'package:new_evmoto_user/app/repositories/advance_booking_repository.dart';
import 'package:new_evmoto_user/app/repositories/driver_nearby_repository.dart';
import 'package:new_evmoto_user/app/repositories/open_maps_repository.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';
import 'package:new_evmoto_user/app/services/sendbird_chat_services.dart';
import 'package:new_evmoto_user/app/services/socket_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/services/user_services.dart';

import 'package:new_evmoto_user/app/utils/google_maps_helper.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:new_evmoto_user/app/utils/time_process_helper.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class RideOrderDetailController extends GetxController {
  final OrderRideRepository orderRideRepository;
  final OpenMapsRepository openMapsRepository;
  final DriverNearbyRepository driverNearbyRepository;
  final AdvanceBookingRepository advanceBookingRepository;

  RideOrderDetailController({
    required this.orderRideRepository,
    required this.openMapsRepository,
    required this.driverNearbyRepository,
    required this.advanceBookingRepository,
  });

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final languageServices = Get.find<LanguageServices>();

  final sendbirdChatServices = Get.find<SendbirdChatServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();
  final socketServices = Get.find<SocketServices>();

  final userServices = Get.find<UserServices>();

  final initialCameraPosition = CameraPosition(
    target: LatLng(-6.1744651, 106.822745),
    zoom: 14,
  ).obs;
  final googleMapController = Completer<GoogleMapController>();

  final polylines = <Polyline>{}.obs;
  final polylinesCoordinate = <LatLng>[].obs;

  final driverLatitude = "".obs;
  final driverLongitude = "".obs;

  final orderRideDetail = OrderRide().obs;
  final orderRideServerDetail = OrderRideServer().obs;
  final orderId = "".obs;
  final orderType = 0.obs;

  Timer? driverCurrentLocationTimer;
  Timer? refocusMapBoundsTimer;

  final isPinLocationWaitingForDriverHide = true.obs;
  final isSchedulerDriverCurrentLocationIsProcess = false.obs;

  final driverToOriginDirection = direction_model.OpenMapDirection().obs;
  final driverToDestinationDirection = direction_model.OpenMapDirection().obs;
  final originToDestinationDirection = direction_model.OpenMapDirection().obs;

  final isDriverToOriginDirectionVisible = true.obs;
  final isDriverToDestinationDirectionVisible = true.obs;
  final isOriginToDestinationDirectionVisible = true.obs;
  final isMarkerDriverVisible = true.obs;
  final isMarkerOriginVisible = true.obs;
  final isMarkerDestinationVisible = true.obs;

  final state = 0.obs;
  final previousState = 0.obs;

  final isGoogleMapControllerCreated = false.obs;

  final totalUnreadMessageCount = 0.obs;
  final isFetchTotalUnreadMessageCount = false.obs;

  Timer? allSchedulerTimer;

  final driverNearbyList = <DriverNearby>[].obs;
  final nearestDistanceDriverNearby = 0.0.obs;
  final markers = <MarkerId, Marker>{}.obs;
  Timer? driverNearbyTimer;

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

  final socketDriverPositionData = SocketDriverPositionData().obs;

  StreamSubscription? streamEvmotoOrderChatMessages;
  StreamSubscription? streamEvmotoOrderChatParticipants;

  final evmotoOrderChatParticipants = EvmotoOrderChatParticipants().obs;
  final evmotoOrderChatMessagesList = <EvmotoOrderChatMessages>[].obs;
  final isUnreadChatExist = false.obs;

  final isCriticalError = false.obs;
  final isFetch = false.obs;

  final totalRetryFailed = 0.obs;

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

      await Future.wait([checkOrderHasBeenCancelled()]);

      await updateVisibility();

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

    allSchedulerTimer = Timer.periodic(Duration(seconds: 5), (value) async {
      if (totalRetryFailed.value >= 5) {
        Get.back();
        SnackbarHelper.showSnackbarError(
          text: languageServices.language.value.retryFailedSnackbar ?? "-",
        );
      }

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
            totalRetryFailed.value = 0;
          } catch (e) {
            totalRetryFailed.value += 1;
          }
        }
      } else {
        totalRetryFailed.value = 0;
      }

      if ([1].contains(state.value)) {
        await getDriverNearByList();
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

    enableDriverNearbyTimer();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();

    await streamEvmotoOrderChatParticipants?.cancel();
    await streamEvmotoOrderChatMessages?.cancel();
    await setChatOffline();

    try {
      (await googleMapController.future).dispose();
    } catch (e) {}
    try {
      driverCurrentLocationTimer?.cancel();
    } catch (e) {}
    try {
      refocusMapBoundsTimer?.cancel();
    } catch (e) {}
    try {
      allSchedulerTimer?.cancel();
    } catch (e) {}
    try {
      driverWaitingTimer?.cancel();
    } catch (e) {}

    try {
      disableDriverNearbyTimer();
    } catch (e) {}
  }

  Future<void> refreshAll() async {
    // markers.clear();
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
    await (await googleMapController.future).animateCamera(
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
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(64, 106)),
          'assets/icons/icon_driver.png',
        ),
        anchor: Offset(0.5, 0.5),
      );
      upsertMarker(markerId: markerId, newMarker: newMarker);

      markerId = MarkerId("appointment_origin");
      newMarker = Marker(
        markerId: markerId,
        position: LatLng(
          orderRideDetail.value.startLat!,
          orderRideDetail.value.startLon!,
        ),
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(33, 39)),
          'assets/icons/icon_pinpoint_map_green.png',
        ),
        anchor: Offset(0.5, 0.5),
        visible: true,
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

      if (isClosed) return;
      await (await googleMapController.future).animateCamera(
        CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
      );
    } else {}
  }

  Future<void> setupGoogleMapOriginToDestination() async {
    if (isClosed) return;
    polylines.clear();

    var markerId = MarkerId("appointment_origin");
    var newMarker = Marker(
      markerId: markerId,
      position: LatLng(
        orderRideDetail.value.startLat!,
        orderRideDetail.value.startLon!,
      ),
      icon: await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(33, 39)),
        'assets/icons/icon_pinpoint_map_green.png',
      ),
      visible: false,
      anchor: Offset(0.5, 0.5),
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);
    markerId = MarkerId("origin");
    newMarker = Marker(
      markerId: MarkerId("origin"),
      position: LatLng(
        orderRideDetail.value.startLat!,
        orderRideDetail.value.startLon!,
      ),
      icon: await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(33, 39)),
        'assets/icons/icon_pinpoint_map_green.png',
      ),
      anchor: Offset(0.5, 0.5),
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);

    markerId = MarkerId("destination");
    newMarker = Marker(
      markerId: markerId,
      position: LatLng(
        orderRideDetail.value.endLat!,
        orderRideDetail.value.endLon!,
      ),
      icon: await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(33, 39)),
        'assets/icons/icon_pinpoint_map_red.png',
      ),
      anchor: Offset(0.5, 0.5),
    );
    upsertMarker(markerId: markerId, newMarker: newMarker);

    markerId = MarkerId("driver_current_location");
    newMarker = Marker(
      markerId: markerId,
      position: LatLng(
        double.parse(driverLatitude.value),
        double.parse(driverLongitude.value),
      ),
      icon: await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(64, 106)),
        'assets/icons/icon_driver.png',
      ),
      anchor: Offset(0.5, 0.5),
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

    if (isClosed) return;
    await (await googleMapController.future).animateCamera(
      CameraUpdate.newLatLngBounds(bounds, Get.width * 0.3),
    );
  }

  void upsertMarker({required Marker newMarker, required MarkerId markerId}) {
    markers[markerId] = newMarker;
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
          icon: await BitmapDescriptor.asset(
            ImageConfiguration(size: Size(64, 106)),
            'assets/icons/icon_driver.png',
          ),
          anchor: Offset(0.5, 0.5),
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
          icon: await BitmapDescriptor.asset(
            ImageConfiguration(size: Size(64, 106)),
            'assets/icons/icon_driver.png',
          ),
          anchor: Offset(0.5, 0.5),
        );
        upsertMarker(markerId: markerId, newMarker: newMarker);

        markerId = MarkerId("appointment_origin");
        newMarker = Marker(
          markerId: markerId,
          position: LatLng(
            orderRideDetail.value.startLat!,
            orderRideDetail.value.startLon!,
          ),
          icon: await BitmapDescriptor.asset(
            ImageConfiguration(size: Size(33, 39)),
            'assets/icons/icon_pinpoint_map_green.png',
          ),
          anchor: Offset(0.5, 0.5),
          visible: true,
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

        if (isClosed) return;
        await (await googleMapController.future).animateCamera(
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
          icon: await BitmapDescriptor.asset(
            ImageConfiguration(size: Size(64, 106)),
            'assets/icons/icon_driver.png',
          ),
          anchor: Offset(0.5, 0.5),
        );
        upsertMarker(markerId: markerId, newMarker: newMarker);

        markerId = MarkerId("destination");
        newMarker = Marker(
          markerId: markerId,
          position: LatLng(
            orderRideDetail.value.endLat!,
            orderRideDetail.value.endLon!,
          ),
          icon: await BitmapDescriptor.asset(
            ImageConfiguration(size: Size(33, 39)),
            'assets/icons/icon_pinpoint_map_red.png',
          ),
          anchor: Offset(0.5, 0.5),
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

        if (isClosed) return;
        await (await googleMapController.future).animateCamera(
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
      if (isClosed) return;
      await (await googleMapController.future).animateCamera(
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

      if (isClosed) return;
      if (movementDirection == MovementDirection.vertical) {
        var padding = 0.0;

        var distanceInMeters = Geolocator.distanceBetween(
          originLatitude,
          originLongitude,
          destinationLatitude,
          destinationLongitude,
        );

        if (distanceInMeters <= 1000) {
          padding = 80.0 * 2;
        } else {
          padding = 50.0 * 3.5;
        }

        await (await googleMapController.future).animateCamera(
          CameraUpdate.newLatLngBounds(bounds, padding),
        );
      } else {
        var padding = 0.0;

        var distanceInMeters = Geolocator.distanceBetween(
          originLatitude,
          originLongitude,
          destinationLatitude,
          destinationLongitude,
        );

        if (distanceInMeters <= 1000) {
          padding = 80.0;
        } else {
          padding = 50.0;
        }

        await (await googleMapController.future).animateCamera(
          CameraUpdate.newLatLngBounds(bounds, padding),
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

      if (isClosed) return;
      if (movementDirection == MovementDirection.vertical) {
        var padding = 0.0;

        var distanceInMeters = Geolocator.distanceBetween(
          originLatitude,
          originLongitude,
          destinationLatitude,
          destinationLongitude,
        );

        if (distanceInMeters <= 1000) {
          padding = 80.0 * 2;
        } else {
          padding = 50.0 * 3.5;
        }

        await (await googleMapController.future).animateCamera(
          CameraUpdate.newLatLngBounds(bounds, padding),
        );
      } else {
        var padding = 0.0;

        var distanceInMeters = Geolocator.distanceBetween(
          originLatitude,
          originLongitude,
          destinationLatitude,
          destinationLongitude,
        );

        if (distanceInMeters <= 1000) {
          padding = 80.0;
        } else {
          padding = 50.0;
        }

        await (await googleMapController.future).animateCamera(
          CameraUpdate.newLatLngBounds(bounds, padding),
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
                                  var activeAdvanceBooking =
                                      await getActiveAdvanceBooking();
                                  var isAdvanceBooking = false;
                                  if (activeAdvanceBooking?.orderId ==
                                      orderRideDetail.value.orderId) {
                                    isAdvanceBooking = true;
                                  }

                                  if (isAdvanceBooking == true) {
                                    await advanceBookingRepository
                                        .cancelAdvanceBooking(
                                          bookingId: activeAdvanceBooking!.id!,
                                        );
                                  } else {
                                    await orderRideRepository.cancelOrderRide(
                                      orderId: orderId.value,
                                      orderType: orderType.value,
                                      language: languageServices
                                          .languageCodeSystem
                                          .value,
                                      reason: null,
                                      remark: null,
                                    );
                                  }

                                  Get.close(1);
                                  Get.back();
                                  SnackbarHelper.showSnackbarSuccess(
                                    text:
                                        languageServices
                                            .language
                                            .value
                                            .snackbarCancelTransactionSuccess ??
                                        "-",
                                  );
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
    if (socketDriverPositionData.value.reservationTime != null) {
      int jam =
          double.parse(socketDriverPositionData.value.reservationTime!) ~/ 60;
      int menit =
          (double.parse(socketDriverPositionData.value.reservationTime!) % 60)
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
        (double.parse(socketDriverPositionData.value.laveTime ?? "0.0") % 60)
            .round();
    var estimatedArrived = now.add(Duration(minutes: menit));
    var formattedTime = DateFormat('HH:mm').format(estimatedArrived);
    return formattedTime;
  }

  // Driver Nearby
  Future<void> getDriverNearByList() async {
    driverNearbyList.value = await driverNearbyRepository.getDriverNearbyList(
      lat: orderRideDetail.value.startLat,
      lon: orderRideDetail.value.startLon,
    );

    if (driverNearbyList.isEmpty) {
      nearestDistanceDriverNearby.value = 0.0;
    } else {
      var nearestDistanceDriverNearby = 0.0;

      for (var driverNearby in driverNearbyList) {
        if (nearestDistanceDriverNearby == 0.0) {
          nearestDistanceDriverNearby = driverNearby.distance ?? 0.0;
        } else {
          if ((driverNearby.distance ?? 0.0) < nearestDistanceDriverNearby) {
            nearestDistanceDriverNearby = driverNearby.distance ?? 0.0;
          }
        }
      }

      this.nearestDistanceDriverNearby.value = nearestDistanceDriverNearby;
    }
  }

  Future<void> refreshMarkerDriverNearby() async {
    if (orderRideDetail.value.state == 1) {
      await getDriverNearByList();
    } else {
      driverNearbyList.value = [];
    }

    for (var driverNearby in driverNearbyList) {
      var markerId = MarkerId("driver_nearby_${driverNearby.driverId}");
      // var widgetBitmapDescriptor =
      //     await DriverNearbyPositionWidget(
      //       driverNearby: driverNearby,
      //     ).toMarkerBitmap(
      //       navigatorKey.currentContext!,
      //       logicalSize: Size(64, 106),
      //     );
      var markerDriverNearby = Marker(
        markerId: markerId,
        position: LatLng(driverNearby.lat!, driverNearby.lon!),
        // icon: widgetBitmapDescriptor,
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(64, 106)),
          'assets/icons/icon_driver.png',
        ),
        anchor: Offset(0.5, 0.5),
        visible: true,
      );
      markers[markerId] = markerDriverNearby;
    }

    var removedMarkerIdList = <MarkerId>[];
    for (var markerId in markers.keys) {
      var isExist = false;
      for (var driverNearby in driverNearbyList) {
        if (markerId.value == "driver_nearby_${driverNearby.driverId}") {
          isExist = true;
        }
      }

      if ([
        "driver",
        "origin",
        "destination",
        "driver_current_location",
        "appointment_origin",
      ].contains(markerId.value)) {
        isExist = true;
      }

      if (isExist == false) {
        // var widgetBitmapDescriptor =
        //     await DriverNearbyPositionWidget(
        //       driverNearby: DriverNearby(),
        //     ).toMarkerBitmap(
        //       navigatorKey.currentContext!,
        //       logicalSize: Size(64, 106),
        //     );
        // var markerDriverNearby = Marker(
        //   markerId: markerId,
        //   position: LatLng(0.0, 0.0),
        //   // icon: widgetBitmapDescriptor,
        //   icon: await BitmapDescriptor.asset(
        //     ImageConfiguration(size: Size(64, 106)),
        //     'assets/icons/icon_driver.png',
        //   ),
        //   anchor: Offset(0.5, 0.5),
        //   visible: false,
        // );
        removedMarkerIdList.add(markerId);
        // markers[markerId] = markerDriverNearby;
      }
    }

    for (var removedMarkerId in removedMarkerIdList) {
      markers.remove(removedMarkerId);
    }

    markers.refresh();
  }

  void enableDriverNearbyTimer() {
    driverNearbyTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await refreshMarkerDriverNearby();
    });
  }

  void disableDriverNearbyTimer() {
    driverNearbyTimer?.cancel();
  }

  // orderRideDetail
  Future<void> getOrderRideDetail() async {
    orderRideDetail.value = (await orderRideRepository
        .getOrderRideDetailbyOrderId(
          orderId: orderId.value,
          orderType: orderType.value,
        ));
    state.value = orderRideDetail.value.state ?? 0;
    await updateVisibility();

    if (orderRideDetail.value.driverArrivedOriginAt != null) {
      driverArrivedOriginAt.value = DateTime.parse(
        orderRideDetail.value.driverArrivedOriginAt!.replaceFirst(' ', 'T'),
      );
    }

    await Future.wait([
      refreshMarkerDriverNearby(),
      // getTotalUnreadSendbirdChat(),
    ]);
    if (orderRideDetail.value.driverId == 0 ||
        orderRideDetail.value.state == 11 ||
        orderRideDetail.value.state == 0) {
      this.evmotoOrderChatParticipants.value = EvmotoOrderChatParticipants();
    }
    if (evmotoOrderChatParticipants.value.userId !=
            orderRideDetail.value.userId.toString() &&
        evmotoOrderChatParticipants.value.driverId !=
            orderRideDetail.value.driverId.toString() &&
        evmotoOrderChatParticipants.value.orderId !=
            orderRideDetail.value.orderId.toString()) {
      await getExistingChatRoom();
      // if (evmotoOrderChatParticipants.value.docId == null) {
      //   await userCreateChatRoom();
      // }
      await setChatOnline();
      await streamExistingChatRoom();
      await streamExistingChatList();
    }
  }

  Future<void> refreshChatRoom() async {
    if (orderRideDetail.value.driverId == 0 ||
        orderRideDetail.value.state == 11 ||
        orderRideDetail.value.state == 0) {
      this.evmotoOrderChatParticipants.value = EvmotoOrderChatParticipants();
    }
    if (evmotoOrderChatParticipants.value.userId !=
            orderRideDetail.value.userId.toString() &&
        evmotoOrderChatParticipants.value.driverId !=
            orderRideDetail.value.driverId.toString() &&
        evmotoOrderChatParticipants.value.orderId !=
            orderRideDetail.value.orderId.toString()) {
      await getExistingChatRoom();
      if (evmotoOrderChatParticipants.value.docId != null) {
        // if (evmotoOrderChatParticipants.value.docId == null) {
        //   await userCreateChatRoom();
        // }
        await setChatOnline();
        await streamExistingChatRoom();
        await streamExistingChatList();
      }
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
              direction_model.OpenMapDirection.fromJson(
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
              direction_model.OpenMapDirection.fromJson(
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
    //   originToDestinationDirection.value = direction_model
    //       .OpenMapDirection.fromJson(jsonDecode(originToDestinationCache));
    // }
  }

  // markers
  Future<void> setupAllMarkers() async {
    if ([1].contains(state.value)) {
      // markers.clear();
    }

    if ([2, 3, 4].contains(state.value)) {
      var driverMarkerId = MarkerId("driver");
      var driverNewMarker = Marker(
        markerId: driverMarkerId,
        position: LatLng(
          double.parse(driverLatitude.value),
          double.parse(driverLongitude.value),
        ),
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(64, 106)),
          'assets/icons/icon_driver.png',
        ),
        anchor: Offset(0.5, 0.5),
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
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(33, 39)),
          'assets/icons/icon_pinpoint_map_green.png',
        ),
        anchor: Offset(0.5, 0.5),
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
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(64, 106)),
          'assets/icons/icon_driver.png',
        ),
        anchor: Offset(0.5, 0.5),
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
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(33, 39)),
          'assets/icons/icon_pinpoint_map_green.png',
        ),
        anchor: Offset(0.5, 0.5),
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
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(33, 39)),
          'assets/icons/icon_pinpoint_map_red.png',
        ),
        anchor: Offset(0.5, 0.5),
        visible: isMarkerDestinationVisible.value,
      );
      upsertMarker(
        markerId: destinationMarkerId,
        newMarker: destinationNewMarker,
      );
    }
  }

  // (await googleMapController.future)
  Future<void> updateCameraAutoFocus() async {
    // waiting driver accept
    if ([1].contains(state.value)) {
      if (isClosed) return;
      await (await googleMapController.future).animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            orderRideDetail.value.startLat!,
            orderRideDetail.value.startLon!,
          ),
          16,
        ),
      );
    }

    var driverLatitude = (double.tryParse(this.driverLatitude.value) ?? 0.0)
        .toInt();
    var driverLongitude = (double.tryParse(this.driverLongitude.value) ?? 0.0)
        .toInt();

    if (driverLatitude != 0 && driverLongitude != 0) {
      // driver to origin
      if ([2, 3, 4].contains(state.value)) {
        LatLngBounds bounds;

        var originLatitude = double.parse(this.driverLatitude.value);
        var originLongitude = double.parse(this.driverLongitude.value);
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

        if (isClosed) return;
        if (movementDirection == MovementDirection.vertical) {
          var padding = 0.0;

          var distanceInMeters = Geolocator.distanceBetween(
            originLatitude,
            originLongitude,
            destinationLatitude,
            destinationLongitude,
          );

          if (distanceInMeters <= 1000) {
            padding = 80.0 * 2;
          } else {
            padding = 50.0 * 3.5;
          }

          await (await googleMapController.future).animateCamera(
            CameraUpdate.newLatLngBounds(bounds, padding),
          );
        } else {
          var padding = 0.0;

          var distanceInMeters = Geolocator.distanceBetween(
            originLatitude,
            originLongitude,
            destinationLatitude,
            destinationLongitude,
          );

          if (distanceInMeters <= 1000) {
            padding = 80.0;
          } else {
            padding = 50.0;
          }

          await (await googleMapController.future).animateCamera(
            CameraUpdate.newLatLngBounds(bounds, padding),
          );
        }
      }

      // driver to destination
      if ([5, 6, 7, 8].contains(state.value)) {
        LatLngBounds bounds;

        var originLatitude = double.parse(this.driverLatitude.value);
        var originLongitude = double.parse(this.driverLongitude.value);
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

        if (isClosed) return;
        if (movementDirection == MovementDirection.vertical) {
          var padding = 0.0;

          var distanceInMeters = Geolocator.distanceBetween(
            originLatitude,
            originLongitude,
            destinationLatitude,
            destinationLongitude,
          );

          if (distanceInMeters <= 1000) {
            padding = 80.0 * 2;
          } else {
            padding = 50.0 * 3.5;
          }

          await (await googleMapController.future).animateCamera(
            CameraUpdate.newLatLngBounds(bounds, padding),
          );
        } else {
          var padding = 0.0;

          var distanceInMeters = Geolocator.distanceBetween(
            originLatitude,
            originLongitude,
            destinationLatitude,
            destinationLongitude,
          );

          if (distanceInMeters <= 1000) {
            padding = 80.0;
          } else {
            padding = 50.0;
          }

          await (await googleMapController.future).animateCamera(
            CameraUpdate.newLatLngBounds(bounds, padding),
          );
        }
      }
    } else {
      if ([2, 3, 4, 5, 6, 7, 8].contains(state.value)) {
        LatLngBounds bounds;

        var originLatitude = orderRideDetail.value.startLat!;
        var originLongitude = orderRideDetail.value.startLon!;
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

        if (isClosed) return;
        if (movementDirection == MovementDirection.vertical) {
          var padding = 0.0;

          var distanceInMeters = Geolocator.distanceBetween(
            originLatitude,
            originLongitude,
            destinationLatitude,
            destinationLongitude,
          );

          if (distanceInMeters <= 1000) {
            padding = 80.0 * 2;
          } else {
            padding = 50.0 * 3.5;
          }

          await (await googleMapController.future).animateCamera(
            CameraUpdate.newLatLngBounds(bounds, padding),
          );
        } else {
          var padding = 0.0;

          var distanceInMeters = Geolocator.distanceBetween(
            originLatitude,
            originLongitude,
            destinationLatitude,
            destinationLongitude,
          );

          if (distanceInMeters <= 1000) {
            padding = 80.0;
          } else {
            padding = 50.0;
          }

          await (await googleMapController.future).animateCamera(
            CameraUpdate.newLatLngBounds(bounds, padding),
          );
        }
      }
    }
  }

  // polylines & polylinesCoordinate
  Future<void> setupAllRouting() async {
    polylines.clear();
    polylinesCoordinate.clear();

    var driverLatitude = (double.tryParse(this.driverLatitude.value) ?? 0.0)
        .toInt();
    var driverLongitude = (double.tryParse(this.driverLongitude.value) ?? 0.0)
        .toInt();

    if (driverLatitude != 0 && driverLongitude != 0) {
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
  }

  // driverLatitude & driverLongitude & markers
  Future<void> handleSocketDriverPosition({
    required SocketDriverPositionData socketDriverPositionData,
  }) async {
    this.driverLatitude.value = socketDriverPositionData.lat.toString();
    this.driverLongitude.value = socketDriverPositionData.lon.toString();

    this.socketDriverPositionData.value = socketDriverPositionData;

    var driverLatitude = (double.tryParse(this.driverLatitude.value) ?? 0.0)
        .toInt();
    var driverLongitude = (double.tryParse(this.driverLongitude.value) ?? 0.0)
        .toInt();

    if (driverLatitude != 0 && driverLongitude != 0) {
      var markerId = MarkerId("driver");
      var newMarker = Marker(
        markerId: markerId,
        position: LatLng(
          double.parse(this.driverLatitude.value),
          double.parse(this.driverLongitude.value),
        ),
        icon: await BitmapDescriptor.asset(
          ImageConfiguration(size: Size(64, 106)),
          'assets/icons/icon_driver.png',
        ),
        anchor: Offset(0.5, 0.5),
        visible: isMarkerDriverVisible.value,
      );
      upsertMarker(markerId: markerId, newMarker: newMarker);
      await updateDriverPositionReducedPolyline();
      await updateDriverPositionReroutingOffRoute();
      await updateCameraAutoFocus();
    }
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
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
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
    var driverLatitude = (double.tryParse(this.driverLatitude.value) ?? 0.0)
        .toInt();
    var driverLongitude = (double.tryParse(this.driverLongitude.value) ?? 0.0)
        .toInt();

    if (driverLatitude != 0 && driverLongitude != 0) {
      var closestPointIndex = getClosestPointIndex(
        LatLng(
          double.parse(this.driverLatitude.value),
          double.parse(this.driverLongitude.value),
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
  }

  Future<void> updateDriverPositionReroutingOffRoute() async {
    var driverLatitude = (double.tryParse(this.driverLatitude.value) ?? 0.0)
        .toInt();
    var driverLongitude = (double.tryParse(this.driverLongitude.value) ?? 0.0)
        .toInt();

    if (driverLatitude != 0 && driverLongitude != 0) {
      var distanceFromRoute = getDistanceFromRoute(
        LatLng(
          double.parse(this.driverLatitude.value),
          double.parse(this.driverLongitude.value),
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

  Future<void> getTotalUnreadSendbirdChat() async {
    totalUnreadMessageCount.value = 0;
    if (sendbirdChatServices.isSuccessInitialize.value == true) {
      if (isFetchTotalUnreadMessageCount.value == false) {
        isFetchTotalUnreadMessageCount.value = true;
        var query = GroupChannelListQuery();
        var channelList = await query.next();

        for (var channel in channelList) {
          var isUser = false;
          var isDriver = false;
          for (var member in channel.members) {
            if (member.userId == "user_${orderRideDetail.value.userId}") {
              isUser = true;
            }

            if (member.userId == "driver_${orderRideDetail.value.driverId}") {
              isDriver = true;
            }
          }
          if (isUser == true && isDriver == true) {
            totalUnreadMessageCount.value += channel.unreadMessageCount;
          }
        }
        isFetchTotalUnreadMessageCount.value = false;
      }
    }
  }

  // Chat Room
  Future<void> streamExistingChatRoom() async {
    await streamEvmotoOrderChatParticipants?.cancel();
    if (evmotoOrderChatParticipants.value.docId != null) {
      streamEvmotoOrderChatParticipants = FirebaseFirestore.instance
          .collection('evmoto_order_chat_participants')
          .doc(evmotoOrderChatParticipants.value.docId)
          .snapshots()
          .listen((snapshots) {
            evmotoOrderChatParticipants.value =
                EvmotoOrderChatParticipants.fromJson(snapshots.data() ?? {});
            evmotoOrderChatParticipants.value.docId = snapshots.id;
          });
    }
  }

  Future<void> getExistingChatRoom() async {
    var result =
        (await FirebaseFirestore.instance
                .collection('evmoto_order_chat_participants')
                .where(
                  "orderId",
                  isEqualTo: orderRideDetail.value.orderId.toString(),
                )
                .where(
                  "userId",
                  isEqualTo: orderRideDetail.value.userId.toString(),
                )
                .where(
                  "driverId",
                  isEqualTo: orderRideDetail.value.driverId.toString(),
                )
                .orderBy("createdAt", descending: true)
                .get())
            .docs;

    if (result.isNotEmpty) {
      this.evmotoOrderChatParticipants.value =
          EvmotoOrderChatParticipants.fromJson(result.first.data());
      this.evmotoOrderChatParticipants.value.docId = result.first.id;
    } else {
      this.evmotoOrderChatParticipants.value = EvmotoOrderChatParticipants();
    }
  }

  Future<void> userCreateChatRoom() async {
    if (orderRideDetail.value.userId != null &&
        orderRideDetail.value.driverId != null &&
        orderRideDetail.value.driverId != 0 &&
        orderRideDetail.value.orderId != null) {
      var evmotoOrderChatParticipantsList =
          (await FirebaseFirestore.instance
                  .collection('evmoto_order_chat_participants')
                  .where(
                    "orderId",
                    isEqualTo: orderRideDetail.value.orderId.toString(),
                  )
                  .where(
                    "userId",
                    isEqualTo: orderRideDetail.value.userId.toString(),
                  )
                  .where(
                    "driverId",
                    isEqualTo: orderRideDetail.value.driverId.toString(),
                  )
                  .get())
              .docs;

      if (evmotoOrderChatParticipantsList.isEmpty) {
        var data = {
          "orderId": orderRideDetail.value.orderId.toString(),
          "userId": orderRideDetail.value.userId.toString(),
          "userName": orderRideDetail.value.user,
          "userProfileUrl": orderRideDetail.value.userHeadImg,
          "driverId": orderRideDetail.value.driverId.toString(),
          "driverName": orderRideDetail.value.driverName,
          "driverProfileUrl": orderRideDetail.value.driverAvatar,
          "createdAt": FieldValue.serverTimestamp(),
        };

        await getExistingChatRoom();
        if (evmotoOrderChatParticipants.value.docId == null) {
          await FirebaseFirestore.instance
              .collection('evmoto_order_chat_participants')
              .add(data);
          await getExistingChatRoom();
        }
      }
    }
  }

  Future<void> setChatOnline() async {
    await setChatOffline();

    if (orderRideDetail.value.driverId != null &&
        orderRideDetail.value.driverId != 0) {
      final batch = FirebaseFirestore.instance.batch();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('evmoto_order_chat_participants')
          .where('orderId', isEqualTo: orderRideDetail.value.orderId.toString())
          .where('userId', isEqualTo: orderRideDetail.value.userId.toString())
          .where(
            'driverId',
            isEqualTo: orderRideDetail.value.driverId.toString(),
          )
          .get();

      for (var doc in querySnapshot.docs) {
        batch.set(doc.reference, {
          "userId": orderRideDetail.value.userId.toString(),
          "userName": userServices.userInfo.value.name,
          "userProfileUrl": userServices.userInfo.value.avatar,
          "userIsOnline": true,
          "userLastSeen": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      await batch.commit();
    }
  }

  Future<void> setChatOffline() async {
    if (evmotoOrderChatParticipants.value.docId != null) {
      final batch = FirebaseFirestore.instance.batch();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('evmoto_order_chat_participants')
          .where('orderId', isEqualTo: orderRideDetail.value.orderId.toString())
          .get();

      for (var doc in querySnapshot.docs) {
        batch.set(doc.reference, {
          "userId": orderRideDetail.value.userId.toString(),
          "userName": userServices.userInfo.value.name,
          "userProfileUrl": userServices.userInfo.value.avatar,
          "userIsOnline": false,
          "userLastSeen": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      await batch.commit();
    }
  }

  Future<void> streamExistingChatList() async {
    await streamEvmotoOrderChatMessages?.cancel();
    if (evmotoOrderChatParticipants.value.docId != null) {
      streamEvmotoOrderChatMessages = FirebaseFirestore.instance
          .collection('evmoto_order_chat_messages')
          .where(
            'evmotoOrderChatParticipantsDocumentId',
            isEqualTo: evmotoOrderChatParticipants.value.docId,
          )
          .orderBy('createdAt', descending: false)
          .snapshots()
          .listen((snapshots) async {
            isUnreadChatExist.value = false;
            var evmotoOrderChatMessagesList = <EvmotoOrderChatMessages>[];
            for (var doc in snapshots.docs) {
              var evmotoOrderChatMessages = EvmotoOrderChatMessages.fromJson(
                doc.data(),
              );
              evmotoOrderChatMessages.evmotoOrderChatMessagesId = doc.id;
              evmotoOrderChatMessagesList.add(evmotoOrderChatMessages);
            }
            this.evmotoOrderChatMessagesList.value =
                evmotoOrderChatMessagesList;

            for (var message in evmotoOrderChatMessagesList) {
              if (message.senderType == "driver") {
                if (message.isRead == false) {
                  isUnreadChatExist.value = true;
                }
              }
            }
          });
    }
  }

  Future<AdvancedBooking?> getActiveAdvanceBooking() async {
    var advanceBooking = advanceBookingRepository.getActiveAdvanceBooking();
    return advanceBooking;
  }
}

enum MovementDirection { vertical, horizontal }
