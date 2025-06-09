import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/core/enums/login_enum.dart';
import 'package:interprise_calendar/app/login/data/repository/login_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController extends GetxController {
  LoginRepository loginRepository = Get.find<LoginRepository>();

  LoginController(this.loginRepository);

  final isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      User? user = await loginRepository.login(email, password);
      if (user != null) {
        // Buscar o tipo de usuário no Firestore
        UserType userType = await _getUserType(user.uid);
        _navigateToCorrectModule(userType);
      }
    } on FirebaseException catch (e) {
      throw ('Erro ao fazer login: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserType> _getUserType(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (userDoc.exists) {
        String userTypeString =
            (userDoc.data() as Map<String, dynamic>?)!['userType'] ??
            'pessoaFisica';
        return UserType.values.firstWhere(
          (type) => type.name == userTypeString,
          orElse: () => UserType.pessoaFisica,
        );
      }
      return UserType.pessoaFisica;
    } catch (e) {
      throw ('Erro ao buscar tipo de usuário: $e');
    }
  }

  void _navigateToCorrectModule(UserType userType) {
    switch (userType) {
      case UserType.pessoaFisica:
        Get.offAllNamed('/job-pessoa-fisica');
        break;
      case UserType.pessoaJuridica:
        Get.offAllNamed('/job-pessoa-juridica');
        break;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required UserType userType,
    required String name,
    String? document,
  }) async {
    isLoading.value = true;
    try {
      await loginRepository.register(
        email: email,
        password: password,
        userType: userType,
        name: name,
      );
    } on FirebaseException catch (e) {
      throw ('Erro ao registrar: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await loginRepository.logout();
  }

  Future<void> resetPassword(String email) async {
    isLoading.value = true;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      isLoading.value = false;
      throw ('Erro ao enviar email de redefinição de senha: $e');
    }
  }
}
