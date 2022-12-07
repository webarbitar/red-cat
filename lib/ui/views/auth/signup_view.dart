import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ret_cat/core/enum/api_status.dart';
import 'package:ret_cat/core/model/user/auth/registration_modal.dart';
import 'package:ret_cat/core/view_model/auth/auth_view_model.dart';
import 'package:ret_cat/ui/shared/navigation/navigation.dart';
import 'package:ret_cat/ui/widgets/custom/custom_button.dart';

import '../../../core/constance/style.dart';
import '../../../core/view_model/home/home_view_modal.dart';
import '../../../core/view_model/user/user_view_model.dart';
import '../../shared/ui_comp_mixin.dart';
import '../../shared/ui_helpers.dart';
import '../../shared/validator_mixin.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> with UiCompMixin, ValidatorMixin {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _state = TextEditingController();
  final _designation = TextEditingController();
  final _latitude = TextEditingController(text: "0");
  final _longitude = TextEditingController(text: "0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("Signup"),
        centerTitle: true,
      ),
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
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.92),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Container(
                      width: double.maxFinite,
                      color: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.all(20),
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // =============== Name ===============
                          buildCustomTextFormField(
                            "Full Name",
                            controller: _name,
                            validator: emptyFieldValidation,
                          ),

                          // =============== Email ===============
                          buildCustomTextFormField(
                            "Email",
                            controller: _email,
                            type: TextInputType.emailAddress,
                            validator: emailValidation,
                          ),

                          // =============== Phone ===============
                          buildCustomTextFormField(
                            "Phone",
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

                          // =============== Designation ===============
                          buildCustomTextFormField(
                            "Designation",
                            controller: _designation,
                            validator: emptyFieldValidation,
                          ),

                          // =============== State ===============
                          buildCustomTextFormField(
                            "Location",
                            controller: _state,
                            validator: emptyFieldValidation,
                          ),

                          // =============== LatLng ===============
                          // Row(
                          //   children: [
                          //     Flexible(
                          //       child: buildCustomTextFormField(
                          //         "Latitude",
                          //         controller: _latitude,
                          //         type: TextInputType.number,
                          //         validator: emptyFieldValidation,
                          //       ),
                          //     ),
                          //     UIHelper.horizontalSpaceMedium,
                          //     Flexible(
                          //       child: buildCustomTextFormField(
                          //         "Longitude",
                          //         controller: _longitude,
                          //         type: TextInputType.number,
                          //         validator: emptyFieldValidation,
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          UIHelper.verticalSpaceLarge,
                          CustomButton(
                            text: "Signup",
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                loaderModal(context);
                                final model = context.read<AuthViewModel>();
                                final res = model.registerUser(RegistrationModel(
                                  name: _name.text.trim(),
                                  phone: _phone.text.trim(),
                                  designation: _designation.text.trim(),
                                  password: _password.text.trim(),
                                  state: _state.text.trim(),
                                  latitude: 0.0,
                                  longitude: 0.0,
                                ));
                                res.then((value) async {
                                  if (value.status == ApiStatus.success) {
                                    context.read<UserViewModel>().fetchUserProfile();
                                    await context.read<HomeViewModal>().checkAttendanceStatus();
                                    Navigation.instance.goBack();
                                    showSuccessMessage(value.message);
                                    Navigation.instance.navigateAndRemoveUntil("/home");
                                  } else {
                                    Navigation.instance.goBack();
                                    showErrorMessage(value.message);
                                  }
                                });
                              }
                            },
                          )
                        ],
                      ),
                    )
                  ],
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
