import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ret_cat/core/constance/style.dart';

import '../../../core/enum/api_status.dart';
import '../../../core/view_model/auth/auth_view_model.dart';
import '../../../core/view_model/home/home_view_modal.dart';
import '../../../core/view_model/user/user_view_model.dart';
import '../../shared/navigation/navigation.dart';
import '../../shared/ui_comp_mixin.dart';
import '../../shared/ui_helpers.dart';
import '../../shared/validator_mixin.dart';
import '../../widgets/custom/custom_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with UiCompMixin, ValidatorMixin {
  late final AuthViewModel _authViewModal;
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authViewModal = context.read<AuthViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Red Cat",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0.0,
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
              child: Column(
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
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UIHelper.verticalSpaceSmall,
                            Text(
                              "Login",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            UIHelper.verticalSpaceLarge,

                            // =============== Email ===============
                            buildLabel("Phone",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                )),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _email,
                              validator: phoneValidation,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 6),
                              ),
                            ),

                            // =============== Password ===============
                            UIHelper.verticalSpaceMedium,
                            buildLabel(
                              "Password",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _password,
                              validator: emptyFieldValidation,
                              obscureText: true,
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 6),
                              ),
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot Password?",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            UIHelper.verticalSpaceMedium,
                            CustomButton(
                              text: "Login",
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  loaderModal(context);
                                  final res = _authViewModal.loginUser(
                                    _email.text.trim(),
                                    _password.text.trim(),
                                  );
                                  res.then((value) async {
                                    if (value.status == ApiStatus.success) {
                                      context.read<UserViewModel>().fetchUserProfile(notify: true);
                                      await context.read<HomeViewModal>().checkAttendanceStatus();
                                      Navigation.instance.goBack();
                                      Navigation.instance.navigateAndRemoveUntil("/home");
                                    } else {
                                      Navigation.instance.goBack();
                                      showErrorMessage(value.message);
                                    }
                                  });
                                }
                              },
                            ),
                            UIHelper.verticalSpaceMedium,
                            UIHelper.verticalSpaceMedium,
                            Row(
                              children: const [
                                Expanded(child: Divider()),
                                UIHelper.horizontalSpaceSmall,
                                Text("Or"),
                                UIHelper.horizontalSpaceSmall,
                                Expanded(child: Divider()),
                              ],
                            ),
                            UIHelper.verticalSpaceMedium,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have a account?",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    splashFactory: NoSplash.splashFactory,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    elevation: 0.0,
                                  ),
                                  onPressed: () {
                                    Navigation.instance.navigate("/signup");
                                  },
                                  child: const Text(
                                    "Create Account",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
