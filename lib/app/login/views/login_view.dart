import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/core/configs/global_themes/global_theme_controller.dart';
import 'package:interprise_calendar/app/login/presentations/login_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/dialogs_home_view_pessoa_fisica/home_view_page_dialog/dialogs_home_view_pessoa_fisica.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:interprise_calendar/app/core/enums/login_enum.dart';

import 'dart:math';

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
  final _phoneController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  UserType _selectedUserType = UserType.pessoaFisica;

  LoginController controller = LoginController(Get.find());
  final GlobalThemeController themeController =
      Get.find<GlobalThemeController>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _documentController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    if (savedEmail != null && mounted) {
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
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (!_isLogin && !_acceptTerms) {
      Get.snackbar(
        'Erro',
        'Você deve aceitar os termos de uso',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    setState(() => _isLoading = true);

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
          aceitarTermos: _acceptTerms ? 'Sim' : 'Não',
          phone: _phoneController.text,
        );
        Get.snackbar('Sucesso', 'Cadastro realizado com sucesso!');
        if (mounted) setState(() => _isLogin = true);
      }
    } catch (e) {
      Get.snackbar('Erro', e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode;

      // ALTERAÇÃO: Fundo preto puro para o modo escuro.
      final darkBackgroundColor = Colors.black;
      final lightBackgroundColor = Colors.white;

      return Scaffold(
        backgroundColor: isDark ? darkBackgroundColor : lightBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: isDark ? darkBackgroundColor : lightBackgroundColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: isDark ? Colors.white : Colors.grey[900],
              ),
              onPressed: () => themeController.toggleTheme(),
              tooltip: isDark ? 'Modo Claro' : 'Modo Escuro',
            ),
          ],
        ),
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildLogo(isDark),
                      const SizedBox(height: 32),
                      _buildAnimatedSwitcher(),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading) _buildLoadingOverlay(),
          ],
        ),
      );
    });
  }

  // 3. WIDGET PARA O OVERLAY DE CARREGAMENTO
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withAlpha(26),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
        ),
      ),
    );
  }

  Widget _buildAnimatedSwitcher() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      transitionBuilder: (child, animation) {
        final rotateAnimation = Tween<double>(
          begin: pi,
          end: 0.0,
        ).animate(animation);
        return AnimatedBuilder(
          animation: rotateAnimation,
          child: child,
          builder: (context, child) {
            final isUnder = (ValueKey(_isLogin) != child?.key);
            var value =
                isUnder
                    ? min(rotateAnimation.value, pi / 2)
                    : rotateAnimation.value;
            return Transform(
              transform:
                  Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(value),
              alignment: Alignment.center,
              child: child,
            );
          },
        );
      },
      switchInCurve: Curves.easeInCubic,
      switchOutCurve: Curves.easeOutCubic,
      child: _isLogin ? _buildLoginForm() : _buildRegisterForm(),
    );
  }

  Widget _buildLogo(bool isDark) {
    // ALTERAÇÃO: Lógica simplificada para alternar as logos.
    return Image.asset(
      isDark ? 'assets/images/logo_black.png' : 'assets/images/logo.png',
      height: 180,
      fit: BoxFit.contain,
    );
  }

  Widget _buildLoginForm() {
    return Column(
      key: const ValueKey(true),
      children: [
        _buildSimpleTextField(
          controller: _emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          validator:
              (value) =>
                  !GetUtils.isEmail(value ?? '')
                      ? 'Digite um e-mail válido'
                      : null,
        ),
        const SizedBox(height: 36),
        _buildSimpleTextField(
          controller: _passwordController,
          hintText: 'Senha',
          obscureText: _obscurePassword,
          suffixIcon: _buildObscureToggle(
            () => setState(() => _obscurePassword = !_obscurePassword),
            _obscurePassword,
          ),
          validator:
              (value) =>
                  (value ?? '').length < 6
                      ? 'A senha deve ter pelo menos 6 caracteres'
                      : null,
        ),

        const SizedBox(height: 65),

        _buildPrimaryButton(title: 'Login', onPressed: _submit),
        const SizedBox(height: 36),
        _buildSecondaryButton(title: 'Cadastre-se', onPressed: _toggleMode),
        const SizedBox(height: 12),
        TextButton(
          onPressed:
              () => DialogsHomeViewPessoaFisica.showResetPasswordDialog(),
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
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      key: const ValueKey(false),
      children: [
        _buildUserTypeDropdown(),
        const SizedBox(height: 16),
        _buildSimpleTextField(
          controller: _nameController,
          hintText:
              _selectedUserType == UserType.pessoaFisica
                  ? 'Nome Completo'
                  : 'Razão Social',
          validator:
              (value) => (value ?? '').length < 6 ? 'Nome muito curto' : null,
        ),
        const SizedBox(height: 16),
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
            final doc = value ?? '';
            if (doc.isEmpty) {
              return 'Digite seu ${_selectedUserType.documentLabel}';
            }
            if (_selectedUserType == UserType.pessoaFisica) {
              return CPFValidator.isValid(doc) ? null : 'CPF inválido';
            }
            return CNPJValidator.isValid(doc) ? null : 'CNPJ inválido';
          },
        ),
        const SizedBox(height: 16),
        _buildSimpleTextField(
          controller: _phoneController,
          hintText: 'Telefone',
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          validator: (value) {
            final phone = value ?? '';
            if (phone.isEmpty) {
              return 'Digite seu telefone';
            }
            if (phone.length < 10) {
              return 'Telefone deve ter pelo menos 10 dígitos';
            }
            if (phone.length == 10) {
              if (!RegExp(r'^[1-9][1-9]\d{8}$').hasMatch(phone)) {
                return 'Telefone inválido';
              }
            } else if (phone.length == 11) {
              if (!RegExp(r'^[1-9][1-9][9]\d{8}$').hasMatch(phone)) {
                return 'Celular inválido';
              }
            } else {
              return 'Telefone deve ter 10 ou 11 dígitos';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildSimpleTextField(
          controller: _addressController,
          hintText: 'Endereço',
          validator:
              (value) =>
                  (value ?? '').length < 10
                      ? 'Endereço deve ter pelo menos 10 caracteres'
                      : null,
        ),
        const SizedBox(height: 16),
        _buildSimpleTextField(
          controller: _emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          validator:
              (value) =>
                  !GetUtils.isEmail(value ?? '')
                      ? 'Digite um e-mail válido'
                      : null,
        ),
        const SizedBox(height: 16),
        _buildSimpleTextField(
          controller: _passwordController,
          hintText: 'Senha',
          obscureText: _obscurePassword,
          suffixIcon: _buildObscureToggle(
            () => setState(() => _obscurePassword = !_obscurePassword),
            _obscurePassword,
          ),
          validator:
              (value) =>
                  (value ?? '').length < 6 ? 'Mínimo 6 caracteres' : null,
        ),
        const SizedBox(height: 16),
        _buildSimpleTextField(
          controller: _confirmPasswordController,
          hintText: 'Confirmar Senha',
          obscureText: _obscureConfirmPassword,
          suffixIcon: _buildObscureToggle(
            () => setState(
              () => _obscureConfirmPassword = !_obscureConfirmPassword,
            ),
            _obscureConfirmPassword,
          ),
          validator:
              (value) =>
                  value != _passwordController.text
                      ? 'As senhas não coincidem'
                      : null,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: _acceptTerms,
              onChanged:
                  (value) => setState(() => _acceptTerms = value ?? false),
              activeColor: const Color(0xFF6366F1),
            ),
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                child: Text(
                  'Aceito os termos de uso e política de privacidade',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildPrimaryButton(title: 'Cadastrar', onPressed: _submit),
        const SizedBox(height: 16),
        _buildSecondaryButton(
          title: 'Já tem conta? Faça login',
          onPressed: _toggleMode,
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String title,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String title,
    required VoidCallback onPressed,
  }) {
    final isDark = themeController.isDarkMode;

    // ALTERAÇÃO: Cor do botão secundário ajustada para o tema "true black".
    final darkButtonColor = const Color(0xFF2A2A2A);
    final lightButtonColor = Colors.grey[100];

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: isDark ? darkButtonColor : lightButtonColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child:
            title.contains('Faça login')
                ? RichText(
                  text: TextSpan(
                    text: 'Já tem conta? ',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white : const Color(0xFF333333),
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: 'Faça login',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF6366F1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
                : Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : const Color(0xFF333333),
                    fontWeight: FontWeight.w500,
                  ),
                ),
      ),
    );
  }

  Widget _buildObscureToggle(VoidCallback onPressed, bool isObscure) {
    return IconButton(
      icon: Icon(
        isObscure ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey[600],
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildUserTypeDropdown() {
    final isDark = themeController.isDarkMode;

    return DropdownButtonFormField<UserType>(
      value: _selectedUserType,
      decoration: _inputDecoration(hintText: 'Tipo de Usuário'),
      dropdownColor: isDark ? Colors.grey[700] : Colors.white,
      items:
          UserType.values
              .map(
                (type) => DropdownMenuItem<UserType>(
                  value: type,
                  child: Text(
                    type.displayName,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF212529),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          setState(() {
            _selectedUserType = newValue;
            _documentController.clear();
          });
        }
      },
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
    final isDark = themeController.isDarkMode;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(
        fontSize: 16,
        color: isDark ? Colors.white : const Color(0xFF212529),
        fontWeight: FontWeight.w500,
      ),
      decoration: _inputDecoration(hintText: hintText, suffixIcon: suffixIcon),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    final isDark = themeController.isDarkMode;

    // ALTERAÇÃO: Cores dos campos de texto para o tema "true black".
    final darkFillColor = const Color(0xFF2A2A2A);
    final darkBorderColor = Colors.grey[800]!;

    return InputDecoration(
      hintText: hintText,
      labelText: hintText,
      hintStyle: TextStyle(
        color: isDark ? Colors.grey[400] : const Color(0xFF6C757D),
      ),
      labelStyle: TextStyle(
        color: isDark ? Colors.grey[300] : const Color(0xFF6C757D),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDark ? darkFillColor : Colors.white,
      errorStyle: TextStyle(
        color: Colors.red.shade400, // Tom de vermelho mais suave para dark mode
        fontWeight: FontWeight.bold,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkBorderColor, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDark ? darkBorderColor : Colors.grey.shade500,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: const Color(0xFF6366F1), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade400, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade400, width: 2.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
