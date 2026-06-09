import 'package:get/get.dart';
import '../services/language_services.dart';

String getEstimatedTimeInMinutesInText({
  required double estimatedTimeInMinutes,
}) {
  var languageServices = Get.find<LanguageServices>();

  int jam = estimatedTimeInMinutes ~/ 60;
  int menit = (estimatedTimeInMinutes % 60).round();

  if (jam > 0) {
    return '$jam ${languageServices.language.value.hour} $menit ${languageServices.language.value.minute}';
  } else {
    return '$menit ${languageServices.language.value.minute}';
  }
}
