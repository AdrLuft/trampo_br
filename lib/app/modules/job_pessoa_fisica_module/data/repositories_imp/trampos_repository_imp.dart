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
    final String user = auth.currentUser?.uid ?? '';

    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(user).get();
    String userName = '';

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      userName = userData['name'] ?? '';
    }

    CollectionReference tramposCollection = firestore.collection('Trampos');

    DocumentReference docRef = await tramposCollection.add({
      'userId': firestore.doc('users/$user'),
      'createTrampoNome': agendamento.createTrampoNome,
      'userName': userName,
      'userAddress': agendamento.userAddress,
      'email': agendamento.email,
      'telefone': agendamento.telefone,
      'createDate': Timestamp.fromDate(agendamento.createDate as DateTime),
      'tipoVaga': agendamento.tipoVaga,
      'status': agendamento.status,
      'descricao': agendamento.descricao.trim(),
    });
    final CreateTramposModel model = CreateTramposModel(
      id: docRef.id,
      createTrampoNome: agendamento.createTrampoNome,
      createDate: agendamento.createDate.toString(),
      status: agendamento.status,
      tipoVaga: agendamento.tipoVaga,
      email: agendamento.email,
      telefone: agendamento.telefone,
      userAddress: agendamento.userAddress.toString(),
      descricao: agendamento.descricao.trim(),
    );
    return model.toEntity();
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
}
