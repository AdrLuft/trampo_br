import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/login/data/repository/login_repository.dart';

class LoginController extends GetxController {
  LoginRepository loginRepository = Get.find<LoginRepository>();

  LoginController(this.loginRepository);

  final isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      await loginRepository.login(email, password);
    } on FirebaseException catch (e) {
      throw ('Erro ao fazer login: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    isLoading.value = true;
    try {
      await loginRepository.register(email, password);
    } on FirebaseException catch (e) {
      throw ('Erro ao registrar: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await loginRepository.logout();
  }
}
