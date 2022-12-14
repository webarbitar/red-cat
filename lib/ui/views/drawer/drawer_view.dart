import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ret_cat/core/view_model/user/user_view_model.dart';
import 'package:ret_cat/ui/shared/navigation/navigation.dart';
import 'package:ret_cat/ui/shared/ui_helpers.dart';

import '../../../../core/constance/style.dart';
import '../../../../core/utils/storage/storage.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({Key? key}) : super(key: key);

  @override
  State<DrawerView> createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(builder: (context, model, _) {
      return Drawer(
        backgroundColor: primaryColor.shade600,
        child: Theme(
          data: ThemeData(
            expansionTileTheme: const ExpansionTileThemeData(
              iconColor: backgroundColor,
              textColor: backgroundColor,
              collapsedIconColor: backgroundColor,
              collapsedTextColor: backgroundColor,
            ),
            listTileTheme: const ListTileThemeData(
              iconColor: backgroundColor,
              textColor: backgroundColor,
            ),
          ),
          child: ListView(
            shrinkWrap: false,
            children: [
              DrawerHeader(
                child: Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [dropShadow],
                    ),
                    child: const Image(
                      image: ResizeImage(AssetImage("assets/images/logo.png"), height: 240),
                      height: 120,
                    ),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigation.instance.goBack();
                },
                leading: const Icon(Icons.dashboard),
                title: const Text("Dashboard"),
              ),
              ListTile(
                onTap: () {
                  Navigation.instance.goBack();
                  Navigation.instance.navigate('/profile');
                },
                leading: const Icon(Icons.account_box_outlined),
                title: const Text("Account"),
              ),
              // ListTile(
              //   onTap: () {
              //     Navigation.instance.goBack();
              //     Navigation.instance.navigate('/change-password');
              //   },
              //   leading: const Icon(Icons.lock_reset),
              //   title: const Text("Change Password"),
              // ),
              ListTile(
                onTap: () {
                  Navigation.instance.goBack();
                  Navigation.instance.navigate('/my-attendance');
                },
                leading: const Icon(Icons.assignment),
                title: const Text("Attendance"),
              ),
              ExpansionTile(
                initiallyExpanded: false,
                leading: const Icon(Icons.graphic_eq),
                title: const Text("Sales Report"),
                children: [
                  ListTile(
                    onTap: () {
                      Navigation.instance.goBack();
                      Navigation.instance.navigate("/management-report", args: "SH");
                    },
                    leading: const Icon(
                      Icons.circle_outlined,
                      size: 16,
                    ),
                    title: const Text("SH Sales Report"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigation.instance.goBack();
                      Navigation.instance.navigate("/management-report", args: "ASM");
                    },
                    leading: const Icon(
                      Icons.circle_outlined,
                      size: 16,
                    ),
                    title: const Text("ASM Sales Report"),
                  ),
                  ExpansionTile(
                    initiallyExpanded: false,
                    leading: const FaIcon(FontAwesomeIcons.chartSimple),
                    title: const Text("TL/TSM Sales Report"),
                    children: [
                      ListTile(
                        onTap: () {
                          Navigation.instance.goBack();
                          Navigation.instance.navigate("/morning-report");
                        },
                        leading: const Icon(
                          Icons.circle_outlined,
                          size: 16,
                        ),
                        title: const Text("Morning Report"),
                      ),
                      ListTile(
                        onTap: () {
                          Navigation.instance.goBack();
                          Navigation.instance.navigate("/evening-report");
                        },
                        leading: const Icon(
                          Icons.circle_outlined,
                          size: 16,
                        ),
                        title: const Text("Evening Report"),
                      ),
                    ],
                  ),
                ],
              ),
              ListTile(
                onTap: () {
                  Navigation.instance.goBack();
                  Navigation.instance.navigate('/leave-application');
                },
                leading: const Icon(Icons.contact_mail_outlined),
                title: const Text("Leave Application"),
              ),
              ListTile(
                onTap: () {
                  Navigation.instance.goBack();
                  Navigation.instance.navigate('/market-visit');
                },
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text("Market Visit Photo"),
              ),
              // const ListTile(
              //   leading: Icon(Icons.shield),
              //   title: Text("Privacy Policy"),
              // ),
              // const ListTile(
              //   leading: FaIcon(FontAwesomeIcons.usersGear),
              //   title: Text("Term And Condition"),
              // ),
              ListTile(
                onTap: () {
                  Storage.instance.logout();
                  Navigation.instance.navigateAndRemoveUntil("/login");
                },
                leading: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
                title: const Text("Logout"),
              ),
              UIHelper.verticalSpaceLarge,
              Center(
                child: Column(
                  children: const [
                    Text(
                      "Red Cat",
                      style: TextStyle(
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "v 1.0.0",
                      style: TextStyle(
                        color: backgroundColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
