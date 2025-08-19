import 'package:nexus/domain/entities/auth/login.entitie.dart';
import 'package:nexus/domain/entities/auth/login_response.dart';

abstract class LoginRepository {
  Future<LoginResponseEntity> login(LoginEntity loginEntity);
}
