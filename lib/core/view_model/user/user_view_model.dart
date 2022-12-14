import 'package:ret_cat/core/model/attendance/attendance_model.dart';

import '../../enum/api_status.dart';
import '../../model/attendance/attendance_log_model.dart';
import '../../model/response_model.dart';
import '../../model/user/user_model.dart';
import '../../services/user/user_service.dart';
import '../base_view_model.dart';

class UserViewModel extends BaseViewModel {
  late UserService _userService;

  set userService(UserService value) {
    _userService = value;
  }

  UserModel? _user;

  List<AttendanceModel> _myAttendances = [];

  List<AttendanceModel> _supUserAttendances = [];

  List<AttendanceLogModel> _attendanceLogs = [];

  UserModel? get user => _user;

  List<AttendanceModel> get myAttendances => _myAttendances;

  List<AttendanceModel> get supUserAttendances => _supUserAttendances;

  List<AttendanceLogModel> get attendanceLogs => _attendanceLogs;

  Future<ResponseModel> fetchUserProfile({bool notify = false}) async {
    final res = await _userService.fetchUserProfile();
    if (res.status == ApiStatus.success) {
      _user = res.data;
    }
    if (notify) {
      notifyListeners();
    }
    return res;
  }

  Future<ResponseModel> updateUserProfile(Map<String, String> data, String? image) async {
    final res = await _userService.updateUserProfile(image, data);
    if (res.status == ApiStatus.success) {
      await fetchUserProfile(notify: true);
    }
    return res;
  }

  Future<ResponseModel> fetchMyAttendances({bool notify = false}) async {
    final res = await _userService.fetchMyAttendances();
    if (res.status == ApiStatus.success) {
      _myAttendances = res.data ?? [];
    }
    if (notify) {
      notifyListeners();
    }
    return res;
  }

  Future<ResponseModel> fetchSupervisedAttendances({bool notify = false}) async {
    final res = await _userService.fetchSupervisedAttendances();
    if (res.status == ApiStatus.success) {
      _supUserAttendances = res.data ?? [];
    }
    if (notify) {
      notifyListeners();
    }
    return res;
  }

  Future<ResponseModel> fetchAttendanceLogs(int userId, {bool notify = false}) async {
    final res = await _userService.fetchAttendanceLogs("$userId");
    _attendanceLogs = [];
    if (res.status == ApiStatus.success) {
      _attendanceLogs = res.data ?? [];
    }
    if (notify) {
      notifyListeners();
    }
    return res;
  }

  Future<ResponseModel> changeUserPassword(
      {required String phone, required String password}) async {
    final res = _userService.changeUserPassword({"mobile": phone, "password": password});
    return res;
  }
}
