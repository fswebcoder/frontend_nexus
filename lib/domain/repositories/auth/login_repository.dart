import 'package:nexus/data/models/presenter/api_response.dart';
import 'package:nexus/domain/entities/auth/request/login.entitie.dart';
import 'package:nexus/domain/entities/auth/response/login_response.dart';

abstract class LoginRepository {
  Future<ApiResponse<LoginResponseEntity>> login(LoginEntity loginEntity);
}
