import 'package:equatable/equatable.dart';

class BrandingModel extends Equatable {
  final String logo;
  final String primaryColor;
  final String secondaryColor;
  final String tertiaryColor;

  const BrandingModel({
    required this.logo,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
  });

  // 🎯 Método para convertir desde JSON
  factory BrandingModel.fromJson(Map<String, dynamic> json) {
    return BrandingModel(
      logo: json['logo'] ?? '',
      primaryColor: json['primaryColor'] ?? '',
      secondaryColor: json['secondaryColor'] ?? '',
      tertiaryColor: json['tertiaryColor'] ?? '',
    );
  }

  // 🎯 Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'logo': logo,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'tertiaryColor': tertiaryColor,
    };
  }

  BrandingModel copyWith({String? logo, String? primaryColor, String? secondaryColor, String? tertiaryColor}) =>
      BrandingModel(
        logo: logo ?? this.logo,
        primaryColor: primaryColor ?? this.primaryColor,
        secondaryColor: secondaryColor ?? this.secondaryColor,
        tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      );

  @override
  List<Object?> get props => [logo, primaryColor, secondaryColor, tertiaryColor];
}
