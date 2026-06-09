import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/modules/activity_detail/controllers/activity_detail_controller.dart';

class ActivityDetailRatingReviewSubView
    extends GetView<ActivityDetailController> {
  const ActivityDetailRatingReviewSubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: controller.themeColorServices.neutralsColorGrey0.value,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: controller.themeColorServices.neutralsColorGrey200.value,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.languageServices.language.value.rating ?? "-",
                  style: controller.typographyServices.bodySmallBold.value,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/icons/icon_star.svg",
                            width: 13,
                            height: 12,
                            colorFilter: ColorFilter.mode(
                              controller
                                  .themeColorServices
                                  .sematicColorYellow400
                                  .value,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        controller.orderRideDetail.value.orderScore.toString(),
                        style:
                            controller.typographyServices.bodySmallBold.value,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (controller.ratingLabelList.isNotEmpty) ...[
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                children: [
                  for (var ratingLabel in controller.ratingLabelList) ...[
                    ChoiceChip(
                      selected: true,
                      onSelected: (value) {},
                      labelPadding: EdgeInsets.all(0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      showCheckmark: false,
                      color: WidgetStatePropertyAll(Color(0XFFEAF4FF)),
                      side: BorderSide(color: Color(0XFFC2D4E9)),
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
                              color: controller
                                  .themeColorServices
                                  .primaryBlue
                                  .value,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
