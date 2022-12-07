import 'dart:convert';
import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../env.dart';
import '../../constance/end_points.dart';
import '../../enum/api_status.dart';
import '../../model/address/geocode_address.dart';
import '../../model/address/reverse_geocode_model.dart';
import '../../model/response_model.dart';
import '../service_mixin.dart';

class MapService with ServiceMixin {
  Future<ResponseModel<ReverseGeocodeModel>> fetchAddressFromGeocode(
      {required LatLng position}) async {
    Uri uri = parseUri("$mapGecode?format=json&lat=${position.latitude}&lon=${position.longitude}");
    final res = await http.get(uri);
    // log(res.body);
    // try {
    switch (res.statusCode) {
      case 200:
        final jsonData = jsonDecode(res.body);
        log(res.body);

        final data = ReverseGeocodeModel.fromJson(jsonData);
        return ResponseModel.success(data: data);

      default:
        return errorResponse(res);
    }
    // } catch (ex) {
    //   return exceptionResponse(ex);
    // }
  }
}
