import 'dart:developer';

import 'package:nexus/core/global/environment.dart';
import 'package:nexus/data/base/api_datasource.dart';
import 'package:nexus/data/datasources/remote/auth/login_remote_datasource.dart';
import 'package:nexus/data/models/domain/auth/login_response_model_domain.dart';
import 'package:nexus/data/models/presenter/api_response.dart';
import 'package:nexus/data/models/request/auth/login_request_model.dart';
import 'package:nexus/domain/entities/auth/request/login.entitie.dart';
import 'package:nexus/domain/entities/auth/response/login_response.dart';

class LoginRemoteDataSourceImp extends ApiDataSource implements LoginRemoteDataSource {
  static const String _logTag = 'LoginRemoteDataSource';

  LoginRemoteDataSourceImp() : super();

  @override
  Future<ApiResponse<LoginResponseEntity>> login(LoginEntity loginEntity) async {
    const path = 'auth/login';

    log('Iniciando login para usuario: ${loginEntity.username}', name: _logTag);

    final requestModel = LoginRequestModel.fromDomain(loginEntity);

    final response = await postApi<LoginResponseModel>(path, (value) {
      log('Respuesta recibida del servidor', name: _logTag);
      return LoginResponseModel.fromJson(value);
    }, data: requestModel.toJson());

    if (response.success && response.data != null) {
      log('Login exitoso', name: _logTag);
      return ApiResponse<LoginResponseEntity>.success(response.data!.toDomain(), response.statusCode);
    }

    log('Login falló: ${response.message}', name: _logTag);
    return ApiResponse<LoginResponseEntity>.error(
      message: response.message,
      statusCode: response.statusCode,
      error: response.error,
      errors: response.errors,
    );
  }
}
