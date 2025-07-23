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

  //*******************************************************************************************************************  */
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
  //*******************************************************************************************************************  */

  static void showChangePasswordDialog() {
    Get.dialog(const _ChangePasswordDialog(), barrierDismissible: false);
  }

  static void showResetPasswordDialog() {
    Get.dialog(const _ResetPasswordDialog(), barrierDismissible: false);
  }
}

class _ResetPasswordDialog extends StatefulWidget {
  const _ResetPasswordDialog();

  @override
  State<_ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}
//*******************************************************************************************************************  */

class _ResetPasswordDialogState extends State<_ResetPasswordDialog> {
  late final TextEditingController _emailController;
  late final LoginController _loginController;
  bool _isLoading = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _loginController = Get.put(LoginController(Get.find()));
  }

  @override
  void dispose() {
    _disposed = true;
    _emailController.dispose();
    super.dispose();
  }

  void _safeSetState(VoidCallback fn) {
    if (!_disposed && mounted) {
      setState(fn);
    }
  }

  Future<void> _handlePasswordReset() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      PerformanceConfig.showOptimizedSnackbar(
        title: 'Erro',
        message: 'Digite seu email',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      PerformanceConfig.showOptimizedSnackbar(
        title: 'Erro',
        message: 'Digite um email válido',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
      return;
    }

    _safeSetState(() {
      _isLoading = true;
    });

    try {
      await _loginController.resetPassword(email);

      if (!_disposed && mounted) {
        Get.back();
        PerformanceConfig.showOptimizedSnackbar(
          title: 'Email Enviado',
          message: 'Instruções enviadas para $email',
          backgroundColor: const Color(0xFF6366F1),
          icon: Icons.check_circle,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      if (!_disposed && mounted) {
        PerformanceConfig.showOptimizedSnackbar(
          title: 'Erro',
          message: 'Erro ao enviar email: ${e.toString()}',
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      }
    } finally {
      _safeSetState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.email, color: Color(0xFF6366F1), size: 28),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Redefinir Senha',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Digite seu email para receber as instruções de redefinição de senha:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              enabled: !_isLoading,
              decoration: PerformanceConfig.getOptimizedInputDecoration(
                labelText: 'Email',
                hintText: 'seuemail@exemplo.com',
                prefixIcon: Icons.email_outlined,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Verifique sua caixa de entrada e spam após o envio.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Get.back(),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: PerformanceConfig.primaryButtonStyle,
          onPressed: _isLoading ? null : _handlePasswordReset,
          child:
              _isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : const Text('Enviar'),
        ),
      ],
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}
//*******************************************************************************************************************  */

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  bool _isLoading = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _disposed = true;
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _safeSetState(VoidCallback fn) {
    if (!_disposed && mounted) {
      setState(fn);
    }
  }

  Future<void> _handleChangePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty) {
      PerformanceConfig.showOptimizedSnackbar(
        title: 'Erro',
        message: 'Digite sua senha atual',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
      return;
    }

    if (newPassword.isEmpty) {
      PerformanceConfig.showOptimizedSnackbar(
        title: 'Erro',
        message: 'Digite a nova senha',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      PerformanceConfig.showOptimizedSnackbar(
        title: 'Erro',
        message: 'As senhas não coincidem',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
      return;
    }

    if (newPassword.length < 6) {
      PerformanceConfig.showOptimizedSnackbar(
        title: 'Erro',
        message: 'A senha deve ter pelo menos 6 caracteres',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
      return;
    }

    _safeSetState(() {
      _isLoading = true;
    });

    try {
      // Simular alteração de senha
      await Future.delayed(const Duration(seconds: 2));

      if (!_disposed && mounted) {
        Get.back();
        PerformanceConfig.showOptimizedSnackbar(
          title: 'Sucesso',
          message: 'Senha alterada com sucesso!',
          backgroundColor: const Color(0xFF6366F1),
          icon: Icons.check_circle,
        );
      }
    } catch (e) {
      if (!_disposed && mounted) {
        PerformanceConfig.showOptimizedSnackbar(
          title: 'Erro',
          message: 'Erro ao alterar senha: ${e.toString()}',
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      }
    } finally {
      _safeSetState(() {
        _isLoading = false;
      });
    }
  }

  //*******************************************************************************************************************  */
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      title: const Text('Alterar Senha'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _currentPasswordController,
            obscureText: true,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            decoration: PerformanceConfig.getOptimizedInputDecoration(
              labelText: 'Senha Atual',
              prefixIcon: Icons.lock_outline,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _newPasswordController,
            obscureText: true,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            decoration: PerformanceConfig.getOptimizedInputDecoration(
              labelText: 'Nova Senha',
              prefixIcon: Icons.lock,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
            decoration: PerformanceConfig.getOptimizedInputDecoration(
              labelText: 'Confirmar Nova Senha',
              prefixIcon: Icons.lock,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Get.back(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: PerformanceConfig.primaryButtonStyle,
          onPressed: _isLoading ? null : _handleChangePassword,
          child:
              _isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : const Text('Alterar'),
        ),
      ],
    );
  }
}
