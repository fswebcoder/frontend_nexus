import 'package:nexus/data/datasources/remote/auth/login_remote_datasource.dart';
import 'package:nexus/data/models/presenter/api_response.dart';
import 'package:nexus/domain/entities/auth/request/login.entitie.dart';
import 'package:nexus/domain/entities/auth/response/login_response.dart';
import 'package:nexus/domain/repositories/auth/login_repository.dart';

/// 🏗️ Implementación concreta del repositorio de login
/// Siguiendo Clean Architecture: Infrastructure Layer
class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource _remoteDataSource;

  const LoginRepositoryImpl({required LoginRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResponse<LoginResponseEntity>> login(LoginEntity loginEntity) async {
    return await _remoteDataSource.login(loginEntity);
  }
}
