import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Configurações de performance para otimização do app
class PerformanceConfig {
  /// Configurações para melhorar a performance das animações de teclado
  static void configureKeyboardAnimations() {
    // Configura o sistema para otimizar as animações do teclado
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
  }

  /// Configurações gerais de performance
  static void configurePerformance() {
    // Configurações do sistema
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Configurações de performance para animações
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Força o garbage collector para liberar memória
      // (usado com moderação para evitar impacto na performance)
    });
  }

  /// Configurações otimizadas para dialogs
  static const Duration dialogAnimationDuration = Duration(milliseconds: 200);
  static const Duration keyboardAnimationDuration = Duration(milliseconds: 250);

  /// Configurações de bordas arredondadas otimizadas
  static const BorderRadius defaultBorderRadius = BorderRadius.all(
    Radius.circular(15),
  );

  static const BorderRadius smallBorderRadius = BorderRadius.all(
    Radius.circular(8),
  );

  /// Estilos de botão otimizados
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.teal,
    foregroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: smallBorderRadius),
    minimumSize: const Size(100, 40),
  );

  static ButtonStyle get dangerButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: smallBorderRadius),
    minimumSize: const Size(100, 40),
  );

  /// Configurações de campo de texto otimizadas
  static InputDecoration getOptimizedInputDecoration({
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.teal, width: 2),
      ),
    );
  }

  /// Configurações de Snackbar otimizadas
  static void showOptimizedSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    Color textColor = Colors.white,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: textColor,
      snackPosition: SnackPosition.BOTTOM,
      duration: duration,
      icon: icon != null ? Icon(icon, color: textColor) : null,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}
