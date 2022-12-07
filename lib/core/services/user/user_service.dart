import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ret_cat/core/model/user/user_model.dart';

import '../../constance/end_points.dart';
import '../../model/response_model.dart';
import '../../utils/storage/storage.dart';
import '../service_mixin.dart';
import 'package:http/http.dart' as http;

class UserService with ServiceMixin {
  final Storage _storage = Storage.instance;

  Future<ResponseModel> loginUser(Map<String, String> data, String role) async {
    var request = http.MultipartRequest('POST', Uri.parse(login));
    request.fields.addAll(data);
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == 200) {
          debugPrint(jsonData["token"]);
          _storage.setUser(jsonData["token"], role);
          return ResponseModel.success(message: jsonData["message"]);
        } else {
          return ResponseModel.error(message: jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModel> registerUser(Map<String, String> data) async {
    var request = http.MultipartRequest('POST', Uri.parse(register));
    request.fields.addAll(data);

    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    debugPrint(res);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> jsonData = jsonDecode(res);
        if (jsonData["status"] == true) {
          debugPrint(jsonData["token"]);
          _storage.setUser(jsonData["token"], "user");
          return ResponseModel.success(message: jsonData["message"]);
        } else {
          return ResponseModel.error(message: jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModel<UserModel>> fetchUserProfile() async {
    var request = http.Request('GET', Uri.parse(profile));
    request.headers.addAll({'Authorization': 'Bearer ${_storage.token}'});
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    debugPrint(res);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> jsonData = jsonDecode(res);
        if (jsonData["status"] == 200) {
          var data = UserModel.fromJson(jsonData["data"]["user_details"]);
          return ResponseModel.success(message: jsonData["message"], data: data);
        } else {
          return ResponseModel.error(message: jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }

  Future<ResponseModel> updateUserProfile(String? image, Map<String, String> data) async {
    var request = http.MultipartRequest('POST', parseUri(profile));
    var header = {"Authorization": "Bearer ${Storage.instance.token}"};
    request.headers.addAll(header);
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('userImage', image));
    }
    request.fields.addAll(data);
    http.StreamedResponse response = await request.send();

    final res = await response.stream.bytesToString();
    print(res);
    switch (response.statusCode) {
      case 200:
        final jsonData = jsonDecode(res);
        if (jsonData["status"] == 200) {
          // final data = UserModel.fromJson(jsonData["data"]);
          return ResponseModel.success(message: jsonData["message"]);
        } else {
          return ResponseModel.error(message: jsonData["error"] ?? jsonData["message"]);
        }
      default:
        return streamErrorResponse(response);
    }
  }
}
