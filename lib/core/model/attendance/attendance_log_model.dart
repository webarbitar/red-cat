class AttendanceLogModel {
  int id;
  String dateOfAttendence;
  String time;
  int userId;
  String location;
  String latitude;
  String longitude;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  AttendanceLogModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        dateOfAttendence = json['date_of_attendence'],
        time = json['time'],
        userId = json['user_id'],
        location = json['location'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        deletedAt = json['deleted_at'];

  static List<AttendanceLogModel> parseJsonList(List list) {
    return list.map((data) => AttendanceLogModel.fromJson(data)).toList();
  }
}
