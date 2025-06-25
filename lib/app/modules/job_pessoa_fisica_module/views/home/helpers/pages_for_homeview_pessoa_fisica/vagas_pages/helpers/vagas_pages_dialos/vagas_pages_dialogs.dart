import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/domain/entities/trampos_entiti.dart';
import 'package:interprise_calendar/app/modules/job_pessoa_fisica_module/presentations/controllers/trampos_controller.dart';

class VagasPagesDialogs {
  static Widget buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  static Widget buildMinhaVagaCard(TramposEntiti vaga, bool isDark) {
    final createDate = DateTime.tryParse(vaga.createDate) ?? DateTime.now();
    final TramposController controller = Get.find<TramposController>();

    Color getStatusColor(String? status) {
      switch (status?.toLowerCase()) {
        case 'disponivel':
        case 'disponível':
          return Colors.green;
        case 'ocupado':
          return Colors.orange;
        case 'finalizado':
        case 'encerrado':
          return Colors.grey;
        default:
          return Colors.green;
      }
    }

    String formatarData(DateTime data) {
      final agora = DateTime.now();
      final diferenca = agora.difference(data);

      if (diferenca.inDays == 0) return 'Hoje';
      if (diferenca.inDays == 1) return 'Ontem';
      if (diferenca.inDays < 7) return '${diferenca.inDays} dias atrás';
      return '${data.day}/${data.month}/${data.year}';
    }

    void confirmarExclusao(String vagaId) {
      Get.dialog(
        AlertDialog(
          title: const Text('Excluir Vaga'),
          content: const Text('Tem certeza que deseja excluir esta vaga?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                Get.back();
                controller.deleteTrampos(vagaId);
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    return Container(
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
                    vaga.tipoVaga,
                    style: TextStyle(
                      color: Colors.teal.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(vaga.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    vaga.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              vaga.titulo,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
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
                    vaga.createTrampoNome.isNotEmpty
                        ? vaga.createTrampoNome
                        : 'Você',
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton.icon(
                      onPressed:
                          () => controller.alterStatusTrampo(
                            vaga.id,
                            vaga.status,
                            vaga.userId ?? '',
                          ),
                      icon: Icon(_getStatusIcon(vaga.status), size: 18),
                      label: Text(_getStatusActionText(vaga.status)),
                      style: TextButton.styleFrom(
                        foregroundColor: _getStatusActionColor(vaga.status),
                      ),
                    ),
                  ],
                ),

                TextButton.icon(
                  onPressed: () => confirmarExclusao(vaga.id),
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Excluir'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Adicionar estas funções auxiliares no escopo da classe
  static IconData _getStatusIcon(String status) {
    // Normalizar o status para comparação
    String normalizado = status
        .toLowerCase()
        .replaceAll('í', 'i')
        .replaceAll('é', 'e');

    if (normalizado.contains('disponivel') ||
        normalizado.contains('disponível')) {
      return Icons.close; // Ícone para encerrar vaga
    } else {
      return Icons.refresh; // Ícone para reabrir vaga
    }
  }

  static String _getStatusActionText(String status) {
    // Normalizar o status para comparação
    String normalizado = status
        .toLowerCase()
        .replaceAll('í', 'i')
        .replaceAll('é', 'e');

    if (normalizado.contains('disponivel') ||
        normalizado.contains('disponível')) {
      return 'Encerrar Vaga';
    } else {
      return 'Reabrir Vaga';
    }
  }

  static Color _getStatusActionColor(String status) {
    // Normalizar o status para comparação
    String normalizado = status
        .toLowerCase()
        .replaceAll('í', 'i')
        .replaceAll('é', 'e');

    if (normalizado.contains('disponivel') ||
        normalizado.contains('disponível')) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
