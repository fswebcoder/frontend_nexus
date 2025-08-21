import 'package:nexus/data/models/presenter/custom_error_result_presenter.dart';

class ApiResponse<T> {
  bool success;
  int statusCode;
  DateTime timestamp;
  String message;
  T? data;
  Map<String, dynamic>? errors;
  CustomErrorResultPresenter? error;

  ApiResponse.success(this.data, this.statusCode, {this.message = 'Success'})
    : success = true,
      timestamp = DateTime.now(),
      errors = null,
      error = null;

  ApiResponse.error({
    required this.statusCode,
    this.message = 'Error occurred',
    CustomErrorResultPresenter? error,
    Map<String, dynamic>? errors,
  }) : success = false,
       timestamp = DateTime.now(),
       data = null {
    _setErrores(error, errors);
  }

  void _setErrores(CustomErrorResultPresenter? error, Map<String, dynamic>? errors) {
    this.error = error ?? CustomErrorResultPresenter(message: message, statusCode: statusCode);
    this.errors = errors ?? <String, dynamic>{};
  }
}
