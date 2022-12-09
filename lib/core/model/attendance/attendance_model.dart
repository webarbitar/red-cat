class AttendanceModel {
  int id;
  String uniqueId;
  String dateOfAttendance;
  int userId;
  String signInAddress;
  String signInImage;
  String signInLat;
  String signInLong;
  String signInTime;
  String signOutImage;
  String signOutAdd;
  String signOutLat;
  String signOutLong;
  String signOutTime;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  AttendanceModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uniqueId = json['unique_id'],
        dateOfAttendance = json['date_of_attendance'],
        userId = json['user_id'],
        signInAddress = json['sign_in_address'],
        signInImage = json['sign_in_image'],
        signInLat = json['sign_in_lat'],
        signInLong = json['sign_in_long'],
        signInTime = json['sign_in_time'],
        signOutImage = json['sign_out_image'],
        signOutAdd = json['sign_out_add'],
        signOutLat = json['sign_out_lat'],
        signOutLong = json['sign_out_long'],
        signOutTime = json['sign_out_time'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        deletedAt = json['deleted_at'];

  static List<AttendanceModel> parseJsonList(List list) {
    return list.map((data) {
      return AttendanceModel.fromJson(data);
    }).toList();
  }
}
