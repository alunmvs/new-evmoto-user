import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:new_evmoto_user/app/utils/dialog_tags.dart';
import 'package:new_evmoto_user/app/widgets/loading_dialog.dart';

/// Centralized dialog API backed by [flutter_smart_dialog].
///
/// Every dialog must use a [tag] from [DialogTags] so it can be closed
/// precisely with [dismiss] without affecting other overlays.
class DialogHelper {
  DialogHelper._();

  static Future<T?> show<T>({
    required String tag,
    required Widget widget,
    bool barrierDismissible = true,
    bool backDismiss = true,
    bool keepSingle = true,
  }) {
    return SmartDialog.show<T>(
      tag: tag,
      keepSingle: keepSingle,
      builder: (_) => widget,
      clickMaskDismiss: barrierDismissible,
      backType: backDismiss ? SmartBackType.normal : SmartBackType.block,
    );
  }

  static Future<void> showLoading({String tag = DialogTags.loading}) {
    if (exists(tag)) {
      return Future.value();
    }

    return SmartDialog.show(
      tag: tag,
      keepSingle: true,
      builder: (_) => LoadingDialog(),
      clickMaskDismiss: false,
      backType: SmartBackType.block,
    );
  }

  static void dismiss<T>(String tag, {T? result}) {
    SmartDialog.dismiss<T>(tag: tag, result: result);
  }

  static void dismissIfExists<T>(String tag, {T? result}) {
    if (exists(tag)) {
      dismiss<T>(tag, result: result);
    }
  }

  static bool exists(String tag) => SmartDialog.checkExist(tag: tag);

  static void dismissLoading() => dismiss(DialogTags.loading);

  static bool get isLoadingShowing => exists(DialogTags.loading);
}
