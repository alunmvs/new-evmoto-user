import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/activity_detail/controllers/activity_detail_controller.dart';
import 'package:new_evmoto_user/app/widgets/loader_elevated_button_widget.dart';

class ActivityDetailFormRatingReviewSubView
    extends GetView<ActivityDetailController> {
  const ActivityDetailFormRatingReviewSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: controller.themeColorServices.neutralsColorGrey0.value,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: controller.themeColorServices.neutralsColorGrey300.value,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    controller
                            .languageServices
                            .language
                            .value
                            .howTravelExperience ??
                        "-",
                    style: controller.typographyServices.bodyLargeBold.value,
                  ),
                  Text(
                    controller
                            .languageServices
                            .language
                            .value
                            .scoreTravelExperience ??
                        "-",
                    style: controller.typographyServices.bodyLargeBold.value,
                  ),
                  SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4),
                    unratedColor: controller
                        .themeColorServices
                        .neutralsColorSlate100
                        .value,
                    itemBuilder: (context, _) => SizedBox(
                      width: 48,
                      height: 48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/icon_star.svg",
                            width: 39,
                            height: 36,
                            color: controller
                                .themeColorServices
                                .sematicColorYellow400
                                .value,
                          ),
                        ],
                      ),
                    ),
                    onRatingUpdate: (rating) async {
                      controller.rating.value = rating;
                      await controller.getRatingLabelList(
                        rating: rating.toInt(),
                      );
                    },
                    glow: false,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              children: [
                for (var ratingLabel in controller.ratingLabelList) ...[
                  ChoiceChip(
                    selected: ratingLabel.isSelected ?? false,
                    onSelected: (value) {
                      ratingLabel.isSelected = value;
                      controller.ratingLabelList.refresh();
                    },
                    labelPadding: EdgeInsets.all(0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    showCheckmark: false,
                    color: WidgetStatePropertyAll(
                      ratingLabel.isSelected == true
                          ? Color(0XFFEAF4FF)
                          : controller
                                .themeColorServices
                                .neutralsColorGrey0
                                .value,
                    ),
                    side: BorderSide(
                      color: ratingLabel.isSelected == true
                          ? Color(0XFFC2D4E9)
                          : Color(0XFFBFBFBF),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    label: Text(
                      ratingLabel.value ?? "-",
                      style: controller
                          .typographyServices
                          .bodySmallRegular
                          .value
                          .copyWith(
                            color: ratingLabel.isSelected == true
                                ? controller
                                      .themeColorServices
                                      .primaryBlue
                                      .value
                                : Color(0XFF272727),
                          ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 12),
            LoaderElevatedButton(
              child: Text(
                controller.languageServices.language.value.submitReview ?? "-",
                style: controller.typographyServices.bodyLargeBold.value
                    .copyWith(color: Colors.white),
              ),
              onPressed: () async {
                await controller.onTapSubmitAndReview();
              },
            ),
          ],
        ),
      ),
    );
  }
}
