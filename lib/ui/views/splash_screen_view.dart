import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ret_cat/core/view_model/home/home_view_modal.dart';
import 'package:ret_cat/ui/shared/ui_comp_mixin.dart';

import '../../core/constance/style.dart';
import '../../core/enum/api_status.dart';
import '../../core/utils/storage/storage.dart';
import '../../core/view_model/user/user_view_model.dart';
import '../shared/navigation/navigation.dart';
import '../shared/ui_helpers.dart';
import '../widgets/loader_widget.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> with UiCompMixin {
  @override
  void initState() {
    super.initState();
    _initNavigation();
  }

  void _initNavigation() async {
    // Initialize local storage
    await Storage.instance.initializeStorage();
    bool isLogin = Storage.instance.isLogin;
    if (isLogin) {
      if (!mounted) return;
      final res = await context.read<UserViewModel>().fetchUserProfile();
      if (res.status == ApiStatus.success) {
        if (!mounted) return;
        await context.read<HomeViewModal>().checkAttendanceStatus();
        Navigation.instance.navigateAndReplace("/home");
      } else {
        if (res.status == ApiStatus.unauthorized) {
          Navigation.instance.navigateAndRemoveUntil("/login");
        }
        showErrorMessage(res.message);
      }
    } else {
      Navigation.instance.navigateAndRemoveUntil("/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle, boxShadow: [dropShadow]),
              child: const Image(
                image: ResizeImage(AssetImage("assets/images/logo.png"), width: 140),
              ),
            ),
            const SizedBox(height: 120),
            const LoaderWidget(),
          ],
        ),
      ),
    );
  }
}
