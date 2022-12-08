import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/constance/style.dart';
import '../../../../core/enum/api_status.dart';
import '../../../../core/view_model/home/home_view_modal.dart';
import '../../../shared/ui_comp_mixin.dart';
import '../../../shared/ui_helpers.dart';
import '../../../widgets/custom/custom_button.dart';
import '../../../widgets/custom/custom_text_field.dart';
import '../../../widgets/loader_widget.dart';

class MarketVisitPhotoView extends StatefulWidget {
  const MarketVisitPhotoView({Key? key}) : super(key: key);

  @override
  State<MarketVisitPhotoView> createState() => _MarketVisitPhotoViewState();
}

class _MarketVisitPhotoViewState extends State<MarketVisitPhotoView> with UiCompMixin {
  late final HomeViewModal _homeViewModal;
  final TextEditingController _remark = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final ImageCropper _cropper = ImageCropper();
  final ImagePicker _picker = ImagePicker();
  File? selfie;
  Position? pos;

  @override
  void initState() {
    super.initState();
    _homeViewModal = context.read();
    fetchCurrentLocation();
  }

  void fetchCurrentLocation() async {
    busyNfy.value = true;
    try {
      pos = await _homeViewModal.currentLocation();
      final res = await _homeViewModal.fetchAddressFromGeocode(
        LatLng(pos!.latitude, pos!.longitude),
      );
      // address = res.data;
      _address.text = res;
    } catch (e, trace) {
      debugPrintStack(stackTrace: trace, label: e.toString());
    }
    busyNfy.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Market Visit Photo"),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
          valueListenable: busyNfy,
          builder: (context, busy, _) {
            if (busy) {
              return const Center(
                child: LoaderWidget(color: primaryColor),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: DottedBorder(
                      borderType: BorderType.Circle,
                      // radius: const Radius.circular(8),
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: pickImage,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: SizedBox(
                            height: 140,
                            width: 140,
                            child: selfie != null
                                ? Image.file(selfie!)
                                : const Center(child: Text("Upload Photo")),
                          ),
                        ),
                      ),
                    ),
                  ),
                  UIHelper.verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildLabel("Visit Location"),
                      TextButton(onPressed: fetchCurrentLocation, child: const Text("Update"))
                    ],
                  ),
                  CustomTextField(
                    hint: "type here",
                    controller: _address,
                    needDecoration: false,
                    enable: false,
                  ),
                  UIHelper.verticalSpaceMedium,

                  // ============ SS Name ============
                  buildLabel("Remark"),
                  UIHelper.verticalSpaceSmall,
                  CustomTextField(
                    hint: "type here",
                    controller: _remark,
                    needDecoration: false,
                  ),
                  UIHelper.verticalSpaceMedium,
                  UIHelper.verticalSpaceMedium,
                  CustomButton(
                    text: "Submit",
                    onTap: () {
                      if (selfie == null) {
                        showErrorMessage("Please upload the selfie");
                        return;
                      }
                      if (pos == null) {
                        showErrorMessage("Location Required");
                        return;
                      }
                      loaderModal(context);
                      _homeViewModal.submitMarketVisit({
                        'address': _address.text.trim(),
                        'lat': '${pos!.latitude}',
                        'lng': '${pos!.longitude}',
                        'remarks': _remark.text.trim(),
                      }, selfie!.path).then((value) {
                        Navigator.of(context).pop();
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
          }),
    );
  }

  void pickImage() async {
    XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (file != null) {
      await cropImage(file.path);
    }
  }

  Future<void> cropImage(String imagePath) async {
    CroppedFile? croppedFile = await _cropper.cropImage(
      sourcePath: imagePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        // CropAspectRatioPreset.original,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop & Upload',
            toolbarColor: primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            hideBottomControls: true,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Crop & Upload',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        selfie = File(croppedFile.path);
      });
    }
  }
}
