import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interprise_calendar/app/modules/agendamento_services_module/domain/entities/agendamento_entiti.dart';
import 'package:interprise_calendar/app/modules/agendamento_services_module/domain/repositories/agendamento_repository_abstract.dart';

class AgendamentosRepositoryImp extends AgendamentoRepositoryAbstract {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<void> createAgendamento(AgendamentoEntiti agendamento) async {
    final String user = auth.currentUser?.uid ?? '';
    CollectionReference agendamentosCollection = firestore.collection(
      'agendamentos',
    );
    await agendamentosCollection.add({
      'userId': user,
      'clienteName': agendamento.clienteNome,
      'email': agendamento.email,
      'telefone': agendamento.telefone,
      'data': Timestamp.fromDate(agendamento.data as DateTime),
      'servico': agendamento.servico,
      'status': agendamento.status,
    });
  }

  @override
  Future<void> deleteAgendamento(String id) async {
    CollectionReference agendamentosCollection = firestore.collection(
      'agendamentos',
    );
    await agendamentosCollection.doc(id).delete();
  }

  @override
  Future<List<AgendamentoEntiti>> getAgendamentos(String userId) async {
    final String user = auth.currentUser?.uid ?? '';
    CollectionReference agendamentosCollection = firestore.collection(
      'agendamentos',
    );

    QuerySnapshot querySnapshot =
        await agendamentosCollection.where('userId', isEqualTo: user).get();

    return querySnapshot.docs.map((doc) {
      return AgendamentoEntiti(
        id: doc.id,
        clienteNome: doc['clienteName'],
        email: doc['email'],
        telefone: doc['telefone'],
        data: (doc['data'] as Timestamp).toDate().toString(),
        servico: doc['servico'],
        status: doc['status'],
      );
    }).toList();
  }

  @override
  Future<void> updateAgendamento(AgendamentoEntiti agendamento) async {
    CollectionReference agendamentosCollection = firestore.collection(
      'agendamentos',
    );
    await agendamentosCollection.doc(agendamento.id).update({
      'clienteName': agendamento.clienteNome,
      'email': agendamento.email,
      'telefone': agendamento.telefone,
      'data': Timestamp.fromDate(DateTime.parse(agendamento.data)),
      'servico': agendamento.servico,
      'status': agendamento.status,
    });
  }

  @override
  Future<AgendamentoEntiti?> getAgendamentoById(String id) async {
    final String user = auth.currentUser?.uid ?? '';
    CollectionReference agendamentosCollection = firestore.collection(
      'agendamentos',
    );
    DocumentSnapshot doc = await agendamentosCollection.doc(id).get();

    if (doc.exists && doc['userId'] == user) {
      return AgendamentoEntiti(
        id: doc.id,
        clienteNome: doc['clienteName'],
        email: doc['email'],
        telefone: doc['telefone'],
        data: (doc['data'] as Timestamp).toDate().toString(),
        servico: doc['servico'],
        status: doc['status'],
      );
    }
    return null;
  }
}
