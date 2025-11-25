import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
            ),
            child: SvgPicture.asset(
              "assets/logos/logo_evmoto.svg",
              width: 63.86,
              height: 19.77,
            ),
          ),
          centerTitle: true,
          backgroundColor: controller.themeColorServices.primaryBlue.value,
        ),
        backgroundColor: controller.themeColorServices.neutralsColorGrey0.value,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0XFF0060C6), Color(0XFF004084)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 1.0],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey0
                            .value,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Siap jalan? tentukan tujuanmu",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey600
                                        .value,
                                  ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: controller
                                  .themeColorServices
                                  .neutralsColorGrey100
                                  .value,
                              border: Border.all(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey300
                                    .value,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_pinpoint.svg",
                                  width: 18,
                                  height: 21,
                                ),
                                SizedBox(width: 11),
                                Text(
                                  "Mau kemana hari ini?",
                                  style: controller
                                      .typographyServices
                                      .bodyLargeBold
                                      .value,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SizedBox(width: 16),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey200
                                          .value,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_home.svg",
                                        width: 12,
                                        height: 12,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Tambah Rumah",
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
                                SizedBox(width: 16),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey200
                                          .value,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_office.svg",
                                        width: 12,
                                        height: 12,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Tambah Kantor",
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
                                SizedBox(width: 16),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey200
                                          .value,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/icon_office.svg",
                                        width: 12,
                                        height: 12,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Tambah Kantor",
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
                                SizedBox(width: 16),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Divider(
                            height: 0,
                            color: controller
                                .themeColorServices
                                .neutralsColorGrey100
                                .value,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 104 / (97 + 20),
                  ),
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 10),
                            AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey200
                                        .value,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_ride.svg",
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Antar",
                                      style: controller
                                          .typographyServices
                                          .bodySmallBold
                                          .value,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0XFF8FD9FA),
                                    Color(0XFFA1E2FB),
                                    Color(0XFFB5ECFC),
                                    Color(0XFFC2F2FD),
                                    Color(0XFFC6F4FD),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                border: Border.all(
                                  color: controller
                                      .themeColorServices
                                      .sematicColorBlue200
                                      .value,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Diskon 50%",
                                style: controller
                                    .typographyServices
                                    .captionSmallBold
                                    .value
                                    .copyWith(
                                      color: controller
                                          .themeColorServices
                                          .sematicColorBlue500
                                          .value,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 10),
                            AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey200
                                        .value,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_delivery_package.svg",
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Paket",
                                      style: controller
                                          .typographyServices
                                          .bodySmallBold
                                          .value,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey0
                                    .value,
                                border: Border.all(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey200
                                      .value,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Segera Hadir",
                                style: controller
                                    .typographyServices
                                    .captionSmallBold
                                    .value
                                    .copyWith(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 10),
                            AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey200
                                        .value,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icon_food.svg",
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Makanan",
                                      style: controller
                                          .typographyServices
                                          .bodySmallBold
                                          .value,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: controller
                                    .themeColorServices
                                    .neutralsColorGrey0
                                    .value,
                                border: Border.all(
                                  color: controller
                                      .themeColorServices
                                      .neutralsColorGrey200
                                      .value,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Segera Hadir",
                                style: controller
                                    .typographyServices
                                    .captionSmallBold
                                    .value
                                    .copyWith(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey200
                          .value,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color(0XFFCFE9FC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/icon_wallet.svg",
                                width: 16,
                                height: 16,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Saldo Kamu",
                                style: controller
                                    .typographyServices
                                    .captionSmallRegular
                                    .value
                                    .copyWith(
                                      color: controller
                                          .themeColorServices
                                          .neutralsColorGrey500
                                          .value,
                                    ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Rp150.000",
                                style: controller
                                    .typographyServices
                                    .bodySmallBold
                                    .value,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 46,
                            height: 36,
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_add_circle.svg",
                                  width: 18,
                                  height: 18,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Topup",
                                  style: controller
                                      .typographyServices
                                      .captionLargeRegular
                                      .value,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 14),
                          SizedBox(
                            width: 46,
                            height: 36,
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/icon_transaction_history.svg",
                                  width: 18,
                                  height: 18,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Riwayat",
                                  style: controller
                                      .typographyServices
                                      .captionLargeRegular
                                      .value,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Promosi hari ini",
                      style: controller.typographyServices.bodyLargeBold.value,
                    ),
                    Text(
                      "Lihat Semua",
                      style: controller.typographyServices.bodySmallBold.value
                          .copyWith(
                            color:
                                controller.themeColorServices.primaryBlue.value,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 155,
                        child: AspectRatio(
                          aspectRatio: 311 / 155,
                          child: Image.asset(
                            "assets/images/img_promo_1.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 155,
                        child: AspectRatio(
                          aspectRatio: 311 / 155,
                          child: Image.asset(
                            "assets/images/img_promo_2.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          height: 64,
          backgroundColor:
              controller.themeColorServices.neutralsColorGrey0.value,
          destinations: [
            Column(
              children: [
                SvgPicture.asset(
                  "assets/icons/icon_home.svg",
                  height: 24,
                  width: 24,
                ),
                SizedBox(height: 8),
                Text(
                  "Beranda",
                  style: controller.typographyServices.captionLargeBold.value
                      .copyWith(
                        color: controller.themeColorServices.primaryBlue.value,
                      ),
                ),
              ],
            ),
            Column(
              children: [
                SvgPicture.asset(
                  "assets/icons/icon_activity.svg",
                  height: 24,
                  width: 24,
                  color:
                      controller.themeColorServices.neutralsColorGrey400.value,
                ),
                SizedBox(height: 8),
                Text(
                  "Aktivitas",
                  style: controller.typographyServices.captionLargeBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey400
                            .value,
                      ),
                ),
              ],
            ),
            Column(
              children: [
                SvgPicture.asset(
                  "assets/icons/icon_account.svg",
                  height: 24,
                  width: 24,
                  color:
                      controller.themeColorServices.neutralsColorGrey400.value,
                ),
                SizedBox(height: 8),
                Text(
                  "Akun",
                  style: controller.typographyServices.captionLargeBold.value
                      .copyWith(
                        color: controller
                            .themeColorServices
                            .neutralsColorGrey400
                            .value,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
