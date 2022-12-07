class LoginModel {
  String mobile;
  String otp;
  String fcmToken;

  LoginModel({required this.mobile, this.otp = "", this.fcmToken = ""});

  Map<String, String> otpMap() {
    return {"mobile": mobile};
  }

  Map<String, String> loginMap() {
    return {
      "mobile": mobile,
      "otp": otp,
      "fcm_token":fcmToken,
    };
  }
}
