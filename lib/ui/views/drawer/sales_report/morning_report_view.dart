import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ret_cat/core/enum/api_status.dart';
import 'package:ret_cat/core/view_model/home/home_view_modal.dart';
import 'package:ret_cat/ui/shared/navigation/navigation.dart';
import 'package:ret_cat/ui/shared/ui_comp_mixin.dart';
import 'package:ret_cat/ui/shared/ui_helpers.dart';
import 'package:ret_cat/ui/shared/validator_mixin.dart';
import 'package:ret_cat/ui/widgets/custom/custom_button.dart';
import 'package:ret_cat/ui/widgets/custom/custom_text_field.dart';

class MorningReportView extends StatefulWidget {
  const MorningReportView({Key? key}) : super(key: key);

  @override
  State<MorningReportView> createState() => _MorningReportViewState();
}

class _MorningReportViewState extends State<MorningReportView> with UiCompMixin, ValidatorMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _designationCtrl = TextEditingController();
  final TextEditingController _locationCtrl = TextEditingController();
  final TextEditingController _todayVisitPlanCtrl = TextEditingController();
  final TextEditingController _totalDistributorCtrl = TextEditingController();
  final TextEditingController _openingStockCtrl = TextEditingController();
  final TextEditingController _todayPrimaryPlanCtrl = TextEditingController();
  final TextEditingController _todayWODPlanCtrl = TextEditingController();
  final TextEditingController _tgtVsAchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Morning Report"),
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

            // ============ Name ============
            buildLabel("Designation"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _designationCtrl,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Location ============
            buildLabel("Location"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _locationCtrl,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Today Visit Plan ============
            buildLabel("Today Visit Plan"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _todayVisitPlanCtrl,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Total Distributor ============
            buildLabel("Total Distributor"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _totalDistributorCtrl,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Opening Stock ============
            buildLabel("Opening Stock"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _openingStockCtrl,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Today Primary Plan ============
            buildLabel("Today Primary Plan"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _todayPrimaryPlanCtrl,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Today Wod Plan ============
            buildLabel("Today WOD Plan"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _todayWODPlanCtrl,
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
                FocusManager.instance.primaryFocus?.unfocus();
                if (_formKey.currentState!.validate()) {
                  loaderModal(context);
                  context.read<HomeViewModal>().submitMorningSalesReport({
                    'date': _dateCtrl.text.trim(),
                    'name': _nameCtrl.text.trim(),
                    'designation': _designationCtrl.text.trim(),
                    'location': _locationCtrl.text.trim(),
                    'today_visit_plan': _todayVisitPlanCtrl.text.trim(),
                    'total_distributor': _totalDistributorCtrl.text.trim(),
                    'opening_stock': _openingStockCtrl.text.trim(),
                    'today_primary_plan': _todayPrimaryPlanCtrl.text.trim(),
                    'today_wod_plan': _todayWODPlanCtrl.text.trim(),
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
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
