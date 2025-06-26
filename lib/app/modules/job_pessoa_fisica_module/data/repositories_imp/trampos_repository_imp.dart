import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/data/models/trampos_model.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/trampos_entiti.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/trampos_repository_abstract.dart';

class TramposRepositoryImp implements TramposRepositoryAbstract {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final vagasSalvas = <Map<String, dynamic>>[];

  @override
  Future<TramposEntiti> createTrampo(TramposEntiti trampo) async {
    final model = CreateTramposModel.fromEntity(trampo);
    final trampoData = model.toJson();
    final docRef = await firestore.collection('Trampos').add(trampoData);
    return model.copyWith(id: docRef.id).toEntity();
  }

  @override
  Future<void> deleteTrampos(String idTrampo) async {
    CollectionReference agendamentosCollection = firestore.collection(
      'Trampos',
    );
    await agendamentosCollection.doc(idTrampo).delete();
  }

  @override
  Future<List<TramposEntiti>> getTrampos(String userId) async {
    final String user = auth.currentUser?.uid ?? '';
    CollectionReference agendamentosCollection = firestore.collection(
      'Trampos',
    );

    QuerySnapshot querySnapshot =
        await agendamentosCollection.where('userId', isEqualTo: user).get();

    return querySnapshot.docs.map((doc) {
      return TramposEntiti(
        id: doc.id,
        createTrampoNome: doc['clienteName'],
        email: doc['email'],
        telefone: doc['telefone'],
        createDate: (doc['createDate'] as Timestamp).toDate().toString(),
        tipoVaga: doc['tipoVaga'],
        status: doc['status'],
        userAddress: doc['userAddress'],
        descricao: doc['descricao'],
        userId: user,
        requisitos: doc['requisitos'] ?? '',
      );
    }).toList();
  }

  @override
  Future<void> updateTrampos(TramposEntiti trampos) async {
    final model = CreateTramposModel.fromEntity(trampos);
    await firestore
        .collection('Trampos')
        .doc(trampos.id)
        .update(model.toJson());
  }

  @override
  Future<TramposEntiti?> getTrampoById(String id) async {
    final String user = auth.currentUser?.uid ?? '';
    final doc = await firestore.collection('Trampos').doc(id).get();
    if (!doc.exists && doc['userId'] != user) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return CreateTramposModel.fromJson(data).toEntity();
    }
    return null;
  }

  @override
  Future<List<TramposEntiti>> getMiTrampos() async {
    try {
      final String currentUserId = auth.currentUser?.uid ?? '';
      if (currentUserId.isEmpty) return [];

      QuerySnapshot querySnapshot =
          await firestore
              .collection('Trampos')
              .where('userId', isEqualTo: currentUserId)
              .orderBy('createDate', descending: true)
              .get();
      return querySnapshot.docs.map((doc) {
        // Pega o mapa de dados do documento.
        final data = doc.data() as Map<String, dynamic>;

        final mapaCompleto = {'id': doc.id, ...data};
        return CreateTramposModel.fromJson(mapaCompleto).toEntity();
      }).toList();
    } catch (e) {
      throw ('Erro ao buscar minhas vagas: $e');
    }
  }

  @override
  Future<void> updateTrampoStatus(
    String idTrampo,
    String novoStatus,
    String userId,
  ) {
    CollectionReference tramposCollection = firestore.collection('Trampos');
    return tramposCollection.doc(idTrampo).update({'status': novoStatus});
  }

  @override
  Future<void> salvarVagaFavoritos(userId, [String? trampoId]) async {
    final currentUserId = auth.currentUser?.uid;
    if (currentUserId == null || trampoId == null) return;

    final vagaSalvaCollection = firestore.collection('vagaSalva');
    final docRef = vagaSalvaCollection.doc('${currentUserId}_$trampoId');
    await docRef.set({'userId': currentUserId, 'vagaId': trampoId});

    // Adiciona na coleção TramposSalvosUsers apenas a vaga salva
    await firestore.collection('TramposSalvosUsers').add({
      'idTrampo': trampoId,
      'userId': currentUserId,
    });
  }

  @override
  Future<void> removerVagaSalva(userId, [String? trampoId]) async {
    final currentUserId = auth.currentUser?.uid;
    if (currentUserId == null || trampoId == null) return;

    final vagaSalvaCollection = firestore.collection('vagaSalva');
    final docRef = vagaSalvaCollection.doc('${currentUserId}_$trampoId');
    await docRef.delete();

    // Remove da coleção TramposSalvosUsers
    final querySnapshot =
        await firestore
            .collection('TramposSalvosUsers')
            .where('idTrampo', isEqualTo: trampoId)
            .where('userId', isEqualTo: currentUserId)
            .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
