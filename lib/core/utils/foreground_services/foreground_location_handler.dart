import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ret_cat/core/services/home/home_service.dart';
import 'package:ret_cat/core/utils/storage/storage.dart';
import 'package:ret_cat/core/view_model/home/home_view_modal.dart';

class ForegroundLocationHandler extends TaskHandler {
  Timer? _timer;
  SendPort? _sendPort;
  HomeService? _homeService;

  @override
  Future<void> onDestroy(DateTime? timestamp, SendPort? sendPort) async {
    log("Foreground location is destroy");
    _timer?.cancel();
    _sendPort = null;
    await FlutterForegroundTask.clearAllData();
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;
  }

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;
    _homeService = HomeService();
    await Storage.instance.initializeStorage();
    updateUserLocation();
  }

  @override
  void onButtonPressed(String id) {
    if (id == "stopButton") {
      FlutterForegroundTask.stopService();
    }
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp();
    _sendPort?.send('onNotificationPressed');
  }

  void updateUserLocation() {
    Position pos;
    String address = "N/A";
    _timer = Timer.periodic(const Duration(minutes: 15), (Timer t) async {
      pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        forceAndroidLocationManager: true,
      );
      address = await HomeViewModal().fetchAddressFromGeocode(LatLng(pos.latitude, pos.longitude));
      _homeService!.updateUserLocation({
        'address': address,
        'lat': "${pos.latitude}",
        'lng': '${pos.longitude}',
      });
    });
  }

  String _formatSecondToHms(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
