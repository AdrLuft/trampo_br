import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/core/configs/global_themes/global_theme_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/aplications/usecases/agendamento_usecases/job_creater_usecases.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/aplications/usecases/agendamento_usecases/job_listner_usecases.dart';

class JobPessoaFisicaController extends GetxController {
  late final CriarJobsUsecasesPessoaFisica _criarAgendamentosUsecases;
  late final ListarAgendamentosPessoaFisicaUsecases _listarAgendamentosUsecases;
  final RxList agendamentos = <dynamic>[].obs;
  final isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Acesso ao controller de tema
  GlobalThemeController get themeController =>
      Get.find<GlobalThemeController>();

  JobPessoaFisicaController(
    this._criarAgendamentosUsecases,
    this._listarAgendamentosUsecases,
  );

  Future<String> criarAgendamento(agendamento) async {
    try {
      isLoading.value = true;
      return await _criarAgendamentosUsecases(agendamento);
    } on FirebaseException catch (e) {
      isLoading.value = false;
      return Future.error('Erro ao criar agendamento: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List> listarAgendamentos() async {
    try {
      isLoading.value = true;
      return await _listarAgendamentosUsecases();
    } on FirebaseException catch (e) {
      isLoading.value = false;
      return Future.error('Erro ao listar agendamentos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleTheme() async {
    await themeController.toggleTheme();
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _auth.signOut();
      await Future.delayed(Duration(seconds: 1));
      Get.toNamed('/login');
    } catch (e) {
      return Future.error('Erro ao fazer logout: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
