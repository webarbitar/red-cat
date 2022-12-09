import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:ret_cat/core/enum/api_status.dart';
import 'package:ret_cat/core/model/user/user_model.dart';
import 'package:ret_cat/core/utils/storage/storage.dart';
import 'package:ret_cat/core/utils/string_extension.dart';
import 'package:ret_cat/core/view_model/user/user_view_model.dart';
import 'package:ret_cat/ui/shared/ui_comp_mixin.dart';
import 'package:ret_cat/ui/shared/ui_helpers.dart';
import 'package:ret_cat/ui/views/attendance/check_in_check_out_view.dart';
import 'package:ret_cat/ui/views/home/notification_view.dart';
import 'package:ret_cat/ui/widgets/custom/custom_button.dart';

import '../../../core/constance/style.dart';
import '../../../core/view_model/home/home_view_modal.dart';
import '../../widgets/loader_widget.dart';
import '../drawer/drawer_view.dart';

class HomeView extends StatefulWidget {
  final int? pageIndex;

  const HomeView({Key? key, this.pageIndex}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with UiCompMixin {
  late final HomeViewModal _homeViewModal;
  late final UserViewModel _userViewModel;
  String dummyImage =
      "http://webarbiter.in/redcat/public/uploads/checkincheckout/checkin_image_20221205091623.jpg";

  @override
  void initState() {
    super.initState();
    _homeViewModal = context.read<HomeViewModal>();
    _userViewModel = context.read();
    initLocation();
    initHomeModule();
  }

  void initHomeModule() async {
    if (_userViewModel.user?.role == "Supervisor") {
      busyNfy.value = true;
      await _homeViewModal.fetchDashboardCount();
      final res = _userViewModel.fetchSupervisedAttendances(notify: true);
      res.then((value) {
        busyNfy.value = false;
      });
    }
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
            body: ValueListenableBuilder<bool>(
                valueListenable: busyNfy,
                builder: (context, busy, _) {
                  if (busy) {
                    return const Center(
                      child: LoaderWidget(
                        color: primaryColor,
                      ),
                    );
                  }
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
                          decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(0.92),
                          ),
                          child: Consumer2<HomeViewModal, UserViewModel>(
                            builder: (context, model, userModel, _) {
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
                                              showErrorMessage(
                                                  "Attendance for today already submitted");
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
                                    ),
                                    UIHelper.verticalSpaceMedium,
                                    UIHelper.verticalSpaceMedium,
                                    if (userModel.user?.role == "Supervisor")
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          buildLabel("Dashboard",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          UIHelper.verticalSpaceSmall,
                                          LayoutBuilder(builder: (context, constraint) {
                                            double width = constraint.maxWidth / 3 - 8;
                                            return Wrap(
                                              spacing: 12,
                                              runSpacing: 12,
                                              children: [
                                                Container(
                                                  width: width,
                                                  height: 90,
                                                  decoration: BoxDecoration(
                                                      color: Colors.green.shade100,
                                                      borderRadius: BorderRadius.circular(8)),
                                                  padding: const EdgeInsets.all(8),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "${_homeViewModal.dashboard?.dependentUsers}",
                                                        style: GoogleFonts.dosis(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      const Text(
                                                        "User Under Supervision",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: width,
                                                  height: 90,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red.shade100,
                                                      borderRadius: BorderRadius.circular(8)),
                                                  padding: const EdgeInsets.all(8),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "${_homeViewModal.dashboard?.attendenceReports}",
                                                        style: GoogleFonts.dosis(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      const Text(
                                                        "Attendance",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: width,
                                                  height: 90,
                                                  decoration: BoxDecoration(
                                                      color: Colors.yellow.shade200,
                                                      borderRadius: BorderRadius.circular(8)),
                                                  padding: const EdgeInsets.all(8),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "${_homeViewModal.dashboard?.leaves}",
                                                        style: GoogleFonts.dosis(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      const Text(
                                                        "Leave",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                          UIHelper.verticalSpaceMedium,
                                          buildLabel("User Attendances",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          UIHelper.verticalSpaceSmall,
                                          _buildSupervisedUserView(),
                                        ],
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
                }),
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

  _buildSupervisedUserView() {
    return Column(
      children: [
        ..._userViewModel.supUserAttendances.map((data) {
          UserModel user =
              _userViewModel.user!.users.singleWhere((element) => element.id == data.userId);
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.uniqueId,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(user.name.capitalize(),
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
                            data.signInTime,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.signInAddress,
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
                            data.signOutTime,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.signOutAdd,
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
                  onTap: () {
                    _showLogsDialog(data.userId);
                  },
                ),
              ],
            ),
          );
        })
      ],
    );
  }

  void _showLogsDialog(int userId) {
    showDialog(
        context: context,
        builder: (context) {
          return AttendanceLogView(userId: userId);
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class AttendanceLogView extends StatefulWidget {
  final int userId;

  const AttendanceLogView({Key? key, required this.userId}) : super(key: key);

  @override
  State<AttendanceLogView> createState() => _AttendanceLogViewState();
}

class _AttendanceLogViewState extends State<AttendanceLogView> with UiCompMixin {
  @override
  void initState() {
    super.initState();
    busyNfy.value = true;
    context.read<UserViewModel>().fetchAttendanceLogs(widget.userId).then((value) {
      busyNfy.value = false;
      if (value.status != ApiStatus.success) {
        showErrorMessage(value.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0, title: const Text("Attendance Logs")),
      body: ValueListenableBuilder<bool>(
          valueListenable: busyNfy,
          builder: (context, busy, _) {
            if (busy) {
              return const LoaderWidget(color: primaryColor);
            }
            return Consumer<UserViewModel>(builder: (context, model, _) {
              if (model.attendanceLogs.isEmpty) {
                return const Center(child: Text("No logs report found!"));
              }
              return ListView(
                children: [
                  ...model.attendanceLogs.map((data) {
                    return Card(
                      child: ListTile(
                        title: Text(data.location),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              data.dateOfAttendence,
                              style: const TextStyle(
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
              );
            });
          }),
    );
  }
}
