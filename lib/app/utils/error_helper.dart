import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:new_evmoto_user/app/services/language_services.dart';

String generateErrorMessageDioException({required DioException dioException}) {
  var languageServices = Get.find<LanguageServices>();

  var errorMessage = languageServices.language.value.thereErrorSystem ?? "-";

  if (dioException.type == DioExceptionType.connectionError) {
    errorMessage = languageServices.language.value.networkUnreachable ?? "-";
    return errorMessage;
  }

  if (dioException.type == DioExceptionType.connectionTimeout ||
      dioException.type == DioExceptionType.sendTimeout ||
      dioException.type == DioExceptionType.receiveTimeout) {
    errorMessage = languageServices.language.value.connectionTimeout ?? "-";
    return errorMessage;
  }

  if (dioException.response?.data?['msg'] != null) {
    errorMessage = dioException.response?.data?['msg'];
  }

  return errorMessage;
}

String generateErrorMessageException({required Exception exception}) {
  var languageServices = Get.find<LanguageServices>();

  var errorMessage = languageServices.language.value.thereErrorSystem ?? "-";

  if (exception.toString().toLowerCase().contains("connection failed")) {
    errorMessage = languageServices.language.value.networkUnreachable ?? "-";
  }

  return errorMessage;
}
