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

class EveningReportView extends StatefulWidget {
  const EveningReportView({Key? key}) : super(key: key);

  @override
  State<EveningReportView> createState() => _EveningReportViewState();
}

class _EveningReportViewState extends State<EveningReportView> with UiCompMixin, ValidatorMixin  {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _designationCtrl = TextEditingController();
  final TextEditingController _locationCtrl = TextEditingController();
  final TextEditingController _ssNameCtrl = TextEditingController();
  final TextEditingController _distributorNameCtrl = TextEditingController();
  final TextEditingController _todayActivation = TextEditingController();
  final TextEditingController _tillDateActivation = TextEditingController();
  final TextEditingController _todayNewWOD = TextEditingController();
  final TextEditingController _tillDateWOD = TextEditingController();
  final TextEditingController _todayKitPlacement = TextEditingController();
  final TextEditingController _tillDateKitPlacement = TextEditingController();
  final TextEditingController _tgtVsAchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evening Report"),
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

            // ============ SS Name ============
            buildLabel("SS Name"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _ssNameCtrl,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Distributor Name ============
            buildLabel("Distributor Name"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _distributorNameCtrl,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Total Distributor ============
            buildLabel("Today Activation"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _todayActivation,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Till Date Activation ============
            buildLabel("Till Date Activation"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _tillDateActivation,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Today New WOD ============
            buildLabel("Today New WOD"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _todayNewWOD,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Till Date WOD ============
            buildLabel("Till Date WOD"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _tillDateWOD,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Today Kit Placement ============
            buildLabel("Today Kit Placement"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _todayKitPlacement,
              needDecoration: false,
            ),
            UIHelper.verticalSpaceMedium,

            // ============ Till Date Kit Placement ============
            buildLabel("Till Date Kit Placement"),
            UIHelper.verticalSpaceSmall,
            CustomTextField(
              validator: emptyFieldValidation,
              hint: "type here",
              controller: _tillDateKitPlacement,
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
                if(_formKey.currentState!.validate()){
                FocusManager.instance.primaryFocus?.unfocus();
                loaderModal(context);
                  context.read<HomeViewModal>()
                      .submitEveningSalesReport({
                    'date': _dateCtrl.text.trim(),
                    'name': _nameCtrl.text.trim(),
                    'designation': _designationCtrl.text.trim(),
                    'location': _locationCtrl.text.trim(),
                    'ss_name': _ssNameCtrl.text.trim(),
                    'distributor_name': _distributorNameCtrl.text.trim(),
                    'today_activation': _todayActivation.text.trim(),
                    'till_date_activation': _tillDateActivation.text.trim(),
                    'today_new_wod': _todayNewWOD.text.trim(),
                    'till_date_wod': _tillDateWOD.text.trim(),
                    'today_kit_placement': _todayKitPlacement.text.trim(),
                    'till_date_kit_placement': _tillDateKitPlacement.text.trim(),
                    'tgt_vs_ach': _tgtVsAchCtrl.text.trim(),
                  }).then((value) {
                    Navigation.instance.goBack();
                    if (value.status == ApiStatus.success) {
                      showSuccessMessage(value.message);
                      Navigation.instance.goBack();
                    } else {
                      showErrorMessage(value.message);
                    }
                  });;
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
