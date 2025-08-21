import 'package:nexus/domain/entities/auth/response/login_response.dart';
import 'package:nexus/shared/models/company_model.dart';
import 'package:nexus/shared/models/document_type_model.dart';
import 'package:nexus/shared/models/tokens_model.dart';

class LoginResponseModel {
  final String id;
  final String documentNumber;
  final String email;
  final bool requirePasswordReset;
  final List<CompanyModel> companies;
  final DocumentTypeModel documentType;
  final TokensModel tokens;

  LoginResponseModel({
    required this.id,
    required this.documentNumber,
    required this.email,
    required this.requirePasswordReset,
    required this.companies,
    required this.documentType,
    required this.tokens,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json['id'],
      documentNumber: json['documentNumber'],
      email: json['email'],
      requirePasswordReset: json['requirePasswordReset'],
      companies: (json['companies'] as List).map((e) => CompanyModel.fromJson(e)).toList(),
      documentType: DocumentTypeModel.fromJson(json['documentType']),
      tokens: TokensModel.fromJson(json['tokens']),
    );
  }

  LoginResponseEntity toDomain() {
    return LoginResponseEntity(
      id: id,
      documentNumber: documentNumber,
      email: email,
      requirePasswordReset: requirePasswordReset,
      companies: companies,
      documentType: documentType,
      tokens: tokens,
    );
  }
}
