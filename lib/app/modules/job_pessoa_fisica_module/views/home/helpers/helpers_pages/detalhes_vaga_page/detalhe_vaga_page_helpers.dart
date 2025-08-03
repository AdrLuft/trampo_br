import 'package:flutter/material.dart';

class DetalheVagaPageHelpers {
  // Novo widget para exibir itens de lista em formato de linhas
  static Widget buildListItem(String item, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 16, color: const Color(0xFF6366F1)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black87,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildListSection(
    String title,
    List<String> items,
    bool isDark,
    IconData icon,
  ) {
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
              Icon(icon, size: 20, color: const Color(0xFF6366F1)),
              const SizedBox(width: 8),
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
          const SizedBox(height: 12),
          // Substituindo o Wrap por uma coluna
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) => buildListItem(item, isDark)).toList(),
          ),
        ],
      ),
    );
  }

  static Widget buildTipItem(String tip, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        tip,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.white70 : Colors.grey.shade700,
        ),
      ),
    );
  }

  static Widget buildTipsCard(bool isDark) {
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
              Icon(Icons.checklist, color: const Color(0xFF6366F1), size: 24),
              const SizedBox(width: 8),
              Text(
                'Dicas para Candidatura',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          buildTipItem('📋 Leia toda a descrição da vaga', isDark),
          buildTipItem('📞 Entre em contato pelo telefone ou WhatsApp', isDark),
          buildTipItem('💬 Seja claro sobre sua experiência', isDark),
          buildTipItem('🕐 Respeite os horários de contato', isDark),
        ],
      ),
    );
  }

  // Novo método para criar a linha de informação
  static Widget buildInfoRow(
    String label,
    String value,
    IconData icon,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6366F1), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String formatarData(dynamic createDate) {
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

  static IconData getModalidadeIcon(String modalidade) {
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

  static IconData getCategoriaIcon(String categoria) {
    switch (categoria) {
      case 'Tecnologia':
        return Icons.computer;
      case 'Design':
        return Icons.palette;
      case 'Marketing':
        return Icons.campaign;
      case 'Vendas':
        return Icons.attach_money;
      case 'Administrativo':
        return Icons.business;
      case 'Educação':
        return Icons.school;
      case 'Saúde':
        return Icons.local_hospital;
      case 'Construção':
        return Icons.construction;
      case 'Alimentação':
        return Icons.restaurant;
      case 'Transporte':
        return Icons.local_shipping;
      case 'Serviços Gerais':
        return Icons.cleaning_services;
      default:
        return Icons.work;
    }
  }
}
