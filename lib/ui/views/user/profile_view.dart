import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ret_cat/core/enum/api_status.dart';
import 'package:ret_cat/core/utils/string_extension.dart';
import 'package:ret_cat/ui/shared/navigation/navigation.dart';
import 'package:ret_cat/ui/shared/ui_comp_mixin.dart';

import '../../../core/constance/style.dart';
import '../../../core/view_model/user/user_view_model.dart';
import '../../shared/ui_helpers.dart';
import '../../widgets/loader_widget.dart';
import 'profile_update_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with UiCompMixin {
  @override
  void initState() {
    super.initState();
    initProfileModule();
  }

  void initProfileModule() {
    busyNfy.value = true;
    final model = context.read<UserViewModel>();
    final res = model.fetchUserProfile(notify: true);
    res.then((value) {
      busyNfy.value = false;
      if (value.status == ApiStatus.success) {
        showSuccessMessage(value.message);
      } else {
        showErrorMessage(value.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontFamily: "Montserrat",
          ),
        ),
        centerTitle: true,
        elevation: 0.2,
        actions: [
          if (context.watch<UserViewModel>().user != null)
            TextButton(
              onPressed: () {
                Navigation.instance.navigate("/profile-update");
              },
              child: const Text(
                "Edit",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: Center(
              child: Image.asset(
                "assets/images/mcop-logo.png",
                height: 240,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.92),
              ),
              child: Consumer<UserViewModel>(builder: (context, userModel, _) {
                return ValueListenableBuilder(
                    valueListenable: busyNfy,
                    builder: (context, bool busy, _) {
                      if (busy) {
                        return const Center(
                          child: LoaderWidget(color: primaryColor),
                        );
                      }
                      if (userModel.user == null) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              "Profile couldn't be fetch. Please try again",
                              style: TextStyle(fontFamily: "Montserrat", fontSize: 13),
                            ),
                          ),
                        );
                      }
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            UIHelper.verticalSpaceMedium,
                            UIHelper.verticalSpaceSmall,
                            if (userModel.user!.image.isNotEmpty)
                              Container(
                                height: 110,
                                width: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(60),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(-4, -4),
                                      blurRadius: 8,
                                    ),
                                    BoxShadow(
                                      color: Color(0xffd4d4d4),
                                      offset: Offset(4, 4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    userModel.user!.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            else
                              Container(
                                height: 110,
                                width: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(60),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(-4, -4),
                                      blurRadius: 8,
                                    ),
                                    BoxShadow(
                                      color: Color(0xffd4d4d4),
                                      offset: Offset(4, 4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: primaryColor,
                                  size: 40,
                                ),
                              ),
                            UIHelper.verticalSpaceLarge,
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Column(
                                  children: [
                                    buildProfileContainer(
                                      label: "Name",
                                      data: "${userModel.user?.name}",
                                    ),
                                    UIHelper.verticalSpaceSmall,
                                    const Divider(thickness: 2),
                                    UIHelper.verticalSpaceSmall,
                                    buildProfileContainer(
                                      label: "Email",
                                      data: "${userModel.user?.email}",
                                    ),
                                    UIHelper.verticalSpaceSmall,
                                    const Divider(thickness: 2),
                                    UIHelper.verticalSpaceSmall,
                                    buildProfileContainer(
                                      label: "Mobile",
                                      data: "${userModel.user?.phone}",
                                    ),
                                    UIHelper.verticalSpaceSmall,
                                    const Divider(thickness: 2),
                                    UIHelper.verticalSpaceSmall,
                                    buildProfileContainer(
                                      label: "Designation",
                                      data: "${userModel.user?.designation.capitalize()}",
                                    ),
                                    UIHelper.verticalSpaceSmall,
                                    const Divider(thickness: 2),
                                    UIHelper.verticalSpaceSmall,
                                    buildProfileContainer(
                                      label: "State",
                                      data: "${userModel.user?.state.capitalize()}",
                                    ),
                                    UIHelper.verticalSpaceSmall,
                                    const Divider(thickness: 2),
                                    UIHelper.verticalSpaceSmall,
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    });
              }),
            ),
          ),
        ],
      ),
    );
  }

  static buildProfileContainer({String label = "", String data = ""}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: "Montserrat",
            ),
          ),
        ),
        Expanded(
            flex: 2,
            child: Text(
              data,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: "Montserrat",
              ),
            ))
      ],
    );
  }
}
