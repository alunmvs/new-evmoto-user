import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';

class ApiServices extends GetxService {
  final Dio dio = Dio();

  @override
  Future<void> onInit() async {
    super.onInit();
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          if (response.data != null) {
            if (response.data is Map<String, dynamic>) {
              if (response.data['code'] == 600) {
                var storage = FlutterSecureStorage();
                await storage.deleteAll();
                Get.offAllNamed(Routes.LOGIN_REGISTER);
              }
            }
          }

          return handler.next(response);
        },
      ),
    );
  }
}
