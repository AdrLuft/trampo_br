import 'package:flutter/material.dart';

class VagasPage extends StatelessWidget {
  const VagasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work, size: 80, color: Colors.teal),
          SizedBox(height: 16),
          Text(
            'Vagas de Trabalho',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Aqui você encontrará todas as vagas disponíveis',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
