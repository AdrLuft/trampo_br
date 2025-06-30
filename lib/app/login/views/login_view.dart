import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _documentController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  UserType _selectedUserType = UserType.pessoaFisica;

  late AnimationController _animationController;

  LoginController get controller => Get.find();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animationController.forward();
    _loadUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _documentController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    if (savedEmail != null) {
      setState(() {
        _emailController.text = savedEmail;
      });
    }
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_email', _emailController.text);
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
    _animationController.reset();
    _animationController.forward();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isLogin && !_acceptTerms) {
      Get.snackbar(
        'Erro',
        'Você deve aceitar os termos de uso',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(28),
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        await controller.login(_emailController.text, _passwordController.text);
        await _saveUserData();
      } else {
        await controller.register(
          email: _emailController.text,
          password: _passwordController.text,
          userType: _selectedUserType,
          document: _documentController.text,
          name: _nameController.text,
          address: _addressController.text,
        );
        Get.snackbar(
          'Sucesso',
          'Cadastro realizado com sucesso!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withAlpha(28),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        setState(() {
          _isLogin = true;
        });
      }
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(28),
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;

            if (isTablet) {
              return _buildTabletLayout();
            } else {
              return _buildMobileLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Lado esquerdo - Logo com gradiente
        Expanded(
          flex: 3,
          child: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF8F9FA),
                  Color(0xFFE9ECEF),
                  Color(0xFFDEE2E6),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  height: 120,
                ),
              ),
            ),
          ),
        ),
        // Lado direito - Formulário
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: SingleChildScrollView(child: _buildFormContent()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Área superior com logo - mais compacta
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF), Color(0xFFDEE2E6)],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 80,
              ),
            ),
          ),
        ),
        // Área do formulário - expansível
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildFormContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo/Título - mais compacto
            const Text(
              'Trampos',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
                letterSpacing: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Formulário
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Campos do cadastro (se não for login)
                  if (!_isLogin) ...[
                    _buildUserTypeDropdown(),
                    const SizedBox(height: 12),
                    _buildSimpleTextField(
                      controller: _nameController,
                      hintText:
                          _selectedUserType == UserType.pessoaFisica
                              ? 'Nome Completo'
                              : 'Razão Social',
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
                    const SizedBox(height: 12),
                    _buildSimpleTextField(
                      controller: _documentController,
                      hintText: _selectedUserType.documentLabel,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                          _selectedUserType == UserType.pessoaFisica ? 11 : 14,
                        ),
                      ],
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
                    const SizedBox(height: 12),
                    _buildSimpleTextField(
                      controller: _addressController,
                      hintText: 'Endereço',
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
                    const SizedBox(height: 12),
                  ],

                  // Email
                  _buildSimpleTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite seu e-mail';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'Digite um e-mail válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Senha
                  _buildSimpleTextField(
                    controller: _passwordController,
                    hintText: 'Senha',
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
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

                  // Confirmar senha (apenas no cadastro)
                  if (!_isLogin) ...[
                    const SizedBox(height: 12),
                    _buildSimpleTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirmar Senha',
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
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
                  ],

                  const SizedBox(height: 16),

                  // Termos de uso (apenas no cadastro)
                  if (!_isLogin)
                    Row(
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptTerms = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF6366F1),
                        ),
                        Expanded(
                          child: Text(
                            'Aceito os termos de uso e política de privacidade',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),

                  if (!_isLogin) const SizedBox(height: 16),

                  // Botão principal
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : Text(
                                _isLogin ? 'Login' : 'Cadastrar',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Link para alternar entre login/cadastro
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: _toggleMode,
                      child: Text(
                        _isLogin ? 'Cadastre-se' : 'Já tem conta? Faça login',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  // Link "Esqueci a senha" (apenas no login)
                  if (_isLogin) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed:
                          () =>
                              DialogsHomeViewPessoaFisica.showResetPasswordDialog(),
                      child: const Text(
                        'Esqueci a senha',
                        style: TextStyle(
                          color: Color(0xFF6366F1),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTypeDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade600, width: 2),
        color: Colors.white,
      ),
      child: DropdownButtonFormField<UserType>(
        value: _selectedUserType,
        decoration: const InputDecoration(
          labelText: 'Tipo de Usuário',
          labelStyle: TextStyle(
            color: Color(0xFF212529),
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        dropdownColor: Colors.white,
        items:
            UserType.values.map((UserType type) {
              return DropdownMenuItem<UserType>(
                value: type,
                child: Text(
                  type.displayName,
                  style: const TextStyle(
                    color: Color(0xFF212529),
                    fontWeight: FontWeight.w500,
                  ),
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
    );
  }

  Widget _buildSimpleTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade600, width: 2),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        validator: validator,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF212529),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF6C757D),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
