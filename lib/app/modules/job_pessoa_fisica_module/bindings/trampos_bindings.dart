import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/aplications/usecases/agendamento_usecases/trampos_listner_usecases.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/data/repositories_imp/trampos_repository_imp.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/data/repositories_imp/user_repository_imp.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/trampos_repository_abstract.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/user_repository_abstract.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/profile_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/trampos_controller.dart';

class PessoaFisicaAppBindings extends Bindings {
  @override
  void dependencies() {
    // Serviços do Firebase (instâncias singleton)
    Get.put<FirebaseAuth>(FirebaseAuth.instance, permanent: true);
    Get.put<FirebaseFirestore>(FirebaseFirestore.instance, permanent: true);

    // Repositórios (Interface => Implementação)
    Get.lazyPut<TramposRepositoryAbstract>(() => TramposRepositoryImp());
    Get.lazyPut<UserRepositoryAbstract>(
      () => UserRepositoryImp(Get.find(), Get.find()),
    );

    // Casos de Uso ===============================================
    Get.lazyPut(
      () => ListarTramposPessoaFisicaUsecases(
        Get.find<TramposRepositoryAbstract>(),
      ),
    );

    // Controladores ===============================================

    // Registrar o ProfileController ANTES do TramposController
    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find<UserRepositoryAbstract>()),
    );

    // Corrigindo o TramposController - removendo o terceiro parâmetro
    Get.lazyPut<TramposController>(
      () => TramposController(
        Get.find<ListarTramposPessoaFisicaUsecases>(),
        Get.find<TramposRepositoryAbstract>(),
      ),
    );
  }
}
