import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interprise_calendar/app/core/widgets/widgets_custom/status_widget.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/data/models/trampos_model.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/trampos_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/helpers_pages/vagas_pages/helpers/editar_minhas_vagas_page.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/helpers_pages/vagas_pages/helpers/vagas_pages_dialos/vagas_pages_dialogs.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/helpers_pages/detalhes_vaga_page/detalhes_vagas_page.dart'
    as detalhes;
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/view/home_view_pessoa_fisica_helpers.dart';

class VagasPage extends StatefulWidget {
  const VagasPage({super.key});

  @override
  State<VagasPage> createState() => _VagasPageState();
}

class _VagasPageState extends State<VagasPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TramposController _controller = Get.find<TramposController>();
  final EditarMinhasVagasPage _editarMinhasVagasPage = EditarMinhasVagasPage(
    vagaData: {},
    vagaId: '',
    onSave: () {},
  );

  // Controladores para busca
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Função para obter cor com base no status
  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'disponivel':
      case 'disponível':
        return const Color(0xFF6366F1);
      case 'ocupado':
        return Colors.orange;
      case 'finalizado':
        return Colors.grey;
      default:
        return const Color(0xFF6366F1);
    }
  }

  // Função para formatar a data
  String formatarData(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inDays == 0) return 'Hoje';
    if (diferenca.inDays == 1) return 'Ontem';
    if (diferenca.inDays < 7) return '${diferenca.inDays} dias atrás';
    return '${data.day}/${data.month}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // TabBar
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF6366F1),
              unselectedLabelColor:
                  isDark ? Colors.white.withAlpha(153) : Colors.grey.shade600,
              indicatorColor: const Color(0xFF6366F1),
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              tabs: const [
                Tab(icon: Icon(Icons.work), text: 'Todas as Vagas'),
                Tab(icon: Icon(Icons.assignment), text: 'Minhas Vagas'),
              ],
              onTap: (index) {
                if (index == 1) {
                  _controller.carregarMinhasVagas();
                }
              },
            ),
          ),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTodasVagasTab(isDark),
                _buildMinhasVagasTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodasVagasTab(bool isDark) {
    return Column(
      children: [
        // Barra de busca
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildSimpleSearchBar(isDark),
        ),

        // Lista de vagas com busca
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('Trampos')
                    .orderBy('createDate', descending: true)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF6366F1)),
                );
              }

              if (snapshot.hasError) {
                return VagasPagesDialogs.buildEmptyState(
                  'Erro ao carregar vagas',
                  'Tente novamente mais tarde',
                  Icons.error,
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return VagasPagesDialogs.buildEmptyState(
                  'Nenhuma vaga disponível',
                  'Quando houver vagas publicadas, elas aparecerão aqui',
                  Icons.work_off,
                );
              }

              // Filtrar vagas com base na busca
              final filteredDocs =
                  _searchQuery.isEmpty
                      ? snapshot.data!.docs
                      : snapshot.data!.docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final titulo =
                            data['titulo']?.toString().toLowerCase() ?? '';
                        final descricao =
                            data['descricao']?.toString().toLowerCase() ?? '';
                        final tipoVaga =
                            data['tipoVaga']?.toString().toLowerCase() ?? '';
                        final local =
                            data['local']?.toString().toLowerCase() ?? '';

                        return titulo.contains(_searchQuery) ||
                            descricao.contains(_searchQuery) ||
                            tipoVaga.contains(_searchQuery) ||
                            local.contains(_searchQuery);
                      }).toList();

              if (filteredDocs.isEmpty && _searchQuery.isNotEmpty) {
                return _buildNoResultsFound(isDark);
              }

              return Column(
                children: [
                  // Contador de resultados
                  if (_searchQuery.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${filteredDocs.length} vaga${filteredDocs.length != 1 ? 's' : ''} encontrada${filteredDocs.length != 1 ? 's' : ''}',
                            style: TextStyle(
                              color:
                                  isDark
                                      ? Colors.white70
                                      : Colors.grey.shade600,
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
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredDocs.length,
                      itemBuilder: (context, index) {
                        final doc = filteredDocs[index];
                        final data = doc.data() as Map<String, dynamic>;
                        return _buildVagaCard(data, isDark, false, doc.id);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
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
          hintText: 'Buscar vagas...',
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

  Widget _buildNoResultsFound(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 60,
              color:
                  isDark
                      ? Colors.white.withAlpha(179)
                      : Theme.of(context).colorScheme.onSurface.withAlpha(153),
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
      ),
    );
  }

  Widget _buildMinhasVagasTab(bool isDark) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF6366F1)),
        );
      }

      if (_controller.minhasVagas.isEmpty) {
        return VagasPagesDialogs.buildEmptyState(
          'Você ainda não publicou vagas',
          'Acesse a aba "Criar" para publicar sua primeira vaga',
          Icons.add_circle_outline,
        );
      }

      return RefreshIndicator(
        onRefresh: () => _controller.carregarMinhasVagas(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _controller.minhasVagas.length,
          itemBuilder: (context, index) {
            final vaga = _controller.minhasVagas[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration:
                  isDark
                      ? null
                      : BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
              child: GestureDetector(
                onTap: () {
                  // Navegar para a tela de edição passando a vaga e seu ID
                  Get.to(() => _editarMinhasVagasPage);
                },
                child: VagasPagesDialogs.buildMinhaVagaCard(vaga, isDark),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildVagaCard(
    Map<String, dynamic> data,
    bool isDark,
    bool isMyJob,
    String docId,
  ) {
    final createDate =
        (data['createDate'] as Timestamp?)?.toDate() ?? DateTime.now();

    final String titulo = data['titulo'] as String? ?? '';

    return GestureDetector(
      onTap: () {
        Get.to(() => detalhes.DetalhesVagaPage(vagaData: data, vagaId: docId));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color:
              isDark ? Colors.white.withAlpha(15) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      data['tipoVaga'] ?? 'Não especificado',
                      style: const TextStyle(
                        color: Color(0xFF6366F1),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (titulo.isNotEmpty) ...[
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      data['createTrampoNome'] ?? 'Usuário não identificado',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formatarData(createDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              StatusVagaWidget(status: data['status'] ?? 'Disponível'),
              const SizedBox(height: 16),
              // Botões de ação
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          final vagaEntity =
                              CreateTramposModel.fromJson({
                                'id': docId,
                                ...data,
                              }).toEntity();
                          _controller.salvarVagaFavoritos(vagaEntity);
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
  }
}
