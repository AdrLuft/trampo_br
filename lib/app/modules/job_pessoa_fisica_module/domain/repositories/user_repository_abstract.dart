import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/users_entiti.dart';

abstract class UserRepositoryAbstract {
  // Retorna o usuário logado ou lança uma exceção se não encontrar.
  Future<UserEntity> getLoggedUser();
}
