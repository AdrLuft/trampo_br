import 'package:cloud_firestore/cloud_firestore.dart';
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
  final List<String> requisitos;
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
    this.requisitos = const [],
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
      createDate:
          json['createDate'] is Timestamp
              ? (json['createDate'] as Timestamp).toDate().toIso8601String()
              : (json['createDate'] as String? ?? ''),
      status: json['status'] as String,
      tipoVaga: json['tipoVaga'] as String? ?? '',
      email: json['email'] as String? ?? '',
      telefone: json['telefone'] as String? ?? '',
      userAddress: json['userAddress'] as String? ?? '',
      descricao: json['descricao'] as String? ?? '',
      userId:
          json['userId'] is DocumentReference
              ? (json['userId'] as DocumentReference).id
              : (json['userId'] as String?),
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
      'userId': userId,
      'createTrampoNome': createTrampoNome,
      'userAddress': userAddress,
      'email': email,
      'telefone': telefone,
      'createDate': Timestamp.fromDate(DateTime.parse(createDate)),
      'tipoVaga': tipoVaga,
      'status': status,
      'descricao': descricao,
      'requisitos': requisitos,
      'exigencias': exigencias,
      'valorizados': valorizados,
      'beneficios': beneficios,
      'titulo': titulo,
      'modalidade': modalidade,
      'salarioACombinar': salarioACombinar,
      'salario': salarioACombinar ? 'A combinar' : salario,
    };
  }

  CreateTramposModel copyWith({
    String? id,
    String? createTrampoNome,
    String? createDate,
    String? status,
    String? tipoVaga,
    String? email,
    String? telefone,
    String? userAddress,
    String? descricao,
    String? userId,
    List<String>? requisitos,
    String? titulo,
    String? modalidade,
    String? salario,
    bool? salarioACombinar,
    List<String>? exigencias,
    List<String>? valorizados,
    List<String>? beneficios,
  }) {
    return CreateTramposModel(
      id: id ?? this.id,
      createTrampoNome: createTrampoNome ?? this.createTrampoNome,
      createDate: createDate ?? this.createDate,
      status: status ?? this.status,
      tipoVaga: tipoVaga ?? this.tipoVaga,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      userAddress: userAddress ?? this.userAddress,
      descricao: descricao ?? this.descricao,
      userId: userId ?? this.userId,
      requisitos: requisitos ?? this.requisitos,
      titulo: titulo ?? this.titulo,
      modalidade: modalidade ?? this.modalidade,
      salario: salario ?? this.salario,
      salarioACombinar: salarioACombinar ?? this.salarioACombinar,
      exigencias: exigencias ?? this.exigencias,
      valorizados: valorizados ?? this.valorizados,
      beneficios: beneficios ?? this.beneficios,
    );
  }

  factory CreateTramposModel.fromEntity(TramposEntiti entity) {
    return CreateTramposModel(
      id: entity.id,
      createTrampoNome: entity.createTrampoNome,
      createDate: entity.createDate,
      status: entity.status,
      tipoVaga: entity.tipoVaga,
      email: entity.email,
      telefone: entity.telefone,
      userAddress: entity.userAddress ?? '',
      descricao: entity.descricao,
      userId: entity.userId,
      requisitos: entity.requisitos,
      titulo: entity.titulo,
      modalidade: entity.modalidade,
      salario: entity.salario,
      salarioACombinar: entity.salarioACombinar,
      exigencias: entity.exigencias,
      valorizados: entity.valorizados,
      beneficios: entity.beneficios,
    );
  }
  TramposEntiti toEntity() => TramposEntiti(
    id: id,
    createTrampoNome: createTrampoNome,
    createDate: createDate,
    status: status,
    tipoVaga: tipoVaga,
    email: email,
    telefone: telefone,
    userAddress: userAddress,
    descricao: descricao,
    userId: userId,
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
