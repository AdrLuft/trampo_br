import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:interprise_calendar/app/core/widgets/widgets_custom/status_widget.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/trampos_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/settings_view_controller_pessoa_fisica.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/dialogs_home_view_pessoa_fisica/home_view_page_dialog/dialogs_home_view_pessoa_fisica.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/pages_for_homeview_pessoa_fisica/criar_trampo_page/criar_trampo_page.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/pages_for_homeview_pessoa_fisica/detalhes_vaga_page/detalhes_vagas_page.dart'
    as detalhes;
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/pages_for_homeview_pessoa_fisica/mensagens_page/mensagens_page_helper.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/pages_for_homeview_pessoa_fisica/trampos_salvos_page/salvos_page_helper.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/pages_for_homeview_pessoa_fisica/vagas_pages/vagas_page_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeViewPessoaFisica extends StatefulWidget {
  const HomeViewPessoaFisica({super.key});

  @override
  State<HomeViewPessoaFisica> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeViewPessoaFisica> {
  int _selectedIndex = 0;
  final TramposController _controller = Get.find();
  final SettingsHomePagePessoaFisicaController _settingsController =
      SettingsHomePagePessoaFisicaController();
  // final DialogsHomeViewPessoaFisica _dialogsHelper = DialogsHomeViewPessoaFisica();
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Lista de páginas para cada aba
  List<Widget> get _pages => [
    _InicioPage(onNavigateToTab: _onItemTapped, controller: _controller),
    const VagasPage(),
    const SalvosPage(),
    const CriarPage(),
    const MensagensPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trampos BR',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.onSurface.withAlpha(153),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.normal,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Vagas'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Salvos'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Criar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mensagens',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      width: 269,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1).withAlpha(204),
                  const Color(0xFF6366F1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.9),
                          blurRadius: 70,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Trampos BR',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Menu Principal',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withAlpha(179),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lista de itens do menu
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.person,
                  title: 'Perfil',
                  onTap: () {
                    Get.back();
                    Get.toNamed('/perfil');
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.palette,
                  title: 'Alterar Tema',
                  onTap: () async {
                    Get.back();
                    await _controller.toggleTheme();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.lock_reset,
                  title: 'Alterar Senha',
                  onTap: () {
                    Get.back();
                    DialogsHomeViewPessoaFisica.showChangePasswordDialog();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notificações',
                  onTap: () {
                    Get.back();
                    DialogsHomeViewPessoaFisica.showNotificationsSettings();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.security,
                  title: 'Privacidade e Segurança',
                  onTap: () {
                    Get.back();
                    DialogsHomeViewPessoaFisica.showPrivacySettings();
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.delete_forever,
                  title: 'Excluir Conta',
                  onTap: () {
                    Get.back();
                    DialogsHomeViewPessoaFisica.showDeleteAccountDialog();
                  },
                  textColor: Colors.red,
                ),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Sair do App',
                  onTap: () {
                    Get.back();
                    _settingsController.logout();
                  },
                  textColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color:
            textColor ??
            (isDark
                ? Colors.white.withAlpha(204)
                : Theme.of(context).colorScheme.onSurface),
      ),
      title: Text(
        title,
        style: TextStyle(
          color:
              textColor ??
              (isDark
                  ? Colors.white.withAlpha(230)
                  : Theme.of(context).colorScheme.onSurface),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}

// Páginas individuais para cada aba
class _InicioPage extends StatelessWidget {
  final Function(int) onNavigateToTab;
  final TramposController controller;

  const _InicioPage({required this.onNavigateToTab, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card de boas-vindas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1).withAlpha(204),
                  const Color(0xFF6366F1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Bem-vindo!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      //color: Theme.of(context).colorScheme.onPrimary,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Encontre as melhores oportunidades de trabalho',
                  style: TextStyle(
                    fontSize: 16,
                    // color: Theme.of(
                    //   context,
                    // ).colorScheme.onPrimary.withAlpha(179),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          Center(
            child: Text(
              'Trampos Recentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Lista de Trampos do Firebase
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('Trampos')
                    .orderBy('createDate', descending: true)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error,
                        size: 60,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Erro ao carregar trampos',
                        style: TextStyle(
                          color:
                              isDark
                                  ? Colors.white.withAlpha(230)
                                  : Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.work_off,
                        size: 60,
                        color:
                            isDark
                                ? Colors.white.withAlpha(179)
                                : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(153),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nenhum trampo cadastrado',
                        style: TextStyle(
                          color:
                              isDark
                                  ? Colors.white.withAlpha(230)
                                  : Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Crie o primeiro trampo na aba "Criar"',
                        style: TextStyle(
                          color:
                              isDark
                                  ? Colors.white.withAlpha(179)
                                  : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withAlpha(153),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  return _buildTrampoCardFromData(data, isDark);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrampoCardFromData(Map<String, dynamic> data, bool isDark) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Get.to(() => detalhes.DetalhesVagaPage(vagaData: data, vagaId: ''));
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Colors.white.withAlpha(15)
                      : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border:
                  isDark
                      ? Border.all(
                        color: Colors.white.withAlpha(38),
                        width: 1.5,
                      )
                      : null,
              boxShadow:
                  isDark
                      ? null
                      : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título da vaga
                  Text(
                    data['tipoVaga'] ?? 'Trampo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Criador
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        data['createTrampoNome'] ?? 'Usuário',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  StatusVagaWidget(status: data['status'] ?? 'Disponível'),
                  const SizedBox(height: 12),

                  // Descrição
                  Text(
                    data['titulo'] ?? 'Sem titulo',
                    style: TextStyle(
                      fontSize: 18,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Botões de ação
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              // Implementação do método de salvar vaga
                            },
                            icon: Icon(
                              Icons.bookmark_border,
                              color: const Color(0xFF6366F1),
                              size: 24,
                            ),
                            tooltip: 'Salvar vaga',
                          ),
                          const Text(
                            'Salvar',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      // Botões de contato direto
                      Row(
                        children: [
                          if (data['telefone'] != null &&
                              data['telefone'].toString().isNotEmpty) ...[
                            IconButton(
                              onPressed: () {
                                final telefone = data['telefone'].toString();
                                final numeroLimpo = telefone.replaceAll(
                                  RegExp(r'[^0-9]'),
                                  '',
                                );
                                String numeroFormatado = numeroLimpo;
                                if (!numeroFormatado.startsWith('55')) {
                                  numeroFormatado = '55$numeroFormatado';
                                }
                                final mensagem =
                                    'Olá! Vi sua vaga "${data['tipoVaga']}" no Trampos BR e tenho interesse.';
                                final whatsappUri =
                                    'https://wa.me/$numeroFormatado?text=${Uri.encodeComponent(mensagem)}';
                                launchUrl(
                                  Uri.parse(whatsappUri),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.whatsapp,
                                color: const Color(0xFF25D366),
                                size: 20,
                              ),
                              tooltip: 'WhatsApp',
                            ),
                            IconButton(
                              onPressed: () {
                                final telefone = data['telefone'].toString();
                                launchUrl(Uri(scheme: 'tel', path: telefone));
                              },
                              icon: Icon(
                                Icons.phone,
                                color: const Color(0xFF22C55E),
                                size: 20,
                              ),
                              tooltip: 'Ligar',
                            ),
                          ],
                          if (data['email'] != null &&
                              data['email'].toString().isNotEmpty)
                            IconButton(
                              onPressed: () {
                                final email = data['email'].toString();
                                final assunto = Uri.encodeComponent(
                                  'Interesse na vaga: ${data['tipoVaga']}',
                                );
                                final corpo = Uri.encodeComponent(
                                  'Olá,\n\nVi sua vaga "${data['tipoVaga']}" no Trampos BR e tenho interesse.\n\nAguardo contato.',
                                );
                                launchUrl(
                                  Uri.parse(
                                    'mailto:$email?subject=$assunto&body=$corpo',
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.email,
                                color: const Color(0xFF6366F1),
                                size: 20,
                              ),
                              tooltip: 'Email',
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
