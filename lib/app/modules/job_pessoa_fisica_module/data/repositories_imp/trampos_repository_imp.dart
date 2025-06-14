import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/data/models/trampos_model.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/trampos_entiti.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/trampos_repository_abstract.dart';

class TramposRepositoryImp extends TramposRepositoryAbstract {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<TramposEntiti> createTrampo(TramposEntiti agendamento) async {
    try {
      final String user = auth.currentUser?.uid ?? '';

      if (user.isEmpty) {
        throw Exception('Usuário não autenticado');
      }

      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(user).get();

      if (!userDoc.exists) {
        throw Exception('Dados do usuário não encontrados');
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String userName = userData['name'] ?? '';
      String userAddress = userData['address'] ?? '';
      String userEmail = userData['email'] ?? agendamento.email;

      CollectionReference tramposCollection = firestore.collection('Trampos');

      DateTime createDateTime;
      try {
        createDateTime = DateTime.parse(agendamento.createDate);
      } catch (e) {
        createDateTime = DateTime.now();
      }

      final trampoData = {
        'userId': firestore.doc('users/$user'),
        'createTrampoNome': userName,
        //'userName': userName,
        'userAddress': userAddress,
        'email': userEmail,
        'telefone': agendamento.telefone,
        'createDate': Timestamp.fromDate(createDateTime),
        'tipoVaga': agendamento.tipoVaga,
        'status': agendamento.status,
        'descricao': agendamento.descricao.trim(),
      };

      DocumentReference docRef = await tramposCollection.add(trampoData);

      final CreateTramposModel model = CreateTramposModel(
        id: docRef.id,
        createTrampoNome: userName,
        createDate: agendamento.createDate,
        status: agendamento.status,
        tipoVaga: agendamento.tipoVaga,
        email: userEmail,
        telefone: agendamento.telefone,
        userAddress: userAddress,
        descricao: agendamento.descricao.trim(),
      );

      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTrampos(String id) async {
    CollectionReference agendamentosCollection = firestore.collection(
      'Trampos',
    );
    await agendamentosCollection.doc(id).delete();
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
      );
    }).toList();
  }

  @override
  Future<void> updateTrampos(TramposEntiti agendamento) async {
    CollectionReference agendamentosCollection = firestore.collection(
      'Trampos',
    );
    await agendamentosCollection.doc(agendamento.id).update({
      'createTrampoNome': agendamento.createTrampoNome,
      'email': agendamento.email,
      'telefone': agendamento.telefone,
      'data': Timestamp.fromDate(DateTime.parse(agendamento.createDate)),
      'tipoVaga': agendamento.tipoVaga,
      'status': agendamento.status,
    });
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

      DocumentReference userRef = firestore.doc('users/$currentUserId');
      QuerySnapshot querySnapshot =
          await firestore
              .collection('Trampos')
              .where('userId', isEqualTo: userRef)
              .orderBy('createDate', descending: true)
              .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
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
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
