import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../controllers/deposit_balance_controller.dart';

class DepositBalanceView extends GetView<DepositBalanceController> {
  const DepositBalanceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.languageServices.language.value.topupBalance ?? "-",
            style: controller.typographyServices.bodyLargeBold.value,
          ),
          centerTitle: true,
          backgroundColor: Color(0XFFF7F7F7),
          surfaceTintColor: Color(0XFFF7F7F7),
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        controller.themeColorServices.neutralsColorGrey0.value,
                    border: Border.all(
                      color: controller
                          .themeColorServices
                          .neutralsColorGrey300
                          .value,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: controller
                            .themeColorServices
                            .overlayDark200
                            .value
                            .withValues(alpha: 0.3),
                        blurRadius: 32,
                        spreadRadius: -6,
                        offset: Offset(0, -1),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_back.svg",
                          width: 18,
                          height: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color(0XFFF7F7F7),
        body: controller.isFetch.value
            ? Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: controller.themeColorServices.primaryBlue.value,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/img_background_balance.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .myBalance1 ??
                                  "-",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey0
                                        .value,
                                  ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(controller.userInfo.value.balance),
                              style: controller
                                  .typographyServices
                                  .headingMediumBold
                                  .value
                                  .copyWith(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey0
                                        .value,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller
                                    .languageServices
                                    .language
                                    .value
                                    .pleaseSelect ??
                                "-",
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
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        addAutomaticKeepAlives: true,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.recommendationAmountList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2 / 1,
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          return Obx(
                            () => GestureDetector(
                              onTap: () {
                                if (controller
                                        .selectedRecommendationAmount
                                        .value ==
                                    controller
                                        .recommendationAmountList[index]) {
                                  controller
                                          .selectedRecommendationAmount
                                          .value =
                                      0;
                                } else {
                                  controller
                                      .selectedRecommendationAmount
                                      .value = controller
                                      .recommendationAmountList[index];
                                  controller.formGroup.control("money").value =
                                      NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: '',
                                        decimalDigits: 0,
                                      ).format(
                                        controller
                                            .recommendationAmountList[index],
                                      );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      controller
                                              .selectedRecommendationAmount
                                              .value ==
                                          controller
                                              .recommendationAmountList[index]
                                      ? null
                                      : Border.all(color: Color(0XFFB3B3B3)),
                                  color:
                                      controller
                                              .selectedRecommendationAmount
                                              .value ==
                                          controller
                                              .recommendationAmountList[index]
                                      ? controller
                                            .themeColorServices
                                            .primaryBlue
                                            .value
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp',
                                      decimalDigits: 0,
                                    ).format(
                                      controller
                                          .recommendationAmountList[index],
                                    ),
                                    style: controller
                                        .typographyServices
                                        .bodySmallRegular
                                        .value
                                        .copyWith(
                                          fontWeight:
                                              controller
                                                      .selectedRecommendationAmount
                                                      .value ==
                                                  controller
                                                      .recommendationAmountList[index]
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                          color:
                                              controller
                                                      .selectedRecommendationAmount
                                                      .value ==
                                                  controller
                                                      .recommendationAmountList[index]
                                              ? controller
                                                    .themeColorServices
                                                    .neutralsColorGrey0
                                                    .value
                                              : controller
                                                    .themeColorServices
                                                    .neutralsColorGrey600
                                                    .value,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(height: 0, color: Color(0XFFE1E1E1)),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ReactiveForm(
                        formGroup: controller.formGroup,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller
                                      .languageServices
                                      .language
                                      .value
                                      .enterAmount ??
                                  "-",
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
                            SizedBox(height: 8),
                            ReactiveTextField(
                              formControlName: 'money',
                              keyboardType: TextInputType.number,
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value,
                              textAlign: TextAlign.left,
                              onChanged: (control) {
                                controller.selectedRecommendationAmount.value =
                                    0;
                              },
                              inputFormatters: [
                                CurrencyTextInputFormatter.currency(
                                  locale: 'id_ID',
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              validationMessages: {
                                ValidationMessage.required: (error) =>
                                    'Wajib diisi',
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 12,
                                ),

                                suffix: SizedBox(width: 12),
                                hintText:
                                    controller
                                        .languageServices
                                        .language
                                        .value
                                        .numberOfRefill ??
                                    "-",
                                hintStyle: controller
                                    .typographyServices
                                    .bodySmallRegular
                                    .value
                                    .copyWith(color: Color(0XFFB3B3B3)),
                                errorStyle: controller
                                    .typographyServices
                                    .bodySmallRegular
                                    .value
                                    .copyWith(
                                      color: controller
                                          .themeColorServices
                                          .sematicColorRed500
                                          .value,
                                    ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed500
                                        .value,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: controller
                                        .themeColorServices
                                        .sematicColorRed500
                                        .value,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey400
                                        .value,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: controller
                                        .themeColorServices
                                        .neutralsColorGrey400
                                        .value,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: controller
                                        .themeColorServices
                                        .primaryBlue
                                        .value,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: 12),
                                    Text(
                                      "Rp",
                                      style: controller
                                          .typographyServices
                                          .bodySmallBold
                                          .value
                                          .copyWith(
                                            color: controller
                                                .themeColorServices
                                                .neutralsColorGrey600
                                                .value,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "${controller.languageServices.language.value.minimumTopupBalance10000!} ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(controller.firebaseRemoteConfigServices.remoteConfig.getInt("user_deposit_min"))}",
                              style: controller
                                  .typographyServices
                                  .bodySmallRegular
                                  .value
                                  .copyWith(color: Color(0XFFB3B3B3)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
        bottomNavigationBar: BottomAppBar(
          height: 78,
          color: Color(0XFFF7F7F7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 46,
                width: MediaQuery.of(context).size.width,
                child: LoaderElevatedButton(
                  onPressed: () async {
                    await controller.onTapSubmit();
                  },
                  child: Text(
                    controller.languageServices.language.value.refillNow ?? "-",
                    style: controller.typographyServices.bodyLargeBold.value
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
