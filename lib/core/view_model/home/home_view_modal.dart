import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ret_cat/core/model/attendance/check_in_out_model.dart';
import 'package:ret_cat/core/model/dashboard/dashboard_model.dart';
import 'package:ret_cat/core/model/leave/leave_application_mode.dart';

import '../../../ui/shared/navigation/navigation.dart';
import '../../../ui/views/auth/permission_handler_page.dart';
import '../../enum/api_status.dart';
import '../../model/address/geocode_address.dart';
import '../../model/notification/notification_model.dart';
import '../../model/response_model.dart';
import '../../services/home/home_service.dart';
import '../../services/map/map_service.dart';
import '../../utils/foreground_services/foreground_notificaton_handler.dart';
import '../../utils/permission/permission_handler_service.dart';
import '../base_view_model.dart';

class HomeViewModal extends BaseViewModel with PermissionHandlerService {
  late HomeService _homeService;
  late MapService _mapService;

  set homeService(HomeService value) {
    _homeService = value;
  }

  set mapService(MapService value) {
    _mapService = value;
  }

  DashboardModel? _dashboard;

  List<NotificationModel> _notifications = [];

  String _attendanceStatus = "";

  String currentAddress = "";

  LatLng? currentLatLng;

  List<LeaveApplicationModel> _leaveApplications = [];

  late PermissionStatus _permissionStatus = PermissionStatus.denied;

  final StreamController<String> _timerController = StreamController.broadcast();

  Timer? _timer;

  static const _setting = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 20,
    timeLimit: Duration(seconds: 10),
  );

  DashboardModel? get dashboard => _dashboard;

  Timer? get timer => _timer;

  Stream<String> get timerStream => _timerController.stream;

  List<NotificationModel> get notifications => _notifications;

  List<LeaveApplicationModel> get leaveApplications => _leaveApplications;

  String get attendanceStatus => _attendanceStatus;

  set attendanceStatus(String value) {
    _attendanceStatus = value;
    notifyListeners();
  }

  void initLocationStartTimer() {
    int second = const Duration(minutes: 5).inSeconds;
    print(second);
    _timerController.sink.add("");
    try {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (second != 0) {
          int min = (second ~/ 60).remainder(60);
          int sec = second.remainder(60);
          _timerController.sink.add("${"$min".padLeft(2, '0')}:${"$sec".padLeft(2, '0')}");
          second--;
        } else {
          _timer?.cancel();
          _timerController.sink.add("00:00");
          _timer = null;
        }
      });
    } catch (e) {
      _timer?.cancel();
      _timer = null;
    }
  }

  Future<ResponseModel> checkAttendanceStatus() async {
    final res = await _homeService.checkAttendanceStatus();
    if (res.status == ApiStatus.success) {
      if (res.message == "Checked In") {
        _attendanceStatus = "checkIn";
      } else if (res.message == "Checked Out") {
        _attendanceStatus = "checkOut";
      } else {
        _attendanceStatus = "";
      }
    } else {
      _attendanceStatus = "";
    }
    notifyListeners();
    return res;
  }

  Future<ResponseModel> fetchDashboardCount() async {
    final res = await _homeService.fetchDashboardCount();
    if (res.status == ApiStatus.success) {
      _dashboard = res.data;
      notifyListeners();
    }
    return res;
  }

  Future<ResponseModel> fetchNotifications() async {
    final res = await _homeService.fetchNotifications();
    if (res.status == ApiStatus.success) {
      _notifications = res.data!;
      notifyListeners();
    }
    return res;
  }

  Future<void> fetchLocation(LatLng latLng, {bool notify = false}) async {
    final res = await fetchAddressFromGeocode(latLng);
    currentLatLng = latLng;
    currentAddress = res;
    // if (res.status == ApiStatus.success) {
    //   currentAddress = res.data!.displayName;
    //   // Check city availability
    // }
  }

  Future<void> _checkLocationPermission() async {
    _permissionStatus = await requestLocationPermission(false);
    if (_permissionStatus.isDenied || _permissionStatus.isPermanentlyDenied) {
      await Navigation.instance.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => PermissionHandlerDialog(
            permissionType: "location",
            onTap: () async {
              _permissionStatus = await requestLocationPermission(true);
              if (_permissionStatus.isGranted || _permissionStatus.isLimited) {
                Navigation.instance.goBack();
              }
              notifyListeners();
            },
          ),
        ),
      );
    }
  }

  Future<void> initLocationListener() async {
    Geolocator.getPositionStream(locationSettings: _setting).listen((pos) {
      currentLatLng = LatLng(pos.latitude, pos.longitude);
    });
  }

  // Future<Position> currentLocation() async {
  //   await _checkLocationPermission();
  //   bool serviceEnabled;
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   return await Geolocator.getCurrentPosition();
  // }

  Future<ResponseModel<GeocodeAddress>> fetchAddressFromGoogleGeocode(LatLng latLng) async {
    final res = await _mapService.fetchAddressFromGeocode(position: latLng);
    return res;
  }

  Future<String> fetchAddressFromGeocode(LatLng latLng) async {
    List<Placemark> placemark = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );
    Placemark place = placemark[0];
    return '${place.name != place.thoroughfare ? place.name : ""} ${place.street}, ${place.subThoroughfare} ${place.thoroughfare} ${place.subLocality}, ${place.locality}, ${place.country}, ${place.postalCode}'
        .trim();
  }

  Future<ResponseModel> checkInCheckOutAttendance(String type,
      {required CheckInOutModel data}) async {
    ResponseModel res;
    if (type == "checkIn") {
      res = await _homeService.checkInAttendance(data);
      if (res.status == ApiStatus.success) {
        ForegroundNotificationHandler.instance.initTrackerService();
        await ForegroundNotificationHandler.instance.startForegroundTask();
      }
    } else {
      res = await _homeService.checkOutAttendance(data);
      if (res.status == ApiStatus.success) {
        ForegroundNotificationHandler.instance.stopForegroundService();
      }
    }
    await checkAttendanceStatus();
    return res;
  }

  Future<ResponseModel> updateUserLocation(Map<String, String> data) async {
    final res = await _homeService.updateUserLocation(data);
    return res;
  }

  Future<ResponseModel> submitLeaveApplication(LeaveApplicationModel data) async {
    final res = await _homeService.submitLeaveApplication(data.toMap());

    return res;
  }

  Future<ResponseModel> fetchSubmittedLeaveApplication() async {
    final res = await _homeService.fetchSubmittedLeaveApplications();
    if (res.status == ApiStatus.success) {
      _leaveApplications = res.data ?? [];
    }
    return res;
  }

  Future<ResponseModel> submitMorningSalesReport(Map<String, String> data) async {
    final res = await _homeService.submitMorningSalesReport(data);

    return res;
  }

  Future<ResponseModel> submitEveningSalesReport(Map<String, String> data) async {
    final res = await _homeService.submitEveningSalesReport(data);

    return res;
  }

  Future<ResponseModel> submitManagementSalesReport(Map<String, String> data) async {
    final res = await _homeService.submitManagementSalesReport(data);

    return res;
  }

  Future<ResponseModel> submitMarketVisit(Map<String, String> data, String image) async {
    final res = await _homeService.submitMarketVisit(data, image);

    return res;
  }
}
