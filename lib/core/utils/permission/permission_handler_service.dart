import "dart:io" show Platform;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionHandlerService {
  void requestAllRequiredPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.notification,
    ].request();
  }

  Future<PermissionStatus> requestLocationPermission(bool openSetting) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool reqRat = pref.getBool("location_req") ?? false;
    String perm = pref.getString("location_perm") ?? "denied";
    PermissionWithService stat = Permission.location;
    PermissionStatus status = await stat.status;

    if (status.isDenied) {
      bool sr = await stat.shouldShowRequestRationale;
      status = await stat.request();

      /* --------- For Android Only --------- */
      if (Platform.isAndroid) {
        await pref.setString("location_perm", status.name);
        if (perm == "denied") {
          pref.setBool("location_req", sr);
        }
      }
      if (!reqRat && (status.name == "permanentlyDenied" || status.name == "denied")) {
        return status;
      }
    }

    if (openSetting && status.isPermanentlyDenied) {
      openAppSettings();
    }

    if (status.isGranted || status.isLimited) {
      pref.remove("location_req");
      pref.remove("location_perm");
    }

    return status;
  }
}
