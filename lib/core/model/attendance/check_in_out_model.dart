class CheckInOutModel {
  String userImage;
  String address;
  double latitude;
  double longitude;

  CheckInOutModel({
    required this.userImage,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String, String> toMap() {
    return {'address': address, 'lat': '$latitude', 'lng': '$longitude'};
  }
}
