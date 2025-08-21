import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nexus/core/network/interceptors/connectivity_interceptor.dart';
import 'package:nexus/core/utils/conection/connectivity_service.dart';
import 'package:nexus/core/utils/shared_preferences/shared_preferences_service.dart';
import 'package:nexus/core/utils/shared_preferences/singleton_shared_preferenses.dart';
import 'package:nexus/data/models/presenter/api_response.dart';
import 'package:nexus/data/models/presenter/custom_error_result_presenter.dart';
import 'package:nexus/shared/constants/app_base_strings.dart';
import 'package:nexus/core/global/environment.dart';

class ApiDataSource {
  final Dio _dio;
  final ConnectivityService _connectivityService;
  final SingletonSharedPreferences _singletonSharedPreferences;

  ApiDataSource({
    Dio? dio,
    ConnectivityService? connectivityService,
    SharedPreferencesService? sharedPreferencesService,
  }) : _dio = dio ?? GetIt.instance<Dio>(),
       _connectivityService = connectivityService ?? GetIt.instance<ConnectivityService>(),
       _singletonSharedPreferences = SingletonSharedPreferences();

  factory ApiDataSource.create() => ApiDataSource();

  Future<ApiResponse<T>> postApi<T>(
    String path,
    T Function(dynamic value) mapperFunction, {
    Map<String, String>? headers,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    HeaderType headerType = HeaderType.listFirstHeaders,
  }) async {
    try {
      // ✅ Los interceptors ya manejan conectividad
      final finalOptions = (options ?? Options()).copyWith(
        headers: {...?options?.headers, ..._getHeaderType(headerType, headers)},
      );

      log('🎯 Enviando POST a: ${_dio.options.baseUrl}$path', name: 'ApiDataSource');

      final response = await _dio.post(path, data: data, options: finalOptions, queryParameters: queryParameters);

      return _manageResponse<T>(response, mapperFunction);
    } catch (ex) {
      return _handleException<T>(ex);
    }
  }

  Future<ApiResponse<T>> getApi<T>(
    String path,
    T Function(dynamic value) mapperFunction, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Options? options,
    HeaderType headerType = HeaderType.listFirstHeaders,
  }) async {
    try {
      final finalOptions = (options ?? Options()).copyWith(
        headers: {...?options?.headers, ..._getHeaderType(headerType, headers)},
      );

      final response = await _dio.get(path, options: finalOptions, queryParameters: queryParameters);
      return _manageResponse<T>(response, mapperFunction);
    } catch (ex) {
      return _handleException<T>(ex);
    }
  }

  ApiResponse<T> _handleException<T>(dynamic ex) {
    if (ex is DioException) {
      return _handleDioException<T>(ex);
    }
    log('❌ Error no manejado: $ex', name: 'ApiDataSource', error: ex);
    return ApiResponse<T>.error(message: 'Error inesperado', statusCode: 0);
  }

  ApiResponse<T> _handleDioException<T>(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResponse<T>.error(message: 'Timeout de conexión', statusCode: 408);
      case DioExceptionType.connectionError:
        // ✅ El interceptor ya maneja esto, pero por si acaso
        return ApiResponse<T>.error(message: ApiBaseStrings.internetNotAvailable, statusCode: 0);
      case DioExceptionType.badResponse:
        if (dioException.response != null) {
          return _manageErrorResponse<T>(dioException.response!);
        }
        return ApiResponse<T>.error(message: 'Respuesta inválida del servidor', statusCode: 0);
      case DioExceptionType.cancel:
        return ApiResponse<T>.error(message: 'Petición cancelada', statusCode: 0);
      default:
        return ApiResponse<T>.error(message: 'Error de red', statusCode: 0);
    }
  }

  ApiResponse<T> _manageErrorResponse<T>(Response response) {
    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    String message = 'Error del servidor';
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? message;
    }

    return ApiResponse<T>.error(
      message: message,
      statusCode: statusCode,
      error: CustomErrorResultPresenter(message: message, statusCode: statusCode),
      errors: data is Map ? (data['errors'] ?? {}) : {},
    );
  }

  Future<ApiResponse<T>> _manageResponse<T>(Response response, T Function(dynamic value) mapperFunction) async {
    final statusCode = response.statusCode ?? 0;

    // ✅ Solo códigos 200-299 son éxito
    if (statusCode >= 200 && statusCode < 300) {
      try {
        final mappedData = mapperFunction(response.data);
        return ApiResponse<T>.success(mappedData, statusCode);
      } catch (e) {
        log('❌ Error en mapeo de datos: $e', name: 'ApiDataSource', error: e);
        return ApiResponse<T>.error(message: 'Error procesando respuesta', statusCode: statusCode);
      }
    }

    return _manageErrorResponse<T>(response);
  }

  Map<String, String> _getHeaderType(HeaderType headerType, Map<String, String>? headers) {
    switch (headerType) {
      case HeaderType.noHeader:
        return headers ?? {};
      case HeaderType.listFirstHeaders:
        return getNexusListHeaders(headers);
      case HeaderType.autorizationHeaders:
        return getHeadersAuthorization(headers);
    }
  }

  Map<String, String> getNexusListHeaders(Map<String, String>? headers) {
    final String uuid = _singletonSharedPreferences.getToken() ?? "";
    headers = headers ?? <String, String>{};

    if (uuid.isNotEmpty) {
      headers["X-Fingerprint"] = uuid;
      final dominio = Environment.dominio ?? "default";
      if (dominio != "domain") {
        // Evitar valor por defecto
        headers["X-Dominio"] = "${uuid}_$dominio";
      }
    }

    return headers;
  }

  Map<String, String> getHeadersAuthorization(Map<String, String>? headers) {
    final String token = _singletonSharedPreferences.getToken() ?? "";
    headers = headers ?? <String, String>{};

    if (token.isNotEmpty) {
      headers["X-Fingerprint"] = token;
      headers["Authorization"] = "Bearer $token";

      final dominio = Environment.dominio ?? "default";
      if (dominio != "domain") {
        headers["X-Dominio"] = "${token}_$dominio";
      }
    }

    return headers;
  }
}

enum HeaderType { noHeader, listFirstHeaders, autorizationHeaders }
