import '../../enum/api_status.dart';
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

  UserModel? get user => _user;

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
}
