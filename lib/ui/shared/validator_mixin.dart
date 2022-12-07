import 'package:flutter/material.dart';

mixin ValidatorMixin {
  String? emptyFieldValidation(data) {
    if (data!.isEmpty) {
      return "* Required";
    }
    return null;
  }

  String? emailValidation(data) {
    final res = emptyFieldValidation(data);
    if (res != null) {
      return res;
    }
    RegExp reg = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!reg.hasMatch(data)) {
      return "Email is invalid";
    }
    return null;
  }

  String? phoneValidation(data) {
    if (data!.length < 9) {
      return "Invalid phone number";
    }
    return null;
  }

  String? passwordValidation(data) {
    if (data!.length < 8) {
      return "Password must be at least 8 characters";
    }
    // RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    // if(!regex.hasMatch(data)){
    //   return "Password is too weak. Use strong password";
    // }
    return null;
  }

  String? confirmPasswordValidation({password, confirmPassword}) {
    String? emptyCheck = emptyFieldValidation(confirmPassword);
    if (emptyCheck != null) {
      return emptyCheck;
    }
    if (password != confirmPassword) {
      return "Password doesn't match";
    }
    return null;
  }
}

// void showErrorMessage(String message) {
//   Fluttertoast.showToast(
//     msg: message,
//     backgroundColor: Colors.red,
//     textColor: Colors.white,
//   );
// }
//
// void showSuccessMessage(String message) {
//   Fluttertoast.showToast(
//     msg: message,
//     backgroundColor: Colors.green,
//     textColor: Colors.white,
//   );
// }


