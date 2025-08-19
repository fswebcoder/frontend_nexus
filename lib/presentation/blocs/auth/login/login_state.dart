part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final String errorMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
    this.errorMessage = '',
  });

  bool get canSubmit => email.isNotEmpty && password.isNotEmpty && !isLoading;

  LoginState copyWith({String? email, String? password}) {
    return LoginState(email: email ?? this.email, password: password ?? this.password);
  }

  factory LoginState.initial() {
    return const LoginState(email: '', password: '');
  }

  @override
  List<Object?> get props => [email, password, isLoading, isSuccess, isError, errorMessage];
}
