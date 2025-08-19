import 'package:equatable/equatable.dart';
import 'package:nexus/shared/models/company_model.dart';
import 'package:nexus/shared/models/document_type_model.dart';
import 'package:nexus/shared/models/tokens_model.dart';

class LoginResponseEntity extends Equatable {
  final String id;
  final String documentNumber;
  final String email;
  final bool requirePasswordReset;
  final List<CompanyModel> companies;
  final DocumentTypeModel documentType;
  final TokensModel tokens;

  const LoginResponseEntity({
    required this.id,
    required this.documentNumber,
    required this.email,
    required this.requirePasswordReset,
    required this.companies,
    required this.documentType,
    required this.tokens,
  });

  @override
  List<Object?> get props => [id, documentNumber, email, requirePasswordReset, companies, documentType, tokens];
}
