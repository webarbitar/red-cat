import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constance/end_points.dart';
import '../../model/attendance/check_in_out_model.dart';
import '../../model/notification/notification_model.dart';
import '../../model/response_model.dart';
import '../../utils/storage/storage.dart';
import '../service_mixin.dart';

class HomeService with ServiceMixin {
  final Storage _storage = Storage.instance;

  Future<ResponseModel> checkAttendanceStatus() async {
    var request = http.Request('GET', Uri.parse(checkStatus));
    request.headers.addAll({'Authorization': 'Bearer ${_storage.token}'});

    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    debugPrint(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"]) {
          return ResponseModel.success(message: jsonData["message"]);
        } else {
          return ResponseModel.error(message: jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModel<List<NotificationModel>>> fetchNotifications() async {
    var request = http.Request('GET', Uri.parse(notification));
    request.headers.addAll({'Authorization': 'Bearer ${_storage.token}'});

    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    debugPrint(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] ==200) {
          final data = NotificationModel.parseJsonList(jsonData["data"]);
          return ResponseModel.success(message: jsonData["message"], data: data);
        } else {
          return ResponseModel.error(message: jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModel> checkInAttendance(CheckInOutModel data) async {
    var request = http.MultipartRequest('POST', Uri.parse(checkIn));
    request.headers.addAll({'Authorization': 'Bearer ${_storage.token}'});
    request.fields.addAll(data.toMap());

    request.files.add(await http.MultipartFile.fromPath('userImage', data.userImage));

    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    debugPrint(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == 200) {
          return ResponseModel.success(message: jsonData["message"]);
        } else {
          return ResponseModel.error(message: jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModel> checkOutAttendance(CheckInOutModel data) async {
    var request = http.MultipartRequest('POST', Uri.parse(checkOut));
    request.headers.addAll({'Authorization': 'Bearer ${_storage.token}'});
    request.fields.addAll(data.toMap());

    request.files.add(await http.MultipartFile.fromPath('userImage', data.userImage));

    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    debugPrint(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == 200) {
          return ResponseModel.success(message: jsonData["message"]);
        } else {
          return ResponseModel.error(message: jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModel> updateUserLocation(Map<String, String> data) async {
    var request = http.MultipartRequest('POST', Uri.parse(locationLog));

    request.headers.addAll({'Authorization': 'Bearer ${_storage.token}'});
    request.fields.addAll(data);

    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    debugPrint(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == 200) {
          return ResponseModel.success(message: jsonData["message"]);
        } else {
          return ResponseModel.error(message: jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }
}
