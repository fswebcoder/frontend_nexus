import 'package:dio/dio.dart';
import 'package:nexus/core/utils/shared_preferences/shared_preferences_service.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferencesService _sharedPreferencesService;

  AuthInterceptor(this._sharedPreferencesService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _sharedPreferencesService.getString(StorageKeys.authToken);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = _sharedPreferencesService.getString(StorageKeys.refreshToken);

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final dio = Dio();

          final response = await dio.post(
            '${err.requestOptions.baseUrl}/auth/refresh',
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200) {
            final newToken = response.data['access_token'];
            final newRefreshToken = response.data['refresh_token'];

            await _sharedPreferencesService.setString(StorageKeys.authToken, newToken);
            if (newRefreshToken != null) {
              await _sharedPreferencesService.setString(StorageKeys.refreshToken, newRefreshToken);
            }

            final originalRequest = err.requestOptions;
            originalRequest.headers['Authorization'] = 'Bearer $newToken';

            final retryResponse = await dio.request(
              originalRequest.path,
              data: originalRequest.data,
              queryParameters: originalRequest.queryParameters,
              options: Options(method: originalRequest.method, headers: originalRequest.headers),
            );

            return handler.resolve(retryResponse);
          }
        } catch (e) {
          await _clearAuthData();
        }
      } else {
        await _clearAuthData();
      }
    }

    super.onError(err, handler);
  }

  Future<void> _clearAuthData() async {
    await _sharedPreferencesService.remove(StorageKeys.authToken);
    await _sharedPreferencesService.remove(StorageKeys.refreshToken);
    await _sharedPreferencesService.setBool(StorageKeys.isLoggedIn, false);
    await _sharedPreferencesService.remove(StorageKeys.userId);
    await _sharedPreferencesService.remove(StorageKeys.userEmail);
  }
}
