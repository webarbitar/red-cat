import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ret_cat/core/utils/string_extension.dart';
import 'package:ret_cat/core/view_model/user/user_view_model.dart';
import 'package:ret_cat/ui/shared/ui_comp_mixin.dart';
import 'package:ret_cat/ui/widgets/loader_widget.dart';

import '../../../../core/constance/style.dart';
import '../../../../core/model/user/user_model.dart';
import '../../../shared/ui_helpers.dart';
import '../../../widgets/custom/custom_button.dart';
import '../../home/home_view.dart';

class MyAttendanceView extends StatefulWidget {
  const MyAttendanceView({Key? key}) : super(key: key);

  @override
  State<MyAttendanceView> createState() => _MyAttendanceViewState();
}

class _MyAttendanceViewState extends State<MyAttendanceView> with UiCompMixin {
  // String dummyImage =
  //     "http://webarbiter.in/redcat/public/uploads/checkincheckout/checkin_image_20221205091623.jpg";

  @override
  void initState() {
    super.initState();
    busyNfy.value = true;
    context.read<UserViewModel>().fetchMyAttendances().then((value) {
      busyNfy.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Attendance"),
        elevation: 0.0,
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: ValueListenableBuilder(
          valueListenable: busyNfy,
          builder: (context, busy, _) {
            return Consumer<UserViewModel>(builder: (context, model, _) {
              if (busy) {
                return const Center(
                  child: LoaderWidget(
                    color: primaryColor,
                  ),
                );
              }
              if (model.myAttendances.isEmpty) {
                return const Center(
                  child: Text("Attendance not found!"),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  ...model.myAttendances.map((data) {
                    UserModel user = model.user!;
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
                          const Divider(thickness: 2,),
                          Text(user.name.capitalize(),
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              )),
                          UIHelper.verticalSpaceSmall,
                          buildLabel(
                            'Sign In',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          UIHelper.verticalSpaceSmall,
                          Row(
                            children: [
                              Image.network("${data.imagePath}/${data.signInImage}", width: 70),
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
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          UIHelper.verticalSpaceSmall,
                          if (data.signOutImage.isNotEmpty)
                            Row(
                              children: [
                                Image.network("${data.imagePath}/${data.signOutImage}", width: 70),
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
                          if (data.signOutImage.isNotEmpty) UIHelper.verticalSpaceMedium,
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
            });
          }),
    );
  }

  void _showLogsDialog(int userId) {
    showDialog(
        context: context,
        builder: (context) {
          return AttendanceLogView(userId: userId);
        });
  }
}
