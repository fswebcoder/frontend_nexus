import 'package:equatable/equatable.dart';

class ApiResponse<T> extends Equatable {
  final bool success;
  final int statusCode;
  final DateTime timestamp;
  final String path;
  final String message;
  final T? data;

  const ApiResponse({
    required this.success,
    required this.statusCode,
    required this.timestamp,
    required this.path,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>)? fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      path: json['path'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T)? toJsonT) {
    return {
      'success': success,
      'statusCode': statusCode,
      'timestamp': timestamp.toIso8601String(),
      'path': path,
      'message': message,
      'data': data != null && toJsonT != null ? toJsonT(data as T) : null,
    };
  }

  ApiResponse<T> copyWith({
    bool? success,
    int? statusCode,
    DateTime? timestamp,
    String? path,
    String? message,
    T? data,
  }) {
    return ApiResponse<T>(
      success: success ?? this.success,
      statusCode: statusCode ?? this.statusCode,
      timestamp: timestamp ?? this.timestamp,
      path: path ?? this.path,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [success, statusCode, timestamp, path, message, data];
}
