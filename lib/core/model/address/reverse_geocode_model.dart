// class ReverseGeocodeModel {
//   int placeId;
//   String licence;
//   String osmType;
//   int osmId;
//   String lat;
//   String lon;
//   String displayName;
//   GeocodeAddress address;
//   List<String> boundingbox;
//
//   ReverseGeocodeModel.fromJson(Map<String, dynamic> json)
//       : placeId = json['place_id'],
//         licence = json['licence'],
//         osmType = json['osm_type'],
//         osmId = json['osm_id'],
//         lat = json['lat'] ?? '',
//         lon = json['lon'] ?? "",
//         displayName = json['display_name'] ?? "",
//         address = GeocodeAddress.fromJson(json['address']),
//         boundingbox = json['boundingbox'].cast<String>();
// }
//
// class GeocodeAddress {
//   String office;
//   String road;
//   String suburb;
//   String cityDistrict;
//   String city;
//   String county;
//   String stateDistrict;
//   String state;
//   String iSO31662Lvl4;
//   String postcode;
//   String country;
//   String countryCode;
//
//   GeocodeAddress.fromJson(Map<String, dynamic> json)
//       : office = json['office'] ?? "",
//         road = json['road'] ?? "",
//         suburb = json['suburb'] ?? "",
//         cityDistrict = json['city_district'] ?? "",
//         city = json['city'] ?? "",
//         county = json['county'] ?? "",
//         stateDistrict = json['state_district'] ?? "",
//         state = json['state'] ?? "",
//         iSO31662Lvl4 = json['ISO3166-2-lvl4'] ?? "",
//         postcode = json['postcode'] ?? "",
//         country = json['country'] ?? "",
//         countryCode = json['country_code'] ?? "";
// }
