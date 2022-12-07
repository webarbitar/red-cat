class UserModel {
  int id;
  String name;
  String? email;
  String phone;
  String designation;
  String state;
  String status;
  String image;
  String avatar;
  DateTime createdAt;
  DateTime updatedAt;

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] ?? "",
        email = json['email'] ?? "",
        phone = json['phone'] ?? "",
        designation = json['designation'] ?? "",
        status = json['status'] ?? "",
        state = json['state'] ?? "",
        image = json['avatar'] ?? "",
        avatar = json["avatar"] ?? "",
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']);

}
