class RegistrationModel {
  String name;
  String phone;
  String designation;
  String password;
  String state;
  double latitude;
  double longitude;

  RegistrationModel({
    required this.name,
    required this.phone,
    required this.designation,
    required this.password,
    required this.state,
    required this.latitude,
    required this.longitude,
  });

  Map<String, String> registerMap() {
    return {
      'name': name,
      'phone': phone,
      'designation': designation,
      'password': password,
      'state': state,
      'latitude': '$latitude',
      'longitude': '$longitude',
    };
  }
}
