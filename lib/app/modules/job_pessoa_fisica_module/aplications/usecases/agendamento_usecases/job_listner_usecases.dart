import 'package:firebase_auth/firebase_auth.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/agendamento_entiti.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/agendamento_repository_abstract.dart';

class ListarAgendamentosPessoaFisicaUsecases {
  final AgendamentoRepositoryAbstract _repository;
  final FirebaseAuth auth = FirebaseAuth.instance;

  ListarAgendamentosPessoaFisicaUsecases(this._repository);

  Future<List<AgendamentoEntiti>> call() async {
    final String userId = auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      return [];
    }
    final agendamentos = await _repository.getAgendamentos(userId);
    return agendamentos;
  }
}
