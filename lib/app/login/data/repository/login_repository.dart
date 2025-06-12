import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interprise_calendar/app/core/enums/login_enum.dart';

class LoginRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> login(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<User> register({
    required String email,
    required String password,
    required UserType userType,
    required String name,
    required String document,
    required String address,
  }) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'email': email,
      'name': name,
      'userType': userType.name,
      'createdAt': FieldValue.serverTimestamp(),
      'address': address,
      'document': document,
    });

    return userCredential.user!;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
