import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/enum/api_status.dart';
import '../../../../core/view_model/home/home_view_modal.dart';
import '../../../shared/navigation/navigation.dart';
import '../../../shared/ui_comp_mixin.dart';
import '../../../shared/ui_helpers.dart';
import '../../../shared/validator_mixin.dart';
import '../../../widgets/custom/custom_button.dart';
import '../../../widgets/custom/custom_text_field.dart';

class ManagementReportView extends StatefulWidget {
  final String type;

  const ManagementReportView({Key? key, required this.type}) : super(key: key);

  @override
  State<ManagementReportView> createState() => _ManagementReportViewState();
}

class _ManagementReportViewState extends State<ManagementReportView>
    with UiCompMixin, ValidatorMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _stateCtrl = TextEditingController();
  final TextEditingController _totalDist = TextEditingController();
  final TextEditingController _totalSS = TextEditingController();
  final TextEditingController _todayVisitPlan = TextEditingController();
  final TextEditingController _todayPrimaryPlan = TextEditingController();
  final TextEditingController _mtdPrimaryDist = TextEditingController();
  final TextEditingController _mtdPrimarySS = TextEditingController();
  final TextEditingController _mtdActivation = TextEditingController();
  final TextEditingController _mtdKitPlacement = TextEditingController();
  final TextEditingController _widthOfSS = TextEditingController();
  final TextEditingController _widthOfDistribution1 = TextEditingController();
  final TextEditingController _widthOfDistribution2 = TextEditingController();
  final TextEditingController _tgtVsAchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.type} Sales Report"),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            // ============ Date ============
            buildLabel("Date"),
            UIHelper.verticalSpaceSmall,
            InkWell(
              onTap: () {
                datePickerModel(context).then((value) {
                  if (value != null) {
                    _dateCtrl.text = dateFormat.format(value);
                  }
                });
              },
              child: CustomTextField(
                validator: emptyFieldValidation,
                controller: _dateCtrl,
                hint: "yyyy-MM-dd",
                needDecoration: false,
                enable: false,
              ),
            ),
            UIHelper.verticalSpaceSmall,

            // ============ Name ============
            buildLabel("Name"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _nameCtrl,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ State ============
            buildLabel("State"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _stateCtrl,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            if (widget.type == "ASM")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ============ Total Dist ============

                  buildLabel("Total Dist"),
                  UIHelper.verticalSpaceSmall,
                  CustomTextField(
                    validator: emptyFieldValidation,
                    hint: "type here",
                    controller: _totalDist,
                    needDecoration: false,
                  ),
                  UIHelper.verticalSpaceMedium,
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ============ Total SS ============

                  buildLabel("Total SS"),
                  UIHelper.verticalSpaceSmall,
                  CustomTextField(
                    validator: emptyFieldValidation,
                    hint: "type here",
                    controller: _totalSS,
                    needDecoration: false,
                  ),
                  UIHelper.verticalSpaceMedium,
                ],
              ),

            // ============ Today Visit Plan ============
            buildLabel("Today Visit Plan"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _todayVisitPlan,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Today Primary Plan ============
            buildLabel("Today Primary Plan"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _todayPrimaryPlan,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            if (widget.type == "ASM")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ============ MTD Primary Dist ============

                  buildLabel("MTD Primary Dist"),
                  UIHelper.verticalSpaceSmall,
                  CustomTextField(
                    validator: emptyFieldValidation,
                    hint: "type here",
                    controller: _mtdPrimaryDist,
                    needDecoration: false,
                  ),
                  UIHelper.verticalSpaceMedium,
                ],
              )
            else
              // ============ MTD Primary SS ============
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildLabel("MTD Primary SS"),
                  UIHelper.verticalSpaceSmall,
                  CustomTextField(
                    validator: emptyFieldValidation,
                    hint: "type here",
                    controller: _mtdPrimarySS,
                    needDecoration: false,
                  ),
                  UIHelper.verticalSpaceMedium,
                ],
              ),

            // ============ MTD Activation ============
            buildLabel("MTD Activation"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _mtdActivation,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ MTD Kit Placement ============
            buildLabel("MTD Kit Placement"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _mtdKitPlacement,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Width Of SS ============
            buildLabel("Width Of SS"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _widthOfSS,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Width Of Distribution ============
            buildLabel("Width Of Distribution"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _widthOfDistribution1,
              needDecoration: false,
            ),

            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _widthOfDistribution2,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ TGT Vs ACH ============
            buildLabel("TGT Vs ACH"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _tgtVsAchCtrl,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,
            UIHelper.verticalSpaceMedium,
            CustomButton(
              text: "Submit",
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  loaderModal(context);
                  context.read<HomeViewModal>().submitManagementSalesReport({
                    'date': _dateCtrl.text.trim(),
                    'name': _nameCtrl.text.trim(),
                    'state': _stateCtrl.text.trim(),
                    'total_dist': _totalDist.text.trim(),
                    'total_ss': _totalSS.text.trim(),
                    'today_visit_plan': _todayVisitPlan.text.trim(),
                    'today_primary_plan': _todayPrimaryPlan.text.trim(),
                    'mtd_primary_dist': _mtdPrimaryDist.text.trim(),
                    'mtd_primary_ss': _mtdPrimarySS.text.trim(),
                    'mtd_activation': _mtdActivation.text.trim(),
                    'mtd_Kit_placement': _mtdKitPlacement.text.trim(),
                    'width_of_ss': _widthOfSS.text.trim(),
                    'width_of_dist[0]': _widthOfDistribution1.text.trim(),
                    'width_of_dist[1]': _widthOfDistribution2.text.trim(),
                    'type': widget.type,
                    'tgt_vs_ach': _tgtVsAchCtrl.text.trim(),
                  }).then((value) {
                    Navigation.instance.goBack();
                    if (value.status == ApiStatus.success) {
                      showSuccessMessage(value.message);
                      Navigation.instance.goBack();
                    } else {
                      showErrorMessage(value.message);
                    }
                  });
                  ;
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
