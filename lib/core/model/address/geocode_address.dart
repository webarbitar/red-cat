import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocodeAddress {
  String? neighborhood;
  String? subLocality;

// Town or city
  String locality;

// District
  String administrativeAreaLevel2;

// Province
  String administrativeAreaLevel1;
  String country;
  String postalCode;
  String formattedAddress;
  LatLng location;

  GeocodeAddress({
    this.neighborhood,
    this.subLocality,
    required this.locality,
    required this.administrativeAreaLevel2,
    required this.administrativeAreaLevel1,
    required this.country,
    required this.postalCode,
    required this.formattedAddress,
    required this.location,
  });

  factory GeocodeAddress.fromJson(List json) {
    var data = json[0];
    return GeocodeAddress(
      neighborhood: _parseAddress(data["address_components"], type: "neighborhood"),
      subLocality: _parseAddress(data["address_components"], type: "sublocality"),
      locality: _parseAddress(data["address_components"], type: "locality") ?? "",
      administrativeAreaLevel2:
          _parseAddress(data["address_components"], type: "administrative_area_level_2") ?? "",
      administrativeAreaLevel1:
          _parseAddress(data["address_components"], type: "administrative_area_level_1") ?? "",
      country: _parseAddress(data["address_components"], type: "country") ?? "",
      postalCode: _parsePostalCode(json, type: "postal_code") ?? "",
      formattedAddress: data["formatted_address"] ?? "",
      location: LatLng(data["geometry"]["location"]["lat"], data["geometry"]["location"]["lng"]),
    );
  }

  static String? _parseAddress(List data, {required String type}) {
    for (var dt in data) {
      if ((dt["types"] as List).contains(type)) {
        return dt["long_name"];
      }
    }
    return null;
  }

  static String? _parsePostalCode(List data, {required String type}) {
    List filterResult = data.where((data) => (data["types"] as List).contains(type)).toList();
    if (filterResult.isNotEmpty) {
      var filterData = filterResult.first["address_components"] as List;
      var res = filterData.singleWhere((data) => (data["types"] as List).contains(type));
      return res["long_name"];
    }
    return "N/A";
  }

  String address() {
    String adr = locality.isNotEmpty ? locality : administrativeAreaLevel2;
    if (neighborhood != null && subLocality != null) {
      return "$neighborhood, $subLocality, $adr";
    } else if (subLocality != null) {
      return "$subLocality, $adr";
    } else {
      return "$neighborhood, $adr";
    }
  }
}
