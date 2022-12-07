class NotificationModel {
  int id;
  String uniqueId;
  String title;
  String description;
  String date;
  DateTime createdAt;
  DateTime updatedAt;

  NotificationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uniqueId = json['unique_id'],
        title = json['title'],
        description = json['description'],
        date = json['date'],
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']);

  static List<NotificationModel> parseJsonList(List json) {
    return json.map((data) => NotificationModel.fromJson(data)).toList();
  }
}
