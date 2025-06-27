import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/core/configs/global_themes/app_theme.dart';
import 'package:interprise_calendar/app/core/configs/global_themes/global_theme_controller.dart';
import 'package:interprise_calendar/app/core/performance/performance_config.dart';
import 'package:interprise_calendar/app/login/bindings/login_bindings.dart';
import 'package:interprise_calendar/app/routs/app_routes.dart';
import 'package:interprise_calendar/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurações de performance
  PerformanceConfig.configurePerformance();
  PerformanceConfig.configureKeyboardAnimations();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configurar locale para Firebase
  FirebaseAuth.instance.setLanguageCode('pt-BR');

  // Inicializa o controller e espera ele carregar o tema salvo
  await Get.putAsync(() async => GlobalThemeController());

  runApp(const TrampoBR());
}

class TrampoBR extends StatelessWidget {
  const TrampoBR({super.key});

  @override
  Widget build(BuildContext context) {
    // Busca a instância do controller para definir o tema inicial
    final GlobalThemeController themeController = Get.find();

    return Obx(
      () => GetMaterialApp(
        title: 'Trampo BR',
        debugShowCheckedModeBanner: false,

        // CONFIGURAÇÃO CORRETA E OBRIGATÓRIA - Agora reativo
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode:
            themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,

        initialRoute: AppRoutes.login,
        getPages: AppRoutes.routes,
        initialBinding: LoginBindings(),
      ),
    );
  }
}

/*
adicionar dentro do icone de configuração na homeview o botão de troca de temas
e fazer uma tela de configuração
*/
