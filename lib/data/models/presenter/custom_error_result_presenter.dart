import 'package:equatable/equatable.dart';

class CustomErrorResultPresenter extends Equatable {
  final int? statusCode;
  final String? message;

  const CustomErrorResultPresenter({this.statusCode = 0, this.message});

  @override
  List<Object?> get props => [statusCode, message];
}
