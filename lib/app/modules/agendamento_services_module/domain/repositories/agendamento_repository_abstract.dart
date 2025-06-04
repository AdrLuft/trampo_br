import 'package:interprise_calendar/app/modules/agendamento_services_module/domain/entities/agendamento_entiti.dart';

abstract class AgendamentoRepositoryAbstract {
  Future<void> createAgendamento(AgendamentoEntiti agendamento);
  Future<List<AgendamentoEntiti>> getAgendamentos(String userId);
  Future<void> updateAgendamento(AgendamentoEntiti agendamento);
  Future<void> deleteAgendamento(String id);
  Future<AgendamentoEntiti?> getAgendamentoById(String id);
}
