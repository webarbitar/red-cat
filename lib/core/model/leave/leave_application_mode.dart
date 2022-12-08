class LeaveApplicationModel {
  int id;
  int userId;
  String userName;
  DateTime startDate;
  DateTime endDate;
  String leaveReason;
  DateTime createdAt;
  DateTime updatedAt;

  LeaveApplicationModel(
      {this.userId = 0,
      this.userName = "",
      required this.startDate,
      required this.endDate,
      required this.leaveReason,
      this.id = 0})
      : updatedAt = DateTime.now(),
        createdAt = DateTime.now();

  LeaveApplicationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['user_id'],
        userName = json['user_name'],
        startDate = json['start_date'],
        endDate = json['end_date'],
        leaveReason = json['leave_reason'],
        updatedAt = json['updated_at'],
        createdAt = json['created_at'];

  static List<LeaveApplicationModel> parseJsonList(List json) {
    return json.map((data) => LeaveApplicationModel.fromJson(data)).toList();
  }

  Map<String, String> toMap() {
    return {
      'start_date': startDate.toString(),
      'end_date': endDate.toString(),
      'leave_reason': leaveReason,
    };
  }
}
