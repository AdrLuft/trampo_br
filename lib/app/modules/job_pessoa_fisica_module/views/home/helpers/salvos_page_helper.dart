import 'package:flutter/material.dart';

class SalvosPage extends StatelessWidget {
  const SalvosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark, size: 80, color: Colors.teal),
          SizedBox(height: 16),
          Text(
            'Vagas Salvas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Suas vagas favoritas ficarão aqui',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
