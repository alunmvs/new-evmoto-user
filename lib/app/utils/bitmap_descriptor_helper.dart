import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BitmapDescriptorHelper {
  static Future<BitmapDescriptor> getBitmapDescriptorFromSvgAsset(
    String assetName, [
    Size size = const Size(48, 48),
  ]) async {
    final pictureInfo = await vg.loadPicture(SvgAssetLoader(assetName), null);

    int width = size.width.toInt();
    int height = size.height.toInt();

    final scaleFactor = math.min(
      width / pictureInfo.size.width,
      height / pictureInfo.size.height,
    );

    final recorder = ui.PictureRecorder();

    ui.Canvas(recorder)
      ..scale(scaleFactor)
      ..drawPicture(pictureInfo.picture);

    final rasterPicture = recorder.endRecording();

    final image = rasterPicture.toImageSync(width, height);
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;

    return BitmapDescriptor.bytes(bytes.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> getBitmapDescriptorFromPngAsset(
    String assetName, [
    Size size = const Size(48, 48),
  ]) async {
    final byteData = await rootBundle.load(assetName);
    final bytes = byteData.buffer.asUint8List();

    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: size.width.toInt(),
      targetHeight: size.height.toInt(),
    );

    final frame = await codec.getNextFrame();
    final resizedBytes = (await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();

    return BitmapDescriptor.bytes(resizedBytes);
  }
}
