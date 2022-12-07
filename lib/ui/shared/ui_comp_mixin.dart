import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/loader_widget.dart';

mixin UiCompMixin {
  final busyNfy = ValueNotifier(false);

  Widget buildLabel(String label, {TextStyle? style}) {
    return Text(
      label,
      style: style ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.3,
            color: Colors.black54,
          ),
    );
  }

  void loaderModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoaderWidget();
      },
    );
  }

  void showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void showSuccessMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
}
