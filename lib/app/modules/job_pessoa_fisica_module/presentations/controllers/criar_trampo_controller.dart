import 'package:get/get.dart';

class CriarTrampoController extends GetxController {
  final isLoading = false.obs;

  Future<void> criarTrampo() async {
    try {
      isLoading.value = true;
      // Simula uma operação de criação de trabalho
      await Future.delayed(Duration(seconds: 2));
      // Aqui você pode adicionar a lógica para criar o trabalho
    } catch (e) {
      // Trate erros aqui, se necessário
      throw ('Erro ao criar trabalho: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
