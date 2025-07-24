import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/data/models/trampos_model.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/trampos_controller.dart';
import 'package:interprise_calendar/app/core/widgets/widgets_custom/status_widget.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/helpers_pages/detalhes_vaga_page/detalhes_vagas_page.dart'
    as detalhes;
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeViewPessoaFisicaHelpers {
  // Método para mostrar a busca avançada
  static void showBuscaAvancada() {
    Get.to(() => const BuscaAvancadaPage());
  }

  // Método para construir o card de trampo com destaque na busca
  static Widget buildTrampoCard(
    Map<String, dynamic> data,
    bool isDark,
    String docId,
    TramposController controller, {
    String searchQuery = '',
  }) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Get.to(
              () => detalhes.DetalhesVagaPage(vagaData: data, vagaId: docId),
            );
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
                  // Título da vaga com destaque
                  if (searchQuery.isNotEmpty)
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        children: _highlightSearchTerm(
                          data['tipoVaga'] ?? 'Trampo',
                          searchQuery,
                        ),
                      ),
                    )
                  else
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

                  // Descrição com destaque
                  if (searchQuery.isNotEmpty)
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.grey.shade700,
                          height: 1.3,
                        ),
                        children: _highlightSearchTerm(
                          data['titulo'] ?? 'Sem titulo',
                          searchQuery,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    Text(
                      data['titulo'] ?? 'Sem titulo',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  // Localização se disponível
                  if (data['local'] != null &&
                      data['local'].toString().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child:
                              searchQuery.isNotEmpty
                                  ? RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            isDark
                                                ? Colors.white70
                                                : Colors.grey.shade700,
                                      ),
                                      children: _highlightSearchTerm(
                                        data['local'].toString(),
                                        searchQuery,
                                      ),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                  : Text(
                                    data['local'].toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          isDark
                                              ? Colors.white70
                                              : Colors.grey.shade700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 12),

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
                              controller.salvarVagaFavoritos(vagaEntity);
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

  // Método para destacar termos de busca
  static List<TextSpan> _highlightSearchTerm(String text, String searchTerm) {
    if (searchTerm.isEmpty) {
      return [TextSpan(text: text)];
    }

    final List<TextSpan> spans = [];
    final String lowerText = text.toLowerCase();
    final String lowerSearch = searchTerm.toLowerCase();

    int start = 0;
    int index = lowerText.indexOf(lowerSearch);

    while (index != -1) {
      // Adiciona o texto antes do termo de busca
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      // Adiciona o termo de busca destacado
      spans.add(
        TextSpan(
          text: text.substring(index, index + searchTerm.length),
          style: const TextStyle(
            backgroundColor: Color(0xFF6366F1),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      start = index + searchTerm.length;
      index = lowerText.indexOf(lowerSearch, start);
    }

    // Adiciona o texto restante
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
  }
}

// Página de Busca Avançada
class BuscaAvancadaPage extends StatefulWidget {
  const BuscaAvancadaPage({super.key});

  @override
  State<BuscaAvancadaPage> createState() => _BuscaAvancadaPageState();
}

class _BuscaAvancadaPageState extends State<BuscaAvancadaPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'Todas';
  String _selectedStatus = 'Todos';
  String _sortBy = 'recent';
  double _minSalary = 0;
  double _maxSalary = 10000;

  final TramposController _controller = Get.find<TramposController>();

  final List<String> _categories = [
    'Todas',
    'Tecnologia',
    'Design',
    'Marketing',
    'Vendas',
    'Administração',
    'Serviços',
    'Educação',
    'Saúde',
    'Construção',
    'Outros',
  ];

  final List<String> _statusOptions = [
    'Todos',
    'Disponível',
    'Em andamento',
    'Finalizado',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Busca Avançada'),
        actions: [
          IconButton(
            onPressed: _clearAllFilters,
            icon: const Icon(Icons.clear_all),
            tooltip: 'Limpar filtros',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Colors.grey.shade50,
              border: Border(
                bottom: BorderSide(
                  color:
                      isDark
                          ? Colors.white.withAlpha(38)
                          : Colors.grey.shade300,
                ),
              ),
            ),
            child: Column(
              children: [
                // Barra de busca principal
                _buildSearchField(isDark),
                const SizedBox(height: 16),

                // Localização
                _buildLocationField(isDark),
                const SizedBox(height: 16),

                // Filtros em linha
                _buildInlineFilters(isDark),
                const SizedBox(height: 16),

                // Filtro de salário
                _buildSalaryFilter(isDark),
              ],
            ),
          ),

          // Resultados
          Expanded(child: _buildResultsList(isDark)),
        ],
      ),
    );
  }

  Widget _buildSearchField(bool isDark) {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value.toLowerCase();
        });
      },
      decoration: InputDecoration(
        hintText: 'Buscar por título, descrição ou palavras-chave...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            _searchQuery.isNotEmpty
                ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.clear),
                )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withAlpha(38) : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        filled: true,
        fillColor: isDark ? Colors.white.withAlpha(15) : Colors.white,
      ),
    );
  }

  Widget _buildLocationField(bool isDark) {
    return TextField(
      controller: _locationController,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: 'Localização (cidade, estado, remoto...)',
        prefixIcon: const Icon(Icons.location_on),
        suffixIcon:
            _locationController.text.isNotEmpty
                ? IconButton(
                  onPressed: () {
                    _locationController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withAlpha(38) : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        filled: true,
        fillColor: isDark ? Colors.white.withAlpha(15) : Colors.white,
      ),
    );
  }

  Widget _buildInlineFilters(bool isDark) {
    return Row(
      children: [
        // Categoria
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              labelText: 'Categoria',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            items:
                _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
        ),
        const SizedBox(width: 16),

        // Status
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedStatus,
            decoration: InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            items:
                _statusOptions.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedStatus = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSalaryFilter(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Faixa salarial: R\$ ${_minSalary.toInt()} - R\$ ${_maxSalary.toInt()}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        RangeSlider(
          values: RangeValues(_minSalary, _maxSalary),
          min: 0,
          max: 10000,
          divisions: 100,
          activeColor: const Color(0xFF6366F1),
          onChanged: (values) {
            setState(() {
              _minSalary = values.start;
              _maxSalary = values.end;
            });
          },
        ),
      ],
    );
  }

  Widget _buildResultsList(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('Trampos')
              .orderBy('createDate', descending: _sortBy == 'recent')
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erro ao carregar vagas',
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.work_off,
                  size: 80,
                  color: isDark ? Colors.white60 : Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma vaga encontrada',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          );
        }

        // Aplicar filtros
        final filteredDocs = _applyFilters(snapshot.data!.docs);

        if (filteredDocs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 80,
                  color: isDark ? Colors.white60 : Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma vaga encontrada',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tente ajustar seus filtros de busca',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _clearAllFilters,
                  child: const Text('Limpar Filtros'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Header com contagem de resultados e ordenação
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredDocs.length} vaga${filteredDocs.length != 1 ? 's' : ''} encontrada${filteredDocs.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _sortBy,
                    items: const [
                      DropdownMenuItem(
                        value: 'recent',
                        child: Text('Mais recentes'),
                      ),
                      DropdownMenuItem(
                        value: 'oldest',
                        child: Text('Mais antigas'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Lista de resultados
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  final doc = filteredDocs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  return HomeViewPessoaFisicaHelpers.buildTrampoCard(
                    data,
                    isDark,
                    doc.id,
                    _controller,
                    searchQuery: _searchQuery,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<QueryDocumentSnapshot> _applyFilters(List<QueryDocumentSnapshot> docs) {
    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;

      // Filtro por texto de busca
      if (_searchQuery.isNotEmpty) {
        final titulo = data['titulo']?.toString().toLowerCase() ?? '';
        final descricao = data['descricao']?.toString().toLowerCase() ?? '';
        final tipoVaga = data['tipoVaga']?.toString().toLowerCase() ?? '';

        if (!titulo.contains(_searchQuery) &&
            !descricao.contains(_searchQuery) &&
            !tipoVaga.contains(_searchQuery)) {
          return false;
        }
      }

      // Filtro por localização
      if (_locationController.text.isNotEmpty) {
        final local = data['local']?.toString().toLowerCase() ?? '';
        if (!local.contains(_locationController.text.toLowerCase())) {
          return false;
        }
      }

      // Filtro por categoria
      if (_selectedCategory != 'Todas') {
        final categoria = data['categoria']?.toString() ?? '';
        if (categoria != _selectedCategory) {
          return false;
        }
      }

      // Filtro por status
      if (_selectedStatus != 'Todos') {
        final status = data['status']?.toString() ?? '';
        if (status != _selectedStatus) {
          return false;
        }
      }

      // Filtro por salário (se disponível)
      final salario = double.tryParse(data['salario']?.toString() ?? '0') ?? 0;
      if (salario > 0 && (salario < _minSalary || salario > _maxSalary)) {
        return false;
      }

      return true;
    }).toList();
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      _locationController.clear();
      _searchQuery = '';
      _selectedCategory = 'Todas';
      _selectedStatus = 'Todos';
      _sortBy = 'recent';
      _minSalary = 0;
      _maxSalary = 10000;
    });
  }
}
