import 'package:equatable/equatable.dart';
import 'package:nexus/shared/models/branding_model.dart';

class CompanyModel extends Equatable {
  final String id;
  final String name;
  final String shortName;
  final BrandingModel branding;

  const CompanyModel({required this.id, required this.name, required this.shortName, required this.branding});

  CompanyModel copyWith({String? id, String? name, String? shortName, BrandingModel? branding}) => CompanyModel(
    id: id ?? this.id,
    name: name ?? this.name,
    shortName: shortName ?? this.shortName,
    branding: branding ?? this.branding,
  );

  @override
  List<Object?> get props => [id, name, shortName, branding];
}
