import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interprise_calendar/app/core/widgets/widgets_custom/status_widget.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/data/models/trampos_model.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/trampos_controller.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/pages_for_homeview_pessoa_fisica/vagas_pages/helpers/editar_minhas_vagas_page.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/pages_for_homeview_pessoa_fisica/vagas_pages/helpers/vagas_pages_dialos/vagas_pages_dialogs.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/pages_for_homeview_pessoa_fisica/detalhes_vaga_page/detalhes_vagas_page.dart'
    as detalhes;

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Função para obter cor com base no status
  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'disponivel':
      case 'disponível':
        return Colors.green;
      case 'ocupado':
        return Colors.orange;
      case 'finalizado':
        return Colors.grey;
      default:
        return Colors.green;
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
              color: isDark ? Colors.grey.shade900 : Colors.white,
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
              labelColor: Colors.teal,
              unselectedLabelColor: isDark ? Colors.white70 : Colors.grey,
              indicatorColor: Colors.teal,
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
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('Trampos')
              .orderBy('createDate', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.teal),
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

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return _buildVagaCard(data, isDark, false, doc.id);
          },
        );
      },
    );
  }

  Widget _buildMinhasVagasTab(bool isDark) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.teal),
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
            // Retorna um card clicável que abrirá a tela de edição
            return GestureDetector(
              onTap: () {
                // Navegar para a tela de edição passando a vaga e seu ID
                Get.to(() => _editarMinhasVagasPage);
              },
              child: VagasPagesDialogs.buildMinhaVagaCard(vaga, isDark),
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
          color: isDark ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
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
                      color: Colors.teal.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      data['tipoVaga'] ?? 'Não especificado',
                      style: TextStyle(
                        color: Colors.teal.shade700,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (data['telefone'] != null &&
                          data['telefone'].toString().isNotEmpty)
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
                                color: Colors.teal,
                                size: 24,
                              ),
                              tooltip: 'Salvar vaga',
                            ),
                            Text(
                              'Salvar Vaga',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.snackbar(
                        'Interesse',
                        'Funcionalidade de candidatura será implementada',
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Tenho Interesse'),
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
