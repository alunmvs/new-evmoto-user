import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/data/models/socket_driver_position_data_model.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';
import 'package:new_evmoto_user/app/services/typography_services.dart';
import 'package:new_evmoto_user/app/utils/socket_helper.dart';

class SocketServices extends GetxService with WidgetsBindingObserver {
  late Socket socket;
  late Timer? schedulerDataSocketTimer;

  final themeColorServices = Get.find<ThemeColorServices>();
  final typographyServices = Get.find<TypographyServices>();

  final isSocketClose = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setupWebsocket();
    } else if (state == AppLifecycleState.paused) {
      socket.close();
    }
  }

  Future<void> setupWebsocket() async {
    socket = await Socket.connect("api-dev.evmotoapp.com", 8888);
    isSocketClose.value = false;

    socket.listen(
      (data) async {
        var dataJson = convertBytesToJson(bytes: data);
        var method = dataJson['method'] ?? "";

        switch (method) {
          case 'DRIVER_POSITION':
            if (Get.currentRoute == Routes.RIDE_ORDER_DETAIL) {
              var socketDriverPositionDataModel =
                  SocketDriverPositionData.fromJson(dataJson['data']);

              var rideOrderDetailController =
                  Get.find<RideOrderDetailController>();
              if (rideOrderDetailController.driverLatitude.value == "0" &&
                  rideOrderDetailController.driverLongitude.value == "0") {
                rideOrderDetailController.driverLatitude.value =
                    socketDriverPositionDataModel.lat.toString();
                rideOrderDetailController.driverLongitude.value =
                    socketDriverPositionDataModel.lon.toString();
                await Get.find<RideOrderDetailController>().refreshAll();
              } else {
                rideOrderDetailController.driverLatitude.value =
                    socketDriverPositionDataModel.lat.toString();
                rideOrderDetailController.driverLongitude.value =
                    socketDriverPositionDataModel.lon.toString();

                if (rideOrderDetailController.orderRideDetail.value.state ==
                    1) {
                  await Get.find<RideOrderDetailController>().refreshAll();
                }
              }
            }

            break;
          case 'ORDER_STATUS':
            if (Get.currentRoute == Routes.RIDE_ORDER_DETAIL) {
              await Get.find<RideOrderDetailController>().refreshAll();
            }
            break;
          case 'OFFLINE':
            var storage = FlutterSecureStorage();
            await storage.deleteAll();
            await closeWebsocket();

            Get.offAndToNamed(Routes.LOGIN_REGISTER);
            break;
          default:
            break;
        }
        print(dataJson);
      },
      onError: (error) {
        print('Error: $error');
        isSocketClose.value = true;
        socket.destroy();
      },
      onDone: () {
        print('Server closed connection');
        isSocketClose.value = true;
        socket.destroy();
      },
    );

    await schedulerDataSocket();
  }

  Future<void> closeWebsocket() async {
    WidgetsBinding.instance.removeObserver(this);
    await socket.close();
  }

  Future<void> schedulerDataSocket() async {
    await sendHeartBeat();

    schedulerDataSocketTimer = Timer.periodic(Duration(seconds: 5), (
      timer,
    ) async {
      await sendHeartBeat();
    });
  }

  Future<void> sendHeartBeat() async {
    if (isSocketClose.value == false) {
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
          "userId": Get.find<HomeController>().userInfo.value.id,
          "token": "$token",
          "type": 1,
        },
        "method": "PING",
        "code": 200,
        "msg": "SUCCESS",
      };

      socket.add(convertJsonToPacket(dataUser));

      await socket.flush();
    }
  }
}
