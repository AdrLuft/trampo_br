import 'package:firebase_auth/firebase_auth.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/trampos_repository_abstract.dart';

class DeleteTramposUsecase {
  final TramposRepositoryAbstract _repository;
  final FirebaseAuth auth = FirebaseAuth.instance;

  DeleteTramposUsecase(this._repository);

  Future<void> call(String trampoId) async {
    final String userId = auth.currentUser?.uid ?? '';
    final getTrampo = await _repository.getTrampoById(userId);
    if (getTrampo?.status == 'concluido') {
      await _repository.deleteTrampos(trampoId);
    } else {
      throw Exception(
        'Agendamento não pode ser deletado, pois não está concluído.'
            .toString(),
      );
    }
  }
}
