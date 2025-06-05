import 'package:get/get.dart';
import 'package:interprise_calendar/app/modules/job_module/bindings/job_bindings.dart';
import 'package:interprise_calendar/app/modules/job_module/views/login_view.dart';

class AppRoutes {
  static const String initialRoute = '/login';
  static const String home = '/home';
  static const String register = '/register';
  static const String agendamentos = '/agendamentos';
  static const String createAgendamento = '/agendamentos';

  static final List<GetPage> routes = [
    GetPage(
      name: initialRoute,
      page: () => LoginView(),
      binding: AppBindings(),
    ),
    // GetPage(
    //   name: home,
    //   page: () => const HomePage(),
    //   transition: Transition.fadeIn,
    // ),
    // GetPage(
    //   name: register,
    //   page: () => const RegisterPage(),
    //   transition: Transition.fadeIn,
    // ),
    // GetPage(
    //   name: agendamentos,
    //   page: () => const AgendamentosPage(),
    //   transition: Transition.fadeIn,
    // ),
    // GetPage(
    //   name: createAgendamento,
    //   page: () => const CreateAgendamentoPage(),
    //   transition: Transition.fadeIn,
    // ),
  ];
}
