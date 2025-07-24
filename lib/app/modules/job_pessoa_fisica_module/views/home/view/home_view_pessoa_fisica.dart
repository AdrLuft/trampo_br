import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/profile_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/view/home_view_pessoa_fisica_helpers.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/trampos_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/settings_view_controller_pessoa_fisica.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/dialogs_home_view_pessoa_fisica/home_view_page_dialog/dialogs_home_view_pessoa_fisica.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/helpers_pages/criar_trampo_page/criar_trampo_page.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/helpers_pages/trampos_salvos_page/salvos_page_helper.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/helpers_pages/vagas_pages/vagas_page_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeViewPessoaFisica extends StatefulWidget {
  const HomeViewPessoaFisica({super.key});

  @override
  State<HomeViewPessoaFisica> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeViewPessoaFisica> {
  int _selectedIndex = 0;
  final SettingsHomePagePessoaFisicaController _settingsController =
      SettingsHomePagePessoaFisicaController();
  final TramposController _controller = Get.find<TramposController>();
  final usercontroller = Get.find<ProfileController>();

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trampos BR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              HomeViewPessoaFisicaHelpers.showBuscaAvancada();
            },
            tooltip: 'Busca Avançada',
          ),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
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
          // Header com altura dinâmica
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 200, maxHeight: 280),
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
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() {
                  // Pega a instância do controller
                  final controller = Get.find<ProfileController>();

                  // Enquanto estiver carregando, mostra um spinner
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  // Se carregou com sucesso, exibe a UI completa
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Avatar/Foto do perfil
                      GestureDetector(
                        onTap: () {
                          // Permite alterar a foto diretamente do drawer
                          controller.pickAndUploadProfileImage();
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child:
                                controller.user.value?.profileImageUrl !=
                                            null &&
                                        controller
                                            .user
                                            .value!
                                            .profileImageUrl!
                                            .isNotEmpty
                                    ? Image.network(
                                      controller.user.value!.profileImageUrl!,
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: 80,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Icon(
                                          Icons.person,
                                          size: 35,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        );
                                      },
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                            strokeWidth: 2,
                                          ),
                                        );
                                      },
                                    )
                                    : Icon(
                                      Icons.person,
                                      size: 35,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Nome do usuário
                      Text(
                        controller.user.value?.name ?? 'Usuário',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Email do usuário
                      Text(
                        controller.user.value?.email ?? 'email@exemplo.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withAlpha(179),
                        ),
                      ),

                      // Indicador de upload se estiver carregando
                      if (controller.isUploadingPhoto.value) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Enviando...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                }),
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

// Página de Início com busca simples
class _InicioPage extends StatefulWidget {
  final Function(int) onNavigateToTab;
  final TramposController controller;

  const _InicioPage({required this.onNavigateToTab, required this.controller});

  @override
  State<_InicioPage> createState() => __InicioPageState();
}

class __InicioPageState extends State<_InicioPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                      color: Colors.white,
                    ),
                  ),
                ),
                //   const SizedBox(height: 8),
                Text(
                  'Encontre as melhores oportunidades de trabalho',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Barra de busca simples
          _buildSimpleSearchBar(isDark),

          const SizedBox(height: 14),

          Center(
            child: Text(
              _searchQuery.isNotEmpty
                  ? 'Resultados da busca'
                  : 'Trampos Recentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Lista de Trampos do Firebase com busca simples
          _buildTramposList(isDark),
        ],
      ),
    );
  }

  Widget _buildSimpleSearchBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withAlpha(15) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            isDark
                ? Border.all(color: Colors.white.withAlpha(38), width: 1.5)
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
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Buscar trampos...',
          hintStyle: TextStyle(
            color: isDark ? Colors.white60 : Colors.grey.shade600,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? Colors.white70 : Colors.grey.shade600,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchQuery.isNotEmpty)
                IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
              IconButton(
                onPressed: () {
                  HomeViewPessoaFisicaHelpers.showBuscaAvancada();
                },
                icon: Icon(Icons.tune, color: const Color(0xFF6366F1)),
                tooltip: 'Busca Avançada',
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      ),
    );
  }

  Widget _buildTramposList(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
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

        // Filtrar apenas por busca simples
        final filteredDocs =
            _searchQuery.isEmpty
                ? snapshot.data!.docs
                : snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final titulo = data['titulo']?.toString().toLowerCase() ?? '';
                  final descricao =
                      data['descricao']?.toString().toLowerCase() ?? '';
                  final tipoVaga =
                      data['tipoVaga']?.toString().toLowerCase() ?? '';
                  final local = data['local']?.toString().toLowerCase() ?? '';

                  return titulo.contains(_searchQuery) ||
                      descricao.contains(_searchQuery) ||
                      tipoVaga.contains(_searchQuery) ||
                      local.contains(_searchQuery);
                }).toList();

        if (filteredDocs.isEmpty && _searchQuery.isNotEmpty) {
          return Center(
            child: Column(
              children: [
                Icon(
                  Icons.search_off,
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
                  'Nenhuma vaga encontrada',
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
                  'Tente usar palavras diferentes ou use a busca avançada',
                  style: TextStyle(
                    color:
                        isDark
                            ? Colors.white.withAlpha(179)
                            : Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(153),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    HomeViewPessoaFisicaHelpers.showBuscaAvancada();
                  },
                  icon: const Icon(Icons.tune),
                  label: const Text('Busca Avançada'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Contador de resultados
            if (_searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredDocs.length} vaga${filteredDocs.length != 1 ? 's' : ''} encontrada${filteredDocs.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        HomeViewPessoaFisicaHelpers.showBuscaAvancada();
                      },
                      icon: const Icon(Icons.tune, size: 16),
                      label: const Text('Filtros'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF6366F1),
                      ),
                    ),
                  ],
                ),
              ),

            // Lista filtrada
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredDocs.length,
              itemBuilder: (context, index) {
                final doc = filteredDocs[index];
                final data = doc.data() as Map<String, dynamic>;
                return HomeViewPessoaFisicaHelpers.buildTrampoCard(
                  data,
                  isDark,
                  doc.id,
                  widget.controller,
                  searchQuery: _searchQuery,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
