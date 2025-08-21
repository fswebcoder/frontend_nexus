import 'package:equatable/equatable.dart';
import 'package:nexus/shared/models/branding_model.dart';

class CompanyModel extends Equatable {
  final String id;
  final String name;
  final String shortName;
  final BrandingModel branding;

  const CompanyModel({required this.id, required this.name, required this.shortName, required this.branding});

  // 🎯 Método para convertir desde JSON
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      shortName: json['shortName'] ?? '',
      branding: BrandingModel.fromJson(json['branding'] ?? {}),
    );
  }

  // 🎯 Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'shortName': shortName, 'branding': branding.toJson()};
  }

  CompanyModel copyWith({String? id, String? name, String? shortName, BrandingModel? branding}) => CompanyModel(
    id: id ?? this.id,
    name: name ?? this.name,
    shortName: shortName ?? this.shortName,
    branding: branding ?? this.branding,
  );

  @override
  List<Object?> get props => [id, name, shortName, branding];
}
