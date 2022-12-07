import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:ret_cat/core/utils/storage/storage.dart';
import 'package:ret_cat/ui/shared/ui_comp_mixin.dart';
import 'package:ret_cat/ui/shared/ui_helpers.dart';
import 'package:ret_cat/ui/views/attendance/check_in_check_out_view.dart';
import 'package:ret_cat/ui/views/home/drawer/drawer_view.dart';
import 'package:ret_cat/ui/views/home/notification_view.dart';
import 'package:ret_cat/ui/widgets/custom/custom_button.dart';

import '../../../core/constance/style.dart';
import '../../../core/view_model/home/home_view_modal.dart';

class HomeView extends StatefulWidget {
  final int? pageIndex;

  const HomeView({Key? key, this.pageIndex}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with UiCompMixin {
  late final HomeViewModal _homeViewModal;
  String dummyImage =
      "http://webarbiter.in/redcat/public/uploads/checkincheckout/checkin_image_20221205091623.jpg";

  @override
  void initState() {
    super.initState();
    _homeViewModal = context.read<HomeViewModal>();

    initLocation();
  }

  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: primaryColor,
        ),
        child: WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationView(),
                        ));
                  },
                  icon: const Icon(Icons.notifications),
                )
              ],
            ),
            drawer: const DrawerView(),
            resizeToAvoidBottomInset: false,
            backgroundColor: backgroundColor,
            body: Builder(
              builder: (context) {
                switch (Storage.instance.role) {
                  case "agent":
                    return _buildAgentView();
                  default:
                    return _buildUserView();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void initLocation() async {
    final modal = context.read<HomeViewModal>();
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.whileInUse && permission != LocationPermission.always) {
      requestBackgroundLocationPermission();
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // Position position = await Geolocator.getCurrentPosition();
  }

  void requestBackgroundLocationPermission() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Background Location Permission",
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Montserrat",
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "We need access to your background location when the app is in closed during check in period. Please enable 'Allow all the time' for location in app settings.",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Montserrat",
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Permission.locationAlways.request();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Update Setting"),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  _buildUserView() {
    return Stack(
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
            child: Consumer<HomeViewModal>(
              builder: (context, model, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.verticalSpaceLarge,
                      Center(
                        child: SizedBox(
                          width: 120,
                          child: CustomButton(
                            text: model.attendanceStatus.isNotEmpty &&
                                    model.attendanceStatus != "checkOut"
                                ? "Check Out"
                                : "Check In",
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            onTap: () {
                              if (model.attendanceStatus != "checkOut") {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CheckInCheckOutView(
                                        type: model.attendanceStatus.isNotEmpty &&
                                                model.attendanceStatus != "checkOut"
                                            ? "checkOut"
                                            : "checkIn"),
                                  ),
                                );
                              } else {
                                showErrorMessage("Attendance for today already submitted");
                              }
                            },
                          ),
                        ),
                      ),
                      UIHelper.verticalSpaceMedium,
                      const Text(
                        "Check In/Out",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: const LinearProgressIndicator(
                          value: 0.5,
                          minHeight: 6,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  _buildAgentView() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ID: REPORT-295834",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text("Piyali Adhikari",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  )),
              UIHelper.verticalSpaceSmall,
              buildLabel(
                'Sign In',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              UIHelper.verticalSpaceSmall,
              Row(
                children: [
                  Image.network(dummyImage, width: 70),
                  UIHelper.horizontalSpaceMedium,
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "3 December,2022",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Barasat City, Barasat, Barasat - I, West Bengal, 700124, India",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              UIHelper.verticalSpaceSmall,
              const Divider(),
              buildLabel(
                'Sign Out',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              UIHelper.verticalSpaceSmall,
              Row(
                children: [
                  Image.network(dummyImage, width: 70),
                  UIHelper.horizontalSpaceMedium,
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "3 December,2022",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Barasat City, Barasat, Barasat - I, West Bengal, 700124, India",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              UIHelper.verticalSpaceMedium,
              CustomButton(
                text: "View Logs",
                onTap: _showLogsDialog,
              ),
            ],
          ),
        )
      ],
    );
  }

  void _showLogsDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(elevation: 0.0, title: const Text("Attendance Logs")),
            body: ListView(
              children: [
                ...List.generate(4, (index) {
                  return const Card(
                    child: ListTile(
                      title: Text("Barasat City, Barasat, Barasat - I, West Bengal, 700124, India"),
                      subtitle: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "3 December,2022 18:11:25",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
