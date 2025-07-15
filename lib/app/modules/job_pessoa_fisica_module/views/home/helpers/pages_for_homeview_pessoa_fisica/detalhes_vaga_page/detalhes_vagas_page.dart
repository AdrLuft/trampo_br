import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:interprise_calendar/app/core/widgets/widgets_custom/status_widget.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/views/home/helpers/pages_for_homeview_pessoa_fisica/detalhes_vaga_page/detalhe_vaga_page_helpers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

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

  void _compartilharVaga() async {
    final String titulo = widget.vagaData['titulo'] as String? ?? '';
    final String tipoVaga = widget.vagaData['tipoVaga'] as String? ?? 'Vaga';
    final String descricao = widget.vagaData['descricao'] as String? ?? '';
    final String modalidade = widget.vagaData['modalidade'] as String? ?? '';
    final String salario = widget.vagaData['salario'] as String? ?? '';
    final String telefone = widget.vagaData['telefone']?.toString() ?? '';
    final String email = widget.vagaData['email']?.toString() ?? '';
    final String nomeEmpresa =
        widget.vagaData['createTrampoNome'] as String? ?? '';

    String textoCompartilhamento = '''
🔥 ${titulo.isNotEmpty ? titulo : tipoVaga} - Trampos BR

👤 Empresa: $nomeEmpresa
💼 Tipo: $tipoVaga
${modalidade.isNotEmpty ? '🏢 Modalidade: $modalidade' : ''}
${salario.isNotEmpty && salario != 'Não informado' ? '💰 Salário: $salario' : ''}

📋 Descrição:
${descricao.isNotEmpty ? descricao : 'Sem descrição disponível'}

📞 Contato:''';

    if (telefone.isNotEmpty) {
      textoCompartilhamento += '\n📱 WhatsApp/Telefone: $telefone';
    }

    if (email.isNotEmpty) {
      textoCompartilhamento += '\n📧 Email: $email';
    }

    if (telefone.isEmpty && email.isEmpty) {
      textoCompartilhamento += '\n⚠️ Informações de contato não disponíveis';
    }

    textoCompartilhamento +=
        '\n\n🚀 Baixe o Trampos BR e encontre mais oportunidades!';

    try {
      // Tenta usar o share_plus primeiro
      await Share.share(
        textoCompartilhamento,
        subject: titulo.isNotEmpty ? titulo : 'Vaga: $tipoVaga',
      );
    } catch (e) {
      // Se falhar, copia para a área de transferência como fallback
      _copiarTexto(textoCompartilhamento, 'Vaga copiada para compartilhar!');

      // Mostra um dialog explicativo
      Get.dialog(
        AlertDialog(
          title: const Text('Compartilhar Vaga'),
          content: const Text(
            'As informações da vaga foram copiadas para sua área de transferência.\n\n'
            'Agora você pode colar em qualquer aplicativo de mensagem!',
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('OK')),
            TextButton(
              onPressed: () {
                Get.back();
                // Tenta abrir WhatsApp Web como alternativa
                final whatsappWebUri =
                    'https://wa.me/?text=${Uri.encodeComponent(textoCompartilhamento)}';
                launchUrl(Uri.parse(whatsappWebUri));
              },
              child: const Text('WhatsApp Web'),
            ),
          ],
        ),
      );
    }
  }

  String _formatarData(dynamic createDate) {
    try {
      DateTime data;

      if (createDate == null) {
        return 'Data não disponível';
      }

      // Se for um Timestamp do Firebase
      if (createDate.runtimeType.toString().contains('Timestamp')) {
        data = createDate.toDate();
      }
      // Se for uma String
      else if (createDate is String) {
        // Tenta diferentes formatos de string
        try {
          data = DateTime.parse(createDate);
        } catch (e) {
          // Se falhar, tenta outros formatos comuns
          try {
            data = DateTime.tryParse(createDate) ?? DateTime.now();
          } catch (e2) {
            return 'Data não disponível';
          }
        }
      }
      // Se for um int (timestamp em milliseconds)
      else if (createDate is int) {
        data = DateTime.fromMillisecondsSinceEpoch(createDate);
      }
      // Se for um Map (possível estrutura do Firebase)
      else if (createDate is Map) {
        if (createDate.containsKey('seconds')) {
          data = DateTime.fromMillisecondsSinceEpoch(
            createDate['seconds'] * 1000 +
                (createDate['nanoseconds'] ?? 0) ~/ 1000000,
          );
        } else {
          return 'Data não disponível';
        }
      }
      // Se já for DateTime
      else if (createDate is DateTime) {
        data = createDate;
      } else {
        return 'Data não disponível';
      }

      final agora = DateTime.now();
      agora.difference(data);

      // Ajustar para timezone local se necessário
      final dataLocal = data.toLocal();
      final agoraLocal = agora.toLocal();
      final diferencaLocal = agoraLocal.difference(dataLocal);

      if (diferencaLocal.inDays == 0) return 'Hoje';
      if (diferencaLocal.inDays == 1) return 'Ontem';
      if (diferencaLocal.inDays < 7) {
        return '${diferencaLocal.inDays} dias atrás';
      }
      return '${dataLocal.day.toString().padLeft(2, '0')}/${dataLocal.month.toString().padLeft(2, '0')}/${dataLocal.year}';
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
            onPressed: _compartilharVaga,
            tooltip: 'Compartilhar vaga',
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
                color: isDark ? Colors.white.withAlpha(15) : Colors.white,
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

            // Dicas para candidatura
            DetalheVagaPageHelpers.buildTipsCard(isDark),

            // Botões de contato direto
            const SizedBox(height: 20),
            if (telefone.isNotEmpty || email.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withAlpha(15) : Colors.white,
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
                        Icon(
                          Icons.contact_phone,
                          size: 20,
                          color: const Color(0xFF6366F1),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Entre em Contato',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (telefone.isNotEmpty) ...[
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  final numeroLimpo = telefone.replaceAll(
                                    RegExp(r'[^0-9]'),
                                    '',
                                  );
                                  String numeroFormatado = numeroLimpo;
                                  if (!numeroFormatado.startsWith('55')) {
                                    numeroFormatado = '55$numeroFormatado';
                                  }
                                  final mensagem =
                                      'Olá! Vi sua vaga "${widget.vagaData['tipoVaga']}" no Trampos BR e tenho interesse.';
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
                                  size: 28,
                                ),
                                tooltip: 'WhatsApp',
                              ),
                              Text(
                                'WhatsApp',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isDark
                                          ? Colors.white70
                                          : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  launchUrl(Uri(scheme: 'tel', path: telefone));
                                },
                                icon: Icon(
                                  Icons.phone,
                                  color: const Color(0xFF22C55E),
                                  size: 28,
                                ),
                                tooltip: 'Ligar',
                              ),
                              Text(
                                'Ligar',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isDark
                                          ? Colors.white70
                                          : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (email.isNotEmpty)
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  final assunto = Uri.encodeComponent(
                                    'Interesse na vaga: ${widget.vagaData['tipoVaga']}',
                                  );
                                  final corpo = Uri.encodeComponent(
                                    'Olá,\n\nVi sua vaga "${widget.vagaData['tipoVaga']}" no Trampos BR e tenho interesse.\n\nAguardo contato.',
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
                                  size: 28,
                                ),
                                tooltip: 'Email',
                              ),
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isDark
                                          ? Colors.white70
                                          : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        // Botão de compartilhamento adicional
                        Column(
                          children: [
                            IconButton(
                              onPressed: _compartilharVaga,
                              icon: Icon(
                                Icons.share,
                                color: const Color(0xFF6366F1),
                                size: 28,
                              ),
                              tooltip: 'Compartilhar',
                            ),
                            Text(
                              'Compartilhar',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    isDark
                                        ? Colors.white70
                                        : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (telefone.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? Colors.blue.shade900.withAlpha(77)
                                  : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isDark
                                    ? Colors.blue.shade600.withAlpha(128)
                                    : Colors.blue.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color:
                                  isDark
                                      ? Colors.blue.shade300
                                      : Colors.blue.shade600,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                telefone,
                                style: TextStyle(
                                  color:
                                      isDark
                                          ? Colors.blue.shade200
                                          : Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed:
                                  () => _copiarTexto(
                                    telefone,
                                    'Telefone copiado',
                                  ),
                              icon: Icon(
                                Icons.copy,
                                color:
                                    isDark
                                        ? Colors.blue.shade300
                                        : Colors.blue.shade600,
                                size: 16,
                              ),
                              tooltip: 'Copiar número',
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (email.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? Colors.purple.shade900.withAlpha(77)
                                  : Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isDark
                                    ? Colors.purple.shade600.withAlpha(128)
                                    : Colors.purple.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.email,
                              color:
                                  isDark
                                      ? Colors.purple.shade300
                                      : Colors.purple.shade600,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                email,
                                style: TextStyle(
                                  color:
                                      isDark
                                          ? Colors.purple.shade200
                                          : Colors.purple.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed:
                                  () => _copiarTexto(email, 'Email copiado'),
                              icon: Icon(
                                Icons.copy,
                                color:
                                    isDark
                                        ? Colors.purple.shade300
                                        : Colors.purple.shade600,
                                size: 16,
                              ),
                              tooltip: 'Copiar email',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ] else
              // Caso não tenha contato disponível
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Colors.orange.shade900.withAlpha(77)
                          : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        isDark
                            ? Colors.orange.shade600.withAlpha(128)
                            : Colors.orange.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color:
                          isDark
                              ? Colors.orange.shade300
                              : Colors.orange.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Informações de contato não disponíveis para esta vaga.',
                        style: TextStyle(
                          color:
                              isDark
                                  ? Colors.orange.shade200
                                  : Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Espaçamento extra no final
            const SizedBox(height: 32),
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
