import '../../model/response_model.dart';
import '../../model/user/auth/registration_modal.dart';
import '../../services/user/user_service.dart';
import '../base_view_model.dart';

class AuthViewModel extends BaseViewModel {
  late UserService _userService;

  set userService(UserService value) {
    _userService = value;
  }

  bool isLogin = true;

  // Future<ResponseModel> sendRegisterOtp(UserRegistrationModel modal) async {
  //   isLogin = false;
  //   _registrationModal = modal;
  //   final res = _userService.sendRegisterOtp(modal.otpMap());
  //   return res;
  // }

  // Future<ResponseModel> sendLoginOtp(LoginModel modal) async {
  //   isLogin = true;
  //   _loginModal = modal;
  //   final res = _userService.sendLoginOtp(modal.otpMap());
  //   return res;
  // }
  //

  Future<ResponseModel> loginUser(String phone, String password) async {
    final res = _userService.loginUser({'phone': phone, 'password': password});
    return res;
  }

  Future<ResponseModel> registerUser(RegistrationModel data) async {
    final res = _userService.registerUser(data.registerMap());
    return res;
  }
}
