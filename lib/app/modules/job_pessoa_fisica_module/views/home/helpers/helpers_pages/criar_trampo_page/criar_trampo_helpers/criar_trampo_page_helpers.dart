import 'package:flutter/material.dart';

class CriarTrampoPageHelpers {
  // Widget para exibir os chips/tags adicionados
  // Widget para exibir os chips/tags adicionados
  static Widget buildChips(List<String> itens, Function(int) onDelete) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: List.generate(
        itens.length,
        (index) => Chip(
          backgroundColor: Colors.teal.shade100,
          label: Text(
            itens[index],
            style: const TextStyle(color: Colors.black87),
          ),
          deleteIcon: const Icon(Icons.cancel, size: 18, color: Colors.black54),
          onDeleted: () => onDelete(index),
        ),
      ),
    );
  }

  static IconData getIconForTipo(String tipo) {
    switch (tipo) {
      case 'Bico':
        return Icons.handyman;
      case 'PJ (Pessoa Jurídica)':
        return Icons.business;
      case 'CLT (Consolidação das Leis do Trabalho)':
        return Icons.work;
      case 'Freelancer':
        return Icons.laptop;
      case 'Estágio':
        return Icons.school;
      case 'Temporário':
        return Icons.schedule;
      case 'Meio Período':
        return Icons.access_time;
      case 'Outro':
        return Icons.help_outline;
      default:
        return Icons.work_outline;
    }
  }

  static IconData getIconForModalidade(String modalidade) {
    switch (modalidade) {
      case 'Presencial':
        return Icons.business_center;
      case 'Remoto':
        return Icons.computer;
      case 'Híbrido':
        return Icons.home_work;
      default:
        return Icons.work_outline;
    }
  }
}
