import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/aplications/usecases/agendamento_usecases/job_creater_usecases.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/aplications/usecases/agendamento_usecases/job_listner_usecases.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/data/repositories_imp/agendamentos_repository_imp.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/agendamento_repository_abstract.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/job_controller.dart';

class PessoaFisicaAppBindings extends Bindings {
  @override
  void dependencies() {
    // Injetando dependências com lazyPut para otimizar a memória.

    // Repositório (Interface => Implementação)
    Get.lazyPut<AgendamentoRepositoryAbstract>(
      () => AgendamentosRepositoryImp(),
    );

    // Casos de Uso
    Get.lazyPut(
      () => CriarJobsUsecasesPessoaFisica(
        Get.find<AgendamentoRepositoryAbstract>(),
        FirebaseAuth.instance,
      ),
    );
    Get.lazyPut(
      () => ListarAgendamentosPessoaFisicaUsecases(
        Get.find<AgendamentoRepositoryAbstract>(),
      ),
    );

    // Controller
    Get.lazyPut(
      () => JobPessoaFisicaController(
        Get.find<CriarJobsUsecasesPessoaFisica>(),
        Get.find<ListarAgendamentosPessoaFisicaUsecases>(),
      ),
    );
  }
}
