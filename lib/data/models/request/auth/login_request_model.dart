import 'package:nexus/domain/entities/auth/request/login.entitie.dart';

class LoginRequestModel {
  final String username;
  final String password;

  const LoginRequestModel({required this.username, required this.password});

  factory LoginRequestModel.fromDomain(LoginEntity loginEntity) {
    return LoginRequestModel(username: loginEntity.username, password: loginEntity.password);
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}
