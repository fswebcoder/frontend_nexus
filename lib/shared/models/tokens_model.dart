import 'package:equatable/equatable.dart';

class TokensModel extends Equatable {
  final String accessToken;
  final String refreshToken;

  const TokensModel({required this.accessToken, required this.refreshToken});

  // 🎯 Método para convertir desde JSON
  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(accessToken: json['accessToken'] ?? '', refreshToken: json['refreshToken'] ?? '');
  }

  // 🎯 Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  TokensModel copyWith({String? accessToken, String? refreshToken}) =>
      TokensModel(accessToken: accessToken ?? this.accessToken, refreshToken: refreshToken ?? this.refreshToken);

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
