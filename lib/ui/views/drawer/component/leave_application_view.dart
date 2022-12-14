import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ret_cat/core/constance/style.dart';
import 'package:ret_cat/core/enum/api_status.dart';
import 'package:ret_cat/core/model/leave/leave_application_mode.dart';
import 'package:ret_cat/core/view_model/home/home_view_modal.dart';
import 'package:ret_cat/ui/shared/ui_comp_mixin.dart';
import 'package:ret_cat/ui/shared/ui_helpers.dart';
import 'package:ret_cat/ui/widgets/custom/custom_button.dart';
import 'package:ret_cat/ui/widgets/custom/custom_text_field.dart';

class LeaveApplicationView extends StatefulWidget {
  const LeaveApplicationView({Key? key}) : super(key: key);

  @override
  State<LeaveApplicationView> createState() => _LeaveApplicationViewState();
}

class _LeaveApplicationViewState extends State<LeaveApplicationView> with UiCompMixin {
  late final HomeViewModal _homeViewModal;
  final DateFormat _dateFormat = DateFormat("yyyy-MM-dd");
  final _startDateNfy = ValueNotifier<DateTime?>(null);
  final _endDateNfy = ValueNotifier<DateTime?>(null);
  final TextEditingController _reason = TextEditingController();

  @override
  void initState() {
    super.initState();
    _homeViewModal = context.read<HomeViewModal>();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Application"),
        elevation: 0.0,
      ),
      backgroundColor: backgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          UIHelper.verticalSpaceLarge,
          buildLabel("From"),
          UIHelper.verticalSpaceSmall,
          ValueListenableBuilder<DateTime?>(
              valueListenable: _startDateNfy,
              builder: (context, startDate, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (startDate != null)
                      Text(
                        _dateFormat.format(startDate),
                        style: textStyle,
                      )
                    else
                      Text(
                        "yyyy-MM-dd",
                        style: textStyle,
                      ),
                    UIHelper.horizontalSpaceMedium,
                    Flexible(
                      child: CustomButton(
                        width: 180,
                        height: 35,
                        text: "Select start date",
                        onTap: () async {
                          final pickedDate = await datePickerModel(context);
                          if (pickedDate != null) {
                            _startDateNfy.value = pickedDate;
                          }
                        },
                      ),
                    ),
                  ],
                );
              }),
          UIHelper.verticalSpaceMedium,
          buildLabel("To"),
          UIHelper.verticalSpaceSmall,
          ValueListenableBuilder<DateTime?>(
              valueListenable: _endDateNfy,
              builder: (context, endDate, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (endDate != null)
                      Text(
                        _dateFormat.format(endDate),
                        style: textStyle,
                      )
                    else
                      Text(
                        "yyyy-MM-dd",
                        style: textStyle,
                      ),
                    UIHelper.horizontalSpaceMedium,
                    Flexible(
                      child: CustomButton(
                        text: "Select end date",
                        width: 180,
                        height: 35,
                        onTap: () async {
                          final endDate = await datePickerModel(context);
                          if (endDate != null) {
                            _endDateNfy.value = endDate;
                          }
                        },
                      ),
                    ),
                  ],
                );
              }),
          UIHelper.verticalSpaceMedium,
          buildLabel("Leave Reason"),
          UIHelper.verticalSpaceSmall,
          CustomTextField(
            controller: _reason,
            hint: "Enter reason",
            needDecoration: false,
          ),
          UIHelper.verticalSpaceMedium,
          UIHelper.verticalSpaceMedium,
          CustomButton(
            text: "Submit",
            onTap: () {
              if (_startDateNfy.value == null) {
                showErrorMessage("Start date required");
                return;
              }

              if (_startDateNfy.value == null) {
                showErrorMessage("End date required");
                return;
              }
              if (_reason.text.isEmpty) {
                showErrorMessage("Leave reason required");
                return;
              }
              final res = _homeViewModal.submitLeaveApplication(
                LeaveApplicationModel(
                  startDate: _startDateNfy.value!,
                  endDate: _endDateNfy.value!,
                  leaveReason: _reason.text.trim(),
                ),
              );
              res.then((value) {
                if (value.status == ApiStatus.success) {
                  showSuccessMessage(value.message);
                  Navigator.of(context).pop();
                } else {
                  showErrorMessage(value.message);
                }
              });
            },
          ),
        ],
      ),
    );
  }

}
