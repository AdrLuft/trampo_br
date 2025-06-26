import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/trampos_entiti.dart';

abstract class TramposRepositoryAbstract {
  Future<void> createTrampo(TramposEntiti novoTrampo);
  Future<List<TramposEntiti>> getTrampos(String userId);
  Future<void> updateTrampos(TramposEntiti agendamento);
  Future<void> deleteTrampos(String id);
  Future<TramposEntiti?> getTrampoById(String id);
  Future<List<TramposEntiti>> getMiTrampos();
  Future<void> updateTrampoStatus(String id, String status, String userId);
  Future<void> salvarVagaFavoritos(String userId, String id);
  Future<void> removerVagaSalva(String userId, String id);
}
