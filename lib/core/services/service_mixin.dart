// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../enum/api_status.dart';
import '../model/response_model.dart';

mixin ServiceMixin {
  /* Error Messages */
  static const UNAUTHORIZED_MESSAGE = "Your session expired. Please login again";
  static const FORBIDDEN_MESSAGE = "You are not authorized. Please try login again";
  static const NO_CONNECTION_MESSAGE =
      "No internet connection. Please check you internet connection";
  static const TIMEOUT_MESSAGE = "Connection timeout. Please try again";
  static const ERROR_MESSAGE = "Something went wrong. Please try again";

  /* Parse String url to Uri */
  Uri parseUri(String url, {parameter}) {
    debugPrint(url);
    return Uri.parse(url);
  }

  ResponseModel<T> exceptionResponse<T>(Object ex) {
    switch (ex) {
      case SocketException:
        return ResponseModel.error(status: ApiStatus.noConnection, message: NO_CONNECTION_MESSAGE);
      case TimeoutException:
        return ResponseModel.error(status: ApiStatus.timeout, message: TIMEOUT_MESSAGE);
      default:
        return ResponseModel.error(status: ApiStatus.error, message: ERROR_MESSAGE);
    }
  }

  ResponseModel<T> errorResponse<T>(Response res) {
    switch (res.statusCode) {
      case 400:
        final jsonData = jsonDecode(res.body);
        String message = "";
        if ((jsonData["type"] ?? "string") == "string") {
          message = jsonData["msg"];
        } else {
          print(jsonData["messages"].join(". "));
          message = (jsonData["messages"] as List).join(". ");
        }
        return ResponseModel.error(status: ApiStatus.error, message: message);
      case 401:
        return ResponseModel.error(message: UNAUTHORIZED_MESSAGE, status: ApiStatus.unauthorized);
      case 403:
        return ResponseModel.error(message: FORBIDDEN_MESSAGE, status: ApiStatus.forbidden);
      default:
        return ResponseModel.error(status: ApiStatus.error, message: ERROR_MESSAGE);
    }
  }

  Future<ResponseModel> imageUploadErrorResponse(StreamedResponse res) async {
    switch (res.statusCode) {
      case 400:
        final respStr = await res.stream.bytesToString();
        var jsonData = jsonDecode(respStr);
        String message = "";
        if (jsonData["type"] == "string") {
          message = jsonData["msg"];
        } else {
          print(jsonData["messages"].join(". "));
          message = (jsonData["messages"] as List).join(". ");
        }
        return ResponseModel.error(status: ApiStatus.error, message: message);
      case 401:
        return ResponseModel.error(message: UNAUTHORIZED_MESSAGE, status: ApiStatus.unauthorized);
      case 403:
        return ResponseModel.error(message: FORBIDDEN_MESSAGE, status: ApiStatus.unauthorized);
      default:
        return ResponseModel.error(status: ApiStatus.error, message: ERROR_MESSAGE);
    }
  }

  Future<ResponseModel<T>> streamErrorResponse<T>(StreamedResponse res) async {
    switch (res.statusCode) {
      case 400:
        final respStr = await res.stream.bytesToString();
        var jsonData = jsonDecode(respStr);
        String message = "";
        if (jsonData["type"] == "string") {
          message = jsonData["msg"];
        } else {
          print(jsonData["messages"].join(". "));
          message = (jsonData["messages"] as List).join(". ");
        }
        return ResponseModel.error(status: ApiStatus.error, message: message);
      case 401:
        return ResponseModel.error(message: UNAUTHORIZED_MESSAGE, status: ApiStatus.unauthorized);
      case 403:
        return ResponseModel.error(message: FORBIDDEN_MESSAGE, status: ApiStatus.unauthorized);
      default:
        return ResponseModel.error(status: ApiStatus.error, message: ERROR_MESSAGE);
    }
  }
}
