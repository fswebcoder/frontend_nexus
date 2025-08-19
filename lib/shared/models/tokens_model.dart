import 'package:equatable/equatable.dart';

class TokensModel extends Equatable {
  final String accessToken;
  final String refreshToken;

  const TokensModel({required this.accessToken, required this.refreshToken});

  TokensModel copyWith({String? accessToken, String? refreshToken}) =>
      TokensModel(accessToken: accessToken ?? this.accessToken, refreshToken: refreshToken ?? this.refreshToken);

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
