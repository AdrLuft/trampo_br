import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/job_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/settings_view_controller_pessoa_fisica.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/pages_for_homeview_pessoa_fisica/trampos_salvos_page/salvos_page_helper.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/pages_for_homeview_pessoa_fisica/vagas_pages/vagas_page_helper.dart';

class HomeViewPessoaFisica extends StatefulWidget {
  const HomeViewPessoaFisica({super.key});

  @override
  State<HomeViewPessoaFisica> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeViewPessoaFisica> {
  int _selectedIndex = 0;
  final JobPessoaFisicaController _controller = Get.find();
  final SettingsHomePagePessoaFisicaController _settingsController =
      SettingsHomePagePessoaFisicaController();
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Lista de páginas para cada aba (apenas 3 agora)
  List<Widget> get _pages => [
    _InicioPage(onNavigateToTab: _onItemTapped),
    const VagasPage(),
    const SalvosPage(),
  ];

  // Método para navegar para páginas que não estão na bottom navigation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trampos BR',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Ação de notificações
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
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
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Header do Drawer
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade400, Colors.teal.shade600],
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
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Trampos BR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Menu Principal',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
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
                _buildDrawerItem(
                  icon: Icons.chat,
                  title: 'Mensagens',
                  onTap: () {
                    Get.back();
                    Get.toNamed('/mensagens');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.work,
                  title: 'Vagas',
                  onTap: () {
                    Get.back();
                    Get.toNamed('/vagas');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.bookmark,
                  title: 'Trampos Salvos',
                  onTap: () {
                    Get.back();
                    Get.toNamed('/trampos-salvos');
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.palette,
                  title: 'Alterar Tema',
                  onTap: () async {
                    Get.back();
                    await _controller.toggleTheme();
                    Get.snackbar(
                      'Tema',
                      'Tema alterado com sucesso!',
                      backgroundColor: Colors.teal,
                      colorText: Colors.white,
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.lock_reset,
                  title: 'Alterar Senha',
                  onTap: () {
                    Get.back();
                    _showChangePasswordDialog();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notificações',
                  onTap: () {
                    Get.back();
                    _showNotificationsSettings();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.security,
                  title: 'Privacidade e Segurança',
                  onTap: () {
                    Get.back();
                    _showPrivacySettings();
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.delete_forever,
                  title: 'Excluir Conta',
                  onTap: () {
                    Get.back();
                    _showDeleteAccountDialog();
                  },
                  textColor: Colors.red,
                ),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Sair do App',
                  onTap: () {
                    Get.back();
                    _showLogoutDialog();
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
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.grey.shade700),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.grey.shade800,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Alterar Senha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha Atual',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nova Senha',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar Nova Senha',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implementar lógica de alteração de senha
              Get.back();
              Get.snackbar(
                'Senha',
                'Senha alterada com sucesso!',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Alterar'),
          ),
        ],
      ),
    );
  }

  void _showNotificationsSettings() {
    Get.dialog(
      AlertDialog(
        title: const Text('Configurações de Notificações'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Notificações de Vagas'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Notificações de Mensagens'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Notificações Push'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fechar')),
        ],
      ),
    );
  }

  void _showPrivacySettings() {
    Get.dialog(
      AlertDialog(
        title: const Text('Privacidade e Segurança'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Perfil Público'),
              trailing: Switch(value: true, onChanged: (value) {}),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Compartilhar Localização'),
              trailing: Switch(value: false, onChanged: (value) {}),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico de Atividades'),
              onTap: () {
                Get.back();
                // Navegar para histórico
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fechar')),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Excluir Conta'),
        content: const Text(
          'Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Get.back();
              // Implementar lógica de exclusão de conta
              Get.snackbar(
                'Conta',
                'Funcionalidade em desenvolvimento',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Sair do App'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Get.back();
              _settingsController.logout();
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

// Páginas individuais para cada aba
class _InicioPage extends StatelessWidget {
  final Function(int) onNavigateToTab;

  const _InicioPage({required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
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
                colors: [Colors.teal.shade400, Colors.teal.shade600],
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Bem-vindo!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Encontre as melhores oportunidades de trabalho',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Seção de ações rápidas
          Center(
            child: const Text(
              'Ações Rápidas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildActionCard(
                'Buscar Trampos',
                Icons.search,
                Colors.blue,
                () => onNavigateToTab(1), // Navega para aba Vagas
              ),
              _buildActionCard(
                'Atualizar Perfil',
                Icons.edit,
                Colors.orange,
                () {
                  Get.toNamed('/perfil');
                },
              ),
              _buildActionCard(
                'Ver Salvos',
                Icons.bookmark,
                Colors.purple,
                () => onNavigateToTab(2), // Navega para aba Salvos
              ),
              _buildActionCard('Mensagens', Icons.chat, Colors.green, () {
                Get.toNamed('/mensagens');
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              // color: color.withOpacity(0.2),
              color: Colors.white.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                //color: color.withOpacity(0.1),
                color: Colors.black.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
