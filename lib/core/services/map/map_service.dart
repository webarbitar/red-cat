import 'dart:convert';
import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../env.dart';
import '../../constance/end_points.dart';
import '../../enum/api_status.dart';
import '../../model/address/geocode_address.dart';
import '../../model/response_model.dart';
import '../service_mixin.dart';

class MapService with ServiceMixin {
  Future<ResponseModel<GeocodeAddress>> fetchAddressFromGeocode({required LatLng position}) async {
    Uri uri =
        parseUri("$mapGecode?latlng=${"${position.latitude},${position.longitude}"}&key=$mapToken");
    final res = await http.get(uri);
    try {
      switch (res.statusCode) {
        case 200:
          final jsonData = jsonDecode(res.body);
          if (jsonData["status"] == "OK" && (jsonData["results"] as List).isNotEmpty) {
            final data = GeocodeAddress.fromJson(jsonData["results"]);
            return ResponseModel.success(data: data);
          }
          return ResponseModel.error(status: ApiStatus.error, message: ServiceMixin.ERROR_MESSAGE);
        default:
          return errorResponse(res);
      }
    } catch (ex) {
      return exceptionResponse(ex);
    }
  }
}
