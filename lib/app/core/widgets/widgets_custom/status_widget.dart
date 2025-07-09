import 'package:flutter/material.dart';

enum StatusVaga { disponivel, encerrado }

class StatusVagaWidget extends StatelessWidget {
  final String status;
  final double? iconSize;
  final double? fontSize;

  const StatusVagaWidget({
    super.key,
    required this.status,
    this.iconSize = 16,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    bool isDisponivel =
        status.toLowerCase() == 'disponivel' ||
        status.toLowerCase() == 'disponível';

    // Use theme colors or appropriate alternatives
    final primaryColor = Theme.of(context).colorScheme.primary;
    final errorColor = Theme.of(context).colorScheme.error;

    final statusColor = isDisponivel ? primaryColor : errorColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(40),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDisponivel ? Icons.event_busy_sharp : Icons.cancel,
            color: statusColor,
            size: iconSize,
          ),
          const SizedBox(width: 4),
          Text(
            isDisponivel ? 'Disponível' : 'Encerrado',
            style: TextStyle(
              color: statusColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
