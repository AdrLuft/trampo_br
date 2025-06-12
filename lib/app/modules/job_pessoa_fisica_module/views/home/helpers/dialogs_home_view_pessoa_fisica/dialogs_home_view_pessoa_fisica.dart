import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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

    Get.dialog(
      AlertDialog(
        title: const Text('Alterar Senha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha Atual',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nova Senha',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar Nova Senha',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implementar lógica de alteração de senha
              Get.back();
              Get.snackbar(
                'Senha',
                'Senha alterada com sucesso!',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Alterar'),
          ),
        ],
      ),
    );
  }
}
