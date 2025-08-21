import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
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

  Future<ApiResponse<T>> getApi<T>(
    String path,
    T Function(dynamic value) mapperFunction, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Options? options,
    HeaderType headerType = HeaderType.listFirstHeaders,
  }) async {
    try {
      final connectivity = await _connectivityService.isConnected;
      if (!connectivity) {
        return ApiResponse<T>.error(message: ApiBaseStrings.internetNotAvailable, statusCode: 0);
      }

      final options = Options(headers: _getHeaderType(headerType, headers));

      final response = await _dio.get(path, options: options, queryParameters: queryParameters);

      return _manageResponse<T>(response, mapperFunction);
    } catch (ex) {
      return _handleException<T>(ex);
    }
  }

  ApiResponse<T> _handleException<T>(dynamic ex) {
    if (ex is DioException) {
      return _handleDioException<T>(ex);
    }
    log(ex.toString(), name: 'ApiSource Error', error: ex);
    return ApiResponse<T>.error(message: ApiBaseStrings.defaultError, statusCode: 0);
  }

  ApiResponse<T> _handleDioException<T>(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResponse<T>.error(message: 'Timeout de conexión', statusCode: 0);
      case DioExceptionType.badResponse:
        if (dioException.response != null) {
          return _manageErrorResponse<T>(dioException.response!);
        }
        return ApiResponse<T>.error(message: ApiBaseStrings.defaultError, statusCode: 0);
      case DioExceptionType.connectionError:
        return ApiResponse<T>.error(message: ApiBaseStrings.internetNotAvailable, statusCode: 0);
      case DioExceptionType.cancel:
        return ApiResponse<T>.error(message: 'Petición cancelada', statusCode: 0);
      default:
        return ApiResponse<T>.error(message: ApiBaseStrings.defaultError, statusCode: 0);
    }
  }

  ApiResponse<T> _manageErrorResponse<T>(Response response) {
    final statusCode = response.statusCode ?? 0;

    if (statusCode >= 500) {
      return ApiResponse<T>.error(message: ApiBaseStrings.defaultError, statusCode: 0);
    } else {
      return _errorFromResponse<T>(response);
    }
  }

  ApiResponse<T> _errorFromResponse<T>(Response response) {
    final statusCode = response.statusCode ?? 0;
    final data = response.data;
    final message = data['message'] ?? ApiBaseStrings.defaultError;
    final errors = data['errors'] ?? {};
    final error = CustomErrorResultPresenter(message: message, statusCode: statusCode);
    return ApiResponse<T>.error(message: message, statusCode: statusCode, error: error, errors: errors);
  }

  Map<String, String> _getHeaderType(HeaderType headerType, Map<String, String>? headers) {
    switch (headerType) {
      case HeaderType.noHeader:
        return {};
      case HeaderType.listFirstHeaders:
        return getNexusListHeaders(headers);
      case HeaderType.autorizationHeaders:
        return getHeadersAuthorization(headers);
    }
  }

  Map<String, String> getNexusListHeaders(Map<String, String>? headers) {
    final String uuid = SingletonSharedPreferences().getToken() ?? "";
    headers = headers ?? <String, String>{};
    headers = _setXFingerprint(headers, uuid);
    headers = _setXDominio(headers, uuid);
    headers[HttpHeaders.contentTypeHeader] = "application/json; charset=utf-8";
    headers[HttpHeaders.acceptHeader] = "application/json; charset=UTF-8";
    return headers;
  }

  Map<String, String> _setXFingerprint(Map<String, String> headers, String uuid) {
    headers["X-Fingerprint"] = uuid;
    return headers;
  }

  Map<String, String> _setXDominio(Map<String, String> headers, String uuid) {
    final dominio = Environment.dominio ?? "default";
    final valorDominio = "${uuid}_$dominio";
    headers["X-Dominio"] = valorDominio;
    return headers;
  }

  Map<String, String> getHeadersAuthorization(Map<String, String>? headers) {
    final String uuid = SingletonSharedPreferences().getToken() ?? "";
    headers = headers ?? <String, String>{};

    headers = _setXFingerprint(headers, uuid);
    headers = _setXDominio(headers, uuid);

    final token = _singletonSharedPreferences.getToken();
    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    headers[HttpHeaders.contentTypeHeader] = "application/json; charset=utf-8";
    headers[HttpHeaders.acceptHeader] = "application/json; charset=UTF-8";

    return headers;
  }

  Future<ApiResponse<T>> _manageResponse<T>(Response response, T Function(dynamic value) mapperFunction) async {
    final statusCode = response.statusCode ?? 0;

    if (statusCode == 200 || statusCode == 400) {
      return ApiResponse<T>.success(mapperFunction(response.data), statusCode);
    }

    if (statusCode >= 500) {
      return ApiResponse<T>.error(message: ApiBaseStrings.defaultError, statusCode: 0);
    } else {
      return _errorFromResponse<T>(response);
    }
  }
}

enum HeaderType { noHeader, listFirstHeaders, autorizationHeaders }
