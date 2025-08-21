import 'package:dio/dio.dart';
import 'package:nexus/core/utils/conection/connectivity_service.dart';

class ConnectivityInterceptor extends Interceptor {
  final ConnectivityService _connectivityService;

  ConnectivityInterceptor(this._connectivityService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final isConnected = await _connectivityService.isConnected;
    if (!isConnected) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: NoInternetException(),
          type: DioExceptionType.connectionError,
          message: 'No hay conexión a internet',
        ),
      );
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ✅ Verificar tipos de error de conexión
    if (_isConnectionError(err.type)) {
      _connectivityService.isConnected.then((isConnected) {
        if (!isConnected) {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: NoInternetException(),
              type: DioExceptionType.connectionError,
              message: 'No hay conexión a internet',
            ),
          );
          return;
        }
        super.onError(err, handler);
      });
      return;
    }

    super.onError(err, handler);
  }

  bool _isConnectionError(DioExceptionType type) {
    return type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.connectionError;
  }
}

class NoInternetException implements Exception {
  final String message;

  const NoInternetException({this.message = 'No hay conexión a internet'});

  @override
  String toString() => message;
}
