import 'package:firebase_auth/firebase_auth.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/trampos_entiti.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/trampos_repository_abstract.dart';

class CriarTramposUsecasesPessoaFisica {
  final TramposRepositoryAbstract _repository;
  FirebaseAuth auth = FirebaseAuth.instance;

  CriarTramposUsecasesPessoaFisica(this._repository, this.auth);

  Future<String> call(TramposEntiti trampo) async {
    final String userId = auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      throw Exception('Usuário não autenticado');
    }
    await _repository.createTrampo(trampo);
    return 'Trampo criado com sucesso';
  }
}

/*
Servem para definir as regras de negócio e a lógica de aplicação.

Use Cases recebem a injeção do repository da Domain manipulando regras de negócio
e depois as use cases são injetadas nos controllers.
 */
