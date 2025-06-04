import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/modules/agendamento_services_module/aplications/usecases/agendamento_usecases/criar_agendamentos_usecases.dart';
import 'package:interprise_calendar/app/modules/agendamento_services_module/aplications/usecases/agendamento_usecases/listar_agendamentos_usecases.dart';

class AgendamentoController extends GetxController {
  late final CriarAgendamentosUsecases _criarAgendamentosUsecases;
  late final ListarAgendamentosUsecases _listarAgendamentosUsecases;
  final RxList agendamentos = <dynamic>[].obs;
  final isLoading = false.obs;

  AgendamentoController(
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
}
