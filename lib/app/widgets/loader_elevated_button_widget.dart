import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/theme_color_services.dart';

class LoaderElevatedButton extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onPressed;
  final Color? buttonColor;
  final BorderSide? borderSide;
  final bool? isWidthFitToContent;
  final EdgeInsetsGeometry? padding;
  final bool? isShowLoading;

  LoaderElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.buttonColor,
    this.borderSide,
    this.isWidthFitToContent,
    this.padding,
    this.isShowLoading,
  });

  final themeColorServices = Get.find<ThemeColorServices>();

  final isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    if (isShowLoading == false) {
      return _buildButton(context, showLoadingState: false);
    }

    return Obx(
      () => _buildButton(
        context,
        showLoadingState: true,
        loading: isLoading.value,
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required bool showLoadingState,
    bool loading = false,
  }) {
    return Center(
      child: SizedBox(
        width: showLoadingState
            ? (loading
                  ? 46
                  : isWidthFitToContent == true
                  ? null
                  : MediaQuery.of(context).size.width)
            : (isWidthFitToContent == true
                  ? null
                  : MediaQuery.of(context).size.width),
        height: 46,
        child: ElevatedButton(
          onPressed: onPressed != null
              ? () async {
                  if (!showLoadingState) {
                    await onPressed!();
                    return;
                  }
                  if (isLoading.value == false) {
                    isLoading.value = true;
                    await onPressed!();
                    isLoading.value = false;
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                buttonColor ?? themeColorServices.primaryBlue.value,
            shape: RoundedRectangleBorder(
              borderRadius: showLoadingState && loading
                  ? BorderRadius.circular(9999)
                  : BorderRadius.circular(16),
              side: borderSide ?? BorderSide.none,
            ),
            padding: showLoadingState && loading
                ? EdgeInsets.all(0)
                : padding ?? EdgeInsets.all(0),
          ),
          child: showLoadingState && loading
              ? Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: themeColorServices.neutralsColorGrey0.value,
                    ),
                  ),
                )
              : child,
        ),
      ),
    );
  }
}
