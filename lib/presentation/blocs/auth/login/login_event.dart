part of 'login_bloc.dart';

abstract class LoginEvent {}

class ChangeEmailEvent extends LoginEvent {
  final String? email;
  ChangeEmailEvent({this.email});
}
