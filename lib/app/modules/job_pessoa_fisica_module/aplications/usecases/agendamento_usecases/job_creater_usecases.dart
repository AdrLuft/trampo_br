import 'package:firebase_auth/firebase_auth.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/agendamento_entiti.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/agendamento_repository_abstract.dart';

class CriarAgendamentosUsecases {
  final AgendamentoRepositoryAbstract _repository;
  FirebaseAuth auth = FirebaseAuth.instance;

  CriarAgendamentosUsecases(this._repository, this.auth);

  Future<String> call(AgendamentoEntiti agendamento) async {
    final String userId = auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      throw Exception('Usuário não autenticado');
    }
    await _repository.createAgendamento(agendamento);
    return 'Agendamento criado com sucesso';
  }
}

/* 
Servem para definir as regras de negócio e a lógica de aplicação.

Use Cases recebem a injeção do repository da Domain manipulando regras de negócio
e depois as use cases são injetadas nos controllers.
 */
