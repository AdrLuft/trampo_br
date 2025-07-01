import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/login/presentations/login_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/dialogs_home_view_pessoa_fisica/home_view_page_dialog/dialogs_home_view_pessoa_fisica.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:interprise_calendar/app/core/enums/login_enum.dart';

import 'dart:math'; // Import para usar o valor de 'pi' na rotação

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

  LoginController get controller => Get.find();

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
    // Esconde o teclado
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (!_isLogin && !_acceptTerms) {
      Get.snackbar('Erro', 'Você deve aceitar os termos de uso');
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
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Stack para colocar o loading sobre a tela
      body: Stack(
        children: [
          // Conteúdo principal da página
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
                    _buildLogo(),
                    const SizedBox(height: 32),
                    _buildAnimatedSwitcher(),
                  ],
                ),
              ),
            ),
          ),

          // 2. Overlay de carregamento condicional
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // 3. WIDGET PARA O OVERLAY DE CARREGAMENTO
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/logo.png',
      height: 200,
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
            if (doc.isEmpty)
              return 'Digite seu ${_selectedUserType.documentLabel}';
            if (_selectedUserType == UserType.pessoaFisica)
              return CPFValidator.isValid(doc) ? null : 'CPF inválido';
            return CNPJValidator.isValid(doc) ? null : 'CNPJ inválido';
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
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF333333),
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
    return DropdownButtonFormField<UserType>(
      value: _selectedUserType,
      decoration: _inputDecoration(hintText: 'Tipo de Usuário'),
      dropdownColor: Colors.white,
      items:
          UserType.values
              .map(
                (type) => DropdownMenuItem<UserType>(
                  value: type,
                  child: Text(
                    type.displayName,
                    style: const TextStyle(
                      color: Color(0xFF212529),
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
    return TextFormField(
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
      decoration: _inputDecoration(hintText: hintText, suffixIcon: suffixIcon),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFF6C757D),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: const TextStyle(
        color: Color(0xFF6C757D),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      errorStyle: TextStyle(
        color: Colors.red.shade800,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade500, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade500, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade800, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade800, width: 2.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
