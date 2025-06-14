import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/trampos_entiti.dart';

abstract class TramposRepositoryAbstract {
  Future<void> createTrampo(TramposEntiti agendamento);
  Future<List<TramposEntiti>> getTrampos(String userId);
  Future<void> updateTrampos(TramposEntiti agendamento);
  Future<void> deleteTrampos(String id);
  Future<TramposEntiti?> getTrampoById(String id);
  Future<List<TramposEntiti>> getMiTrampos();
}
