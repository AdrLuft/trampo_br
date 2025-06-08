import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/core/widgets_custom/buttons_custom.dart';
import 'package:interprise_calendar/app/login/presentations/login_controller.dart';

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

  bool _isLoginMode = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  LoginController get controller => Get.find<LoginController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (_isLoginMode) {
        await controller.login(_emailController.text, _passwordController.text);
        Get.snackbar('Sucesso', 'Login realizado com sucesso!');
        // Get.offAllNamed(AppRoutes.home); // Descomentar quando criar a home
      } else {
        await controller.register(
          _emailController.text,
          _passwordController.text,
        );
        Get.snackbar('Sucesso', 'Cadastro realizado com sucesso!');
        setState(() {
          _isLoginMode = true;
        });
      }
    } catch (e) {
      Get.snackbar('Erro', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background com imagem original
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/trampos.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay sutil para melhorar legibilidade
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),

          // Conteúdo principal
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // Logo pequena flutuante
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
                        'assets/images/trampos.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.teal.shade400,
                                  Colors.teal.shade600,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Icon(
                              Icons.work_rounded,
                              size: 60,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Título sem fundo - apenas texto
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

                  // Subtítulo sem fundo - apenas texto
                  Text(
                    _isLoginMode ? 'Entre na sua conta' : 'Crie sua conta',
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

                  const SizedBox(height: 50),

                  // Form sem container - widgets flutuando individualmente
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email translúcido
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.99),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.45),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.1),
                                blurRadius: 15,
                                offset: const Offset(0, -5),
                                spreadRadius: -5,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.99),
                                fontSize: 20,
                              ),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              filled: false,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 11,
                              ),
                            ),
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

                        const SizedBox(height: 25),

                        // Senha translúcida
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.99),
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.45),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.1),
                                blurRadius: 15,
                                offset: const Offset(0, -5),
                                spreadRadius: -5,
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              labelStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 20,
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              filled: false,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 11,
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

                        // Confirmar senha translúcida (apenas no modo cadastro)
                        if (!_isLoginMode) ...[
                          const SizedBox(height: 25),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.99),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, -5),
                                  spreadRadius: -5,
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Confirmar Senha',
                                labelStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 20,
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Colors.white,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                filled: false,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 11,
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
                        ],

                        const SizedBox(height: 40),

                        // Botão principal flutuante
                        Container(
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
                            () => CustomButtons(
                              text: _isLoginMode ? 'Entrar' : 'Cadastrar',
                              onPressed:
                                  controller.isLoading.value ? null : _submit,
                              width: double.infinity,
                              height: 56,
                              backgroundColor: Colors.teal,
                              icon:
                                  controller.isLoading.value
                                      ? null
                                      : (_isLoginMode
                                          ? Icons.login
                                          : Icons.person_add),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Botão para alternar modo - apenas texto
                        TextButton(
                          onPressed: _toggleMode,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
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
                                TextSpan(
                                  text:
                                      _isLoginMode
                                          ? 'Não tem uma conta? '
                                          : 'Já tem uma conta? ',
                                ),
                                TextSpan(
                                  text: _isLoginMode ? 'Cadastre-se' : 'Entre',
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.7,
                                        ),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
