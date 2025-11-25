import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TypographyServices extends GetxService {
  final headingMediumBold = GoogleFonts.nunitoSans(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.2,
    letterSpacing: 0,
  ).obs;

  final bodyLargeBold = GoogleFonts.nunitoSans(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.4,
    letterSpacing: 0,
  ).obs;

  final bodySmallRegular = GoogleFonts.nunitoSans(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.2,
    letterSpacing: 0,
  ).obs;

  final bodySmallBold = GoogleFonts.nunitoSans(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.2,
    letterSpacing: 0,
  ).obs;

  final captionLargeBold = GoogleFonts.nunitoSans(
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 1.2,
    letterSpacing: 0,
  ).obs;

  final captionLargeRegular = GoogleFonts.nunitoSans(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.2,
    letterSpacing: 0,
  ).obs;
}
