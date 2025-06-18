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
  final String descricao;
  final String? userId;
  final List<String> requisitos; // Alterado de String para List<String>
  final String titulo;
  final String modalidade;
  final String salario;
  final bool salarioACombinar;
  final List<String> exigencias;
  final List<String> valorizados;
  final List<String> beneficios;

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
    required this.userId,
    this.requisitos = const [], // Alterado para lista com valor padrão
    this.titulo = '',
    this.modalidade = 'Presencial',
    this.salario = '',
    this.salarioACombinar = false,
    this.exigencias = const [],
    this.valorizados = const [],
    this.beneficios = const [],
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
      userId: json['userId'] as String?,
      requisitos: List<String>.from(json['requisitos'] ?? []),
      titulo: json['titulo'] as String? ?? '',
      modalidade: json['modalidade'] as String? ?? 'Presencial',
      salario: json['salario'] as String? ?? '',
      salarioACombinar: json['salarioACombinar'] as bool? ?? false,
      exigencias: List<String>.from(json['exigencias'] ?? []),
      valorizados: List<String>.from(json['valorizados'] ?? []),
      beneficios: List<String>.from(json['beneficios'] ?? []),
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
      'userId': userId,
      'requisitos': requisitos,
      'titulo': titulo,
      'modalidade': modalidade,
      'salario': salario,
      'salarioACombinar': salarioACombinar,
      'exigencias': exigencias,
      'valorizados': valorizados,
      'beneficios': beneficios,
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
    userId: userId ?? '',
    requisitos: requisitos,
    titulo: titulo,
    modalidade: modalidade,
    salario: salario,
    salarioACombinar: salarioACombinar,
    exigencias: exigencias,
    valorizados: valorizados,
    beneficios: beneficios,
  );
}
