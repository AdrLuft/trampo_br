import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/trampos_entiti.dart';

class CreateTramposModel {
  final String id;
  final String createTrampoNome;
  final String createDate;
  final String status;
  final String tipoVaga;
  final String email;
  final String telefone;
  final String userAddress;
  final String descricao; // Assuming descricao is not provided in the model

  CreateTramposModel({
    required this.id,
    required this.createTrampoNome,
    required this.createDate,
    required this.tipoVaga,
    required this.status,
    required this.email,
    required this.telefone,
    required this.userAddress,
    required this.descricao,
  });

  factory CreateTramposModel.fromJson(Map<String, dynamic> json) {
    return CreateTramposModel(
      id: json['id'] as String? ?? '',
      createTrampoNome: json['createTrampoNome'] as String,
      createDate: json['createDate'] as String,
      status: json['status'] as String,
      tipoVaga: json['tipoVaga'] as String? ?? '',
      email: json['email'] as String? ?? '',
      telefone: json['telefone'] as String? ?? '',
      userAddress: json['userAddress'] as String? ?? '',
      descricao: json['descricao'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createTrampoNome': createTrampoNome,
      'createDate': createDate,
      'status': status,
      'tipoVaga': tipoVaga,
      'email': email,
      'telefone': telefone,
      'userAddress': userAddress,
      'descricao': descricao,
    };
  }

  TramposEntiti toEntity() => TramposEntiti(
    id: id,
    createTrampoNome: createTrampoNome,
    email: email,
    telefone: telefone,
    createDate: createDate,
    tipoVaga: tipoVaga,
    status: status,
    userAddress: userAddress,
    descricao: descricao,
  );
}
