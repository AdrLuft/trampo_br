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
    CollectionReference agendamentosCollection = firestore.collection(
      'Trampos',
    );
    DocumentSnapshot doc = await agendamentosCollection.doc(id).get();

    if (doc.exists && doc['userId'] == user) {
      return TramposEntiti(
        id: doc.id,
        createTrampoNome: doc['createTrampoNome'],
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
    }
    return null;
  }

  @override
  Future<List<TramposEntiti>> getMiTrampos() async {
    try {
      final String currentUserId = auth.currentUser?.uid ?? '';

      if (currentUserId.isEmpty) {
        return [];
      }
      // debugPrint('Buscando trampos para o usuário: $currentUserId');
      QuerySnapshot querySnapshot =
          await firestore
              .collection('Trampos')
              .where('userId', isEqualTo: currentUserId)
              .orderBy('createDate', descending: true)
              .get();
      //   debugPrint('Trampos encontrados: ${querySnapshot.docs.length}');
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        List<String> requisitosList = [];
        if (data['requisitos'] != null) {
          if (data['requisitos'] is List) {
            requisitosList = List<String>.from(data['requisitos']);
          } else if (data['requisitos'] is String) {
            requisitosList = [data['requisitos']];
          }
        }

        List<String> exigenciasList = [];
        if (data['exigencias'] != null && data['exigencias'] is List) {
          exigenciasList = List<String>.from(data['exigencias']);
        }

        List<String> valorizadosList = [];
        if (data['valorizados'] != null && data['valorizados'] is List) {
          valorizadosList = List<String>.from(data['valorizados']);
        }

        List<String> beneficiosList = [];
        if (data['beneficios'] != null && data['beneficios'] is List) {
          beneficiosList = List<String>.from(data['beneficios']);
        }

        return TramposEntiti(
          id: doc.id,
          createTrampoNome: data['createTrampoNome'] ?? '',
          email: data['email'] ?? '',
          telefone: data['telefone'] ?? '',
          createDate: (data['createDate'] as Timestamp).toDate().toString(),
          tipoVaga: data['tipoVaga'] ?? '',
          status: data['status'] ?? 'Disponível',
          userAddress: data['userAddress'] ?? '',
          descricao: data['descricao'] ?? '',
          userId: currentUserId,
          requisitos: requisitosList,
          exigencias: exigenciasList,
          valorizados: valorizadosList,
          beneficios: beneficiosList,
          titulo: data['titulo'] ?? '',
          modalidade: data['modalidade'] ?? 'Presencial',
          salario: data['salario'] ?? '',
          salarioACombinar: data['salarioACombinar'] ?? false,
        );
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
    return tramposCollection.doc(idTrampo).update({
      'status': novoStatus,
      // Não alteramos o formato do userId, mantendo-o como string
      // 'userId': firestore.doc('users/$userId'),
    });
  }

  @override
  Future<void> sincronizarVagasSalvasComFirestore(userId) async {
    final userId = auth.currentUser?.uid;
    if (userId == null) return;

    final collectionRef = firestore
        .collection('usuarios')
        .doc(userId)
        .collection('vagasSalvas');
    final batch = firestore.batch();

    // Limpa a coleção remota primeiro
    final snapshot = await collectionRef.get();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    // Adiciona todos os itens da lista local `vagasSalvas`
    for (final vaga in vagasSalvas) {
      final docRef = collectionRef.doc(vaga['id']);
      batch.set(docRef, vaga);
    }

    await batch.commit();
  }
}
