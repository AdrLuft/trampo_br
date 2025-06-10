import 'package:get/get.dart';
import 'package:interprise_calendar/app/login/bindings/login_bindings.dart';
import 'package:interprise_calendar/app/login/views/login_view.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/bindings/job_bindings.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/view/home_view_pessoa_fisica.dart';

class AppRoutes {
  static const String login = '/login';
  static const String jobPessoaFisica = '/job-pessoa-fisica';
  static const String jobPessoaJuridica = '/job-pessoa-juridica';

  static final List<GetPage> routes = [
    GetPage(
      name: login,
      page: () => const LoginView(),
      binding: LoginBindings(),
    ),
    GetPage(
      name: jobPessoaFisica,
      page: () => const HomeViewPessoaFisica(),
      binding: PessoaFisicaAppBindings(),
    ),
    // GetPage(
    //   name: jobPessoaJuridica,
    //   page: () => const JobPessoaJuridicaView(),
    //   binding: JobPessoaJuridicaBindings(),
    // ),
  ];
}
