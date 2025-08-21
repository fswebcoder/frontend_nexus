import 'package:equatable/equatable.dart';

class DocumentTypeModel extends Equatable {
  final String id;
  final String name;
  final String code;

  const DocumentTypeModel({required this.id, required this.name, required this.code});

  // 🎯 Método para convertir desde JSON
  factory DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    return DocumentTypeModel(id: json['id'] ?? '', name: json['name'] ?? '', code: json['code'] ?? '');
  }

  // 🎯 Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code};
  }

  DocumentTypeModel copyWith({String? id, String? name, String? code}) =>
      DocumentTypeModel(id: id ?? this.id, name: name ?? this.name, code: code ?? this.code);

  @override
  List<Object?> get props => [id, name, code];
}
