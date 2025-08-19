import 'package:nexus/domain/entities/auth/login.entitie.dart';
import 'package:nexus/domain/entities/auth/login_response.dart';
import 'package:nexus/domain/repositories/auth/login_repository.dart';

export 'package:nexus/domain/usescases/auth/login_usecase.dart';

class LoginUseCase {
  final LoginRepository loginRepository;

  LoginUseCase({required this.loginRepository});

  Future<LoginResponseEntity> call(LoginEntity loginEntity) async {
    return await loginRepository.login(loginEntity);
  }
}
