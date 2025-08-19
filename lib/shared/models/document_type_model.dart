import 'package:equatable/equatable.dart';

class DocumentTypeModel extends Equatable {
  final String id;
  final String name;
  final String code;

  const DocumentTypeModel({required this.id, required this.name, required this.code});

  DocumentTypeModel copyWith({String? id, String? name, String? code}) =>
      DocumentTypeModel(id: id ?? this.id, name: name ?? this.name, code: code ?? this.code);

  @override
  List<Object?> get props => [id, name, code];
}
