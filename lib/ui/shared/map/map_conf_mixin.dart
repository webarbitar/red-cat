import 'dart:ui' as ui;
import 'package:flutter/services.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/* ============= Map LatLng Bound ============= */
// final LatLngBounds mapBound = LatLngBounds(
//   northeast: const LatLng(30.4473898, 88.20182969999999),
//   southwest: const LatLng(26.3473741, 80.05846980000001),
// );
/* ============= Map [Min,Max] Zoom Level ============= */
const mapZoom = MinMaxZoomPreference(8, 18);
const onboardMapZoom = MinMaxZoomPreference(15, 18);

mixin MapConfig {
  Future<BitmapDescriptor> getMapDescriptorFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    final byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    final unit8List = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(unit8List);
  }

  // // Api to fetch polyline from [Pickup] and [Destination]
  // Future<PolylineResult> getPolylineBetweenCoordinates(LatLng c1, LatLng c2) async {
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   final result = await polylinePoints.getRouteBetweenCoordinates(
  //     "AIzaSyAFihH7hgmV-3u7P1Zv0sIWNBtro8AlbnI",
  //     PointLatLng(c1.latitude, c1.longitude),
  //     PointLatLng(c2.latitude, c2.longitude),
  //   );
  //   return result;
  // }
  //
  // List<LatLng> parsePointLatLng(List<PointLatLng> data) {
  //   return data.map((e) => LatLng(e.latitude, e.longitude)).toList();
  // }
}
