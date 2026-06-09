import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/account/views/account_view/account_logout_sub_view.dart';
import 'package:new_evmoto_user/app/modules/account/views/account_view/account_menu_section_1_sub_view.dart';
import 'package:new_evmoto_user/app/modules/account/views/account_view/account_menu_section_2_sub_view.dart';
import 'package:new_evmoto_user/app/modules/account/views/account_view/account_user_info_sub_view.dart';
import 'package:new_evmoto_user/app/modules/home/controllers/home_controller.dart';
import 'package:new_evmoto_user/app/routes/app_pages.dart';
import 'package:new_evmoto_user/app/widgets/advanced_booking_expired_dialog.dart';
import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0XFFFFFFFF), Color(0XFFCDE2F8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
          ),
          RefreshIndicator(
            color: controller.themeColorServices.primaryBlue.value,
            backgroundColor:
                controller.themeColorServices.neutralsColorGrey0.value,
            onRefresh: () async {
              await controller.homeController.refreshAll();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AccountUserInfoSubView(),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AccountMenuSection1SubView(),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AccountMenuSection2SubView(),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AccountLogoutSubView(),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
