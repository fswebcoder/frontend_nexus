import 'package:nexus/domain/entities/auth/login.entitie.dart';

abstract class LoginRepository {
  Future<void> login(LoginEntity loginEntity);
}
