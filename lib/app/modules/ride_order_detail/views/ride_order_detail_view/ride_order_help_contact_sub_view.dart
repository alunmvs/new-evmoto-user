import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/ride_order_detail/controllers/ride_order_detail_controller.dart';
import 'package:new_evmoto_user/app/utils/snackbar_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class RideOrderHelpContactSubView extends GetView<RideOrderDetailController> {
  const RideOrderHelpContactSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              try {
                await controller.onTapOpenGoogleMaps();
              } catch (e) {
                SnackbarHelper.showSnackbarError(
                  text: 'Could not open Google Maps.',
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                boxShadow: [
                  BoxShadow(
                    color: controller.themeColorServices.overlayDark200.value
                        .withValues(alpha: 0.05),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 42 / 2,
                child: SvgPicture.asset(
                  "assets/icons/icon_route.svg",
                  width: 18,
                  height: 18,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  var customerCsWhatsapp = controller
                      .firebaseRemoteConfigServices
                      .remoteConfig
                      .getString("customer_cs_whatsapp");
                  final Uri url = Uri.parse(
                    "https://wa.me/$customerCsWhatsapp",
                  );

                  try {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } catch (e) {
                    SnackbarHelper.showSnackbarSuccess(
                      text:
                          controller
                              .languageServices
                              .language
                              .value
                              .unableOpenWhatsapp ??
                          "-",
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: [
                      BoxShadow(
                        color: controller
                            .themeColorServices
                            .overlayDark200
                            .value
                            .withValues(alpha: 0.05),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 42 / 2,
                    child: SvgPicture.asset(
                      "assets/icons/icon_microphone.svg",
                      width: 16.67,
                      height: 17.38,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri(scheme: 'tel', path: '112');

                  try {
                    await launchUrl(url);
                  } catch (e) {
                    SnackbarHelper.showSnackbarError(
                      text:
                          controller
                              .languageServices
                              .language
                              .value
                              .cantMakeCall ??
                          "-",
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: [
                      BoxShadow(
                        color: controller
                            .themeColorServices
                            .overlayDark200
                            .value
                            .withValues(alpha: 0.05),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 42 / 2,
                    child: Image.asset(
                      "assets/icons/icon_alert.png",
                      width: 18.92,
                      height: 18.92,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 21.66),
        ],
      ),
    );
  }
}
