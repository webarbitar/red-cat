import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ret_cat/ui/shared/ui_comp_mixin.dart';

import '../../../core/constance/style.dart';
import '../../../core/enum/api_status.dart';
import '../../../core/view_model/user/user_view_model.dart';
import '../../shared/ui_helpers.dart';
import '../../widgets/custom/custom_button.dart';
import '../../widgets/custom/custom_text_field.dart';

class ProfileUpdateView extends StatefulWidget {
  const ProfileUpdateView({Key? key}) : super(key: key);

  @override
  State<ProfileUpdateView> createState() => _ProfileUpdateViewState();
}

class _ProfileUpdateViewState extends State<ProfileUpdateView> with UiCompMixin {
  late final UserViewModel _userViewModel;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _designationCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();

  final _imagePicker = ImagePicker();
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _userViewModel = context.read<UserViewModel>();
    _nameCtrl.text = _userViewModel.user?.name ?? "";
    _emailCtrl.text = _userViewModel.user?.email ?? "";
    _mobileCtrl.text = _userViewModel.user?.phone ?? "";
    _designationCtrl.text = _userViewModel.user?.designation ?? "";
    _stateCtrl.text = _userViewModel.user?.state ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile Update",
          style: TextStyle(
            fontFamily: "Montserrat",
          ),
        ),
        centerTitle: true,
        elevation: 0.2,
      ),
      backgroundColor: backgroundColor,
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
              child: ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 110,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: backgroundColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_pickedImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 110,
                              child: Image.file(
                                File(_pickedImage!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                          ),
                      ],
                    ),
                  ),
                  UIHelper.verticalSpaceMedium,
                  Center(
                    child: CustomButton(
                      width: 130,
                      height: 40,
                      text: "Upload Image",
                      textStyle: const TextStyle(
                        fontSize: 12,
                        color: backgroundColor,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                      ),
                      onTap: _imagePickerOnTap,
                    ),
                  ),
                  UIHelper.verticalSpaceMedium,
                  UIHelper.verticalSpaceMedium,
                  CustomTextField(
                    controller: _nameCtrl,
                    hint: "Enter your name",
                    needDecoration: false,
                    // color: Colors.grey,
                  ),
                  UIHelper.verticalSpaceMedium,
                  CustomTextField(
                    controller: _emailCtrl,
                    hint: "Enter your email",
                    needDecoration: false,
                    type: TextInputType.emailAddress,
                  ),
                  UIHelper.verticalSpaceMedium,
                  IgnorePointer(
                    child: CustomTextField(
                      controller: _mobileCtrl,
                      hint: "Enter your phone",
                      color: Colors.grey.shade200,
                      needDecoration: false,
                      type: TextInputType.phone,
                    ),
                  ),
                  UIHelper.verticalSpaceMedium,
                  CustomTextField(
                    controller: _designationCtrl,
                    hint: "Enter your designation",
                    needDecoration: false,
                  ),
                  UIHelper.verticalSpaceMedium,
                  CustomTextField(
                    controller: _stateCtrl,
                    hint: "Enter your state",
                    needDecoration: false,
                  ),
                  UIHelper.verticalSpaceMedium,
                  UIHelper.verticalSpaceMedium,
                  SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        elevation: 0.0,
                      ),
                      onPressed: () {
                        final model = context.read<UserViewModel>();
                        loaderModal(context);
                        final res = model.updateUserProfile({
                          'name': _nameCtrl.text.trim(),
                          'phone': _mobileCtrl.text.trim(),
                          "email": _emailCtrl.text.trim(),
                          'designation': _designationCtrl.text.trim(),
                          'state': _stateCtrl.text.trim(),
                        }, _pickedImage?.path);
                        res.then((value) {
                          Navigator.of(context).pop();
                          if (value.status == ApiStatus.success) {
                            Navigator.of(context).pop();
                          } else {
                            showErrorMessage(value.message);
                          }
                        });
                      },
                      child: Ink(
                        width: double.maxFinite,
                        height: 45,
                        padding: EdgeInsets.zero,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xffff0044),
                              Color(0xffff794d),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        ),
                        child: const Center(child: Text("Update")),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _imagePickerOnTap() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 95,
    );
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }
}
