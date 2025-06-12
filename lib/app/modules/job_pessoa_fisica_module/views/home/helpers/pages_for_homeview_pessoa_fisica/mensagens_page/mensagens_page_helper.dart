import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_individual_page.dart';

class MensagensPage extends StatefulWidget {
  const MensagensPage({super.key});

  @override
  State<MensagensPage> createState() => _MensagensPageState();
}

class _MensagensPageState extends State<MensagensPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock data - substituir por dados do Firebase
  final List<Conversa> _conversas = [
    Conversa(
      id: '1',
      nomeContato: 'Tech Solutions Ltda',
      tipoContato: TipoUsuario.empresa,
      ultimaMensagem:
          'Olá! Vimos seu perfil e temos uma vaga perfeita para você.',
      horarioUltimaMensagem: DateTime.now().subtract(
        const Duration(minutes: 15),
      ),
      naoLidas: 2,
      avatarUrl: null,
    ),
    Conversa(
      id: '2',
      nomeContato: 'Maria Silva',
      tipoContato: TipoUsuario.pessoaFisica,
      ultimaMensagem: 'Você pode me indicar para aquela vaga?',
      horarioUltimaMensagem: DateTime.now().subtract(const Duration(hours: 2)),
      naoLidas: 0,
      avatarUrl: null,
    ),
    Conversa(
      id: '3',
      nomeContato: 'Startup Inovadora',
      tipoContato: TipoUsuario.empresa,
      ultimaMensagem: 'Quando você pode começar?',
      horarioUltimaMensagem: DateTime.now().subtract(const Duration(days: 1)),
      naoLidas: 1,
      avatarUrl: null,
    ),
  ];

  List<Conversa> get _conversasFiltradas {
    if (_searchQuery.isEmpty) return _conversas;
    return _conversas
        .where(
          (conversa) => conversa.nomeContato.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mensagens',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.toNamed('/job-pessoa-fisica');
          },
        ),
      ),
      body: Column(
        children: [
          // Barra de pesquisa
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar conversas...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Lista de conversas
          Expanded(
            child:
                _conversasFiltradas.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      itemCount: _conversasFiltradas.length,
                      itemBuilder: (context, index) {
                        final conversa = _conversasFiltradas[index];
                        return _buildConversaItem(conversa, isDark);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversaItem(Conversa conversa, bool isDark) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: _buildAvatar(conversa, isDark),
        title: Row(
          children: [
            Expanded(
              child: Text(
                conversa.nomeContato,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildTipoIndicador(conversa.tipoContato),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              conversa.ultimaMensagem,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _formatarHorario(conversa.horarioUltimaMensagem),
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
        trailing:
            conversa.naoLidas > 0
                ? Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    conversa.naoLidas.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : null,
        onTap: () {
          Get.to(() => ChatIndividualPage(conversa: conversa));
        },
      ),
    );
  }

  Widget _buildAvatar(Conversa conversa, bool isDark) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.teal.shade100,
      child:
          conversa.avatarUrl != null
              ? ClipOval(
                child: Image.network(
                  conversa.avatarUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
              : Icon(
                conversa.tipoContato == TipoUsuario.empresa
                    ? Icons.business
                    : Icons.person,
                color: Colors.teal,
                size: 30,
              ),
    );
  }

  Widget _buildTipoIndicador(TipoUsuario tipo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: tipo == TipoUsuario.empresa ? Colors.blue : Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        tipo == TipoUsuario.empresa ? 'PJ' : 'CPF',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Nenhuma conversa ainda',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Suas conversas aparecerão aqui',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _formatarHorario(DateTime horario) {
    final agora = DateTime.now();
    final diferenca = agora.difference(horario);

    if (diferenca.inMinutes < 60) {
      return '${diferenca.inMinutes}min';
    } else if (diferenca.inHours < 24) {
      return '${diferenca.inHours}h';
    } else if (diferenca.inDays < 7) {
      return '${diferenca.inDays}d';
    } else {
      return '${horario.day}/${horario.month}';
    }
  }
}

// Modelos de dados
enum TipoUsuario { pessoaFisica, empresa }

class Conversa {
  final String id;
  final String nomeContato;
  final TipoUsuario tipoContato;
  final String ultimaMensagem;
  final DateTime horarioUltimaMensagem;
  final int naoLidas;
  final String? avatarUrl;

  Conversa({
    required this.id,
    required this.nomeContato,
    required this.tipoContato,
    required this.ultimaMensagem,
    required this.horarioUltimaMensagem,
    required this.naoLidas,
    this.avatarUrl,
  });
}
