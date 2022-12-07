import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ret_cat/core/constance/style.dart';
import 'package:ret_cat/core/enum/api_status.dart';
import 'package:ret_cat/core/model/address/reverse_geocode_model.dart';
import 'package:ret_cat/core/model/attendance/check_in_out_model.dart';
import 'package:ret_cat/core/view_model/home/home_view_modal.dart';
import 'package:ret_cat/ui/shared/ui_comp_mixin.dart';
import 'package:ret_cat/ui/shared/ui_helpers.dart';
import 'package:ret_cat/ui/widgets/custom/custom_button.dart';
import 'package:ret_cat/ui/widgets/loader_widget.dart';

class CheckInCheckOutView extends StatefulWidget {
  final String type;

  const CheckInCheckOutView({Key? key, required this.type}) : super(key: key);

  @override
  State<CheckInCheckOutView> createState() => _CheckInCheckOutViewState();
}

class _CheckInCheckOutViewState extends State<CheckInCheckOutView> with UiCompMixin {
  late final HomeViewModal _homeViewModal;
  final ImageCropper _cropper = ImageCropper();
  final ImagePicker _picker = ImagePicker();
  File? selfie;
  Position? pos;

  // ReverseGeocodeModel? address;
  String? address;

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
      address = res;
    } catch (e, trace) {
      debugPrintStack(stackTrace: trace, label: e.toString());
    }
    busyNfy.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == "checkIn" ? "Check In" : "Check Out"),
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
                                : const Center(child: Text("Upload Selfie")),
                          ),
                        ),
                      ),
                    ),
                  ),
                  UIHelper.verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildLabel("${widget.type == "checkIn" ? "Check In" : "Check Out"} Location"),
                      TextButton(onPressed: fetchCurrentLocation, child: const Text("Update"))
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: primaryColor.shade50),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(address ?? ""),
                  ),
                  UIHelper.verticalSpaceMedium,
                  UIHelper.verticalSpaceMedium,
                  CustomButton(
                    text: widget.type == "checkIn" ? "Check In" : "Check Out",
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
                      final res = _homeViewModal.checkInCheckOutAttendance(
                        widget.type,
                        data: CheckInOutModel(
                          userImage: selfie!.path,
                          address: address ?? "",
                          latitude: pos!.latitude,
                          longitude: pos!.longitude,
                        ),
                      );
                      res.then((value) {
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
