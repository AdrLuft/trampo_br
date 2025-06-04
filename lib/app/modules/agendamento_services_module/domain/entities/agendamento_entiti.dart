class AgendamentoEntiti {
  final String id;
  final String clienteNome;
  final String? email;
  final String telefone;
  final String data;

  final String servico;
  final String status;

  AgendamentoEntiti({
    required this.id,
    required this.clienteNome,
    this.email,
    required this.telefone,
    required this.data,

    required this.servico,
    required this.status,
  });
}
