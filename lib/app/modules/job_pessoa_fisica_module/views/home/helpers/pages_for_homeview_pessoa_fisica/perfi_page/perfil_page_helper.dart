import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meu Perfil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              // Ação de editar perfil
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Meu Perfil',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color:
                        isDark
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Gerencie suas informações pessoais',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        isDark
                            ? Colors.white.withAlpha(179)
                            : Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(153),
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.email,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: const Text('Email'),
                          subtitle: const Text('usuario@trampos.br'),
                        ),
                        const Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.phone,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: const Text('Telefone'),
                          subtitle: const Text('(11) 99999-9999'),
                        ),
                        const Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: const Text('Localização'),
                          subtitle: const Text('São Paulo, SP'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
