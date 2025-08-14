import 'package:dio/dio.dart';
import 'package:nexus/core/network/interceptors/connectivity_interceptor.dart';
import 'package:nexus/core/network/http_status_error.dart';

class DioExceptions {
  static String fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        return "La petición fue cancelada";

      case DioExceptionType.connectionTimeout:
        return "Tiempo de conexión agotado";

      case DioExceptionType.receiveTimeout:
        return "Tiempo de recepción agotado";

      case DioExceptionType.sendTimeout:
        return "Tiempo de envío agotado";

      case DioExceptionType.badResponse:
        return _handleStatusCode(dioException.response?.statusCode);

      case DioExceptionType.connectionError:
        if (dioException.error is NoInternetException) {
          return dioException.error.toString();
        }
        return "Error de conexión";

      case DioExceptionType.badCertificate:
        return "Certificado SSL inválido";

      case DioExceptionType.unknown:
        if (dioException.error is NoInternetException) {
          return dioException.error.toString();
        }
        return "Error desconocido: ${dioException.message}";
    }
  }

  static String _handleStatusCode(int? statusCode) {
    return HttpStatusError.messageFor(statusCode);
  }

  static String getErrorMessage(DioException dioException) {
    try {
      if (dioException.response?.data != null) {
        final data = dioException.response!.data;

        if (data is Map<String, dynamic>) {
          if (data.containsKey('message')) {
            return data['message'] as String;
          }

          if (data.containsKey('error')) {
            final error = data['error'];
            if (error is String) {
              return error;
            } else if (error is Map<String, dynamic> && error.containsKey('message')) {
              return error['message'] as String;
            }
          }

          if (data.containsKey('errors') && data['errors'] is List) {
            final errors = data['errors'] as List;
            if (errors.isNotEmpty) {
              return errors.first.toString();
            }
          }

          if (data.containsKey('detail')) {
            return data['detail'] as String;
          }
        }
      }
    } catch (e) {
      return fromDioError(dioException);
    }

    return fromDioError(dioException);
  }
}
