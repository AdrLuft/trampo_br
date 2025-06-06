import 'package:get/get.dart';
import 'package:interprise_calendar/app/login/bindings/login_bindings.dart';
import 'package:interprise_calendar/app/login/views/login_view.dart';

class AppRoutes {
  static const String initialRoute = '/login';
  static const String home = '/home';
  static const String register = '/register';
  static const String agendamentos = '/trampos';
  static const String createAgendamento = '/createTrampos';

  static final List<GetPage> routes = [
    GetPage(
      name: initialRoute,
      page: () => const LoginView(),
      binding: LoginBindings(),
    ),
  ];
}
