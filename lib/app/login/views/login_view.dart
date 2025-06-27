import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:interprise_calendar/app/core/enums/login_enum.dart';
import 'package:interprise_calendar/app/login/presentations/login_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/dialogs_home_view_pessoa_fisica/home_view_page_dialog/dialogs_home_view_pessoa_fisica.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _documentController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController(); // Novo campo
  bool _isLoginMode = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  UserType _selectedUserType = UserType.pessoaFisica;

  LoginController get controller => Get.find();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _documentController.dispose();
    _nameController.dispose();
    _addressController.dispose(); // Dispose do novo campo
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    controller.isLoading.value = true;

    try {
      if (_isLoginMode) {
        await controller.login(_emailController.text, _passwordController.text);
        controller.isLoading.value = false;
      } else {
        await controller.register(
          email: _emailController.text,
          password: _passwordController.text,
          userType: _selectedUserType,
          document: _documentController.text,
          name: _nameController.text,
          address: _addressController.text, // Incluir endereço
        );
        Get.snackbar(
          'Sucesso',
          'Cadastro realizado com sucesso!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
        );
        setState(() {
          _isLoginMode = true;
        });
      }
    } catch (e) {
      Get.snackbar('Erro', e.toString());
      controller.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo sempre presente
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/trampos3.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay sutil
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),

          // Conteúdo principal
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child:
                      _isLoginMode
                          ? _buildLoginContent(context)
                          : _buildRegisterContent(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        // Logo
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, -5),
                spreadRadius: -5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Image.asset(
              'assets/images/trampos2.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade400, Colors.teal.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.work_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Trampos BR',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2.0,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.8),
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Entre na sua conta',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 6,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Login Form
        _buildLoginForm(),
        const SizedBox(height: 30),
        TextButton(
          onPressed: _toggleMode,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 16,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 4,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              children: [
                const TextSpan(text: 'Não tem uma conta? '),
                TextSpan(
                  text: 'Cadastre-se',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.7),
                        blurRadius: 4,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Text(
          'Trampos BR',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2.0,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.8),
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Crie sua conta',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 6,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Registration Form
        _buildRegisterForm(),
        const SizedBox(height: 20),
        TextButton(
          onPressed: _toggleMode,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 16,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 4,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              children: [
                const TextSpan(text: 'Já tem uma conta? '),
                TextSpan(
                  text: 'Entre',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.7),
                        blurRadius: 4,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildFormField(
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              decoration: _getInputDecoration('Email', Icons.email),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite seu email';
                }
                if (!GetUtils.isEmail(value)) {
                  return 'Digite um email válido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildFormField(
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              decoration: _getInputDecoration(
                'Senha',
                Icons.lock,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite sua senha';
                }
                if (value.length < 6) {
                  return 'A senha deve ter pelo menos 6 caracteres';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: DialogsHomeViewPessoaFisica.showResetPasswordDialog,
              child: Text(
                'Esqueci minha senha',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 4,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildSubmitButton(isLoginMode: true),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildFormField(
            child: DropdownButtonFormField<UserType>(
              value: _selectedUserType,
              decoration: _getInputDecoration(
                'Tipo de Usuário',
                Icons.person_outline,
              ),
              dropdownColor: Colors.teal.shade800,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              items:
                  UserType.values.map((UserType type) {
                    return DropdownMenuItem<UserType>(
                      value: type,
                      child: Text(
                        type.displayName,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
              onChanged: (UserType? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedUserType = newValue;
                    _documentController.clear();
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildFormField(
            child: TextFormField(
              controller: _nameController,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              decoration: _getInputDecoration(
                _selectedUserType == UserType.pessoaFisica
                    ? 'Nome Completo'
                    : 'Razão Social',
                _selectedUserType == UserType.pessoaFisica
                    ? Icons.person
                    : Icons.business,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return _selectedUserType == UserType.pessoaFisica
                      ? 'Digite seu nome completo'
                      : 'Digite a razão social';
                }
                if (value.length < 6) {
                  return 'Nome deve ter pelo menos 6 caracteres';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildFormField(
            child: TextFormField(
              controller: _documentController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(
                  _selectedUserType == UserType.pessoaFisica ? 11 : 14,
                ),
              ],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              decoration: _getInputDecoration(
                _selectedUserType.documentLabel,
                Icons.badge,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite seu ${_selectedUserType.documentLabel}';
                }

                if (_selectedUserType == UserType.pessoaFisica) {
                  if (!CPFValidator.isValid(value)) {
                    return 'CPF inválido';
                  }
                } else {
                  if (!CNPJValidator.isValid(value)) {
                    return 'CNPJ inválido';
                  }
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildFormField(
            child: TextFormField(
              controller: _addressController,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              decoration: _getInputDecoration('Endereço', Icons.location_on),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite seu endereço';
                }
                if (value.length < 10) {
                  return 'Endereço deve ter pelo menos 10 caracteres';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildFormField(
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              decoration: _getInputDecoration('Email', Icons.email),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite seu email';
                }
                if (!GetUtils.isEmail(value)) {
                  return 'Digite um email válido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildFormField(
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              decoration: _getInputDecoration(
                'Senha',
                Icons.lock,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite sua senha';
                }
                if (value.length < 6) {
                  return 'A senha deve ter pelo menos 6 caracteres';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildFormField(
            child: TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              decoration: _getInputDecoration(
                'Confirmar Senha',
                Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirme sua senha';
                }
                if (value != _passwordController.text) {
                  return 'As senhas não coincidem';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSubmitButton(isLoginMode: false),
        ],
      ),
    );
  }

  Widget _buildSubmitButton({required bool isLoginMode}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 3,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -8),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isLoading.value ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                controller.isLoading.value ? Colors.teal.shade300 : Colors.teal,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 0,
          ),
          child:
              controller.isLoading.value
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Center(
                        child: Text(
                          isLoginMode ? 'Entrando...' : 'Cadastrando...',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isLoginMode ? Icons.login : Icons.person_add),
                      const SizedBox(width: 8),
                      Text(
                        isLoginMode ? 'Entrar' : 'Cadastrar',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  // Método helper para criar campos de formulário com estilo consistente
  Widget _buildFormField({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black.withValues(
          alpha: 0.3,
        ), // Fundo escuro semi-transparente
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 2.0, // Borda mais espessa
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, -3),
            spreadRadius: -3,
          ),
        ],
      ),
      child: child,
    );
  }

  // Método helper para decoração de inputs
  InputDecoration _getInputDecoration(
    String label,
    IconData icon, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18, // Fixed font size for login fields
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(icon, color: Colors.white, size: 24),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.teal.shade300, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16, // Fixed vertical padding for login fields
      ),
      errorMaxLines: 1,
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        shadows: [
          Shadow(color: Colors.black, blurRadius: 2, offset: Offset(1, 1)),
        ],
      ),
      floatingLabelStyle: TextStyle(
        color: Colors.teal.shade200,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
