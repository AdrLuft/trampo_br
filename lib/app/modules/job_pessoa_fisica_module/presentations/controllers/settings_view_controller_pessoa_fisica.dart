import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
// Para pegar a versão do app, adicione o pacote `package_info_plus`

class SettingsHomePagePessoaFisicaController extends GetxController {
  final appVersion = ''.obs;
  final isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<void> _loadAppVersion() async {
  //   final packageInfo = await PackageInfo.fromPlatform();
  //   appVersion.value =
  //       'Versão ${packageInfo.version} (${packageInfo.buildNumber})';
  // }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _auth.signOut();
      await Future.delayed(Duration(seconds: 1));
      Get.toNamed('/login');
    } catch (e) {
      return Future.error('Erro ao fazer logout: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
