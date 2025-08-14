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
        DioException(requestOptions: options, error: NoInternetException(), type: DioExceptionType.connectionError),
      );
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError) {
      _connectivityService.isConnected.then((isConnected) {
        if (!isConnected) {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: NoInternetException(),
              type: DioExceptionType.connectionError,
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
}

class NoInternetException implements Exception {
  final String message;

  const NoInternetException({this.message = 'No hay conexión a internet'});

  @override
  String toString() => message;
}
