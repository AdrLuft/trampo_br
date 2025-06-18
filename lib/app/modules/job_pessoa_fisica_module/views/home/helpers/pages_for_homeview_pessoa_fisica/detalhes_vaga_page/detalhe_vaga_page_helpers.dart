import 'package:flutter/material.dart';

class DetalheVagaPageHelpers {
  // Novo widget para exibir itens de lista em formato de linhas
  static Widget buildListItem(String item, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.teal),
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
              Icon(icon, size: 20, color: Colors.teal),
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

  static Widget buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(tip, style: const TextStyle(fontSize: 14)),
    );
  }

  static Widget buildTipsCard(bool isDark) {
    return Card(
      color: isDark ? Colors.grey.shade800 : Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.checklist, color: Colors.teal, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Dicas para Candidatura',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            buildTipItem('📋 Leia toda a descrição da vaga'),
            buildTipItem('📞 Entre em contato pelo telefone ou WhatsApp'),
            buildTipItem('💬 Seja claro sobre sua experiência'),
            buildTipItem('🕐 Respeite os horários de contato'),
          ],
        ),
      ),
    );
  }

  // Novo método para criar a seção de contatos com telefone e email
  static Widget buildContatoSection(
    String telefone,
    String email,
    bool isDark,
  ) {
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
              Icon(Icons.contact_phone, size: 20, color: Colors.teal),
              const SizedBox(width: 8),
              Text(
                'Informações de Contato',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (telefone.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.teal),
                const SizedBox(width: 8),
                Text(
                  'Telefone: $telefone',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (email.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.email, size: 16, color: Colors.teal),
                const SizedBox(width: 8),
                Text(
                  'Email: $email',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

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
          Icon(icon, color: Colors.teal, size: 20),
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
}
