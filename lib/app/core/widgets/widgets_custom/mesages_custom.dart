import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageUtils {
  // Mensagem de sucesso
  static void showSucessSnackbar(
    String title,
    String message, {
    bool isError = false,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: isError ? Colors.redAccent : Colors.black87,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
    );
  }

  //Para avisos
  static void showDialogMessage(
    String title,
    String message, {
    bool isWarning = false,
  }) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            if (isWarning) const Icon(Icons.warning, color: Colors.amber),
            if (isWarning) const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        backgroundColor: isWarning ? Colors.amber[50] : null,
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  //Messagem de erro
  static void handleError(Object error, String message) {
    //Log pra captura de erros
    //debugPrint('Erro capturado: $error');

    Get.snackbar(
      'Erro',
      message,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    );
  }

  //Dialog para confirmação
  static void showConfirmationDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  // Novo: Indicador de Loading
  static void showLoading() {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false, // Impede que o usuário feche o dialog
    );
  }

  // Novo: Esconder o Loading
  static void hideLoading() {
    // Verifica se há um dialog aberto antes de tentar fechar
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  // Novo: Bottom Sheet para opções
  static void showOptionsBottomSheet({
    required String title,
    required List<Widget> options,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Get.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ...options,
          ],
        ),
      ),
    );
  }
}
