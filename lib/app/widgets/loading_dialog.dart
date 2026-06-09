import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';

class LoadingDialog extends StatelessWidget {
  LoadingDialog({super.key});

  final themeColorServices = Get.find<ThemeColorServices>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              color: Color(0XFFFFFFFF),
              child: SizedBox(
                width: 75,
                height: 75,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: themeColorServices.primaryBlue.value,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
