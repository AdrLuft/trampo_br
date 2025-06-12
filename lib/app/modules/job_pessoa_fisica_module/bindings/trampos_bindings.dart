import 'package:get/get.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/aplications/usecases/agendamento_usecases/trampos_listner_usecases.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/data/repositories_imp/trampos_repository_imp.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/trampos_repository_abstract.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/trampos_controller.dart';

class PessoaFisicaAppBindings extends Bindings {
  @override
  void dependencies() {
    // Injetando dependências com lazyPut para otimizar a memória.

    // Repositório (Interface => Implementação)
    Get.lazyPut<TramposRepositoryAbstract>(() => TramposRepositoryImp());

    // Casos de Uso
    Get.lazyPut(
      () => ListarTramposPessoaFisicaUsecases(
        Get.find<TramposRepositoryAbstract>(),
      ),
    );

    // Controller - agora recebe o repositório diretamente
    Get.lazyPut(
      () => TramposController(
        Get.find<ListarTramposPessoaFisicaUsecases>(),
        Get.find<TramposRepositoryAbstract>(),
      ),
    );
  }
}
