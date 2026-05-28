import 'dart:async';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/evmoto_order_chat_participants_model.dart';
import 'package:new_evmoto_user/app/data/models/socket_driver_position_data_model.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import 'package:new_evmoto_user/app/repositories/order_ride_repository.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/firebase_remote_config_services.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/common_helper.dart';
import 'package:new_evmoto_user/app/utils/socket_helper.dart';
import 'package:new_evmoto_user/app/widgets/driver_cancel_dialog.dart';
import 'package:new_evmoto_user/environment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocketServices extends GetxService {
  late Socket? socket;
  Timer? schedulerDataSocketTimer;

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();
  final firebaseRemoteConfigServices = Get.find<FirebaseRemoteConfigServices>();

  final pingDateTime = DateTime.now().obs;
  final pongDateTime = DateTime.now().obs;

  final pingMs = 0.obs;

  final isSocketClose = true.obs;
  final isProcessConnect = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    Timer.periodic(Duration(seconds: 3), (value) async {
      if (isSocketClose.value == true) {
        var storage = FlutterSecureStorage();
        var token = await storage.read(key: 'token');
        var isUserLogin = token != null && token != "";

        if (isUserLogin) {
          await setupWebsocket();
        }
      }
    });
  }

  Future<void> setupWebsocket() async {
    if (isProcessConnect.value == false) {
      isProcessConnect.value = true;
      try {
        if (socket != null) {
          await socket?.close();
        }
      } catch (e) {}
      socket = null;

      try {
        socket = await Socket.connect(socketUrl, 8888);
        isSocketClose.value = false;

        socket?.listen(
          (data) async {
            var dataJson = convertBytesToJson(bytes: data);
            if (dataJson != null) {
              var method = dataJson['method'] ?? "";
              // print("[DEBUG SOCKET] $dataJson");

              switch (method) {
                case 'DRIVER_POSITION':
                  if (Get.currentRoute == Routes.RIDE_ORDER_DETAIL) {
                    var socketDriverPositionDataModel =
                        SocketDriverPositionData.fromJson(dataJson['data']);

                    var rideOrderDetailController =
                        Get.find<RideOrderDetailController>();
                    await rideOrderDetailController.handleSocketDriverPosition(
                      socketDriverPositionData: socketDriverPositionDataModel,
                    );
                    // if (rideOrderDetailController.driverLatitude.value == "0" &&
                    //     rideOrderDetailController.driverLongitude.value ==
                    //         "0") {
                    //   rideOrderDetailController.driverLatitude.value =
                    //       socketDriverPositionDataModel.lat.toString();
                    //   rideOrderDetailController.driverLongitude.value =
                    //       socketDriverPositionDataModel.lon.toString();
                    //   await Get.find<RideOrderDetailController>().refreshAll();
                    // } else {
                    //   rideOrderDetailController.driverLatitude.value =
                    //       socketDriverPositionDataModel.lat.toString();
                    //   rideOrderDetailController.driverLongitude.value =
                    //       socketDriverPositionDataModel.lon.toString();

                    //   if (rideOrderDetailController
                    //           .orderRideDetail
                    //           .value
                    //           .state ==
                    //       1) {
                    //     await Get.find<RideOrderDetailController>()
                    //         .refreshAll();
                    //   }
                    // }
                  }

                  break;
                case 'ORDER_STATUS':
                  if (Get.currentRoute == Routes.RIDE_ORDER_DETAIL ||
                      Get.currentRoute == Routes.CHAT_DETAIL) {
                    // await Get.find<RideOrderDetailController>().refreshAll();

                    await Get.find<RideOrderDetailController>()
                        .handleSocketOrderStatus();
                  }
                  break;
                case 'OFFLINE':
                  await clearDataLogout();
                  Get.offAllNamed(Routes.LOGIN_REGISTER);
                  break;
                case 'END_PUSH':
                  // if (Get.currentRoute == Routes.RIDE_ORDER_DETAIL) {
                  //   Get.dialog(
                  //     EndPushDialog(
                  //       orderId: dataJson['data']['orderId'],
                  //       orderType: dataJson['data']['orderType'],
                  //     ),
                  //   );
                  // }
                  break;
                case 'DRIVER_CANCEL_POPUP':
                  if (Get.currentRoute == Routes.CHAT_DETAIL) {
                    Get.back();
                  } else if (Get.currentRoute == Routes.RIDE_ORDER_DETAIL) {
                    var rideOrderDetailController =
                        Get.find<RideOrderDetailController>();
                    rideOrderDetailController
                            .evmotoOrderChatParticipants
                            .value =
                        EvmotoOrderChatParticipants();
                    rideOrderDetailController.isUnreadChatExist.value = false;
                    var result = await Get.dialog(
                      DriverCancelDialog(
                        onTapSearchingDriver: () async {
                          var orderRideRepository = OrderRideRepository();
                          var rideOrderDetailController =
                              Get.find<RideOrderDetailController>();
                          await orderRideRepository.driverCancelChoice(
                            orderId: dataJson['data']['orderId'].toString(),
                            orderType: int.tryParse(
                              dataJson['data']['orderType'].toString(),
                            )!,
                            choice: "reassign",
                          );

                          await rideOrderDetailController
                              .handleSocketOrderStatus();
                        },
                      ),
                    );

                    if (result != true) {
                      var orderRideRepository = OrderRideRepository();
                      var rideOrderDetailController =
                          Get.find<RideOrderDetailController>();

                      await orderRideRepository.driverCancelChoice(
                        orderId: dataJson['data']['orderId'].toString(),
                        orderType: int.tryParse(
                          dataJson['data']['orderType'].toString(),
                        )!,
                        choice: "cancel",
                      );

                      await rideOrderDetailController.handleSocketOrderStatus();
                      await rideOrderDetailController
                          .checkOrderHasBeenCancelled();
                    }
                  } else {
                    var result = await Get.dialog(
                      DriverCancelDialog(
                        onTapSearchingDriver: () async {
                          var orderRideRepository = OrderRideRepository();
                          var homeController = Get.find<HomeController>();

                          await orderRideRepository.driverCancelChoice(
                            orderId: dataJson['data']['orderId'].toString(),
                            orderType: int.tryParse(
                              dataJson['data']['orderType'].toString(),
                            )!,
                            choice: "reassign",
                          );

                          await homeController.refreshAll();
                        },
                      ),
                    );

                    if (result != true) {
                      var orderRideRepository = OrderRideRepository();
                      var homeController = Get.find<HomeController>();

                      await orderRideRepository.driverCancelChoice(
                        orderId: dataJson['data']['orderId'].toString(),
                        orderType: int.tryParse(
                          dataJson['data']['orderType'].toString(),
                        )!,
                        choice: "cancel",
                      );

                      await homeController.refreshAll();
                    }
                  }
                  break;
                case 'PONG':
                  pongDateTime.value = DateTime.now();
                  pingMs.value = pongDateTime.value
                      .difference(pingDateTime.value)
                      .inMilliseconds;

                  break;
                default:
                  break;
              }
              // print(dataJson);
            }
          },
          onError: (error) {
            isSocketClose.value = true;
            socket?.destroy();
          },
          onDone: () {
            isSocketClose.value = true;
            socket?.destroy();
          },
        );

        await schedulerDataSocket();
      } catch (e) {
        isSocketClose.value = true;
        // print("[SOCKET DEBUG] Socket did not connect $e");
      }
      isProcessConnect.value = false;
    }
  }

  Future<void> closeWebsocket() async {
    await socket?.close();
    isSocketClose.value = true;
  }

  Future<void> schedulerDataSocket() async {
    if (schedulerDataSocketTimer?.isActive ?? false) {
      return;
    }

    await sendHeartBeat();

    schedulerDataSocketTimer = Timer.periodic(Duration(seconds: 3), (
      timer,
    ) async {
      await sendHeartBeat();
    });
  }

  Future<void> sendHeartBeat() async {
    var prefs = await SharedPreferences.getInstance();

    if (isSocketClose.value == false &&
        (prefs.getBool('home_controller_registered') ?? false)) {
      // print("send heart beat ${DateFormat('HH:mm:ss').format(DateTime.now())}");
      var storage = FlutterSecureStorage();
      var token = await storage.read(key: 'token');

      // var dataUser = {
      //   "code": 200,
      //   "data": {
      //     "token": token,
      //     "type": 1,
      //     "userId": Get.find<HomeController>().userInfo.value.id,
      //   },
      //   "method": "PING",
      //   "msg": "SUCCESS",
      // };

      var dataUser = {
        "data": {
          "userId": Get.find<HomeController>().userServices.userInfo.value.id,
          "token": "$token",
          "type": 1,
        },
        "method": "PING",
        "code": 200,
        "msg": "SUCCESS",
      };
      try {
        // print("[DEBUG SOCKET] PING START");
        socket?.add(convertJsonToPacket(dataUser));
        pingDateTime.value = DateTime.now();
        await socket?.flush();
        // print("[DEBUG SOCKET] PING END");
      } catch (e) {}
    }
  }
}
