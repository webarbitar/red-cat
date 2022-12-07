import 'package:flutter/material.dart';

import '../../../core/constance/style.dart';
import '../../shared/ui_helpers.dart';

class PermissionHandlerDialog extends StatefulWidget {
  final String permissionType;
  final VoidCallback onTap;

  const PermissionHandlerDialog({Key? key, required this.permissionType, required this.onTap})
      : super(key: key);

  @override
  State<PermissionHandlerDialog> createState() => _PermissionHandlerDialogState();
}

class _PermissionHandlerDialogState extends State<PermissionHandlerDialog>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UIHelper.verticalSpaceMedium,
                UIHelper.verticalSpaceMedium,
                Image.asset("assets/images/logo.png"),
                UIHelper.verticalSpaceMedium,
                const Text(
                  "Control Your App Permission",
                  style: TextStyle(fontSize: 16, fontFamily: "Montserrat"),
                ),
                UIHelper.verticalSpaceMedium,
                Text(
                  "Socspl required the ${widget.permissionType} permission to continue with the services you requesting.",
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 15,
                    color: Colors.grey,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                UIHelper.verticalSpaceSmall,
                Flexible(
                  child: SizedBox(
                    height: double.maxFinite,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          fixedSize: const Size(double.maxFinite, 45),
                        ),
                        onPressed: widget.onTap,
                        child: const Text(
                          "Grant Permission",
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
