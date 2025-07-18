import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/users_entiti.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/repositories/user_repository_abstract.dart';

class UserRepositoryImp implements UserRepositoryAbstract {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  UserRepositoryImp(this._auth, this._firestore);

  @override
  Future<UserEntity> getLoggedUser() async {
    final firebaseUser = _auth.currentUser;

    if (firebaseUser == null) {
      throw Exception('Nenhum usuário autenticado.');
    }

    // Tenta primeiro pelo displayName do Firebase Auth
    if (firebaseUser.displayName != null &&
        firebaseUser.displayName!.isNotEmpty) {
      return UserEntity(
        uid: firebaseUser.uid,
        name: firebaseUser.displayName!,
        email: firebaseUser.email ?? '',
      );
    }

    // Se não houver, busca no Firestore
    final userDoc =
        await _firestore.collection('users').doc(firebaseUser.uid).get();

    if (userDoc.exists && userDoc.data() != null) {
      final data = userDoc.data()!;
      return UserEntity(
        uid: firebaseUser.uid,
        name: data['name'] ?? 'Usuário',
        email: data['email'] ?? firebaseUser.email ?? '',
      );
    }

    // Se não encontrar em lugar nenhum, lança um erro
    throw Exception('Não foi possível carregar os dados do usuário.');
  }
}
