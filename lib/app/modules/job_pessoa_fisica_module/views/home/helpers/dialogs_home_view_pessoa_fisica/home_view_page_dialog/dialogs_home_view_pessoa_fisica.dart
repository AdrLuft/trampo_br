import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/core/performance/performance_config.dart';
import 'package:interprise_calendar/app/login/presentations/login_controller.dart';

class DialogsHomeViewPessoaFisica {
  static void showNotificationsSettings() {
    Get.dialog(
      AlertDialog(
        title: const Text('Configurações de Notificações'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Notificações de Vagas'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Notificações de Mensagens'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Notificações Push'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fechar')),
        ],
      ),
    );
  }

  static void showPrivacySettings() {
    Get.dialog(
      AlertDialog(
        title: const Text('Privacidade e Segurança'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Perfil Público'),
              trailing: Switch(value: true, onChanged: (value) {}),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Compartilhar Localização'),
              trailing: Switch(value: false, onChanged: (value) {}),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico de Atividades'),
              onTap: () {
                Get.back();
                // Navegar para histórico
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fechar')),
        ],
      ),
    );
  }

  static void showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        title: const Text('Excluir Conta'),
        content: const Text(
          'Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back();
              // Implementar lógica de exclusão de conta
              Get.snackbar(
                'Conta',
                'Funcionalidade em desenvolvimento',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  static void showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final controllers = [
      currentPasswordController,
      newPasswordController,
      confirmPasswordController,
    ];

    Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        title: const Text('Alterar Senha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              textInputAction: TextInputAction.next,
              decoration: PerformanceConfig.getOptimizedInputDecoration(
                labelText: 'Senha Atual',
                prefixIcon: Icons.lock_outline,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              textInputAction: TextInputAction.next,
              decoration: PerformanceConfig.getOptimizedInputDecoration(
                labelText: 'Nova Senha',
                prefixIcon: Icons.lock,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              decoration: PerformanceConfig.getOptimizedInputDecoration(
                labelText: 'Confirmar Nova Senha',
                prefixIcon: Icons.lock,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _disposePasswordControllers(controllers);
              Get.back();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: PerformanceConfig.primaryButtonStyle,
            onPressed: () {
              // Implementar lógica de alteração de senha
              Get.back();
              PerformanceConfig.showOptimizedSnackbar(
                title: 'Senha',
                message: 'Senha alterada com sucesso!',
                backgroundColor: Colors.green,
                icon: Icons.check_circle,
              );
            },
            child: const Text('Alterar'),
          ),
        ],
      ),
    ).then((_) {
      // Garantir cleanup quando o diálogo for fechado
      _disposePasswordControllers(controllers);
    });
  }
  }

  static void _disposePasswordControllers(
    List<TextEditingController> controllers,
  ) {
    for (final controller in controllers) {
      try {
        controller.dispose();
      } catch (e) {
        // Controller já foi disposed, ignorar erro
      }
    }
  }
}
