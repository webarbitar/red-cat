import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ret_cat/core/enum/api_status.dart';
import 'package:ret_cat/core/utils/storage/storage.dart';
import 'package:ret_cat/core/view_model/user/user_view_model.dart';
import 'package:ret_cat/ui/shared/navigation/navigation.dart';
import 'package:ret_cat/ui/widgets/custom/custom_button.dart';

import '../../../../core/constance/style.dart';
import '../../../shared/ui_comp_mixin.dart';
import '../../../shared/ui_helpers.dart';
import '../../../shared/validator_mixin.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> with UiCompMixin, ValidatorMixin {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("Change Password"),
      ),
      resizeToAvoidBottomInset: false,
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
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.92),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.verticalSpaceMedium,
                      // =============== Password ===============
                      buildCustomTextFormField(
                        "Phone Number",
                        controller: _phone,
                        type: TextInputType.phone,
                        validator: phoneValidation,
                      ),

                      // =============== Password ===============
                      buildCustomTextFormField(
                        "Password",
                        controller: _password,
                        obscure: true,
                        validator: passwordValidation,
                      ),

                      // =============== Confirm Password ===============
                      buildCustomTextFormField(
                        "Confirm Password",
                        controller: _confirmPassword,
                        obscure: true,
                        validator: (val) {
                          return confirmPasswordValidation(
                            password: _password.text,
                            confirmPassword: val,
                          );
                        },
                      ),

                      UIHelper.verticalSpaceMedium,
                      UIHelper.verticalSpaceMedium,
                      CustomButton(
                        text: "Change Password",
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            loaderModal(context);
                            UserViewModel model = context.read();
                            model
                                .changeUserPassword(
                                    password: _password.text.trim(), phone: _phone.text.trim())
                                .then((value) {
                              Navigation.instance.goBack();
                              if (value.status == ApiStatus.success) {
                                Storage.instance.logout();
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCustomTextFormField(String label,
      {required TextEditingController controller,
      String? Function(String?)? validator,
      TextInputType type = TextInputType.text,
      bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UIHelper.verticalSpaceMedium,
        buildLabel(label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscure,
          keyboardType: type,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 6),
          ),
        ),
      ],
    );
  }
}
