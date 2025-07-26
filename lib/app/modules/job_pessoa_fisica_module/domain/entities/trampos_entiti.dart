class TramposEntiti {
  final String id;
  final String createTrampoNome;
  final String email;
  final String telefone;
  final String createDate;
  final String tipoVaga;
  final String status;
  final String? userAddress;
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
  final String? categoria;

  TramposEntiti({
    required this.id,
    required this.createTrampoNome,
    required this.email,
    required this.telefone,
    required this.createDate,
    required this.tipoVaga,
    required this.status,
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
    this.categoria,
  });
}
