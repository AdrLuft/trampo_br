// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/trampos_repository_abstract.dart';

// class DeleteTramposUsecase {
//   final TramposRepositoryAbstract _repository;
//   final FirebaseAuth _auth;

//   DeleteTramposUsecase(this._repository, this._auth);

//   Future<void> call(String trampoId) async {
//     // Validação do ID
//     if (trampoId.isEmpty) {
//       throw Exception('ID do trampo é obrigatório');
//     }

//     // Verificar se usuário está autenticado
//     final String userId = _auth.currentUser?.uid ?? '';
//     if (userId.isEmpty) {
//       throw Exception('Usuário não autenticado');
//     }

//     try {
//       // Buscar o trampo específico pelo ID (não pelo userId)
//       final trampo = await _repository.getTrampoById(trampoId);

//       if (trampo == null) {
//         throw Exception('Trampo não encontrado');
//       }

//       // Verificar se o trampo pertence ao usuário (segurança)
//       if (trampo.userId != userId) {
//         throw Exception('Você não tem permissão para deletar este trampo');
//       }

//       // Verificar se pode ser deletado (regra de negócio)
//       if (trampo.status != 'concluido' && trampo.status != 'cancelado') {
//         throw Exception(
//           'Trampo só pode ser deletado quando estiver concluído ou cancelado',
//         );
//       }

//       // Deletar o trampo
//       await _repository.deleteTrampos(trampoId);
//     } catch (e) {
//       // Re-throw com contexto
//       throw Exception('Erro ao deletar trampo: ${e.toString()}');
//     }
//   }
// }
