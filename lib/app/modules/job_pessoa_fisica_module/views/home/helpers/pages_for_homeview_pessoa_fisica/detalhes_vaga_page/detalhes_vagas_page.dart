import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/core/widgets/widgets_custom/status_widget.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/pages_for_homeview_pessoa_fisica/detalhes_vaga_page/detalhe_vaga_page_helpers.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesVagaPage extends StatefulWidget {
  final Map<String, dynamic> vagaData;
  final String vagaId;

  const DetalhesVagaPage({
    super.key,
    required this.vagaData,
    required this.vagaId,
  });

  @override
  State<DetalhesVagaPage> createState() => _DetalhesVagaPageState();
}

class _DetalhesVagaPageState extends State<DetalhesVagaPage> {
  void _mostrarOpcoesContato() {
    final telefone = widget.vagaData['telefone']?.toString() ?? '';
    final email = widget.vagaData['email']?.toString() ?? '';

    // Verifica se existe pelo menos um meio de contato
    if (telefone.isEmpty && (email.isEmpty)) {
      Get.snackbar(
        'Informação',
        'Não há informações de contato disponíveis para esta vaga.',
        backgroundColor: const Color(0xFF6366F1),
        colorText: Colors.white,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informações de Contato'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (telefone.isNotEmpty) ...[
                  const Text(
                    'Telefone:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(telefone),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.phone,
                              color: Color(0xFF6366F1),
                              size: 30,
                            ),
                            onPressed: () => _fazerLigacao(telefone),
                            tooltip: 'Ligar',
                          ),
                          const Text('Ligar', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.message,
                              color: Color(0xFF6366F1),
                              size: 30,
                            ),
                            onPressed: () => _enviarWhatsApp(telefone),
                            tooltip: 'WhatsApp',
                          ),
                          const Text(
                            'WhatsApp',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.copy,
                              color: Color(0xFF6366F1),
                              size: 30,
                            ),
                            onPressed:
                                () =>
                                    _copiarTexto(telefone, 'Telefone copiado'),
                            tooltip: 'Copiar',
                          ),
                          const Text('Copiar', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],

                if (telefone.isNotEmpty && email.isNotEmpty)
                  const Divider(height: 32),

                if (email.isNotEmpty) ...[
                  const Text(
                    'Email:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(email),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.email,
                              color: Color(0xFF6366F1),
                              size: 30,
                            ),
                            onPressed: () => _enviarEmail(email),
                            tooltip: 'Enviar Email',
                          ),
                          const Text('Email', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.copy,
                              color: Color(0xFF6366F1),
                              size: 30,
                            ),
                            onPressed:
                                () => _copiarTexto(email, 'Email copiado'),
                            tooltip: 'Copiar',
                          ),
                          const Text('Copiar', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  // Função para fazer ligação - melhorada com tratamento de erros
  void _fazerLigacao(String telefone) async {
    final Uri telUri = Uri(scheme: 'tel', path: telefone);
    try {
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        _copiarTexto(
          telefone,
          'Não foi possível abrir o telefone. Número copiado.',
        );
      }
    } catch (e) {
      _copiarTexto(telefone, 'Erro ao tentar ligar. Número copiado.');
      debugPrint('Erro ao tentar fazer ligação: $e');
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(); // Fecha o diálogo após a ação
  }

  // Função para enviar WhatsApp - melhorada
  void _enviarWhatsApp(String telefone) async {
    final numeroLimpo = telefone.replaceAll(RegExp(r'[^0-9]'), '');
    String numeroFormatado = numeroLimpo;

    // Adiciona o código do país se não estiver presente (assume Brasil)
    if (!numeroFormatado.startsWith('55')) {
      numeroFormatado = '55$numeroFormatado';
    }

    final mensagem =
        'Olá! Vi sua vaga "${widget.vagaData['tipoVaga']}" no Trampos BR e tenho interesse.';
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$numeroFormatado?text=${Uri.encodeComponent(mensagem)}',
    );

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(); // Fecha o diálogo após abrir o WhatsApp
      } else {
        // Se não conseguir abrir o WhatsApp, exibe mensagem e copia o número
        _copiarTexto(
          telefone,
          'Não foi possível abrir o WhatsApp. Número copiado.',
        );
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    } catch (e) {
      _copiarTexto(telefone, 'Erro ao tentar abrir WhatsApp. Número copiado.');
      debugPrint('Erro ao tentar abrir WhatsApp: $e');
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  // Função para enviar email - melhorada
  void _enviarEmail(String email) async {
    final assunto = Uri.encodeComponent(
      'Interesse na vaga: ${widget.vagaData['tipoVaga']}',
    );
    final corpo = Uri.encodeComponent(
      'Olá,\n\nVi sua vaga "${widget.vagaData['tipoVaga']}" no Trampos BR e tenho interesse.\n\nAguardo contato.',
    );

    final Uri mailtoUri = Uri.parse(
      'mailto:$email?subject=$assunto&body=$corpo',
    );

    try {
      if (await canLaunchUrl(mailtoUri)) {
        await launchUrl(mailtoUri);
      } else {
        _copiarTexto(
          email,
          'Não foi possível abrir o email. Endereço copiado.',
        );
      }
    } catch (e) {
      _copiarTexto(email, 'Erro ao tentar enviar email. Endereço copiado.');
      debugPrint('Erro ao tentar enviar email: $e');
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(); // Fecha o diálogo após a ação
  }

  void _copiarTexto(String texto, String mensagem) {
    Clipboard.setData(ClipboardData(text: texto));
    Get.snackbar(
      'Copiado!',
      mensagem,
      backgroundColor: const Color(0xFF6366F1),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void mostrarMensagemWhatsApp(String telefone) {
    final TextEditingController mensagemController = TextEditingController();
    mensagemController.text =
        'Olá! Vi sua vaga "${widget.vagaData['tipoVaga']}" no Trampos BR e tenho interesse.';

    Get.dialog(
      AlertDialog(
        title: const Text('Mensagem para WhatsApp'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Telefone: $telefone'),
            const SizedBox(height: 10),
            TextField(
              controller: mensagemController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Sua mensagem',
                border: OutlineInputBorder(),
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
              final mensagem = mensagemController.text;
              final numeroLimpo = telefone.replaceAll(RegExp(r'[^0-9]'), '');
              final textoCompleto =
                  'WhatsApp: $numeroLimpo\nMensagem: $mensagem';

              _copiarTexto(
                textoCompleto,
                'Informações copiadas! Cole no WhatsApp',
              );
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
            ),
            child: const Text('Copiar Info'),
          ),
        ],
      ),
    );
  }

  void _candidatarVaga() {
    Get.snackbar(
      'Candidatura',
      'Funcionalidade em desenvolvimento',
      backgroundColor: const Color(0xFF6366F1),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  String _formatarData(dynamic createDate) {
    try {
      DateTime data;
      if (createDate is String) {
        data = DateTime.parse(createDate);
      } else {
        data = DateTime.now();
      }

      final agora = DateTime.now();
      final diferenca = agora.difference(data);

      if (diferenca.inDays == 0) return 'Hoje';
      if (diferenca.inDays == 1) return 'Ontem';
      if (diferenca.inDays < 7) return '${diferenca.inDays} dias atrás';
      return '${data.day}/${data.month}/${data.year}';
    } catch (e) {
      return 'Data não disponível';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Extraindo dados adicionais
    final String titulo = widget.vagaData['titulo'] as String? ?? '';
    final String modalidade =
        widget.vagaData['modalidade'] as String? ?? 'Não especificada';
    final String salario =
        widget.vagaData['salario'] as String? ?? 'Não informado';
    final String telefone = widget.vagaData['telefone']?.toString() ?? '';
    final String email = widget.vagaData['email']?.toString() ?? '';

    // Recuperando listas
    final List<dynamic> requisitos =
        widget.vagaData['requisitos'] as List<dynamic>? ?? [];
    final List<dynamic> exigencias =
        widget.vagaData['exigencias'] as List<dynamic>? ?? [];
    final List<dynamic> valorizados =
        widget.vagaData['valorizados'] as List<dynamic>? ?? [];
    final List<dynamic> beneficios =
        widget.vagaData['beneficios'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo.isNotEmpty ? titulo : 'Detalhes da Vaga'),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final texto = '''
${titulo.isNotEmpty ? titulo : widget.vagaData['tipoVaga'] ?? 'Vaga'}

${widget.vagaData['descricao'] ?? 'Sem descrição'}

Contato: ${widget.vagaData['telefone'] ?? 'Não informado'}
              ''';
              _copiarTexto(texto, 'Informações da vaga copiadas');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header da vaga
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(21),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (titulo.isNotEmpty)
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    )
                  else
                    Text(
                      widget.vagaData['tipoVaga'] ?? 'Trampo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 18,
                        color: Color(0xFF6366F1),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.vagaData['createTrampoNome'] ?? 'Usuário',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white70 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  StatusVagaWidget(
                    status: widget.vagaData['status'] ?? 'Disponível',
                  ),
                  const SizedBox(height: 16),
                  DetalheVagaPageHelpers.buildInfoRow(
                    'Tipo da Vaga',
                    widget.vagaData['tipoVaga'] ?? 'Não especificado',
                    Icons.work_outline,
                    isDark,
                  ),
                  DetalheVagaPageHelpers.buildInfoRow(
                    'Modalidade',
                    modalidade,
                    _getModalidadeIcon(modalidade),
                    isDark,
                  ),
                  DetalheVagaPageHelpers.buildInfoRow(
                    'Status',
                    widget.vagaData['status'] ?? 'Disponível',
                    Icons.flag,
                    isDark,
                  ),
                  DetalheVagaPageHelpers.buildInfoRow(
                    'Data de Publicação',
                    _formatarData(widget.vagaData['createDate']),
                    Icons.calendar_today,
                    isDark,
                  ),
                  DetalheVagaPageHelpers.buildInfoRow(
                    'Salário',
                    salario,
                    Icons.payments_outlined,
                    isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Descrição
            _buildSection(
              'Descrição',
              widget.vagaData['descricao'] ?? 'Sem descrição disponível',
              isDark,
            ),

            // Listas de informações adicionais
            if (requisitos.isNotEmpty)
              DetalheVagaPageHelpers.buildListSection(
                'Requisitos',
                requisitos.cast<String>(),
                isDark,
                Icons.assignment_outlined,
              ),

            if (exigencias.isNotEmpty)
              DetalheVagaPageHelpers.buildListSection(
                'Exigências',
                exigencias.cast<String>(),
                isDark,
                Icons.check_circle_outline,
              ),

            if (valorizados.isNotEmpty)
              DetalheVagaPageHelpers.buildListSection(
                'Valorizado',
                valorizados.cast<String>(),
                isDark,
                Icons.star_outline,
              ),

            if (beneficios.isNotEmpty)
              DetalheVagaPageHelpers.buildListSection(
                'Benefícios',
                beneficios.cast<String>(),
                isDark,
                Icons.card_giftcard,
              ),

            // Contato
            if (telefone.isNotEmpty || email.isNotEmpty)
              DetalheVagaPageHelpers.buildContatoSection(
                telefone,
                email,
                isDark,
              ),

            const SizedBox(height: 20),

            // Dicas para candidatura
            DetalheVagaPageHelpers.buildTipsCard(isDark),

            const SizedBox(height: 30),

            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _mostrarOpcoesContato,
                    icon: const Icon(Icons.phone),
                    label: const Text('Contatar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _candidatarVaga,
                    icon: const Icon(Icons.work),
                    label: const Text('Candidatar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Método para obter ícone baseado na modalidade
  IconData _getModalidadeIcon(String modalidade) {
    switch (modalidade.toLowerCase()) {
      case 'presencial':
        return Icons.business_center;
      case 'remoto':
        return Icons.computer;
      case 'híbrido':
      case 'hibrido':
        return Icons.home_work;
      default:
        return Icons.work_outline;
    }
  }

  Widget _buildSection(
    String title,
    String content,
    bool isDark, {
    IconData? icon,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(21),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: const Color(0xFF6366F1)),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
