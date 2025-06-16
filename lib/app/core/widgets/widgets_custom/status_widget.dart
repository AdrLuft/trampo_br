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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            isDisponivel
                ? Colors.green.withAlpha(40)
                : Colors.red.withAlpha(40),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDisponivel ? Icons.event_busy_sharp : Icons.cancel,
            color: isDisponivel ? Colors.green : Colors.red,
            size: iconSize,
          ),
          SizedBox(width: 4),
          Text(
            isDisponivel ? 'Disponível' : 'Encerrado',
            style: TextStyle(
              color: isDisponivel ? Colors.green : Colors.red,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
