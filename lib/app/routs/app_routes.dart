import 'package:get/get.dart';
import 'package:interprise_calendar/app/login/bindings/login_bindings.dart';
import 'package:interprise_calendar/app/login/views/login_view.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/bindings/trampos_bindings.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/helpers_pages/perfi_page/editar_perfil_page.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/view/home_view_pessoa_fisica.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/helpers_pages/mensagens_page/mensagens_page_helper.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/helpers_pages/perfi_page/perfil_page.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/helpers_pages/trampos_salvos_page/salvos_page_helper.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/helpers_pages/vagas_pages/vagas_page_helper.dart';

class AppRoutes {
  static const String login = '/login';
  static const String jobPessoaFisica = '/job-pessoa-fisica';
  static const String jobPessoaJuridica = '/job-pessoa-juridica';
  static const String perfil = '/perfil';
  static const String mensagens = '/mensagens';
  static const String tramposSalvos = '/trampos-salvos';
  static const String vagas = '/vagas';
  static const String editarPerfil = '/editarPerfil';

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
    GetPage(name: perfil, page: () => const PerfilPage()),
    GetPage(name: mensagens, page: () => const MensagensPage()),
    GetPage(name: tramposSalvos, page: () => const SalvosPage()),
    GetPage(name: vagas, page: () => const VagasPage()),
    GetPage(name: editarPerfil, page: () => const EditarPerfilPage()),
  ];
}
