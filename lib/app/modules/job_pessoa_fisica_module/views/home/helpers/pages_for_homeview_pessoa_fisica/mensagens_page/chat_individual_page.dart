import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mensagens_page_helper.dart';

class ChatIndividualPage extends StatefulWidget {
  final Conversa conversa;

  const ChatIndividualPage({super.key, required this.conversa});

  @override
  State<ChatIndividualPage> createState() => _ChatIndividualPageState();
}

class _ChatIndividualPageState extends State<ChatIndividualPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock data - substituir por dados do Firebase
  final List<Mensagem> _mensagens = [
    Mensagem(
      id: '1',
      texto: 'Olá! Vimos seu perfil e temos uma vaga perfeita para você.',
      horario: DateTime.now().subtract(const Duration(hours: 2)),
      ehMinhaMessage: false,
    ),
    Mensagem(
      id: '2',
      texto: 'Olá! Fico interessado. Pode me contar mais detalhes?',
      horario: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      ehMinhaMessage: true,
    ),
    Mensagem(
      id: '3',
      texto: 'Claro! É uma vaga para desenvolvedor Flutter, remoto, CLT.',
      horario: DateTime.now().subtract(const Duration(minutes: 45)),
      ehMinhaMessage: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _enviarMensagem() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _mensagens.add(
        Mensagem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          texto: _messageController.text.trim(),
          horario: DateTime.now(),
          ehMinhaMessage: true,
        ),
      );
    });

    _messageController.clear();

    // Simular resposta automática (remover em produção)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _mensagens.add(
            Mensagem(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              texto: 'Obrigado pela mensagem! Responderemos em breve.',
              horario: DateTime.now(),
              ehMinhaMessage: false,
            ),
          );
        });
        _scrollToBottom();
      }
    });

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(
                widget.conversa.tipoContato == TipoUsuario.empresa
                    ? Icons.business
                    : Icons.person,
                color: Colors.teal,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversa.nomeContato,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.conversa.tipoContato == TipoUsuario.empresa
                        ? 'Empresa'
                        : 'Pessoa Física',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showOptionsMenu();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Lista de mensagens
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _mensagens.length,
              itemBuilder: (context, index) {
                final mensagem = _mensagens[index];
                return _buildMensagemBubble(mensagem, isDark);
              },
            ),
          ),

          // Campo de entrada de mensagem
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: isDark ? Colors.grey.shade800 : Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _enviarMensagem(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _enviarMensagem,
                  backgroundColor: Colors.teal,
                  mini: true,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMensagemBubble(Mensagem mensagem, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            mensagem.ehMinhaMessage
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        children: [
          if (!mensagem.ehMinhaMessage) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.teal.shade100,
              child: Icon(
                widget.conversa.tipoContato == TipoUsuario.empresa
                    ? Icons.business
                    : Icons.person,
                color: Colors.teal,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    mensagem.ehMinhaMessage
                        ? Colors.teal
                        : (isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mensagem.texto,
                    style: TextStyle(
                      color:
                          mensagem.ehMinhaMessage
                              ? Colors.white
                              : (isDark ? Colors.white : Colors.black87),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatarHorarioMensagem(mensagem.horario),
                    style: TextStyle(
                      color:
                          mensagem.ehMinhaMessage
                              ? Colors.white70
                              : (isDark
                                  ? Colors.white54
                                  : Colors.grey.shade600),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (mensagem.ehMinhaMessage) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.person, color: Colors.grey, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text('Bloquear usuário'),
                  onTap: () {
                    Get.back();
                    Get.snackbar(
                      'Bloqueado',
                      'Usuário foi bloqueado',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.report),
                  title: const Text('Denunciar'),
                  onTap: () {
                    Get.back();
                    Get.snackbar(
                      'Denúncia',
                      'Denúncia enviada',
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }

  String _formatarHorarioMensagem(DateTime horario) {
    final agora = DateTime.now();
    final diferenca = agora.difference(horario);

    if (diferenca.inMinutes < 1) {
      return 'Agora';
    } else if (diferenca.inMinutes < 60) {
      return '${diferenca.inMinutes}min';
    } else if (diferenca.inHours < 24) {
      return '${horario.hour.toString().padLeft(2, '0')}:${horario.minute.toString().padLeft(2, '0')}';
    } else {
      return '${horario.day}/${horario.month} ${horario.hour.toString().padLeft(2, '0')}:${horario.minute.toString().padLeft(2, '0')}';
    }
  }
}

// Modelo de dados para mensagem
class Mensagem {
  final String id;
  final String texto;
  final DateTime horario;
  final bool ehMinhaMessage;

  Mensagem({
    required this.id,
    required this.texto,
    required this.horario,
    required this.ehMinhaMessage,
  });
}
