import '../enum/api_status.dart';

class ResponseModel<T> {
  ApiStatus status;
  String message;
  T? data;

  ResponseModel.success({String? message, this.data})
      : status = ApiStatus.success,
        message = message ?? "";

  ResponseModel.error({this.status = ApiStatus.error, required this.message, this.data});
}
