import 'package:interprise_calendar/app/modules/job_module/domain/entities/agendamento_entiti.dart';

class AgendamentosModel {
  final String id;
  final String clienteNome;
  final String data;
  final String status;
  final String servico;
  final String email;
  final String telefone;

  AgendamentosModel(
    this.servico, {
    required this.id,
    required this.clienteNome,
    required this.data,
    required this.status,
    required this.email,
    required this.telefone,
  });

  factory AgendamentosModel.fromJson(Map<String, dynamic> json) {
    return AgendamentosModel(
      json['servico'] as String,
      id: json['id'] as String,
      clienteNome: json['nome'] as String,
      data: json['data'] as String,
      status: json['status'] as String,
      email: json['email'] as String? ?? '',
      telefone: json['telefone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': clienteNome,
      'data': data,
      'status': status,
      'servico': servico,
      'email': email,
      'telefone': telefone,
    };
  }

  AgendamentoEntiti toEntity() => AgendamentoEntiti(
    id: id,
    clienteNome: clienteNome,
    email: null,
    telefone: '',
    data: data,
    servico: servico,
    status: status,
  );
}
