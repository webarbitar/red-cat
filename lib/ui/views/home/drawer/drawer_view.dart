import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    return Drawer(
      backgroundColor: primaryColor.shade900,
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
            const ListTile(
              leading: Icon(Icons.assignment),
              title: Text("Attendance"),
            ),
            const ExpansionTile(

              initiallyExpanded: false,
              leading: Icon(Icons.graphic_eq),
              title: Text("Sales Report"),
              children: [
                ListTile(
                  leading: Icon(Icons.circle),
                  title: Text("Morning Report"),
                ),
                ListTile(
                  leading: Icon(Icons.circle),
                  title: Text("Evening Report"),
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
            // const ListTile(
            //   leading: Icon(Icons.people_alt_outlined),
            //   title: Text("About Us"),
            // ),
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
  }
}
