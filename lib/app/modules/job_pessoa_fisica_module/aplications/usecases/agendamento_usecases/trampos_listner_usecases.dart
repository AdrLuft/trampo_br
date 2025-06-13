import 'package:firebase_auth/firebase_auth.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/trampos_entiti.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/trampos_repository_abstract.dart';

class ListarTramposPessoaFisicaUsecases {
  final TramposRepositoryAbstract _repository;
  final FirebaseAuth auth = FirebaseAuth.instance;

  ListarTramposPessoaFisicaUsecases(this._repository);

  Future<List<TramposEntiti>> call() async {
    final String userId = auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      return [];
    }
    final agendamentos = await _repository.getTrampos(userId);
    return agendamentos;
  }

  Future<List<TramposEntiti>> getMinhasVagas() async {
    return await _repository.getMiTrampos();
  }
}
