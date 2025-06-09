import 'package:firebase_auth/firebase_auth.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/agendamento_repository_abstract.dart';

class DeleteAgendamentoUsecase {
  final AgendamentoRepositoryAbstract _repository;
  final FirebaseAuth auth = FirebaseAuth.instance;

  DeleteAgendamentoUsecase(this._repository);

  Future<void> call(String agendamentoId) async {
    final String userId = auth.currentUser?.uid ?? '';
    final getAgendamento = await _repository.getAgendamentoById(userId);
    if (getAgendamento?.status == 'concluido') {
      await _repository.deleteAgendamento(agendamentoId);
    } else {
      throw Exception(
        'Agendamento não pode ser deletado, pois não está concluído.'
            .toString(),
      );
    }
  }
}
